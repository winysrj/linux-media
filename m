Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:47176 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab2IRKx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:29 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 04/11] vpif_display: move output_id to channel_obj.
Date: Tue, 18 Sep 2012 12:53:06 +0200
Message-Id: <4b1a596ad93a1963d6a98b56508d815b5324c0a5.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The output index does not belong to video_obj, it belongs to
channel_obj. Also rename to output_idx to be consistent with
the input_idx name used in vpif_capture.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_display.c |   17 ++++++-----------
 drivers/media/video/davinci/vpif_display.h |    2 +-
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 371a459..19338b4 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1217,7 +1217,6 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
@@ -1232,7 +1231,7 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	if (ret < 0)
 		vpif_err("Failed to set output standard\n");
 
-	vid_ch->output_id = i;
+	ch->output_idx = i;
 	return ret;
 }
 
@@ -1240,9 +1239,8 @@ static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	*i = vid_ch->output_id;
+	*i = ch->output_idx;
 
 	return 0;
 }
@@ -1276,9 +1274,8 @@ static int vpif_enum_dv_timings(struct file *file, void *priv,
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
 			video, enum_dv_timings, timings);
 }
 
@@ -1305,7 +1302,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	}
 
 	/* Configure subdevice timings, if any */
-	ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
+	ret = v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
 			video, s_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD) {
 		vpif_dbg(2, debug, "Custom DV timings not supported by "
@@ -1436,9 +1433,8 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg){
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
 			g_register, reg);
 }
 
@@ -1455,9 +1451,8 @@ static int vpif_dbg_s_register(struct file *file, void *priv,
 		struct v4l2_dbg_register *reg){
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
 
-	return v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id], core,
+	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
 			s_register, reg);
 }
 #endif
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index ad22c70..b602def 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -63,7 +63,6 @@ struct video_obj {
 	v4l2_std_id stdid;		/* Currently selected or default
 					 * standard */
 	struct v4l2_dv_timings dv_timings;
-	u32 output_id;			/* Current output id */
 };
 
 struct vpif_disp_buffer {
@@ -126,6 +125,7 @@ struct channel_obj {
 					 * which is being displayed */
 	u8 initialized;			/* flag to indicate whether
 					 * encoder is initialized */
+	u32 output_idx;			/* Current output index */
 
 	enum vpif_channel_id channel_id;/* Identifies channel */
 	struct vpif_params vpifparams;
-- 
1.7.10.4

