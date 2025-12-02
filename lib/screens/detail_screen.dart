import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../providers/country_provider.dart';

class DetailScreen extends StatefulWidget {
  final Country country;
  const DetailScreen({required this.country, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final country = widget.country;

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          Consumer<CountryProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(country.name);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  provider.toggleFavorite(country);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: country.flagurl.isNotEmpty
                  ? Hero(
                      tag: country.name,
                      child: Image.network(
                        country.flagurl,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.flag, size: 150, color: Colors.grey);
                        },
                      ),
                    )
                  : const Icon(Icons.flag, size: 150, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Capitale', country.capital),
            const SizedBox(height: 12),
            _buildInfoRow('Région', country.region),
            const SizedBox(height: 12),
            _buildInfoRow('Population', _formatPopulation(country.population)),
            const Divider(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  String _formatPopulation(String population) {
    try {
      final num = int.parse(population);
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(1)}K';
      }
      return num.toString();
    } catch (e) {
      return population;
    }
  }
}
