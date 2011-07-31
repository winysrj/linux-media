Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:42211 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1GaJxh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 05:53:37 -0400
Received: from [94.248.227.4] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QnSiC-0004n4-7C
	for linux-media@vger.kernel.org; Sun, 31 Jul 2011 11:53:34 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: notch filter control fixes
MIME-Version: 1.0
Date: Sun, 31 Jul 2011 11:53:29 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311153.29710.istvan_v@mailbox.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch reduces the number of available choices for the notch filter type control
so that the standard-specific filter types cannot be selected. It is now limited to
being either 0 (4xFsc, the default) or 1 (square pixel optimized).
The patch also removes the initialization of this control from cx88_reset(), since
that is already done by init_controls(), which is called by cx8800_initdev().

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
--- a/drivers/media/video/cx88/cx88-core.c	2011-07-31 11:19:03.000000000 +0200
+++ b/drivers/media/video/cx88/cx88-core.c	2011-07-31 11:43:14.000000000 +0200
@@ -636,9 +636,6 @@
 	cx_write(MO_PCI_INTSTAT,   0xFFFFFFFF); // Clear PCI int
 	cx_write(MO_INT1_STAT,     0xFFFFFFFF); // Clear RISC int
 
-	/* set default notch filter */
-	cx_andor(MO_HTOTAL, 0x1800, (HLNotchFilter4xFsc << 11));
-
 	/* Reset on-board parts */
 	cx_write(MO_SRST_IO, 0);
 	msleep(10);
diff -uNr a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c	2011-07-31 11:19:03.000000000 +0200
+++ b/drivers/media/video/cx88/cx88-video.c	2011-07-31 11:43:40.000000000 +0200
@@ -266,7 +266,7 @@
 			.id            = V4L2_CID_BAND_STOP_FILTER,
 			.name          = "Notch filter",
 			.minimum       = 0,
-			.maximum       = 3,
+			.maximum       = 1,
 			.step          = 1,
 			.default_value = 0x0,
 			.type          = V4L2_CTRL_TYPE_INTEGER,
