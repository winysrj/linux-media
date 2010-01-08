Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:56619 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0AHJda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 04:33:30 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1168457eye.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 01:33:29 -0800 (PST)
Date: Fri, 8 Jan 2010 18:38:28 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] DVB-T regression fix for saa7134 cards
Message-ID: <20100108183828.4f86cd3c@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/T/svqZceicZedN5qzOvHyRI"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/T/svqZceicZedN5qzOvHyRI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

Some customers has problem with quality of DVB-T
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/446575

After this patch http://patchwork.kernel.org/patch/23345/

This is patch for fix regression with DVB-T. Tested with many people.

diff -u ./saa7134.orig/saa7134-core.c ./saa7134/saa7134-core.c
--- ./saa7134.orig/saa7134-core.c	2009-09-10 05:13:59.000000000 +0700
+++ ./saa7134/saa7134-core.c	2010-01-07 13:01:11.000000000 +0600
@@ -420,19 +420,6 @@
 		ctrl |= SAA7134_MAIN_CTRL_TE5;
 		irq  |= SAA7134_IRQ1_INTE_RA2_1 |
 			SAA7134_IRQ1_INTE_RA2_0;
-
-		/* dma: setup channel 5 (= TS) */
-
-		saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
-		saa_writeb(SAA7134_TS_DMA1,
-			((dev->ts.nr_packets - 1) >> 8) & 0xff);
-		/* TSNOPIT=0, TSCOLAP=0 */
-		saa_writeb(SAA7134_TS_DMA2,
-			(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
-		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
-		saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
-						  SAA7134_RS_CONTROL_ME |
-						  (dev->ts.pt_ts.dma >> 12));
 	}
 
 	/* set task conditions + field handling */
diff -u ./saa7134.orig/saa7134-ts.c ./saa7134/saa7134-ts.c
--- ./saa7134.orig/saa7134-ts.c	2009-09-10 05:13:59.000000000 +0700
+++ ./saa7134/saa7134-ts.c	2010-01-07 13:03:29.000000000 +0600
@@ -249,7 +249,20 @@
 	dprintk("TS start\n");
 
 	BUG_ON(dev->ts_started);
+
+	/* dma: setup channel 5 (= TS) */
+	saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
+	saa_writeb(SAA7134_TS_DMA1,
+		((dev->ts.nr_packets - 1) >> 8) & 0xff);
+	/* TSNOPIT=0, TSCOLAP=0 */
+	saa_writeb(SAA7134_TS_DMA2,
+		(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
+	saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
+					  SAA7134_RS_CONTROL_ME |
+					  (dev->ts.pt_ts.dma >> 12));
 
+	/* reset hardware TS buffers */
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
 	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/T/svqZceicZedN5qzOvHyRI
Content-Type: text/x-patch; name=dma_set_fix.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dma_set_fix.patch

diff -u ./saa7134.orig/saa7134-core.c ./saa7134/saa7134-core.c
--- ./saa7134.orig/saa7134-core.c	2009-09-10 05:13:59.000000000 +0700
+++ ./saa7134/saa7134-core.c	2010-01-07 13:01:11.000000000 +0600
@@ -420,19 +420,6 @@
 		ctrl |= SAA7134_MAIN_CTRL_TE5;
 		irq  |= SAA7134_IRQ1_INTE_RA2_1 |
 			SAA7134_IRQ1_INTE_RA2_0;
-
-		/* dma: setup channel 5 (= TS) */
-
-		saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
-		saa_writeb(SAA7134_TS_DMA1,
-			((dev->ts.nr_packets - 1) >> 8) & 0xff);
-		/* TSNOPIT=0, TSCOLAP=0 */
-		saa_writeb(SAA7134_TS_DMA2,
-			(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
-		saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
-		saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
-						  SAA7134_RS_CONTROL_ME |
-						  (dev->ts.pt_ts.dma >> 12));
 	}
 
 	/* set task conditions + field handling */
diff -u ./saa7134.orig/saa7134-ts.c ./saa7134/saa7134-ts.c
--- ./saa7134.orig/saa7134-ts.c	2009-09-10 05:13:59.000000000 +0700
+++ ./saa7134/saa7134-ts.c	2010-01-07 13:03:29.000000000 +0600
@@ -249,7 +249,20 @@
 	dprintk("TS start\n");
 
 	BUG_ON(dev->ts_started);
+
+	/* dma: setup channel 5 (= TS) */
+	saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
+	saa_writeb(SAA7134_TS_DMA1,
+		((dev->ts.nr_packets - 1) >> 8) & 0xff);
+	/* TSNOPIT=0, TSCOLAP=0 */
+	saa_writeb(SAA7134_TS_DMA2,
+		(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
+	saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
+					  SAA7134_RS_CONTROL_ME |
+					  (dev->ts.pt_ts.dma >> 12));
 
+	/* reset hardware TS buffers */
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
 	saa_writeb(SAA7134_TS_SERIAL1, 0x03);
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>
Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/T/svqZceicZedN5qzOvHyRI--
