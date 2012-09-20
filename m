Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4586 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2ITMHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 03/14] vpif_capture: move input_idx to channel_obj.
Date: Thu, 20 Sep 2012 14:06:22 +0200
Message-Id: <f9e6bf38a5903721879205e315bd5e33eb55a2da.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

input_idx does not belong to video_obj. Move it where it belongs.
Also remove the bogus code in the open() function that suddenly
changes the input to 0 for no reason.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_capture.c |    9 ++-------
 drivers/media/platform/davinci/vpif_capture.h |    4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 78edd01..4233554 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -888,8 +888,6 @@ static int vpif_open(struct file *filep)
 			if (vpif_obj.sd[i]) {
 				/* the sub device is registered */
 				ch->curr_subdev_info = &config->subdev_info[i];
-				/* make first input as the current input */
-				vid_ch->input_idx = 0;
 				break;
 			}
 		}
@@ -1442,10 +1440,8 @@ static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
-
-	*index = vid_ch->input_idx;
 
+	*index = ch->input_idx;
 	return 0;
 }
 
@@ -1462,7 +1458,6 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct video_obj *vid_ch = &ch->video;
 	struct vpif_subdev_info *subdev_info;
 	int ret = 0, sd_index = 0;
 	u32 input = 0, output = 0;
@@ -1517,7 +1512,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 			return ret;
 		}
 	}
-	vid_ch->input_idx = index;
+	ch->input_idx = index;
 	ch->curr_subdev_info = subdev_info;
 	ch->curr_sd_index = sd_index;
 	/* copy interface parameters to vpif */
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 0a3904c..a284667 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -54,8 +54,6 @@ struct video_obj {
 	/* Currently selected or default standard */
 	v4l2_std_id stdid;
 	struct v4l2_dv_timings dv_timings;
-	/* This is to track the last input that is passed to application */
-	u32 input_idx;
 };
 
 struct vpif_cap_buffer {
@@ -121,6 +119,8 @@ struct channel_obj {
 	enum vpif_channel_id channel_id;
 	/* index into sd table */
 	int curr_sd_index;
+	/* Current input */
+	u32 input_idx;
 	/* ptr to current sub device information */
 	struct vpif_subdev_info *curr_subdev_info;
 	/* vpif configuration params */
-- 
1.7.10.4

