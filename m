Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:38915 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0J1GqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 02:46:25 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com, mkaricheri@gmail.com
Cc: hans.verkuil@tandberg.com, linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFCv2/PATCH 2/5] vpif: Consolidate formats from capture and display
Date: Thu, 28 Oct 2010 08:46:20 +0200
Message-Id: <1288248383-12557-3-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
References: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

- The ch_params tables in vpif_capture.c and vpif_display.c are moved to a common
  table in vpif.c. Then it is easier to maintain the table.
- The field "fps" is removed from the struct vpif_channel_config_params because it
  is not used.

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
Acked-by : Murali Karicheri <mkaricheri@gmail.com>
---
 drivers/media/video/davinci/vpif.c         |   50 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpif.h         |    4 ++-
 drivers/media/video/davinci/vpif_capture.c |   18 +---------
 drivers/media/video/davinci/vpif_display.c |   17 ++--------
 4 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index 1f532e3..54cc0da 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -41,6 +41,56 @@ spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
 
+/**
+ * ch_params: video standard configuration parameters for vpif
+ * The table must include all presets from supported subdevices.
+ */
+const struct vpif_channel_config_params ch_params[] = {
+	/* SDTV formats */
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
index 188841b..940c30f 100644
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
@@ -594,6 +593,9 @@ struct vpif_channel_config_params {
 	v4l2_std_id stdid;
 };
 
+extern const unsigned int vpif_ch_params_count;
+extern const struct vpif_channel_config_params ch_params[];
+
 struct vpif_video_params;
 struct vpif_params;
 struct vpif_vbi_params;
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 3b5c98b..4768f79 100644
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
index 57b206c..be3fa2e 100644
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

