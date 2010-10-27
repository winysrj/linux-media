Return-path: <mchehab@pedra>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:41062 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759656Ab0J0NzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:55:13 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH] cafe_ccic: fix colorspace corruption on resume
Message-Id: <20101027135500.BA4869D401B@zog.reactivated.net>
Date: Wed, 27 Oct 2010 14:55:00 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If you suspend and resume during video capture, the video colours
are corrupted on resume. This is because the sensor is being unconditionally
powered off during the resume path.

Only power down during resume if the camera is not in use, and correctly
reconfigure the sensor during resume.
Fixes http://dev.laptop.org/ticket/10190

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/cafe_ccic.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 7bc3667..d147525 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -859,8 +859,6 @@ static int cafe_cam_configure(struct cafe_camera *cam)
 	struct v4l2_mbus_framefmt mbus_fmt;
 	int ret;
 
-	if (cam->state != S_IDLE)
-		return -EINVAL;
 	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
 	ret = sensor_call(cam, core, init, 0);
 	if (ret == 0)
@@ -2197,12 +2195,13 @@ static int cafe_pci_resume(struct pci_dev *pdev)
 		return ret;
 	}
 	cafe_ctlr_init(cam);
-	cafe_ctlr_power_down(cam);
 
 	mutex_lock(&cam->s_mutex);
 	if (cam->users > 0) {
 		cafe_ctlr_power_up(cam);
 		__cafe_cam_reset(cam);
+	} else {
+		cafe_ctlr_power_down(cam);
 	}
 	mutex_unlock(&cam->s_mutex);
 
-- 
1.7.2.3

