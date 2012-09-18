Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:42705 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab2IRKx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:28 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 03/11] vpif_capture: move input_idx to channel_obj.
Date: Tue, 18 Sep 2012 12:53:05 +0200
Message-Id: <af16e4a7239796afde34c84449bfe66134b84ce5.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

input_idx does not belong to video_obj. Move it where it belongs.
Also remove the bogus code in the open() function that suddenly
changes the input to 0 for no reason.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |    9 ++-------
 drivers/media/video/davinci/vpif_capture.h |    4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 313f461..eec687c 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -880,8 +880,6 @@ static int vpif_open(struct file *filep)
 			if (vpif_obj.sd[i]) {
 				/* the sub device is registered */
 				ch->curr_subdev_info = &config->subdev_info[i];
-				/* make first input as the current input */
-				vid_ch->input_idx = 0;
 				break;
 			}
 		}
@@ -1427,10 +1425,8 @@ static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct video_obj *vid_ch = &ch->video;
-
-	*index = vid_ch->input_idx;
 
+	*index = ch->input_idx;
 	return 0;
 }
 
@@ -1447,7 +1443,6 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct video_obj *vid_ch = &ch->video;
 	struct vpif_subdev_info *subdev_info;
 	int ret = 0, sd_index = 0;
 	u32 input = 0, output = 0;
@@ -1502,7 +1497,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 			return ret;
 		}
 	}
-	vid_ch->input_idx = index;
+	ch->input_idx = index;
 	ch->curr_subdev_info = subdev_info;
 	ch->curr_sd_index = sd_index;
 	/* copy interface parameters to vpif */
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index de19c80..cf954f8 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -55,8 +55,6 @@ struct video_obj {
 	/* Currently selected or default standard */
 	v4l2_std_id stdid;
 	struct v4l2_dv_timings dv_timings;
-	/* This is to track the last input that is passed to application */
-	u32 input_idx;
 };
 
 struct vpif_cap_buffer {
@@ -122,6 +120,8 @@ struct channel_obj {
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

