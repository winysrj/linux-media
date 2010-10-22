Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:53585 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0JVHBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:01:18 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, hans.verkuil@tandberg.com,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFC/PATCH 5/5] vpif_cap/disp: Cleanup, improved comments
Date: Fri, 22 Oct 2010 09:00:51 +0200
Message-Id: <1287730851-18579-6-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
References: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
---
 drivers/media/video/davinci/vpif.h         |   13 ++++++-------
 drivers/media/video/davinci/vpif_capture.c |   13 ++++++-------
 drivers/media/video/davinci/vpif_display.c |   23 ++++++++++++++++++++---
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index b121683..aea7487 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -577,11 +577,10 @@ struct vpif_channel_config_params {
 	char name[VPIF_MAX_NAME];	/* Name of the mode */
 	u16 width;			/* Indicates width of the image */
 	u16 height;			/* Indicates height of the image */
-	u8 frm_fmt;			/* Indicates whether this is interlaced
-					 * or progressive format */
-	u8 ycmux_mode;			/* Indicates whether this mode requires
-					 * single or two channels */
-	u16 eav2sav;			/* length of sav 2 eav */
+	u8 frm_fmt;			/* Interlaced (0) or progressive (1) */
+	u8 ycmux_mode;			/* This mode requires one (0) or two (1)
+					   channels */
+	u16 eav2sav;			/* length of eav 2 sav */
 	u16 sav2eav;			/* length of sav 2 eav */
 	u16 l1, l3, l5, l7, l9, l11;	/* Other parameter configurations */
 	u16 vsize;			/* Vertical size of the image */
@@ -589,8 +588,8 @@ struct vpif_channel_config_params {
 					 * is in BT or in CCD/CMOS */
 	u8  vbi_supported;		/* Indicates whether this mode
 					 * supports capturing vbi or not */
-	u8 hd_sd;
-	v4l2_std_id stdid;
+	u8 hd_sd;			/* HDTV (1) or SDTV (0) format */
+	v4l2_std_id stdid;		/* SDTV format */
 	u32 dv_preset;			/* HDTV format */
 };
 
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 184fa3c..3acc081 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -329,7 +329,7 @@ static void vpif_schedule_next_buffer(struct common_obj *common)
  * @dev_id: dev_id ptr
  *
  * It changes status of the captured buffer, takes next buffer from the queue
- * and sets its address in VPIF  registers
+ * and sets its address in VPIF registers
  */
 static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 {
@@ -422,14 +422,12 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	const struct vpif_channel_config_params *config;
-	struct vpif_channel_config_params *std_info;
+	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
 	int index;
 
 	vpif_dbg(2, debug, "vpif_update_std_info\n");
 
-	std_info = &vpifparams->std_info;
-
 	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &ch_params[index];
 		if (config->hd_sd == 0) {
@@ -458,6 +456,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	common->fmt.fmt.pix.bytesperline = std_info->width;
 	vpifparams->video_params.hpitch = std_info->width;
 	vpifparams->video_params.storage_mode = std_info->frm_fmt;
+
 	return 0;
 }
 
@@ -1691,7 +1690,7 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pixfmt;
 	int ret = 0;
 
-	vpif_dbg(2, debug, "VIDIOC_S_FMT\n");
+	vpif_dbg(2, debug, "%s\n", __func__);
 
 	/* If streaming is started, return error */
 	if (common->started) {
@@ -2356,9 +2355,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 		if (vpif_obj.sd[i])
 			vpif_obj.sd[i]->grp_id = 1 << i;
 	}
-	v4l2_info(&vpif_obj.v4l2_dev, "DM646x VPIF Capture driver"
-		  " initialized\n");
 
+	v4l2_info(&vpif_obj.v4l2_dev,
+			"DM646x VPIF capture driver initialized\n");
 	return 0;
 
 probe_subdev_out:
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index bc42505..0a7a05e 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -363,6 +363,13 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/**
+ * vpif_get_std_info() - update standard related info
+ * @ch: ptr to channel object
+ *
+ * For a given standard selected by application, update values
+ * in the device data structures
+ */
 static int vpif_get_std_info(struct channel_obj *ch)
 {
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
@@ -566,7 +573,10 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vpif_fh *fh = filep->private_data;
-	struct common_obj *common = &fh->channel->common[VPIF_VIDEO_INDEX];
+	struct channel_obj *ch = fh->channel;
+	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
+
+	vpif_dbg(2, debug, "vpif_mmap\n");
 
 	return videobuf_mmap_mapper(&common->buffer_queue, vma);
 }
@@ -678,7 +688,12 @@ static int vpif_release(struct file *filep)
 }
 
 /* functions implementing ioctls */
-
+/**
+ * vpif_querycap() - QUERYCAP handler
+ * @file: file ptr
+ * @priv: file handle
+ * @cap: ptr to v4l2_capability structure
+ */
 static int vpif_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *cap)
 {
@@ -1088,7 +1103,7 @@ static int vpif_streamon(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	/* Call videobuf_streamon to start streaming  in videobuf */
+	/* Call videobuf_streamon to start streaming in videobuf */
 	ret = videobuf_streamon(&common->buffer_queue);
 	if (ret < 0) {
 		vpif_err("videobuf_streamon\n");
@@ -1872,6 +1887,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 			vpif_obj.sd[i]->grp_id = 1 << i;
 	}
 
+	v4l2_info(&vpif_obj.v4l2_dev,
+			"DM646x VPIF display driver initialized\n");
 	return 0;
 
 probe_subdev_out:
-- 
1.7.1

