Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4845 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2ITMHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/14] vpif_capture: fix cleanup code.
Date: Thu, 20 Sep 2012 14:06:29 +0200
Message-Id: <dd8a4d60d322f1d2d66a60eee084500c5806c0c0.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cleanup sequence was incorrect and could cause a kernel oops.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   41 ++++++++++++-------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 98423b5..5f81e0f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2060,7 +2060,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_capture_config *config;
-	int i, j, k, m, q, err;
+	int i, j, k, err;
+	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
 	struct channel_obj *ch;
 	struct common_obj *common;
@@ -2083,18 +2084,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	k = 0;
-	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
+	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
 					"VPIF_Capture",
-				(void *)(&vpif_obj.dev[k]->channel_id))) {
+					(void *)(&vpif_obj.dev[res_idx]->channel_id))) {
 				err = -EBUSY;
-				i--;
+				for (j = 0; j < i; j++)
+					free_irq(j, (void *)(&vpif_obj.dev[res_idx]->channel_id));
 				goto vpif_int_err;
 			}
 		}
-		k++;
+		res_idx++;
 	}
 
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
@@ -2108,7 +2109,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_dev_alloc_err;
+			goto vpif_int_err;
 		}
 
 		/* Initialize field of video device */
@@ -2148,7 +2149,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto vpif_dev_alloc_err;
+		goto vpif_sd_error;
 	}
 
 	for (i = 0; i < subdev_count; i++) {
@@ -2197,21 +2198,19 @@ probe_subdev_out:
 	/* free sub devices memory */
 	kfree(vpif_obj.sd);
 
-vpif_dev_alloc_err:
-	k = VPIF_CAPTURE_MAX_DEVICES-1;
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, k);
-	i = res->end;
-
-vpif_int_err:
-	for (q = k; q >= 0; q--) {
-		for (m = i; m >= (int)res->start; m--)
-			free_irq(m, (void *)(&vpif_obj.dev[q]->channel_id));
-
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, q-1);
-		if (res)
-			i = res->end;
+vpif_sd_error:
+	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
+		/* Note: does nothing if ch->video_dev == NULL */
+		video_device_release(ch->video_dev);
 	}
+vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
+	for (i = 0; i < res_idx; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		for (j = res->start; j <= res->end; j++)
+			free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
+	}
 	return err;
 }
 
-- 
1.7.10.4

