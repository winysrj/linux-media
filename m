Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47844 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaEPNkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 May 2014 09:40:52 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 23/49] media: davinci: vpif_display: return -ENODATA for *std calls
Date: Fri, 16 May 2014 19:03:28 +0530
Message-Id: <1400247235-31434-25-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds supports to return -ENODATA to *std calls
if the selected output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index f51b5be..f581e7a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -715,14 +715,26 @@ static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
+	int ret;
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_STD)
+		return -ENODATA;
 
 	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
 
+
 	if (!(std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
@@ -754,8 +766,19 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
+	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct vpif_display_chan_config *chan_cfg;
+	struct v4l2_output output;
+
+	if (config->chan_config[ch->channel_id].outputs == NULL)
+		return -ENODATA;
+
+	chan_cfg = &config->chan_config[ch->channel_id];
+	output = chan_cfg->outputs[ch->output_idx].output;
+	if (output.capabilities != V4L2_OUT_CAP_STD)
+		return -ENODATA;
 
 	*std = ch->video.stdid;
 	return 0;
-- 
1.7.9.5

