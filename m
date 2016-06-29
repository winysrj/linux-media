Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36377 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 22:17:51 -0400
Received: by mail-qt0-f169.google.com with SMTP id w59so17891255qtd.3
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2016 19:17:51 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 1/2] tw686x: use a formula instead of two tables for div
Date: Tue, 28 Jun 2016 23:17:34 -0300
Message-Id: <20160629021735.24463-1-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Instead of using two tables to estimate the temporal decimation
factor, use a formula. This allows to get the closest fps, which
sounds better than the current tables.

Also, the current code doesn't store the real framerate.

This patch fixes the above issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[Ezequiel:
  - introduce a TW686X_MAX_FPS macro for max_fps.
  - use hweight_long instead of open coding the set bits count.]
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
Mauro,

I'm resending your patch with a cosmetic modifications.
Let me know how it looks.

 drivers/media/pci/tw686x/tw686x-video.c | 95 +++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 0e839f617e03..3131f9305313 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -28,6 +28,7 @@
 #define TW686X_INPUTS_PER_CH		4
 #define TW686X_VIDEO_WIDTH		720
 #define TW686X_VIDEO_HEIGHT(id)		((id & V4L2_STD_525_60) ? 480 : 576)
+#define TW686X_MAX_FPS(id)		((id & V4L2_STD_525_60) ? 30 : 25)
 
 #define TW686X_MAX_SG_ENTRY_SIZE	4096
 #define TW686X_MAX_SG_DESC_COUNT	256 /* PAL 720x576 needs 203 4-KB pages */
@@ -369,53 +370,79 @@ const struct tw686x_dma_ops sg_dma_ops = {
 	.field		= V4L2_FIELD_SEQ_TB,
 };
 
-static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
+static const unsigned int fps_map[15] = {
+	/*
+	 * bit 31 enables selecting the field control register
+	 * bits 0-29 are a bitmask with fields that will be output.
+	 * For NTSC (and PAL-M, PAL-60), all 30 bits are used.
+	 * For other PAL standards, only the first 25 bits are used.
+	 */
+	0x00000000, /* output all fields */
+	0x80000006, /* 2 fps (60Hz), 2 fps (50Hz) */
+	0x80018006, /* 4 fps (60Hz), 4 fps (50Hz) */
+	0x80618006, /* 6 fps (60Hz), 6 fps (50Hz) */
+	0x81818186, /* 8 fps (60Hz), 8 fps (50Hz) */
+	0x86186186, /* 10 fps (60Hz), 8 fps (50Hz) */
+	0x86619866, /* 12 fps (60Hz), 10 fps (50Hz) */
+	0x86666666, /* 14 fps (60Hz), 12 fps (50Hz) */
+	0x9999999e, /* 16 fps (60Hz), 14 fps (50Hz) */
+	0x99e6799e, /* 18 fps (60Hz), 16 fps (50Hz) */
+	0x9e79e79e, /* 20 fps (60Hz), 16 fps (50Hz) */
+	0x9e7e7e7e, /* 22 fps (60Hz), 18 fps (50Hz) */
+	0x9fe7f9fe, /* 24 fps (60Hz), 20 fps (50Hz) */
+	0x9ffe7ffe, /* 26 fps (60Hz), 22 fps (50Hz) */
+	0x9ffffffe, /* 28 fps (60Hz), 24 fps (50Hz) */
+};
+
+static unsigned int tw686x_real_fps(unsigned int index, unsigned int max_fps)
 {
-	static const unsigned int map[15] = {
-		0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
-		0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
-		0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
-	};
-
-	static const unsigned int std_625_50[26] = {
-		0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
-		   8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
-	};
-
-	static const unsigned int std_525_60[31] = {
-		0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
-		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
-	};
+	unsigned long mask;
 
-	unsigned int i;
+	if (!index || index >= ARRAY_SIZE(fps_map))
+		return max_fps;
 
-	if (std & V4L2_STD_525_60) {
-		if (fps >= ARRAY_SIZE(std_525_60))
-			fps = 30;
-		i = std_525_60[fps];
-	} else {
-		if (fps >= ARRAY_SIZE(std_625_50))
-			fps = 25;
-		i = std_625_50[fps];
-	}
+	mask = GENMASK(max_fps - 1, 0);
+	return hweight_long(fps_map[index] & mask);
+}
+
+static unsigned int tw686x_fps_idx(unsigned int fps, unsigned int max_fps)
+{
+	unsigned int idx, real_fps;
+	int delta;
+
+	/* First guess */
+	idx = (12 + 15 * fps) / max_fps;
+
+	/* Minimal possible framerate is 2 frames per second */
+	if (!idx)
+		return 1;
+
+	/* Check if the difference is bigger than abs(1) and adjust */
+	real_fps = tw686x_real_fps(idx, max_fps);
+	delta = real_fps - fps;
+	if (delta < -1)
+		idx++;
+	else if (delta > 1)
+		idx--;
+
+	/* Max framerate */
+	if (idx >= 15)
+		return 0;
 
-	return map[i];
+	return idx;
 }
 
 static void tw686x_set_framerate(struct tw686x_video_channel *vc,
 				 unsigned int fps)
 {
-	unsigned int map;
+	unsigned int i;
 
 	if (vc->fps == fps)
 		return;
 
-	map = tw686x_fields_map(vc->video_standard, fps) << 1;
-	map |= map << 1;
-	if (map > 0)
-		map |= BIT(31);
-	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], map);
-	vc->fps = fps;
+	i = tw686x_fps_idx(fps, TW686X_MAX_FPS(vc->video_standard));
+	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], fps_map[i]);
+	vc->fps = tw686x_real_fps(i, TW686X_MAX_FPS(vc->video_standard));
 }
 
 static const struct tw686x_format *format_by_fourcc(unsigned int fourcc)
-- 
2.9.0

