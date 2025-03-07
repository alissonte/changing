import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/conversor_service.dart';
import '../utils/logger.dart';

class ConversaoEURBRLScreen extends StatefulWidget {
  const ConversaoEURBRLScreen({super.key});

  @override
  State<ConversaoEURBRLScreen> createState() => _ConversaoEURBRLScreenState();
}

class _ConversaoEURBRLScreenState extends State<ConversaoEURBRLScreen> {
  double taxaConversao = 0.0;
  final TextEditingController _controllerValorEuro = TextEditingController();
  double valorConvertido = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarCotacao();
  }

  void _carregarCotacao() async {
    setState(() {
      _isLoading = true;
    });

    try {
      double cotacao = await ConversorMoedaService.obterCotacaoEuroReal();
      setState(() {
        taxaConversao = cotacao;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Erro ao carregar cotação', e);
      setState(() {
        taxaConversao = -1;
        _isLoading = false;
      });
    }
  }

  void _converterMoeda(String valorDigitado) {
    if (valorDigitado.isEmpty || taxaConversao <= 0) {
      setState(() {
        valorConvertido = 0.0;
      });
      return;
    }

    final double? valorEuro = double.tryParse(valorDigitado);
    if (valorEuro != null) {
      setState(() {
        valorConvertido = valorEuro * taxaConversao;
      });
    } else {
      setState(() {
        valorConvertido = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor Euro - Real'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarCotacao,
            tooltip: 'Atualizar cotação',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1A5276),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Conversor de Moedas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versão 1.0.0',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text('Euro para Real'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Taxa de conversão
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.euro,
                              color: Color(0xFF1A5276),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.attach_money,
                              color: Color(0xFF2ECC71),
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else if (taxaConversao > 0)
                          Text(
                            'Taxa atual: 1 EUR = R\$ ${taxaConversao.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Erro ao carregar cotação',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (!_isLoading && taxaConversao > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Atualizado em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} às ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Conversor
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Converter Euro para Real',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _controllerValorEuro,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Digite o valor em Euro',
                            prefixIcon: Icon(Icons.euro),
                            hintText: '0.00',
                          ),
                          onChanged: _converterMoeda,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Valor em Reais:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Color(0xFF2ECC71),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'R\$ ${valorConvertido.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controllerValorEuro.clear();
          setState(() {
            valorConvertido = 0.0;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.refresh),
        tooltip: 'Limpar valores',
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o Aplicativo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conversor Euro - Real'),
            SizedBox(height: 8),
            Text('Versão 1.0.0'),
            SizedBox(height: 16),
            Text(
                'Este aplicativo permite converter valores de Euro para Real brasileiro utilizando cotações atualizadas.'),
            SizedBox(height: 8),
            Text('Desenvolvido com Flutter.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
