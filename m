Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:53622 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932112Ab0JFHXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 03:23:18 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1P3OLV-0002hQ-Gw
	for linux-media@vger.kernel.org; Wed, 06 Oct 2010 09:23:25 +0200
Date: Wed, 6 Oct 2010 09:23:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: sh_mobile_ceu_camera: use default .get_parm() and
 .set_parm() operations
Message-ID: <Pine.LNX.4.64.1010060922490.9687@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

No need to duplicate default .get_parm() and .set_parm() operations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 0b029bd..fdaadde 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1789,22 +1789,6 @@ static void sh_mobile_ceu_init_videobuf(struct videobuf_queue *q,
 				       icd);
 }
 
-static int sh_mobile_ceu_get_parm(struct soc_camera_device *icd,
-				  struct v4l2_streamparm *parm)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-
-	return v4l2_subdev_call(sd, video, g_parm, parm);
-}
-
-static int sh_mobile_ceu_set_parm(struct soc_camera_device *icd,
-				  struct v4l2_streamparm *parm)
-{
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-
-	return v4l2_subdev_call(sd, video, s_parm, parm);
-}
-
 static int sh_mobile_ceu_get_ctrl(struct soc_camera_device *icd,
 				  struct v4l2_control *ctrl)
 {
@@ -1866,8 +1850,6 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.set_ctrl	= sh_mobile_ceu_set_ctrl,
 	.get_ctrl	= sh_mobile_ceu_get_ctrl,
-	.set_parm	= sh_mobile_ceu_set_parm,
-	.get_parm	= sh_mobile_ceu_get_parm,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
-- 
1.7.1

