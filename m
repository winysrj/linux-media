Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60883 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaECQNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 12:13:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 8466740BD9
	for <linux-media@vger.kernel.org>; Sat,  3 May 2014 18:13:05 +0200 (CEST)
Date: Sat, 3 May 2014 18:13:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: wxplicitly free allocated managed memory
 on error
Message-ID: <Pine.LNX.4.64.1405031812230.26510@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_kzalloc() allocations are freed when the device is unbound. But if a
certain path fails and the allocated memory cannot be used anyway it is
better to free it explicitly immediately. This patch does exactly this if
asynchronous group probing in scan_async_group() fails after memory has
been allocated.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..ef5e197 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1522,14 +1522,14 @@ static int scan_async_group(struct soc_camera_host *ici,
 
 	ret = soc_camera_dyn_pdev(&sdesc, sasc);
 	if (ret < 0)
-		return ret;
+		goto eallocpdev;
 
 	sasc->sensor = &sasd->asd;
 
 	icd = soc_camera_add_pdev(sasc);
 	if (!icd) {
-		platform_device_put(sasc->pdev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto eaddpdev;
 	}
 
 	sasc->notifier.subdevs = asd;
@@ -1557,7 +1557,11 @@ static int scan_async_group(struct soc_camera_host *ici,
 	v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
-	platform_device_unregister(sasc->pdev);
+	platform_device_del(sasc->pdev);
+eaddpdev:
+	platform_device_put(sasc->pdev);
+eallocpdev:
+	devm_kfree(ici->v4l2_dev.dev, sasc);
 	dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
 
 	return ret;
-- 
1.9.2

