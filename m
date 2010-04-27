Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0D0VWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:22:23 -0400
Message-Id: <201004272111.o3RLBPi3020002@imap1.linux-foundation.org>
Subject: [patch 08/11] drivers/media/video/sn9c102/sn9c102_core.c: improve error handling
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	error27@gmail.com, laurent.pinchart@ideasonboard.com,
	luca.risolia@studio.unibo.it
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:25 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

Return an error if the controller is not found.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/sn9c102/sn9c102_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2295,7 +2295,7 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_dev
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -2305,7 +2305,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_dev
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
-
+	}
+	if (i == ARRAY_SIZE(s->qctrl))
+		return -EINVAL;
 	if ((err = s->set_ctrl(cam, &ctrl)))
 		return err;
 
_
