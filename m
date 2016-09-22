Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33270 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934461AbcIVAEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 20:04:30 -0400
Received: by mail-lf0-f42.google.com with SMTP id b71so28072136lfg.0
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 17:04:29 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: maintainers@bluecherrydvr.com, andrey_utkin@fastmail.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] [media] tw5864: crop picture width to 704
Date: Thu, 22 Sep 2016 03:04:20 +0300
Message-Id: <20160922000420.4273-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, width of 720 was used, but it gives 16-pixel wide black bar
at right side of encoded picture.

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/tw5864/tw5864-reg.h   |  8 ++++++++
 drivers/media/pci/tw5864/tw5864-video.c | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-reg.h b/drivers/media/pci/tw5864/tw5864-reg.h
index 92a1b07..30ac142 100644
--- a/drivers/media/pci/tw5864/tw5864-reg.h
+++ b/drivers/media/pci/tw5864/tw5864-reg.h
@@ -1879,6 +1879,14 @@
 #define TW5864_INDIR_IN_PIC_HEIGHT(channel) (0x201 + 4 * channel)
 #define TW5864_INDIR_OUT_PIC_WIDTH(channel) (0x202 + 4 * channel)
 #define TW5864_INDIR_OUT_PIC_HEIGHT(channel) (0x203 + 4 * channel)
+
+/* Some registers skipped */
+
+#define TW5864_INDIR_CROP_ETC 0x260
+/* Define controls in register TW5864_INDIR_CROP_ETC */
+/* Enable cropping from 720 to 704 */
+#define TW5864_INDIR_CROP_ETC_CROP_EN 0x4
+
 /*
  * Interrupt status register from the front-end. Write "1" to each bit to clear
  * the interrupt
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index ff94e6c..3c8c302 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -590,6 +590,15 @@ static int tw5864_enable_input(struct tw5864_input *input)
 	tw_indir_writeb(TW5864_INDIR_OUT_PIC_WIDTH(nr), input->width / 4);
 	tw_indir_writeb(TW5864_INDIR_OUT_PIC_HEIGHT(nr), input->height / 4);
 
+	/*
+	 * Crop width from 720 to 704.
+	 * Above register settings need value 720 involved.
+	 */
+	input->width = 704;
+	tw_indir_writeb(TW5864_INDIR_CROP_ETC,
+			tw_indir_readb(TW5864_INDIR_CROP_ETC) |
+			TW5864_INDIR_CROP_ETC_CROP_EN);
+
 	tw_writel(TW5864_DSP_PIC_MAX_MB,
 		  ((input->width / 16) << 8) | (input->height / 16));
 
@@ -792,7 +801,7 @@ static int tw5864_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct tw5864_input *input = video_drvdata(file);
 
-	f->fmt.pix.width = 720;
+	f->fmt.pix.width = 704;
 	switch (input->std) {
 	default:
 		WARN_ON_ONCE(1);
@@ -998,7 +1007,7 @@ static int tw5864_enum_framesizes(struct file *file, void *priv,
 		return -EINVAL;
 
 	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-	fsize->discrete.width = 720;
+	fsize->discrete.width = 704;
 	fsize->discrete.height = input->std == STD_NTSC ? 480 : 576;
 
 	return 0;
-- 
2.9.2

