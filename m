Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0C1LuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 07:50:15 -0400
Date: Sun, 28 Mar 2010 14:50:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andreas Mohr <andi@lisas.de>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] video/sn9c102: improve error handling
Message-ID: <20100328115005.GW5069@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return an error if the controller is not found.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index cbf8087..28e19da 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2295,7 +2295,7 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -2305,7 +2305,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_device* cam, void __user * arg)
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
-
+	}
+	if (i == ARRAY_SIZE(s->qctrl))
+		return -EINVAL;
 	if ((err = s->set_ctrl(cam, &ctrl)))
 		return err;
 
