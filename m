Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:11079 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1LMJpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 04:45:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] vpif_capture.c: v4l2_device_register() is called too late in vpif_probe()
Date: Tue, 13 Dec 2011 10:44:42 +0100
Cc: Manjunath Hadli <manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112131044.42862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function v4l2_device_register() is called too late in vpif_probe().
This meant that vpif_obj.v4l2_dev is accessed before it is initialized
which caused a crash.

This used to work in the past, but video_register_device() is now actually
using the v4l2_dev pointer.

Note that vpif_display.c doesn't have this bug, there v4l2_device_register()
is called at the beginning of vpif_probe.

Signed-off-by: Georgios Plakaris <gplakari@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 49e4deb..6504e40 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2177,6 +2177,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
+	if (err) {
+		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
+		return err;
+	}
+
 	k = 0;
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
@@ -2246,12 +2252,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto probe_out;
 	}
 
-	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
-	if (err) {
-		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
-		goto probe_subdev_out;
-	}
-
 	for (i = 0; i < subdev_count; i++) {
 		subdevdata = &config->subdev_info[i];
 		vpif_obj.sd[i] =
@@ -2281,7 +2281,6 @@ probe_subdev_out:
 
 	j = VPIF_CAPTURE_MAX_DEVICES;
 probe_out:
-	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 	for (k = 0; k < j; k++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[k];
@@ -2303,6 +2302,7 @@ vpif_int_err:
 		if (res)
 			i = res->end;
 	}
+	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 	return err;
 }
 


