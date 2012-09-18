Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:42705 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab2IRKxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:30 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 10/11] vpif_display: use a v4l2_subdev pointer to call a subdev.
Date: Tue, 18 Sep 2012 12:53:12 +0200
Message-Id: <65a795e86372648bb126c35048b749a9be1c68ad.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it easier to have outputs without subdevs.
This needs more work. The way the outputs are configured should be identical
to how inputs are configured.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_display.c |   17 +++++++++--------
 drivers/media/video/davinci/vpif_display.h |    1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index a6e8ddd..5f1d736 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1232,6 +1232,8 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 		vpif_err("Failed to set output standard\n");
 
 	ch->output_idx = i;
+	if (vpif_obj.sd[i])
+		ch->sd = vpif_obj.sd[i];
 	return ret;
 }
 
@@ -1302,14 +1304,13 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
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
@@ -1434,8 +1435,7 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
-			g_register, reg);
+	return v4l2_subdev_call(ch->sd, core, g_register, reg);
 }
 
 /*
@@ -1452,8 +1452,7 @@ static int vpif_dbg_s_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->output_idx], core,
-			s_register, reg);
+	return v4l2_subdev_call(ch->sd, core, s_register, reg);
 }
 #endif
 
@@ -1721,6 +1720,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 		}
 		ch->initialized = 0;
+		if (subdev_count)
+			ch->sd = vpif_obj.sd[0];
 		ch->channel_id = j;
 		if (j < 2)
 			ch->common[VPIF_VIDEO_INDEX].numbuffers =
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index b602def..1e436ac 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -126,6 +126,7 @@ struct channel_obj {
 	u8 initialized;			/* flag to indicate whether
 					 * encoder is initialized */
 	u32 output_idx;			/* Current output index */
+	struct v4l2_subdev *sd;		/* Current output subdev (may be NULL) */
 
 	enum vpif_channel_id channel_id;/* Identifies channel */
 	struct vpif_params vpifparams;
-- 
1.7.10.4

