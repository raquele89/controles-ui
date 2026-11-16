import 'package:flutter/material.dart';

void main() => runApp(const AppCursos());

class Curso {
  final String titulo;
  final String categoria;
  final IconData icone;
  final int duracaohora;

  const Curso(this.titulo, this.categoria, this.icone, this.duracaohora);
}

const categorias = ['Programação', 'Design', 'Negócios', 'Dados'];

const cursos = [
  Curso('Flutter na prática', 'Programação', Icons.code, 3800),
  Curso('Orientação a objetos', 'Programação', Icons.account_tree, 2500),
  Curso('Interfaces acessíveis', 'Design', Icons.accessibility_new, 3700),
  Curso('Design de interfaces', 'Design', Icons.palette, 24),
  Curso('Gestão de projetos', 'Negócios', Icons.business_center, 60),
  Curso('Gestão de Banco de Dados', 'Dados', Icons.sd_storage, 200),
];

class AppCursos extends StatelessWidget {
  const AppCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: DefaultTabController(
        length: categorias.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Explore cursos'),
            bottom: TabBar(
              tabs: [for (final categoria in categorias) Tab(text: categoria)],
            ),
          ),
          body: TabBarView(
            children: [
              for (final categoria in categorias)
                ListaCursos(categoria: categoria),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaCursos extends StatelessWidget {
  final String categoria;

  const ListaCursos({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final filtrados = cursos
        .where((curso) => curso.categoria == categoria)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtrados.length,
      itemBuilder: (context, index) {
        final curso = filtrados[index];

        return CursoCard(
          curso: curso,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DetalhesCurso(curso: curso),
              ),
            );
          },
        );
      },
    );
  }
}

class CursoCard extends StatelessWidget {
  final Curso curso;
  final VoidCallback onTap;

  const CursoCard({super.key, required this.curso, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Hero(tag: curso.titulo, child: Icon(curso.icone, size: 36)),
        title: Text(curso.titulo),
        subtitle: Text(curso.categoria),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class DetalhesCurso extends StatefulWidget {
  final Curso curso;

  const DetalhesCurso({super.key, required this.curso});

  @override
  State<DetalhesCurso> createState() => _DetalhesCursoState();
}

class _DetalhesCursoState extends State<DetalhesCurso> {
  bool favorito = false;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final reduzirMovimento = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do curso')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Hero(
            tag: widget.curso.titulo,
            child: Icon(widget.curso.icone, size: 96),
          ),
          const SizedBox(height: 24),
          Text(
            widget.curso.titulo,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(widget.curso.categoria),
          const SizedBox(height: 24),
          Text('${widget.curso.duracaohora} horas'),
          const SizedBox(height: 24),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: reduzirMovimento ? 0 : 200),
              padding: EdgeInsets.all(favorito ? 12 : 4),
              decoration: BoxDecoration(
                color: favorito ? cores.primaryContainer : cores.surface,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                tooltip: favorito
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                isSelected: favorito,
                selectedIcon: const Icon(Icons.favorite),
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  setState(() => favorito = !favorito);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
