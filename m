Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55371 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3CHCLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 21:11:48 -0500
Message-ID: <3fe50e59b4f7baeda879f4f7b2e5cc1a.squirrel@www.codeaurora.org>
Date: Thu, 7 Mar 2013 18:11:47 -0800
Subject: Custom device names for v4l2 devices
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Names of V4L2 device nodes keep on varying depending on target, on some
targets, the device node assigned to my device is /dev/video21 and on some
it is /dev/video15. In order to determine my device, i am opening it,
reading the capabilities, enumerating its formats and then chose the one
matching my requirements. This is impacting start-up latency. One way to
resolve this without impacting start-up latency is to give custom name to
my V4L2 device node (/dev/custom_name instead of /dev/video21). This needs
following change in V4L2 framework. Please review this patch. If you have
faced similar problem please let me know.

--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -676,7 +676,8 @@ int __video_register_device(struct video_device *vdev,
int type, int nr,
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	if (vdev->parent)
 		vdev->dev.parent = vdev->parent;
-	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
+	if (!dev_name(&vdev->dev))
+		dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n", __func__);


Thanks
Vinay

