Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43179 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbbCMLRs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 38/39] vivid: turn this into a platform_device
Date: Fri, 13 Mar 2015 12:16:16 +0100
Message-Id: <1426245377-17704-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This turns this driver into a platform device. This ensures that it
appears in /sys/bus/platform_device since it now has a proper parent
device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 50 +++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index a7e033a..d2558db 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -26,6 +26,7 @@
 #include <linux/vmalloc.h>
 #include <linux/font.h>
 #include <linux/mutex.h>
+#include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/videobuf2-vmalloc.h>
@@ -618,7 +619,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	Initialization and module stuff
    ------------------------------------------------------------------*/
 
-static int __init vivid_create_instance(int inst)
+static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
 					V4L2_DV_BT_CEA_1280X720P60;
@@ -646,7 +647,7 @@ static int __init vivid_create_instance(int inst)
 	/* register v4l2_device */
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 			"%s-%03d", VIVID_MODULE_NAME, inst);
-	ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto free_dev;
 
@@ -1274,7 +1275,7 @@ free_dev:
    will succeed. This is limited to the maximum number of devices that
    videodev supports, which is equal to VIDEO_NUM_DEVICES.
  */
-static int __init vivid_init(void)
+static int vivid_probe(struct platform_device *pdev)
 {
 	const struct font_desc *font = find_font("VGA8x16");
 	int ret = 0, i;
@@ -1289,7 +1290,7 @@ static int __init vivid_init(void)
 	n_devs = clamp_t(unsigned, n_devs, 1, VIVID_MAX_DEVS);
 
 	for (i = 0; i < n_devs; i++) {
-		ret = vivid_create_instance(i);
+		ret = vivid_create_instance(pdev, i);
 		if (ret) {
 			/* If some instantiations succeeded, keep driver */
 			if (i)
@@ -1309,7 +1310,7 @@ static int __init vivid_init(void)
 	return ret;
 }
 
-static void __exit vivid_exit(void)
+static int vivid_remove(struct platform_device *pdev)
 {
 	struct vivid_dev *dev;
 	unsigned i;
@@ -1370,6 +1371,45 @@ static void __exit vivid_exit(void)
 		kfree(dev);
 		vivid_devs[i] = NULL;
 	}
+	return 0;
+}
+
+static void vivid_pdev_release(struct device *dev)
+{
+}
+
+static struct platform_device vivid_pdev = {
+	.name		= "vivid",
+	.dev.release	= vivid_pdev_release,
+};
+
+static struct platform_driver vivid_pdrv = {
+	.probe		= vivid_probe,
+	.remove		= vivid_remove,
+	.driver		= {
+		.name	= "vivid",
+	},
+};
+
+static int __init vivid_init(void)
+{
+	int ret;
+
+	ret = platform_device_register(&vivid_pdev);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&vivid_pdrv);
+	if (ret)
+		platform_device_unregister(&vivid_pdev);
+
+	return ret;
+}
+
+static void __exit vivid_exit(void)
+{
+	platform_driver_unregister(&vivid_pdrv);
+	platform_device_unregister(&vivid_pdev);
 }
 
 module_init(vivid_init);
-- 
2.1.4

