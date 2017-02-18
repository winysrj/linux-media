Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40866 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdBRAay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 19:30:54 -0500
Date: Sat, 18 Feb 2017 00:30:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, 853110@bugs.debian.org
Message-ID: <20170218003051.GB4152@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
Subject: [PATCH] [media] dvb-usb-dibusb-mc-common: Add MODULE_LICENSE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

dvb-usb-dibusb-mc-common is licensed under GPLv2, and if we don't say
so then it won't even load since it needs a GPL-only symbol.

Reported-by: Dominique Dumont <dod@debian.org>
References: https://bugs.debian.org/853110
Cc: stable@vger.kernel.org # 4.9+
Fixes: e91455a1495a ("[media] dvb-usb: split out common parts of dibusb")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/dvb-usb/dibusb-mc-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dibusb-mc-common.c b/drivers/media/u=
sb/dvb-usb/dibusb-mc-common.c
index c989cac9343d..0c2bc97436d5 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mc-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
@@ -11,6 +11,8 @@
=20
 #include "dibusb.h"
=20
+MODULE_LICENSE("GPL");
+
 /* 3000MC/P stuff */
 // Config Adjacent channels  Perf -cal22
 static struct dibx000_agc_config dib3000p_mt2060_agc_config =3D {

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBWKeVu+e/yOyVhhEJAQpQIg//c9xaO0xiTbnp3wDlbk+77YEAkSh8jlRE
YwsUKb8qMqdNZhlvfcQ25j9SJbzd84+YM2nG5wETlWIhrEVhmly2Z0CMVQIj2rF5
KUYbyeFdQ12HrOBBSDXDhA0NhjnyRL3Xig6a++oORNOONRppKSPHgLNLULFjyusK
FTwGstHXJELiVt7jR02lxVc+deYi+cRLHq5SkRKotiR4YOB0DkMs/XfbSIZcHhCv
Hp49ZUKUxGhtcjqxPhMgEFoY1TjVd431VWTD7WeqntrckLYWEx6m1SwLARdeEbad
fB2qhKhvgEHBmniIAygGgHWIADt9iw5uSYeFvb9T3ePe/thuA8NAlUqUlJ/adn9Q
2E7Acbwg3vEr1cagl2hJ4KCDWhmMkhGabMVpgh2486zjfdfgNY9+evRRV+AbN7SH
TCoBxQNG/K4OrBRWdMFRzfxi4XOyWYAQMaxRjgYz0ZLaEVOt65Gk2KvY+6n8vJ/C
ZLjP2E7vqO5rH+TbQ6PAUS1c/8/jViKdR1DXI8Arl9scbfAMImmHCFo9B3onJoTF
FaMRJ5yRgM3eusLZhK2w5u8CQAAefyfK0eXjuBJELRhSnNV4g//jCbL1bkOTzS8p
x4zDd9Hm2X2htlnANq6e+Ev6f/54e1YyV1NEkTgEaqXV1I9lwPKDNgUTi6BhcqBN
Iynqnr++hJQ=
=hcR1
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
