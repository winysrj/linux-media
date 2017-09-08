Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:58169 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754986AbdIHMdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 08:33:37 -0400
Subject: [PATCH 3/3] [media] DaVinci-VPBE-Display: Adjust 12 checks for null
 pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net>
Message-ID: <3331c4f8-a327-abc6-df00-09e67d3769fe@users.sourceforge.net>
Date: Fri, 8 Sep 2017 14:33:30 +0200
MIME-Version: 1.0
In-Reply-To: <e980c48c-9525-4942-a58e-20af8a96e531@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 14:00:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe_display.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index afe31900f5de..6aabd21fe69f 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -122,7 +122,7 @@ static irqreturn_t venc_isr(int irq, void *arg)
 	int fid;
 	int i;
 
-	if ((NULL == arg) || (NULL == disp_dev->dev[0]))
+	if (!arg || !disp_dev->dev[0])
 		return IRQ_HANDLED;
 
 	if (venc_is_second_field(disp_dev))
@@ -337,10 +337,10 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 		vb2_buffer_done(&layer->cur_frm->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 	} else {
-		if (layer->cur_frm != NULL)
+		if (layer->cur_frm)
 			vb2_buffer_done(&layer->cur_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
-		if (layer->next_frm != NULL)
+		if (layer->next_frm)
 			vb2_buffer_done(&layer->next_frm->vb.vb2_buf,
 					VB2_BUF_STATE_ERROR);
 	}
@@ -947,7 +947,7 @@ static int vpbe_display_s_std(struct file *file, void *priv,
 	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
 
-	if (NULL != vpbe_dev->ops.s_std) {
+	if (vpbe_dev->ops.s_std) {
 		ret = vpbe_dev->ops.s_std(vpbe_dev, std_id);
 		if (ret) {
 			v4l2_err(&vpbe_dev->v4l2_dev,
@@ -1000,8 +1000,7 @@ static int vpbe_display_enum_output(struct file *file, void *priv,
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_ENUM_OUTPUT\n");
 
 	/* Enumerate outputs */
-
-	if (NULL == vpbe_dev->ops.enum_outputs)
+	if (!vpbe_dev->ops.enum_outputs)
 		return -EINVAL;
 
 	ret = vpbe_dev->ops.enum_outputs(vpbe_dev, output);
@@ -1030,7 +1029,7 @@ static int vpbe_display_s_output(struct file *file, void *priv,
 	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
 
-	if (NULL == vpbe_dev->ops.set_output)
+	if (!vpbe_dev->ops.set_output)
 		return -EINVAL;
 
 	ret = vpbe_dev->ops.set_output(vpbe_dev, i);
@@ -1077,7 +1076,7 @@ vpbe_display_enum_dv_timings(struct file *file, void *priv,
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_ENUM_DV_TIMINGS\n");
 
 	/* Enumerate outputs */
-	if (NULL == vpbe_dev->ops.enum_dv_timings)
+	if (!vpbe_dev->ops.enum_dv_timings)
 		return -EINVAL;
 
 	ret = vpbe_dev->ops.enum_dv_timings(vpbe_dev, timings);
@@ -1292,7 +1291,7 @@ static int vpbe_device_get(struct device *dev, void *data)
 	if (strcmp("vpbe_controller", pdev->name) == 0)
 		vpbe_disp->vpbe_dev = platform_get_drvdata(pdev);
 
-	if (strstr(pdev->name, "vpbe-osd") != NULL)
+	if (strstr(pdev->name, "vpbe-osd"))
 		vpbe_disp->osd_device = platform_get_drvdata(pdev);
 
 	return 0;
@@ -1408,7 +1407,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 
 	v4l2_dev = &disp_dev->vpbe_dev->v4l2_dev;
 	/* Initialize the vpbe display controller */
-	if (NULL != disp_dev->vpbe_dev->ops.initialize) {
+	if (disp_dev->vpbe_dev->ops.initialize) {
 		err = disp_dev->vpbe_dev->ops.initialize(&pdev->dev,
 							 disp_dev->vpbe_dev);
 		if (err) {
@@ -1476,7 +1475,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 probe_out:
 	for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
 		/* Unregister video device */
-		if (disp_dev->dev[k] != NULL) {
+		if (disp_dev->dev[k]) {
 			video_unregister_device(&disp_dev->dev[k]->video_dev);
 			kfree(disp_dev->dev[k]);
 		}
@@ -1498,7 +1497,7 @@ static int vpbe_display_remove(struct platform_device *pdev)
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_remove\n");
 
 	/* deinitialize the vpbe display controller */
-	if (NULL != vpbe_dev->ops.deinitialize)
+	if (vpbe_dev->ops.deinitialize)
 		vpbe_dev->ops.deinitialize(&pdev->dev, vpbe_dev);
 	/* un-register device */
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
-- 
2.14.1
