Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1IGQe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:34:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 53A4B18B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 15:50:29 +0200 (CEST)
Date: Wed, 7 Sep 2011 15:50:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc_camera_platform: do not leave dangling invalid
 pointers
Message-ID: <Pine.LNX.4.64.1109071549190.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The life-time of soc-camera device objects can be longer, than the
time, it is attached to a client driver, therefore all references to
the driver own data have to be cleared, when the driver is detached.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera_platform.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
index f5ebe59..c8f6b18 100644
--- a/drivers/media/video/soc_camera_platform.c
+++ b/drivers/media/video/soc_camera_platform.c
@@ -173,7 +173,9 @@ evdrs:
 static int soc_camera_platform_remove(struct platform_device *pdev)
 {
 	struct soc_camera_platform_priv *priv = get_priv(pdev);
+	struct soc_camera_platform_info *p = v4l2_get_subdevdata(&priv->subdev);
 
+	p->icd->control = NULL;
 	v4l2_device_unregister_subdev(&priv->subdev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
-- 
1.7.2.5

