Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752558Ab0CWOzN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:55:13 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Nu5Vq-00023z-SB
	for linux-media@vger.kernel.org; Tue, 23 Mar 2010 15:55:22 +0100
Date: Tue, 23 Mar 2010 15:55:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: update comment
Message-ID: <Pine.LNX.4.64.1003231554120.7689@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera no longer requires .set_crop() implementations to update their
argument. Update the commentary.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index c5a6c44..95cb336 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -752,8 +752,7 @@ static int soc_camera_g_crop(struct file *file, void *fh,
 /*
  * According to the V4L2 API, drivers shall not update the struct v4l2_crop
  * argument with the actual geometry, instead, the user shall use G_CROP to
- * retrieve it. However, we expect camera host and client drivers to update
- * the argument, which we then use internally, but do not return to the user.
+ * retrieve it.
  */
 static int soc_camera_s_crop(struct file *file, void *fh,
 			     struct v4l2_crop *a)
-- 
1.6.2.4

