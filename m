Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:61997 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933838AbcJLPOB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:14:01 -0400
Subject: [PATCH 32/34] [media] DaVinci-VPIF-Display: Adjust 11 checks for null
 pointers
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <c1f01855-e05c-2435-0fa0-e159b47fa065@users.sourceforge.net>
Date: Wed, 12 Oct 2016 17:13:50 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 15:40:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpif_display.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 3347fa14..fff1ece 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -271,10 +271,10 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 	} else {
-		if (common->cur_frm != NULL)
+		if (common->cur_frm)
 			vb2_buffer_done(&common->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
-		if (common->next_frm != NULL)
+		if (common->next_frm)
 			vb2_buffer_done(&common->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
@@ -686,7 +686,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	struct v4l2_output output;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].outputs == NULL)
+	if (!config->chan_config[ch->channel_id].outputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -732,7 +732,7 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	struct vpif_display_chan_config *chan_cfg;
 	struct v4l2_output output;
 
-	if (config->chan_config[ch->channel_id].outputs == NULL)
+	if (!config->chan_config[ch->channel_id].outputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -783,11 +783,11 @@ vpif_output_to_subdev(struct vpif_display_config *vpif_cfg,
 
 	vpif_dbg(2, debug, "vpif_output_to_subdev\n");
 
-	if (chan_cfg->outputs == NULL)
+	if (!chan_cfg->outputs)
 		return -1;
 
 	subdev_name = chan_cfg->outputs[index].subdev_name;
-	if (subdev_name == NULL)
+	if (!subdev_name)
 		return -1;
 
 	/* loop through the sub device list to get the sub device info */
@@ -833,7 +833,7 @@ static int vpif_set_output(struct vpif_display_config *vpif_cfg,
 	}
 	ch->output_idx = index;
 	ch->sd = sd;
-	if (chan_cfg->outputs != NULL)
+	if (chan_cfg->outputs)
 		/* update tvnorms from the sub device output info */
 		ch->video_dev.tvnorms = chan_cfg->outputs[index].output.std;
 	return 0;
@@ -885,7 +885,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	struct v4l2_output output;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].outputs == NULL)
+	if (!config->chan_config[ch->channel_id].outputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -922,7 +922,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	struct v4l2_output output;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].outputs == NULL)
+	if (!config->chan_config[ch->channel_id].outputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1021,7 +1021,7 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_output output;
 
-	if (config->chan_config[ch->channel_id].outputs == NULL)
+	if (!config->chan_config[ch->channel_id].outputs)
 		goto error;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1280,7 +1280,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	subdev_count = vpif_obj.config->subdev_count;
 	subdevdata = vpif_obj.config->subdevinfo;
 	vpif_obj.sd = kcalloc(subdev_count, sizeof(*vpif_obj.sd), GFP_KERNEL);
-	if (vpif_obj.sd == NULL) {
+	if (!vpif_obj.sd) {
 		err = -ENOMEM;
 		goto vpif_unregister;
 	}
-- 
2.10.1

