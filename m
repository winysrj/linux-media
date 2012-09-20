Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2542 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2ITMHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/14] vpif_display: use a v4l2_subdev pointer to call a subdev.
Date: Thu, 20 Sep 2012 14:06:31 +0200
Message-Id: <9c002597feebefaaf15bc8e0a570556d23a9bfb1.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This makes it easier to have outputs without subdevs.
This needs more work. The way the outputs are configured should be identical
to how inputs are configured.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_display.c |   17 +++++++++--------
 drivers/media/platform/davinci/vpif_display.h |    1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 66b4b32..8d1ce09 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1246,6 +1246,8 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 		vpif_err("Failed to set output standard\n");
 
 	ch->output_idx = i;
+	if (vpif_obj.sd[i])
+		ch->sd = vpif_obj.sd[i];
 	return ret;
 }
 
@@ -1317,14 +1319,13 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	}
 
 	/* Configure subdevice timings, if any */
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->output_idx],
-			video, s_dv_timings, timings);
+	ret = v4l2_subdev_call(ch->sd, video, s_dv_timings, timings);
 	if (ret == -ENOIOCTLCMD) {
 		vpif_dbg(2, debug, "Custom DV timings not supported by "
 				"subdevice\n");
-		return -EINVAL;
+		return -ENODATA;
 	}
-	if (ret < 0) {
+	if (ret < 0 && ret != -ENODEV) {
 		vpif_dbg(2, debug, "Error setting custom DV timings\n");
 		return ret;
 	}
@@ -1449,8 +1450,7 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
-			g_register, reg);
+	return v4l2_subdev_call(ch->sd, core, g_register, reg);
 }
 
 /*
@@ -1467,8 +1467,7 @@ static int vpif_dbg_s_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
-			s_register, reg);
+	return v4l2_subdev_call(ch->sd, core, s_register, reg);
 }
 #endif
 
@@ -1737,6 +1736,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 		}
 		ch->initialized = 0;
+		if (subdev_count)
+			ch->sd = vpif_obj.sd[0];
 		ch->channel_id = j;
 		if (j < 2)
 			ch->common[VPIF_VIDEO_INDEX].numbuffers =
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 805704c..dca2a8c0 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -125,6 +125,7 @@ struct channel_obj {
 	u8 initialized;			/* flag to indicate whether
 					 * encoder is initialized */
 	u32 output_idx;			/* Current output index */
+	struct v4l2_subdev *sd;		/* Current output subdev (may be NULL) */
 
 	enum vpif_channel_id channel_id;/* Identifies channel */
 	struct vpif_params vpifparams;
-- 
1.7.10.4

