Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52841 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755427AbcJLRRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 13:17:04 -0400
Subject: [PATCH resent 27/34] [media] DaVinci-VPIF-Capture: Adjust ten checks
 for null pointers
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <73a8bc6c-3dc5-c152-7b59-fd1a5e84f61c@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <a4f74e62-dfd2-5804-da5e-9a6dcd355d6d@users.sourceforge.net>
Date: Wed, 12 Oct 2016 19:16:15 +0200
MIME-Version: 1.0
In-Reply-To: <73a8bc6c-3dc5-c152-7b59-fd1a5e84f61c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 15:20:34 +0200

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written ...

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

Another send try because of the following notification:

Mailer Daemon wrote on 2016-10-12 at 17:06:
> This message was created automatically by mail delivery software.
> 
> A message that you sent could not be delivered to one or more of
> its recipients. This is a permanent error. The following address(es)
> failed:
> 
> linux-media@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S933375AbcJLPGr
> 
> kernel-janitors@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S933375AbcJLPGr
> 
> linux-kernel@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S933375AbcJLPGr


 drivers/media/platform/davinci/vpif_capture.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 24d1f61..d9fc591 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -291,10 +291,10 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
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
@@ -648,7 +648,7 @@ static int vpif_input_to_subdev(
 	vpif_dbg(2, debug, "vpif_input_to_subdev\n");
 
 	subdev_name = chan_cfg->inputs[input_index].subdev_name;
-	if (subdev_name == NULL)
+	if (!subdev_name)
 		return -1;
 
 	/* loop through the sub device list to get the sub device info */
@@ -764,7 +764,7 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 
 	vpif_dbg(2, debug, "vpif_g_std\n");
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -794,7 +794,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 	vpif_dbg(2, debug, "vpif_s_std\n");
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1050,7 +1050,7 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 	struct v4l2_input input;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1084,7 +1084,7 @@ vpif_query_dv_timings(struct file *file, void *priv,
 	struct v4l2_input input;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1120,7 +1120,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	struct v4l2_input input;
 	int ret;
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1218,7 +1218,7 @@ static int vpif_g_dv_timings(struct file *file, void *priv,
 	struct vpif_capture_chan_config *chan_cfg;
 	struct v4l2_input input;
 
-	if (config->chan_config[ch->channel_id].inputs == NULL)
+	if (!config->chan_config[ch->channel_id].inputs)
 		return -ENODATA;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1465,7 +1465,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	subdev_count = vpif_obj.config->subdev_count;
 	vpif_obj.sd = kcalloc(subdev_count, sizeof(*vpif_obj.sd), GFP_KERNEL);
-	if (vpif_obj.sd == NULL) {
+	if (!vpif_obj.sd) {
 		err = -ENOMEM;
 		goto vpif_unregister;
 	}
-- 
2.10.1

