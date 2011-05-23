Return-path: <mchehab@pedra>
Received: from mailfe03.c2i.net ([212.247.154.66]:44497 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755253Ab1EWOiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:38:51 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Alternate setting 1 must be selected for interface 0 on the model that I received. Else the rest is identical.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:37:39 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zEn2NxpFtxIsen3"
Message-Id: <201105231637.39053.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_zEn2NxpFtxIsen3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_zEn2NxpFtxIsen3
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0016.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0016.patch"

=46rom 3cf61d6a77b22f58471188cd0e7e3dc6c3a29b0b Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:36:55 +0200
Subject: [PATCH] Alternate setting 1 must be selected for interface 0 on th=
e model that I received. Else the rest is identical.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/me=
dia/dvb/ttusb-budget/dvb-ttusb-budget.c
index cbe2f0d..38a7d03 100644
=2D-- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -971,6 +971,14 @@ static int ttusb_stop_feed(struct dvb_demux_feed *dvbd=
mxfeed)
=20
 static int ttusb_setup_interfaces(struct ttusb *ttusb)
 {
+	/*
+	 * Try to select alternate setting 1 for first interface. If
+	 * that does not work, restore to alternate setting 0.
+	 */
+	if (usb_set_interface(ttusb->dev, 0, 1) < 0)
+		usb_set_interface(ttusb->dev, 0, 0);
+
+	/* Select alternate setting 1 for second interface. */
 	usb_set_interface(ttusb->dev, 1, 1);
=20
 	ttusb->bulk_out_pipe =3D usb_sndbulkpipe(ttusb->dev, 1);
=2D-=20
1.7.1.1


--Boundary-00=_zEn2NxpFtxIsen3--
