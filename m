Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46195 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2LCCur (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 21:50:47 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1273869qcr.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 18:50:47 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 21:50:47 -0500
Message-ID: <CAPgLHd-9LAbh_VvKsGZOy5tTtoHd1--TREKV=E9KUnc=DLkxng@mail.gmail.com>
Subject: [PATCH -next] [media] media: davinci: vpbe: return error code on
 error in vpbe_display_g_crop()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We have assigned error code to 'ret' if crop->type is not
V4L2_BUF_TYPE_VIDEO_OUTPUT, but never use it. 
We'd better return the error code on this error.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpbe_display.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 2bfde79..119a100 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -791,7 +791,6 @@ static int vpbe_display_g_crop(struct file *file, void *priv,
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 	struct osd_state *osd_device = fh->disp_dev->osd_device;
 	struct v4l2_rect *rect = &crop->c;
-	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 			"VIDIOC_G_CROP, layer id = %d\n",
@@ -799,7 +798,7 @@ static int vpbe_display_g_crop(struct file *file, void *priv,
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buf type\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	osd_device->ops.get_layer_config(osd_device,
 				layer->layer_info.id, cfg);


