Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751902AbZH1HCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 03:02:08 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1MgvTP-0001GI-BW
	for linux-media@vger.kernel.org; Fri, 28 Aug 2009 09:02:11 +0200
Date: Fri, 28 Aug 2009 09:02:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: remove now unneeded subdevice group ID assignments
Message-ID: <Pine.LNX.4.64.0908280900370.4462@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we are not using v4l2_device_call_* calls any more, we don't need to
initialise subdevice .grp_id any more. This also fixes compiler warnings on
64-bit platforms.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

I'm not expecting big problems with this one, so, unless anyone shouts 
I'll be pushing this out in the next couple of hours.

 drivers/media/video/soc_camera.c          |    1 -
 drivers/media/video/soc_camera_platform.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0863361..0ebd72d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -858,7 +858,6 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 		goto ei2cnd;
 	}
 
-	subdev->grp_id = (__u32)icd;
 	client = subdev->priv;
 
 	/* Use to_i2c_client(dev) to recover the i2c client */
diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index 8b1c735..c7c9151 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -136,7 +136,6 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, p);
-	priv->subdev.grp_id = (__u32)icd;
 	strncpy(priv->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
 
 	ret = v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
-- 
1.6.2.4

