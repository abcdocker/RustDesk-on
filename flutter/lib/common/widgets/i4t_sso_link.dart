import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

const _i4tSsoUrl = 'https://sso.frps.cn';

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

  Future<void> _openSso() async {
    final uri = Uri.parse(_i4tSsoUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _openSso,
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
                  'i4T SSO运维单点登录',
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
