Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3693 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2ITMHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/14] vpif_display: move output_id to channel_obj.
Date: Thu, 20 Sep 2012 14:06:23 +0200
Message-Id: <6a7bc216d840fc980ee43506d1af6345c602990d.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The output index does not belong to video_obj, it belongs to
channel_obj. Also rename to output_idx to be consistent with
the input_idx name used in vpif_capture.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_display.c |   17 ++++++-----------
 drivers/media/platform/davinci/vpif_display.h |    2 +-
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 2c06778..f394599 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1231,7 +1231,6 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
@@ -1246,7 +1245,7 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	if (ret < 0)
 		vpif_err("Failed to set output standard\n");
 
-	vid_ch->output_id = i;
+	ch->output_idx = i;
 	return ret;
 }
 
@@ -1254,9 +1253,8 @@ static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	*i = vid_ch->output_id;
+	*i = ch->output_idx;
 
 	return 0;
 }
@@ -1291,9 +1289,8 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
 			video, enum_dv_timings, timings);
 }
 
@@ -1320,7 +1317,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	}
 
 	/* Configure subdevice timings, if any */
-	ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+	ret = v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
 			video, s_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD) {
 		vpif_dbg(2, debug, "Custom DV timings not supported by "
@@ -1451,9 +1448,8 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg){
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
 			g_register, reg);
 }
 
@@ -1470,9 +1466,8 @@ static int vpif_dbg_s_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg){
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
 			s_register, reg);
 }
 #endif
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 8654002..805704c 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -62,7 +62,6 @@ struct video_obj {
 	v4l2_std_id stdid;		/* Currently selected or default
 					 * standard */
 	struct v4l2_dv_timings dv_timings;
-	u32 output_id;			/* Current output id */
 };
 
 struct vpif_disp_buffer {
@@ -125,6 +124,7 @@ struct channel_obj {
 					 * which is being displayed */
 	u8 initialized;			/* flag to indicate whether
 					 * encoder is initialized */
+	u32 output_idx;			/* Current output index */
 
 	enum vpif_channel_id channel_id;/* Identifies channel */
 	struct vpif_params vpifparams;
-- 
1.7.10.4

