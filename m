Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:35437 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751546Ab1EWKw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 06:52:28 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Correct a module parameter description to describe the correct parameter.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:51:15 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jwj2NpB2BWemrS+"
Message-Id: <201105231251.15532.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_jwj2NpB2BWemrS+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_jwj2NpB2BWemrS+
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0002.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0002.patch"

=46rom 0b5b16dfa302229060eb4ceae0498f0d60ab86c1 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:50:01 +0200
Subject: [PATCH] Correct a module parameter description to describe the cor=
rect parameter.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/cx24116.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/fron=
tends/cx24116.c
index 2410d8b..cf1ec6c 100644
=2D-- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -137,7 +137,7 @@ MODULE_PARM_DESC(toneburst, "DiSEqC toneburst 0=3DOFF, =
1=3DTONE CACHE, "\
 /* SNR measurements */
 static int esno_snr;
 module_param(esno_snr, int, 0644);
=2DMODULE_PARM_DESC(debug, "SNR return units, 0=3DPERCENTAGE 0-100, "\
+MODULE_PARM_DESC(esno_snr, "SNR return units, 0=3DPERCENTAGE 0-100, "\
 	"1=3DESNO(db * 10) (default:0)");
=20
 enum cmds {
=2D-=20
1.7.1.1


--Boundary-00=_jwj2NpB2BWemrS+--
