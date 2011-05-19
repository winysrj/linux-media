Return-path: <mchehab@pedra>
Received: from mailfe01.c2i.net ([212.247.154.2]:43063 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756684Ab1ESIj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 04:39:59 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe01.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 129166233 for linux-media@vger.kernel.org; Thu, 19 May 2011 10:39:56 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCHES] Various MODULE parameter releated fixes
Date: Thu, 19 May 2011 10:38:48 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YcN1NCcnD8vP2pZ"
Message-Id: <201105191038.48068.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_YcN1NCcnD8vP2pZ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_YcN1NCcnD8vP2pZ
Content-Type: text/x-patch;
  charset="us-ascii";
  name="tda7432.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="tda7432.diff"

=46rom 0e135fa9cd9cb377bd8930253a547d6d9ae6d01b Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 19 May 2011 02:46:40 +0200
Subject: [PATCH] Parameter description should be after parameter.

=2D--
 ../media_tree/drivers/media/video/tda7432.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/../media_tree/drivers/media/video/tda7432.c b/../media_tree/dr=
ivers/media/video/tda7432.c
index 3941f95..398b9fb 100644
=2D-- a/../media_tree/drivers/media/video/tda7432.c
+++ b/../media_tree/drivers/media/video/tda7432.c
@@ -50,8 +50,8 @@ static int loudness; /* disable loudness by default */
 static int debug;	 /* insmod parameter */
 module_param(debug, int, S_IRUGO | S_IWUSR);
 module_param(loudness, int, S_IRUGO);
=2DMODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0d=
b(1)");
 module_param(maxvol, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0db(=
1)");
=20
=20
=20
=2D-=20
1.7.1.1


--Boundary-00=_YcN1NCcnD8vP2pZ
Content-Type: text/x-patch;
  charset="us-ascii";
  name="tda8261.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="tda8261.diff"

=46rom 7191938e7da088ccb5e8bad36e99ca495e53d206 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 19 May 2011 02:56:48 +0200
Subject: [PATCH] Remove invalid parameter description.

=2D--
 ../media_tree/drivers/media/dvb/frontends/tda8261.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/../media_tree/drivers/media/dvb/frontends/tda8261.c b/../media=
_tree/drivers/media/dvb/frontends/tda8261.c
index 1742056..53c7d8f 100644
=2D-- a/../media_tree/drivers/media/dvb/frontends/tda8261.c
+++ b/../media_tree/drivers/media/dvb/frontends/tda8261.c
@@ -224,7 +224,6 @@ exit:
 }
=20
 EXPORT_SYMBOL(tda8261_attach);
=2DMODULE_PARM_DESC(verbose, "Set verbosity level");
=20
 MODULE_AUTHOR("Manu Abraham");
 MODULE_DESCRIPTION("TDA8261 8PSK/QPSK Tuner");
=2D-=20
1.7.1.1


--Boundary-00=_YcN1NCcnD8vP2pZ
Content-Type: text/x-patch;
  charset="us-ascii";
  name="cx24116.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="cx24116.c.diff"

--- cx24116.c.orig	2011-03-20 23:11:40.000000000 +0100
+++ cx24116.c	2011-03-20 23:12:35.000000000 +0100
@@ -137,7 +137,7 @@
 /* SNR measurements */
 static int esno_snr;
 module_param(esno_snr, int, 0644);
-MODULE_PARM_DESC(debug, "SNR return units, 0=PERCENTAGE 0-100, "\
+MODULE_PARM_DESC(esno_snr, "SNR return units, 0=PERCENTAGE 0-100, "\
 	"1=ESNO(db * 10) (default:0)");
 
 enum cmds {

--Boundary-00=_YcN1NCcnD8vP2pZ--
