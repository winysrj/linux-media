Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:48400 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754740Ab0HLUdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 16:33:08 -0400
Date: Thu, 12 Aug 2010 22:32:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] soc-camera: initialise videobuf immediately before allocating
 them
Message-ID: <Pine.LNX.4.64.1008122229440.17224@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Only the "streamer" process has to initialise videobufs.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Janusz, this and the following patch can be useful, if we decide to 
implement dynamic switching between videobuf implementations. Only 
compile-tested...

 drivers/media/video/soc_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index a499cac..d90386c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -158,6 +158,8 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 
 	WARN_ON(priv != file->private_data);
 
+	ici->ops->init_videobuf(&icf->vb_vidq, icd);
+
 	ret = videobuf_reqbufs(&icf->vb_vidq, p);
 	if (ret < 0)
 		return ret;
@@ -409,8 +411,6 @@ static int soc_camera_open(struct file *file)
 	file->private_data = icf;
 	dev_dbg(&icd->dev, "camera device open\n");
 
-	ici->ops->init_videobuf(&icf->vb_vidq, icd);
-
 	mutex_unlock(&icd->video_lock);
 
 	return 0;
-- 
1.7.2

