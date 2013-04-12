Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3DLPk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 13/20] soc-camera: don't attach the client to the host during probing
Date: Fri, 12 Apr 2013 17:40:33 +0200
Message-Id: <1365781240-16149-14-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During client probing we only have to turn on the host's clock, no need to
actually attach the client to the host.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 507f539..f693817 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1207,7 +1207,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		ssdd->reset(icd->pdev);
 
 	mutex_lock(&ici->host_lock);
-	ret = soc_camera_add_device(icd);
+	ret = ici->ops->clock_start(ici);
 	mutex_unlock(&ici->host_lock);
 	if (ret < 0)
 		goto eadd;
@@ -1280,7 +1280,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		icd->field		= mf.field;
 	}
 
-	soc_camera_remove_device(icd);
+	ici->ops->clock_stop(ici);
 
 	mutex_unlock(&ici->host_lock);
 
@@ -1303,7 +1303,7 @@ eadddev:
 	icd->vdev = NULL;
 evdc:
 	mutex_lock(&ici->host_lock);
-	soc_camera_remove_device(icd);
+	ici->ops->clock_stop(ici);
 	mutex_unlock(&ici->host_lock);
 eadd:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
-- 
1.7.2.5

