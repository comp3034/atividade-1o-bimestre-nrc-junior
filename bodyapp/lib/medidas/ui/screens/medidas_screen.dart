import 'package:bodyapp/dieta/dieta.dart';
import 'package:bodyapp/shared/colors.dart';
import 'package:bodyapp/shared/widgets/input_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class MedidasScreen extends StatefulWidget {
  final String altura;
  final String peso;
  final String pescoco;
  final String peito;

  MedidasScreen({
    Key? key,
    this.altura = null ?? '170',
    this.peso = null ?? '70',
    this.pescoco = null ?? '95',
    this.peito = null ?? '95',
  }) : super(key: key);

  @override
  _MedidasScreenState createState() => _MedidasScreenState();
}

int count = 0;
int countMeasure = 0;
bool hasConnection = true;

class Medidas {
  bool initialized = false;
  final List<String> labels = ['Altura', 'Peso', 'Pescoço', 'Peito'];
  List<String> values;
  Medidas(this.values);
}

class _MedidasScreenState extends State<MedidasScreen> {
  
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  Medidas medidas = Medidas([]);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (!medidas.initialized) {
      count = 0;
      countMeasure = 0;
      medidas =
          Medidas([widget.altura, widget.peso, widget.pescoco, widget.peito]);
      medidas.initialized = true;
    }

    List<Widget> widgetsAtualizador = [
      Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            child: Container(color: Colors.white.withOpacity(0.5)),
          ),
          Positioned.fill(
            top: 420,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      '${medidas.labels[countMeasure]}',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 18 / 568 * height,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 72.0, right: 72.0),
                    child: Form(
                      key: _formKey,
                      child: InputWidget(
                        controller: _controller,
                        hintText: 'Nova medida',
                        validator: (value) {
                          RegExp negativo = new RegExp(
                              r'^-'); //nrc: não sei porque mas valor negativo n ta retornando????
                          if (value != null &&
                              !isFloat(value) &&
                              !negativo.hasMatch(value)) {
                            return 'insira um valor.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 72.0, right: 72.0),
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            medidas.values[countMeasure] = _controller.text;
                            setState(() {
                              if (countMeasure < medidas.values.length - 1) {
                                countMeasure++;
                              } else if (hasConnection) {
                                count = 0;
                                countMeasure = 0;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Salvou informações no backend')),
                                );
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedidasScreen(
                                      altura: medidas.values[0],
                                      peso: medidas.values[1],
                                      pescoco: medidas.values[2],
                                      peito: medidas.values[3],
                                    ),
                                  ),
                                );
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Sem Conexão com Backend')),
                                );
                              }
                            });
                            _controller.text = medidas.values[countMeasure];
                          }
                        },
                        child: Center(
                          child: Text(
                            '${countMeasure < medidas.values.length - 1 ? 'Atualizar' : 'Concluir'}',
                            style: GoogleFonts.rokkitt(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${count == 0 ? 'Medidas' : 'Atualizando Medidas'}'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              height: height - 64,
              child: Image.asset(
                'assets/images/women-silhouette.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              bottom: 8,
              left: width * .3,
              child: Text('atualizado em ${DateTime.now()}'),
            ),
            Positioned(
              right: 48,
              top: 48,
              child: Row(
                children: [
                  MeasureLabelWidget(
                    label: 'Altura',
                    value: '${medidas.values[0]}',
                    measure: 'cm',
                  ),
                  SizedBox(width: 16),
                  MeasureLabelWidget(
                    label: 'Peso',
                    value: '${medidas.values[1]}',
                    measure: 'kg',
                  ),
                ],
              ),
            ),

            NestedMeasureWidget(
              top: 125,
              left: 0,
              width: width * .5,
              label: 'Pescoço',
              value: '${medidas.values[2]}',
              measure: ' cm',
            ),
            NestedMeasureWidget(
              top: 188,
              left: 0,
              width: width * .6,
              label: 'Peito',
              value: '${medidas.values[3]}',
              measure: ' cm',
            ),

            //adiciona atualizador:
            ListView.builder(
                itemCount: widgetsAtualizador.length,
                itemBuilder: (context, index) {
                  return count == 1 ? widgetsAtualizador[index] : SizedBox();
                }),
          ],
        ),
      ),
      floatingActionButton: 
      count == 0?
      FloatingActionButton(
        onPressed: () {
          setState(() {
            count = count == 0 ? 1 : 0;
          });
        },
        child: Icon(Icons.add),
      ):null,
    );
  }
}

class NestedMeasureWidget extends StatelessWidget {
  NestedMeasureWidget({
    Key? key,
    required this.width,
    this.top = 0,
    this.left = 0,
    required this.label,
    required this.value,
    this.measure = '',
  }) : super(key: key);

  final double width;
  final double top;
  final double left;
  final String label;
  final String value;
  final String measure;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8),
                child: DottedLine(
                  dashGapLength: 8,
                ),
              ),
            ),
            MeasureLabelWidget(
              label: '$label',
              value: '$value',
              measure: '$measure',
            ),
          ],
        ),
      ),
    );
  }
}

class MeasureLabelWidget extends StatelessWidget {
  final String label;
  final String value;
  final String measure;

  const MeasureLabelWidget({
    Key? key,
    required this.label,
    required this.value,
    this.measure = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label'),
        RichText(
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              fontSize: 36,
            ),
            children: [
              TextSpan(
                text: ' $measure',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
