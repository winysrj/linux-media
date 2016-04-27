Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbcD0P1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 11:27:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH v3] tw686x: use a formula instead of two tables for div
Date: Wed, 27 Apr 2016 12:27:02 -0300
Message-Id: <527358bfde61acf7ac1a6e5bfc737f5645ba05a7.1461770668.git.mchehab@osg.samsung.com>
In-Reply-To: <a3c0afb9b600b5284d6643bc165241eb1b81cdf6.1461770188.git.mchehab@osg.samsung.com>
References: <a3c0afb9b600b5284d6643bc165241eb1b81cdf6.1461770188.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using two tables to estimate the temporal decimation
factor, use a formula. This allows to get the closest fps, with
sounds better than the current tables.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

[media] tw686x: cleanup the fps estimation code

There are some issues with the old code:
	1) it uses two static tables;
	2) some values for 50Hz standards are wrong;
	3) it doesn't store the real framerate.

This patch fixes the above issues.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

-

v3: Patch v2 were actually a diff patch against PATCH v1. Fold the two patches in one.

PS.: With this patch, it should be easy to add support for
VIDIOC_G_PARM and VIDIOC_S_PARM, as vc->fps will now store the
real frame rate, with should be used when returning from those
functions.

---
 drivers/media/pci/tw686x/tw686x-video.c | 110 +++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 37 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 253e10823ba3..b247a7b4ddd8 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -43,53 +43,89 @@ static const struct tw686x_format formats[] = {
 	}
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
+{
+	unsigned int i, bits, c = 0;
+
+	if (!index || index >= ARRAY_SIZE(fps_map))
+		return max_fps;
+
+	bits = fps_map[index];
+	for (i = 0; i < max_fps; i++)
+		if ((1 << i) & bits)
+			c++;
+
+	return c;
+}
+
+static unsigned int tw686x_fps_idx(unsigned int fps, unsigned int max_fps)
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
-
-	unsigned int i;
-
-	if (std & V4L2_STD_525_60) {
-		if (fps >= ARRAY_SIZE(std_525_60))
-			fps = 30;
-		i = std_525_60[fps];
-	} else {
-		if (fps >= ARRAY_SIZE(std_625_50))
-			fps = 25;
-		i = std_625_50[fps];
-	}
-
-	return map[i];
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
+
+	return idx;
 }
 
 static void tw686x_set_framerate(struct tw686x_video_channel *vc,
 				 unsigned int fps)
 {
-	unsigned int map;
+	unsigned int i, max_fps;
 
 	if (vc->fps == fps)
 		return;
 
-	map = tw686x_fields_map(vc->video_standard, fps) << 1;
-	map |= map << 1;
-	if (map > 0)
-		map |= BIT(31);
-	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], map);
-	vc->fps = fps;
+	if (vc->video_standard & V4L2_STD_525_60)
+		max_fps = 30;
+	else
+		max_fps = 25;
+
+	i = tw686x_fps_idx(fps, max_fps);
+
+	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], fps_map[i]);
+	vc->fps = tw686x_real_fps(i, max_fps);
 }
 
 static const struct tw686x_format *format_by_fourcc(unsigned int fourcc)
-- 
2.5.5


