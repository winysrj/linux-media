Return-path: <mchehab@localhost>
Received: from mail.juropnet.hu ([212.24.188.131]:59552 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab1GKOHr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 10:07:47 -0400
Received: from [94.248.228.50] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QgH9E-0007Qp-0q
	for linux-media@vger.kernel.org; Mon, 11 Jul 2011 16:07:46 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] cx88: implemented luma notch filter control
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 16:07:43 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111607.43487.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The following patch adds a new control that makes it possible to set the
luma notch filter type to finetune picture quality.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-core.c xc4000/drivers/media/video/cx88/cx88-core.c
--- xc4000_orig/drivers/media/video/cx88/cx88-core.c	2011-07-11 15:34:50.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-core.c	2011-07-11 15:44:35.000000000 +0200
@@ -636,6 +636,9 @@
 	cx_write(MO_PCI_INTSTAT,   0xFFFFFFFF); // Clear PCI int
 	cx_write(MO_INT1_STAT,     0xFFFFFFFF); // Clear RISC int
 
+	/* set default notch filter */
+	cx_andor(MO_HTOTAL, 0x1800, (HLNotchFilter4xFsc << 11));
+
 	/* Reset on-board parts */
 	cx_write(MO_SRST_IO, 0);
 	msleep(10);
@@ -994,10 +997,10 @@
 	// htotal
 	tmp64 = norm_htotal(norm) * (u64)vdec_clock;
 	do_div(tmp64, fsc8);
-	htotal = (u32)tmp64 | (HLNotchFilter4xFsc << 11);
+	htotal = (u32)tmp64;
 	dprintk(1,"set_tvnorm: MO_HTOTAL        0x%08x [old=0x%08x,htotal=%d]\n",
 		htotal, cx_read(MO_HTOTAL), (u32)tmp64);
-	cx_write(MO_HTOTAL, htotal);
+	cx_andor(MO_HTOTAL, 0x07ff, htotal);
 
 	// vbi stuff, set vbi offset to 10 (for 20 Clk*2 pixels), this makes
 	// the effective vbi offset ~244 samples, the same as the Bt8x8
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-video.c xc4000/drivers/media/video/cx88/cx88-video.c
--- xc4000_orig/drivers/media/video/cx88/cx88-video.c	2011-07-11 15:34:50.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-video.c	2011-07-11 15:49:29.000000000 +0200
@@ -262,6 +262,20 @@
 		.mask                  = 1 << 9,
 		.shift                 = 9,
 	}, {
+		.v = {
+			.id            = V4L2_CID_BAND_STOP_FILTER,
+			.name          = "Notch filter",
+			.minimum       = 0,
+			.maximum       = 3,
+			.step          = 1,
+			.default_value = 0x0,
+			.type          = V4L2_CTRL_TYPE_INTEGER,
+		},
+		.off                   = 0,
+		.reg                   = MO_HTOTAL,
+		.mask                  = 3 << 11,
+		.shift                 = 11,
+	}, {
 	/* --- audio --- */
 		.v = {
 			.id            = V4L2_CID_AUDIO_MUTE,
@@ -320,6 +334,7 @@
 	V4L2_CID_SHARPNESS,
 	V4L2_CID_CHROMA_AGC,
 	V4L2_CID_COLOR_KILLER,
+	V4L2_CID_BAND_STOP_FILTER,
 	0
 };
 EXPORT_SYMBOL(cx88_user_ctrls);
