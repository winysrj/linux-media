Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:50818 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0JVHBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:01:12 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, hans.verkuil@tandberg.com,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFC/PATCH 2/5] vpif: Move and extend ch_params[]
Date: Fri, 22 Oct 2010 09:00:48 +0200
Message-Id: <1287730851-18579-3-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
References: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

- The ch_params tables in vpif_capture.c and vpif_display.c are moved to a common
  table in vpif.c. Then it is easier to maintain the table.
- The new table is extended with all the DV formats supportet by TVP7002.
- The field "fps" is removed from the struct vpif_channel_config_params because it
  is not used.
- The field "dv_preset" is added to the struct vpif_channel_config_params to
  support DV formats.

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
---
 drivers/media/video/davinci/vpif.c         |  178 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpif.h         |    5 +-
 drivers/media/video/davinci/vpif_capture.c |   18 +---
 drivers/media/video/davinci/vpif_display.c |   17 +--
 4 files changed, 187 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index 1f532e3..baa9462 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -41,6 +41,184 @@ spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
 
+/**
+ * ch_params: video standard configuration parameters for vpif
+ * The table must include all presets from supported subdevices.
+ */
+const struct vpif_channel_config_params ch_params[] = {
+	/* HDTV formats */
+	{
+		.name = "480p59_94",
+		.width = 720,
+		.height = 480,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 138-8,
+		.sav2eav = 720,
+		.l1 = 1,
+		.l3 = 43,
+		.l5 = 523,
+		.vsize = 525,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_480P59_94,
+	},
+	{
+		.name = "576p50",
+		.width = 720,
+		.height = 576,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 144-8,
+		.sav2eav = 720,
+		.l1 = 1,
+		.l3 = 45,
+		.l5 = 621,
+		.vsize = 625,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_576P50,
+	},
+	{
+		.name = "720p50",
+		.width = 1280,
+		.height = 720,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 700-8,
+		.sav2eav = 1280,
+		.l1 = 1,
+		.l3 = 26,
+		.l5 = 746,
+		.vsize = 750,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_720P50,
+	},
+	{
+		.name = "720p60",
+		.width = 1280,
+		.height = 720,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 370 - 8,
+		.sav2eav = 1280,
+		.l1 = 1,
+		.l3 = 26,
+		.l5 = 746,
+		.vsize = 750,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_720P60,
+	},
+	{
+		.name = "1080I50",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 0,
+		.ycmux_mode = 0,
+		.eav2sav = 720 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 21,
+		.l5 = 561,
+		.l7 = 563,
+		.l9 = 584,
+		.l11 = 1124,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080I50,
+	},
+	{
+		.name = "1080I60",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 0,
+		.ycmux_mode = 0,
+		.eav2sav = 280 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 21,
+		.l5 = 561,
+		.l7 = 563,
+		.l9 = 584,
+		.l11 = 1124,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080I60,
+	},
+	{
+		.name = "1080p60",
+		.width = 1920,
+		.height = 1080,
+		.frm_fmt = 1,
+		.ycmux_mode = 0,
+		.eav2sav = 280 - 8,
+		.sav2eav = 1920,
+		.l1 = 1,
+		.l3 = 42,
+		.l5 = 1122,
+		.vsize = 1125,
+		.capture_format = 0,
+		.vbi_supported = 0,
+		.hd_sd = 1,
+		.dv_preset = V4L2_DV_1080P60,
+	},
+
+	/* SDTV formats */
+
+	{
+		.name = "NTSC_M",
+		.width = 720,
+		.height = 480,
+		.frm_fmt = 0,
+		.ycmux_mode = 1,
+		.eav2sav = 268,
+		.sav2eav = 1440,
+		.l1 = 1,
+		.l3 = 23,
+		.l5 = 263,
+		.l7 = 266,
+		.l9 = 286,
+		.l11 = 525,
+		.vsize = 525,
+		.capture_format = 0,
+		.vbi_supported = 1,
+		.hd_sd = 0,
+		.stdid = V4L2_STD_525_60,
+	},
+	{
+		.name = "PAL_BDGHIK",
+		.width = 720,
+		.height = 576,
+		.frm_fmt = 0,
+		.ycmux_mode = 1,
+		.eav2sav = 280,
+		.sav2eav = 1440,
+		.l1 = 1,
+		.l3 = 23,
+		.l5 = 311,
+		.l7 = 313,
+		.l9 = 336,
+		.l11 = 624,
+		.vsize = 625,
+		.capture_format = 0,
+		.vbi_supported = 1,
+		.hd_sd = 0,
+		.stdid = V4L2_STD_625_50,
+	},
+};
+
+const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
+
 static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
 {
 	if (val)
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 188841b..b121683 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -577,7 +577,6 @@ struct vpif_channel_config_params {
 	char name[VPIF_MAX_NAME];	/* Name of the mode */
 	u16 width;			/* Indicates width of the image */
 	u16 height;			/* Indicates height of the image */
-	u8 fps;
 	u8 frm_fmt;			/* Indicates whether this is interlaced
 					 * or progressive format */
 	u8 ycmux_mode;			/* Indicates whether this mode requires
@@ -592,8 +591,12 @@ struct vpif_channel_config_params {
 					 * supports capturing vbi or not */
 	u8 hd_sd;
 	v4l2_std_id stdid;
+	u32 dv_preset;			/* HDTV format */
 };
 
+extern const unsigned int vpif_ch_params_count;
+extern const struct vpif_channel_config_params ch_params[];
+
 struct vpif_video_params;
 struct vpif_params;
 struct vpif_vbi_params;
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 34ac883..778af7e 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -82,20 +82,6 @@ static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
 
 /**
- * ch_params: video standard configuration parameters for vpif
- */
-static const struct vpif_channel_config_params ch_params[] = {
-	{
-		"NTSC_M", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
-		286, 525, 525, 0, 1, 0, V4L2_STD_525_60,
-	},
-	{
-		"PAL_BDGHIK", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
-		336, 624, 625, 0, 1, 0, V4L2_STD_625_50,
-	},
-};
-
-/**
  * vpif_uservirt_to_phys : translate user/virtual address to phy address
  * @virtp: user/virtual address
  *
@@ -444,7 +430,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 
 	std_info = &vpifparams->std_info;
 
-	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
+	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &ch_params[index];
 		if (config->stdid & vid_ch->stdid) {
 			memcpy(std_info, config, sizeof(*config));
@@ -453,7 +439,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	}
 
 	/* standard not found */
-	if (index == ARRAY_SIZE(ch_params))
+	if (index == vpif_ch_params_count)
 		return -EINVAL;
 
 	common->fmt.fmt.pix.width = std_info->width;
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index b56c53a..edfc095 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -85,17 +85,6 @@ static struct vpif_config_params config_params = {
 static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
 
-static const struct vpif_channel_config_params ch_params[] = {
-	{
-		"NTSC", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
-		286, 525, 525, 0, 1, 0, V4L2_STD_525_60,
-	},
-	{
-		"PAL", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
-		336, 624, 625, 0, 1, 0, V4L2_STD_625_50,
-	},
-};
-
 /*
  * vpif_uservirt_to_phys: This function is used to convert user
  * space virtual address to physical address.
@@ -388,7 +377,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	if (!std_info->stdid)
 		return -1;
 
-	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
+	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &ch_params[index];
 		if (config->stdid & std_info->stdid) {
 			memcpy(std_info, config, sizeof(*config));
@@ -396,8 +385,8 @@ static int vpif_get_std_info(struct channel_obj *ch)
 		}
 	}
 
-	if (index == ARRAY_SIZE(ch_params))
-		return -1;
+	if (index == vpif_ch_params_count)
+		return -EINVAL;
 
 	common->fmt.fmt.pix.width = std_info->width;
 	common->fmt.fmt.pix.height = std_info->height;
-- 
1.7.1

