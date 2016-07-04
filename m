Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396AbcGDIf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/14] cx231xx: use v4l2_s_ctrl instead of the s_ctrl op.
Date: Mon,  4 Jul 2016 10:35:04 +0200
Message-Id: <1467621310-8203-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op is deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 00da024..29d450c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1570,10 +1570,12 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = file->private_data;
 	struct cx231xx *dev = fh->dev;
+	struct v4l2_subdev *sd;
 
 	dprintk(3, "enter vidioc_s_ctrl()\n");
 	/* Update the A/V core */
-	call_all(dev, core, s_ctrl, ctl);
+	v4l2_device_for_each_subdev(sd, &dev->v4l2_dev)
+		v4l2_s_ctrl(NULL, sd->ctrl_handler, ctl);
 	dprintk(3, "exit vidioc_s_ctrl()\n");
 	return 0;
 }
-- 
2.8.1

