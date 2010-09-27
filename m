Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab0I0NH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:07:58 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3246776bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:07:58 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 13/13] Staging: cx25821: fix tabs and space coding style issue in cx25821.h
Date: Mon, 27 Sep 2010 16:07:46 +0300
Message-Id: <1285592866-475-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821.h file that fixed
up a tabs and space error and warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821.h |   51 ++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 1b628f6..c940001 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -91,10 +91,10 @@
 
 /* Currently supported by the driver */
 #define CX25821_NORMS (\
-    V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP | V4L2_STD_NTSC_M_KR | \
-    V4L2_STD_PAL_BG |  V4L2_STD_PAL_DK    |  V4L2_STD_PAL_I    | \
-    V4L2_STD_PAL_M  |  V4L2_STD_PAL_N     |  V4L2_STD_PAL_H    | \
-    V4L2_STD_PAL_Nc )
+	V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP | V4L2_STD_NTSC_M_KR | \
+	V4L2_STD_PAL_BG |  V4L2_STD_PAL_DK    |  V4L2_STD_PAL_I    | \
+	V4L2_STD_PAL_M  |  V4L2_STD_PAL_N     |  V4L2_STD_PAL_H    | \
+	V4L2_STD_PAL_Nc)
 
 #define CX25821_BOARD_CONEXANT_ATHENA10 1
 #define MAX_VID_CHANNEL_NUM     12
@@ -139,7 +139,7 @@ struct cx25821_fh {
 	/* video capture */
 	struct cx25821_fmt *fmt;
 	unsigned int width, height;
-    int channel_id;
+	int channel_id;
 
 	/* vbi capture */
 	struct videobuf_queue vidq;
@@ -238,26 +238,25 @@ struct cx25821_data {
 };
 
 struct cx25821_channel {
-       struct v4l2_prio_state prio;
+	struct v4l2_prio_state prio;
 
-       int ctl_bright;
-       int ctl_contrast;
-       int ctl_hue;
-       int ctl_saturation;
+	int ctl_bright;
+	int ctl_contrast;
+	int ctl_hue;
+	int ctl_saturation;
+	struct cx25821_data timeout_data;
 
-       struct cx25821_data timeout_data;
+	struct video_device *video_dev;
+	struct cx25821_dmaqueue vidq;
 
-       struct video_device *video_dev;
-       struct cx25821_dmaqueue vidq;
+	struct sram_channel *sram_channels;
 
-       struct sram_channel *sram_channels;
-
-       struct mutex lock;
-       int resources;
+	struct mutex lock;
+	int resources;
 
-       int pixel_formats;
-       int use_cif_resolution;
-       int cif_width;
+	int pixel_formats;
+	int use_cif_resolution;
+	int cif_width;
 };
 
 struct cx25821_dev {
@@ -283,7 +282,7 @@ struct cx25821_dev {
 	int nr;
 	struct mutex lock;
 
-    struct cx25821_channel channels[MAX_VID_CHANNEL_NUM];
+	struct cx25821_channel channels[MAX_VID_CHANNEL_NUM];
 
 	/* board details */
 	unsigned int board;
@@ -311,7 +310,7 @@ struct cx25821_dev {
 	int _audio_lines_count;
 	int _audioframe_count;
 	int _audio_upstream_channel_select;
-       int _last_index_irq;    /* The last interrupt index processed. */
+	int _last_index_irq;    /* The last interrupt index processed. */
 
 	__le32 *_risc_audio_jmp_addr;
 	__le32 *_risc_virt_start_addr;
@@ -443,7 +442,7 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 }
 
 #define cx25821_call_all(dev, o, f, args...) \
-    v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
+	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
 extern struct list_head cx25821_devlist;
 extern struct cx25821_board cx25821_boards[];
@@ -491,7 +490,7 @@ struct sram_channel {
 	u32 fld_aud_fifo_en;
 	u32 fld_aud_risc_en;
 
-       /* For Upstream Video */
+	/* For Upstream Video */
 	u32 vid_fmt_ctl;
 	u32 vid_active_ctl1;
 	u32 vid_active_ctl2;
@@ -511,8 +510,8 @@ extern struct sram_channel cx25821_sram_channels[];
 #define cx_write(reg, value)     writel((value), dev->lmmio + ((reg)>>2))
 
 #define cx_andor(reg, mask, value) \
-  writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
-  ((value) & (mask)), dev->lmmio+((reg)>>2))
+	writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
+	((value) & (mask)), dev->lmmio+((reg)>>2))
 
 #define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
 #define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)
-- 
1.7.0.4

