import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countryProvider = context.watch<CountryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => countryProvider.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Rechercher un pays',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                isDense: true,
              ),
            ),
          ),
        ),
        actions: [
          Consumer<CountryProvider>(
            builder: (context, provider, child) {
              final favoriteCount = provider.favorites.length;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                  if (favoriteCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => countryProvider.loadCountries(),
        child: _buildBody(countryProvider),
      ),
    );
  }

  Widget _buildBody(CountryProvider provider) {
    // 1. Afficher le chargement (DH-04)
    if (provider.isLoading && provider.countries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Afficher l'erreur (DH-03)
    if (provider.errorMessage != null) {
      return Center(
        child: Text(
          'Erreur: ${provider.errorMessage}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    
    final list = provider.filteredCountries;
    if (list.isNotEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 colonnes par exemple
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75, // Ajustez selon le contenu de la carte
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final country = list[index];
          return CountryCard(country: country);
        },
      );
    }

    // Cas par défaut (Liste vide sans erreur)
    return Center(
      child: Text(
        provider.searchQuery.isNotEmpty ? 'Aucun pays trouvé.' : 'Aucun pays à afficher.',
      ),
    );
  }
}
