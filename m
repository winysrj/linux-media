Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4387 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3FLPCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 09/12] omap24xxcam: add v4l2_device and replace parent with v4l2_dev
Date: Wed, 12 Jun 2013 17:00:59 +0200
Message-Id: <1371049262-5799-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver did not yet support struct v4l2_device, so add it. This
make it possible to replace the deprecated parent field with the
v4l2_dev field, allowing the eventual removal of the parent field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap24xxcam.c |    9 ++++++++-
 drivers/media/platform/omap24xxcam.h |    3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
index debb44c..d2b440c 100644
--- a/drivers/media/platform/omap24xxcam.c
+++ b/drivers/media/platform/omap24xxcam.c
@@ -1656,7 +1656,7 @@ static int omap24xxcam_device_register(struct v4l2_int_device *s)
 	}
 	vfd->release = video_device_release;
 
-	vfd->parent = cam->dev;
+	vfd->v4l2_dev = &cam->v4l2_dev;
 
 	strlcpy(vfd->name, CAM_NAME, sizeof(vfd->name));
 	vfd->fops		 = &omap24xxcam_fops;
@@ -1752,6 +1752,11 @@ static int omap24xxcam_probe(struct platform_device *pdev)
 
 	cam->dev = &pdev->dev;
 
+	if (v4l2_device_register(&pdev->dev, &cam->v4l2_dev)) {
+		dev_err(&pdev->dev, "v4l2_device_register failed\n");
+		goto err;
+	}
+
 	/*
 	 * Impose a lower limit on the amount of memory allocated for
 	 * capture. We require at least enough memory to double-buffer
@@ -1849,6 +1854,8 @@ static int omap24xxcam_remove(struct platform_device *pdev)
 		cam->mmio_base_phys = 0;
 	}
 
+	v4l2_device_unregister(&cam->v4l2_dev);
+
 	kfree(cam);
 
 	return 0;
diff --git a/drivers/media/platform/omap24xxcam.h b/drivers/media/platform/omap24xxcam.h
index c439595..7f6f791 100644
--- a/drivers/media/platform/omap24xxcam.h
+++ b/drivers/media/platform/omap24xxcam.h
@@ -29,6 +29,7 @@
 
 #include <media/videobuf-dma-sg.h>
 #include <media/v4l2-int-device.h>
+#include <media/v4l2-device.h>
 
 /*
  *
@@ -462,6 +463,8 @@ struct omap24xxcam_device {
 	 */
 	struct mutex mutex;
 
+	struct v4l2_device v4l2_dev;
+
 	/*** general driver state information ***/
 	atomic_t users;
 	/*
-- 
1.7.10.4

