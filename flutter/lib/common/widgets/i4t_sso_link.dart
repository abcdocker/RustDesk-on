import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

const i4tSsoUrl = 'https://sso.frps.cn';
const i4tBlogUrl = 'https://i4t.com';
const i4tSsoLabel = 'i4T SSO运维单点登录';
const i4tCopyNote = 'i4T 运维博客单点登录Rustdesk客户端使用';

const _i4tSsoSvg = '''
<svg width="168" height="96" viewBox="0 0 168 96" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="12" y1="12" x2="156" y2="84" gradientUnits="userSpaceOnUse">
      <stop stop-color="#1F7A8C"/>
      <stop offset="0.48" stop-color="#2EC4B6"/>
      <stop offset="1" stop-color="#FF9F1C"/>
    </linearGradient>
    <linearGradient id="shine" x1="28" y1="10" x2="142" y2="76" gradientUnits="userSpaceOnUse">
      <stop stop-color="white" stop-opacity="0.56"/>
      <stop offset="1" stop-color="white" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect x="8" y="8" width="152" height="80" rx="16" fill="url(#bg)"/>
  <path d="M22 26C38 13 59 16 74 32C86 45 103 46 119 33C129 25 141 23 153 27V75H22V26Z" fill="url(#shine)"/>
  <circle cx="44" cy="49" r="18" fill="white" fill-opacity="0.16"/>
  <circle cx="124" cy="49" r="18" fill="white" fill-opacity="0.16"/>
  <path d="M58 49H110" stroke="white" stroke-width="8" stroke-linecap="round"/>
  <path d="M76 33L92 49L76 65" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="84" y="79" text-anchor="middle" fill="white" font-family="Arial, Helvetica, sans-serif" font-size="18" font-weight="700">i4T SSO</text>
</svg>
''';

Future<void> openI4TSso() async {
  final uri = Uri.parse(i4tSsoUrl);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await launchUrl(uri);
  }
}

String i4tRustDeskCopyText({
  String? id,
  String? oneTimePassword,
}) {
  final lines = <String>[i4tCopyNote];
  final trimmedId = id?.trim() ?? '';
  final trimmedPassword = oneTimePassword?.trim() ?? '';
  if (trimmedId.isNotEmpty) {
    lines.add('ID: $trimmedId');
  }
  if (trimmedPassword.isNotEmpty && trimmedPassword != '-') {
    lines.add('一次性密码: $trimmedPassword');
  }
  return lines.join('\n');
}

Future<void> copyI4TRustDeskInfo({
  String? id,
  String? oneTimePassword,
}) async {
  await Clipboard.setData(ClipboardData(
      text: i4tRustDeskCopyText(id: id, oneTimePassword: oneTimePassword)));
}

class I4TSsoLink extends StatelessWidget {
  const I4TSsoLink({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.svgWidth = 112,
    this.svgHeight = 64,
  }) : super(key: key);

  final EdgeInsetsGeometry margin;
  final double svgWidth;
  final double svgHeight;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: openI4TSso,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.string(
                  _i4tSsoSvg,
                  width: svgWidth,
                  height: svgHeight,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 4),
                Text(
                  i4tSsoLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class I4TSsoButton extends StatelessWidget {
  const I4TSsoButton({
    Key? key,
    this.height = 38,
    this.width,
    this.iconSize = 20,
  }) : super(key: key);

  final double height;
  final double? width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      icon: SvgPicture.string(
        _i4tSsoSvg,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.cover,
      ),
      label: const Text(
        i4tSsoLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: openI4TSso,
    );
    return SizedBox(height: height, width: width, child: button);
  }
}

class I4TDynamicAvatar extends StatelessWidget {
  const I4TDynamicAvatar({
    Key? key,
    required this.seed,
    this.radius = 14,
  }) : super(key: key);

  final String seed;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _I4TAvatarPainter(seed),
        ),
      ),
    );
  }
}

class _I4TAvatarPainter extends CustomPainter {
  _I4TAvatarPainter(this.seed);

  final String seed;

  int get _hash {
    var hash = 0x45d9f3b;
    for (var i = 0; i < seed.length; i++) {
      hash = 0x1fffffff & (hash + seed.codeUnitAt(i));
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
    return hash;
  }

  Color _color(int shift, double saturation, double lightness) {
    final hue = ((_hash >> shift) & 0xff) * 360 / 255;
    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = _color(0, 0.58, 0.32);
    final accent = _color(8, 0.78, 0.58);
    final warm = _color(16, 0.82, 0.64);
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [base, accent],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.38);
    canvas.drawArc(
      rect.deflate(size.width * 0.18),
      -0.85,
      4.45,
      false,
      ringPaint,
    );

    final dotPaint = Paint()..color = warm;
    final dotRadius = size.width * 0.12;
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.34),
      dotRadius,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.38, size.height * 0.62),
      dotRadius * 0.68,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _I4TAvatarPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
