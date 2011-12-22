Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56975 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1LVPMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 10:12:09 -0500
Received: by werm1 with SMTP id m1so3397194wer.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 07:12:08 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de, lethal@linux-sh.org,
	hans.verkuil@cisco.com, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2] media i.MX27 camera: Fix field_count handling.
Date: Thu, 22 Dec 2011 16:12:00 +0100
Message-Id: <1324566720-14073-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To properly detect frame loss the driver must keep
track of a frame_count.

Furthermore, field_count use was erroneous because
in progressive format this must be incremented twice.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ea1f4dc..ca76dd2 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -255,6 +255,7 @@ struct mx2_camera_dev {
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
 	struct mx2_fmt_cfg	*emma_prp;
+	u32			frame_count;
 };
 
 /* buffer for one video frame */
@@ -368,6 +369,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
+	pcdev->frame_count = 0;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -1211,7 +1213,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		list_del(&vb->queue);
 		vb->state = state;
 		do_gettimeofday(&vb->ts);
-		vb->field_count++;
+		vb->field_count = pcdev->frame_count * 2;
+		pcdev->frame_count++;
 
 		wake_up(&vb->done);
 	}
-- 
1.7.0.4

