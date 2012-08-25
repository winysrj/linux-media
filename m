Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44969 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2HYDJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:17 -0400
Received: by mail-gg0-f174.google.com with SMTP id k6so581646ggd.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:17 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/9] marvel-cam: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:09:02 -0300
Message-Id: <1345864146-2207-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index ce2b7b4..e117adb 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1098,7 +1098,7 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 
 #endif /* MCAM_MODE_DMA_SG */
 
-static int mcam_setup_vb2(struct mcam_camera *cam)
+static void mcam_setup_vb2(struct mcam_camera *cam)
 {
 	struct vb2_queue *vq = &cam->vb_queue;
 
@@ -1139,7 +1139,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 #endif
 		break;
 	}
-	return vb2_queue_init(vq);
+	vb2_queue_init(vq);
 }
 
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
@@ -1548,15 +1548,12 @@ static int mcam_v4l_open(struct file *filp)
 	frames = singles = delivered = 0;
 	mutex_lock(&cam->s_mutex);
 	if (cam->users == 0) {
-		ret = mcam_setup_vb2(cam);
-		if (ret)
-			goto out;
+		mcam_setup_vb2(cam);
 		mcam_ctlr_power_up(cam);
 		__mcam_cam_reset(cam);
 		mcam_set_config_needed(cam, 1);
 	}
 	(cam->users)++;
-out:
 	mutex_unlock(&cam->s_mutex);
 	return ret;
 }
-- 
1.7.8.6

