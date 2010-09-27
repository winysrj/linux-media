Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231Ab0I0NDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:03:16 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3242997bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:03:15 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 04/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-core.c
Date: Mon, 27 Sep 2010 16:03:06 +0300
Message-Id: <1285592586-32281-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-core.c file that fixed up a tabs
and space Errors and warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-core.c |   62 ++++++++++++++++----------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index c487c19..e793b21 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -42,7 +42,7 @@ static unsigned int card[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
-static unsigned int cx25821_devcount = 0;
+static unsigned int cx25821_devcount;
 
 static DEFINE_MUTEX(devlist);
 LIST_HEAD(cx25821_devlist);
@@ -781,14 +781,14 @@ static void cx25821_shutdown(struct cx25821_dev *dev)
 
 	/* Disable Video A/B activity */
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
-	       cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-	       cx_write(dev->channels[i].sram_channels->int_msk, 0);
+		cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+		cx_write(dev->channels[i].sram_channels->int_msk, 0);
 	}
 
-	for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
-	     i++) {
-	       cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
-	       cx_write(dev->channels[i].sram_channels->int_msk, 0);
+	for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
+		i <= VID_UPSTREAM_SRAM_CHANNEL_J; i++) {
+		cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+		cx_write(dev->channels[i].sram_channels->int_msk, 0);
 	}
 
 	/* Disable Audio activity */
@@ -806,9 +806,9 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
 			      u32 format)
 {
 	if (channel_select <= 7 && channel_select >= 0) {
-	       cx_write(dev->channels[channel_select].
-			       sram_channels->pix_frmt, format);
-	       dev->channels[channel_select].pixel_formats = format;
+		cx_write(dev->channels[channel_select].
+			sram_channels->pix_frmt, format);
+		dev->channels[channel_select].pixel_formats = format;
 	}
 }
 
@@ -829,7 +829,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	cx_write(PCI_INT_STAT, 0xffffffff);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++)
-	       cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
 
 	cx_write(AUD_A_INT_STAT, 0xffffffff);
 	cx_write(AUD_B_INT_STAT, 0xffffffff);
@@ -843,22 +843,22 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	mdelay(100);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
-	       cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
-	       cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
-					       1440, 0);
-	       dev->channels[i].pixel_formats = PIXEL_FRMT_422;
-	       dev->channels[i].use_cif_resolution = FALSE;
+		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+		cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
+						1440, 0);
+		dev->channels[i].pixel_formats = PIXEL_FRMT_422;
+		dev->channels[i].use_cif_resolution = FALSE;
 	}
 
 	/* Probably only affect Downstream */
-	for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
-	     i++) {
-	       cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+	for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
+		i <= VID_UPSTREAM_SRAM_CHANNEL_J; i++) {
+		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
 	}
 
-       cx25821_sram_channel_setup_audio(dev,
-			       dev->channels[SRAM_CH08].sram_channels,
-			       128, 0);
+	cx25821_sram_channel_setup_audio(dev,
+				dev->channels[SRAM_CH08].sram_channels,
+				128, 0);
 
 	cx25821_gpio_init(dev);
 }
@@ -931,8 +931,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	/* Apply a sensible clock frequency for the PCIe bridge */
 	dev->clk_freq = 28000000;
-       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
-	       dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+	for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
+		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
 
 	if (dev->nr > 1)
 		CX25821_INFO("dev->nr > 1!");
@@ -1003,11 +1003,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	cx25821_card_setup(dev);
 
-       if (medusa_video_init(dev) < 0)
-	       CX25821_ERR("%s() Failed to initialize medusa!\n"
-	       , __func__);
+	if (medusa_video_init(dev) < 0)
+		CX25821_ERR("%s() Failed to initialize medusa!\n"
+		, __func__);
 
-       cx25821_video_register(dev);
+	cx25821_video_register(dev);
 
 	/* register IOCTL device */
 	dev->ioctl_dev =
@@ -1342,12 +1342,12 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
 		if (pci_status & mask[i]) {
-		       vid_status = cx_read(dev->channels[i].
-			       sram_channels->int_stat);
+			vid_status = cx_read(dev->channels[i].
+				sram_channels->int_stat);
 
 			if (vid_status)
 				handled +=
-				    cx25821_video_irq(dev, i, vid_status);
+				cx25821_video_irq(dev, i, vid_status);
 
 			cx_write(PCI_INT_STAT, mask[i]);
 		}
-- 
1.7.0.4

