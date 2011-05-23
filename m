Return-path: <mchehab@pedra>
Received: from mailfe05.c2i.net ([212.247.154.130]:51256 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195Ab1EWL2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:28:25 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Define parameter description after the parameter itself.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:27:11 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PSk2NFi2yxg4yOh"
Message-Id: <201105231327.11791.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_PSk2NFi2yxg4yOh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_PSk2NFi2yxg4yOh
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0008.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0008.patch"

=46rom 2f5378e5c5cc5528473f77321879fb075005d3dd Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:26:04 +0200
Subject: [PATCH] Define parameter description after the parameter itself.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/video/tda7432.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tda7432.c b/drivers/media/video/tda7432.c
index 3941f95..398b9fb 100644
=2D-- a/drivers/media/video/tda7432.c
+++ b/drivers/media/video/tda7432.c
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


--Boundary-00=_PSk2NFi2yxg4yOh--
