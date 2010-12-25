Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.8]:54408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LYV35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 16:29:57 -0500
Date: Sat, 25 Dec 2010 22:29:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: soc-camera: fix multiple simultaneous user case
Message-ID: <Pine.LNX.4.64.1012252201520.5248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

A recent patch has introduced a regression, whereby a second open of an
soc-camera video device breaks the running capture. This patch fixes this bug
by guaranteeing, that video buffers get initialised only during the first open
of the device node.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Mauro, please, let's try to get it in 2.6.37, or we'll have to push it to 
stable after 2.6.37 is out. I'm just posting it quickly and will push it 
to linuxtv.org like tomorrow or on Monday...

 drivers/media/video/soc_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 335120c..052bd6d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -405,13 +405,13 @@ static int soc_camera_open(struct file *file)
 		ret = soc_camera_set_fmt(icd, &f);
 		if (ret < 0)
 			goto esfmt;
+
+		ici->ops->init_videobuf(&icd->vb_vidq, icd);
 	}
 
 	file->private_data = icd;
 	dev_dbg(&icd->dev, "camera device open\n");
 
-	ici->ops->init_videobuf(&icd->vb_vidq, icd);
-
 	mutex_unlock(&icd->video_lock);
 
 	return 0;
-- 
1.7.2.3

