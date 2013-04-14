Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1718 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3DNP15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 15/30] cx25821: remove TRUE/FALSE/STATUS_(UN)SUCCESSFUL defines.
Date: Sun, 14 Apr 2013 17:27:11 +0200
Message-Id: <1365953246-8972-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c         |    2 +-
 drivers/media/pci/cx25821/cx25821-medusa-video.c |    2 +-
 drivers/media/pci/cx25821/cx25821.h              |    5 -----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index bf6c181..ba417c9 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -814,7 +814,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 		cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
 						1440, 0);
 		dev->channels[i].pixel_formats = PIXEL_FRMT_422;
-		dev->channels[i].use_cif_resolution = FALSE;
+		dev->channels[i].use_cif_resolution = 0;
 	}
 
 	/* Probably only affect Downstream */
diff --git a/drivers/media/pci/cx25821/cx25821-medusa-video.c b/drivers/media/pci/cx25821/cx25821-medusa-video.c
index 6a92e5c..6ab3ae0 100644
--- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
+++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
@@ -404,7 +404,7 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 
 int medusa_set_videostandard(struct cx25821_dev *dev)
 {
-	int status = STATUS_SUCCESS;
+	int status = 0;
 	u32 value = 0, tmp = 0;
 
 	if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index c63f7f5..95dbf70 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -52,8 +52,6 @@
 
 #define CX25821_MAXBOARDS 2
 
-#define TRUE    1
-#define FALSE   0
 #define LINE_SIZE_D1    1440
 
 /* Number of decoders and encoders */
@@ -456,9 +454,6 @@ struct sram_channel {
 
 extern const struct sram_channel cx25821_sram_channels[];
 
-#define STATUS_SUCCESS         0
-#define STATUS_UNSUCCESSFUL    -1
-
 #define cx_read(reg)             readl(dev->lmmio + ((reg)>>2))
 #define cx_write(reg, value)     writel((value), dev->lmmio + ((reg)>>2))
 
-- 
1.7.10.4

