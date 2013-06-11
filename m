Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKJ1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:27:55 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v10 11/21] soc-camera: don't attach the client to the host during probing
Date: Tue, 11 Jun 2013 10:23:38 +0200
Message-Id: <1370939028-8352-12-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During client probing we only have to turn on the host's clock, no need to
actually attach the client to the host.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index e503f03..ac98bcb 100644
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

