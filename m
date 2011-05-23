Return-path: <mchehab@pedra>
Received: from mailfe03.c2i.net ([212.247.154.66]:57447 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753301Ab1EWLan (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:30:43 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Remove invalid parameter description.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:29:31 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bUk2Nrrof8Ulm0X"
Message-Id: <201105231329.31371.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_bUk2Nrrof8Ulm0X
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_bUk2Nrrof8Ulm0X
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0009.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0009.patch"

=46rom 843559156c08edaf3ef616df005eae8b8d14b186 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:28:50 +0200
Subject: [PATCH] Remove invalid parameter description.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/tda8261.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda8261.c b/drivers/media/dvb/fron=
tends/tda8261.c
index 1742056..53c7d8f 100644
=2D-- a/drivers/media/dvb/frontends/tda8261.c
+++ b/drivers/media/dvb/frontends/tda8261.c
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


--Boundary-00=_bUk2Nrrof8Ulm0X--
