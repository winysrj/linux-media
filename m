Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:47111 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZHINbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 09:31:03 -0400
Received: by ewy10 with SMTP id 10so2489225ewy.37
        for <linux-media@vger.kernel.org>; Sun, 09 Aug 2009 06:31:02 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org, Mauro Chehab <mchehab@infradead.org>,
	Mark Zimmerman <markzimm@frii.com>,
	"v4l-dvb list" <v4l-dvb-maintainer@linuxtv.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: [PATCH] cx88: fix TBS 8920 card support.
Date: Sun, 9 Aug 2009 16:30:20 +0300
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_s9sfKKLQgcwHGf+"
Message-Id: <200908091630.20844.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_s9sfKKLQgcwHGf+
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

It does matter to set explicitly gpio0 value in cx88_board structure for TBS 8920 card.


--Boundary-00=_s9sfKKLQgcwHGf+
Content-Type: text/x-patch;
  charset="us-ascii";
  name="12346_a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="12346_a.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1248905908 -10800
# Node ID d2dee95e2da26a145cca2d081be86793cc9b07ea
# Parent  ee6cf88cb5d3faf861289fce0ef0385846adcc7c
cx88: fix TBS 8920 card support

From: Igor M. Liplianin <liplianin@me.by>

It does matter to set explicitly gpio0 value in
cx88_board structure for TBS 8920 card.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r ee6cf88cb5d3 -r d2dee95e2da2 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Wed Jul 29 01:42:02 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Thu Jul 30 01:18:28 2009 +0300
@@ -1941,7 +1941,8 @@
 		.radio_addr     = ADDR_UNSET,
 		.input          = {{
 			.type   = CX88_VMUX_DVB,
-			.vmux   = 1,
+			.vmux   = 0,
+			.gpio0  = 0x8080,
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -3187,7 +3188,11 @@
 	case  CX88_BOARD_PROF_6200:
 	case  CX88_BOARD_PROF_7300:
 	case  CX88_BOARD_SATTRADE_ST4200:
+		cx_write(MO_GP0_IO, 0x8000);
+		msleep(100);
 		cx_write(MO_SRST_IO, 0);
+		msleep(10);
+		cx_write(MO_GP0_IO, 0x8080);
 		msleep(100);
 		cx_write(MO_SRST_IO, 1);
 		msleep(100);
diff -r ee6cf88cb5d3 -r d2dee95e2da2 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Wed Jul 29 01:42:02 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Jul 30 01:18:28 2009 +0300
@@ -425,17 +425,16 @@
 	struct cx8802_dev *dev= fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
+	cx_set(MO_GP0_IO, 0x6040);
 	switch (voltage) {
 		case SEC_VOLTAGE_13:
-			printk("LNB Voltage SEC_VOLTAGE_13\n");
-			cx_write(MO_GP0_IO, 0x00006040);
+			cx_clear(MO_GP0_IO, 0x20);
 			break;
 		case SEC_VOLTAGE_18:
-			printk("LNB Voltage SEC_VOLTAGE_18\n");
-			cx_write(MO_GP0_IO, 0x00006060);
+			cx_set(MO_GP0_IO, 0x20);
 			break;
 		case SEC_VOLTAGE_OFF:
-			printk("LNB Voltage SEC_VOLTAGE_off\n");
+			cx_clear(MO_GP0_IO, 0x20);
 			break;
 	}
 

--Boundary-00=_s9sfKKLQgcwHGf+--
