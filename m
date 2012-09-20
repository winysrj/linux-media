Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4918 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2ITMHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/14] vpif_display: fix cleanup code.
Date: Thu, 20 Sep 2012 14:06:28 +0200
Message-Id: <3cd9a57d4eadfcd1ec18760e0796d7485236fc73.1348142407.git.hans.verkuil@cisco.com>
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
 drivers/media/platform/davinci/vpif_display.c |   30 +++++++++++++++----------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index e71c88f..66b4b32 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1607,7 +1607,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct vpif_display_config *config;
-	int i, j = 0, k, q, m, err = 0;
+	int i, j = 0, k, err = 0;
+	int res_idx = 0;
 	struct i2c_adapter *i2c_adap;
 	struct common_obj *common;
 	struct channel_obj *ch;
@@ -1630,21 +1631,21 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	k = 0;
-	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
+	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
 					"VPIF_Display",
-				(void *)(&vpif_obj.dev[k]->channel_id))) {
+					(void *)(&vpif_obj.dev[res_idx]->channel_id))) {
 				err = -EBUSY;
+				for (j = 0; j < i; j++)
+					free_irq(j, (void *)(&vpif_obj.dev[res_idx]->channel_id));
 				goto vpif_int_err;
 			}
 		}
-		k++;
+		res_idx++;
 	}
 
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
-
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 
@@ -1698,7 +1699,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	if (vpif_obj.sd == NULL) {
 		vpif_err("unable to allocate memory for subdevice pointers\n");
 		err = -ENOMEM;
-		goto vpif_int_err;
+		goto vpif_sd_error;
 	}
 
 	for (i = 0; i < subdev_count; i++) {
@@ -1775,14 +1776,19 @@ probe_out:
 	}
 probe_subdev_out:
 	kfree(vpif_obj.sd);
+vpif_sd_error:
+	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
+		ch = vpif_obj.dev[i];
+		/* Note: does nothing if ch->video_dev == NULL */
+		video_device_release(ch->video_dev);
+	}
 vpif_int_err:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 	vpif_err("VPIF IRQ request failed\n");
-	for (q = k; k >= 0; k--) {
-		for (m = i; m >= res->start; m--)
-			free_irq(m, (void *)(&vpif_obj.dev[k]->channel_id));
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, k-1);
-		m = res->end;
+	for (i = 0; i < res_idx; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		for (j = res->start; j <= res->end; j++)
+			free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
 	}
 
 	return err;
-- 
1.7.10.4

