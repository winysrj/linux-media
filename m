Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61893 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2DNWdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 18:33:45 -0400
Received: by bkcik5 with SMTP id ik5so2927721bkc.19
        for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 15:33:43 -0700 (PDT)
Message-ID: <4F89FB44.8050608@googlemail.com>
Date: Sun, 15 Apr 2012 00:33:40 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi,

I'm happy to announce the release of v4l-utils-0.8.8. It contains mostly
backports from the development branch. The most interesting addition are
the DVBv5 tools.
In case you're wondering what happened to 0.8.7: It contained a
regression in the upside down table for Lenovo X201 users.
Additionally Jean-Francois Moine prepared a patch for improved image
quality with Pixart based webcams that didn't made it into 0.8.7.

Full changelog for both versions:

v4l-utils-0.8.8
- ---------------
* Utils changes (0.9.x backports)
  * dvb-format-convert: fix argument check and helper message
* libv4l changes (0.9.x backports)
  * tinyjpeg: Better luminance quantization table for Pixart JPEG
(Jean-Francois Moine)
  * tinyjpeg: Fix out of bounds array usage
  * libv4lconvert: Use bytesperline instead of width (Robert Abel)
  * libv4lconvert: Revert Lenovo X201 upside down table entry
  * libv4lconver: Add 06f8:301b pac7302 based cam to the quirk table

v4l-utils-0.8.7
- ---------------
* Utils changes (0.9.x backports)
  * ir-keytable: Fixed file parsing errors
  * qv4l2: fix segfault when there are no inputs or outputs
  * dvb: Merged DVB tools from development branch
* libv4l changes (0.9.x backports)
  * Prevent GCC 4.7 inlining error
  * Add some more laptop models to the upside down devices table

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.8.tar.bz2

You can always find the latest developments and the stable branch here:
http://git.linuxtv.org/v4l-utils.git

Thanks,
Gregor

PS: Ubuntu users, you can install this via the ppa:libv4l/stable PPA.
-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPiftEAAoJEBmaZPrftQD/IgkP/1CRTIKOKTiLJFPW8/4uw2K9
PjIwjCXNgSF6X/yP8IuuDQvmgm1cqeshpn792Y9cahjI96AIvvTjmMVymrgWmuDQ
s87Zl1KquWCPFx33OKvRBOa2uQrbksY08tK0R7PwtOMjEElPNW6e9scgNw76Ic7o
z+R8FiEhlhyBFE5UCQMZbY/H+QX5JYkaYnJXhENi1VW/ot7USOdvCaPnCj8y2RqL
0164Ezg2QijocGcBpuTtLYk/sIYL4G6OUM+/iFF4zi6xQHD2oxomkR7YpSIXxz7l
VwDqLqXtC16H9mcKZTLBuvYDncczAQTN7bns28F+Dyf3NU70bvnQ6ZCa9N1fuWzN
XaVU3g2ZdjchEKi2hWE8Ir3oIBOnSiro3ZJTwPp9cvnKzOSNTuln/5OJPHt8dKHZ
LBWsjaLqbhv5neOYz64dAP4rwWREB/Kbn88YSuC1vHPany++rf51VUpAeZrNobRk
M7k7NWcg54Q3L1x+1l0bsQBcwOV9ik5KtDNzGUCNUDsoA7RWNiMjXrOnnViefktd
5Hd0qEM+TxosZBrD9+m8CStyZv0A+1kEk96+3GpNe3m1HZzZuiLEIbiNRg8w7PUh
nAne9uWOxMEKMXRYKJ0lbjUIuNbt/Z58OAiMmn8lwh7T3h35HCSmtgoglv/cNW1j
d+DxX0e+D4MHKW4ySpKu
=/zm4
-----END PGP SIGNATURE-----
