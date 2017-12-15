Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33331 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754714AbdLOEc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 23:32:29 -0500
Received: by mail-pg0-f66.google.com with SMTP id g7so5018343pgs.0
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 20:32:28 -0800 (PST)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [RFC PATCH] media: v4l2-device: Link subdevices to their parent devices if available
Date: Fri, 15 Dec 2017 13:32:21 +0900
Message-Id: <20171215043221.242719-1-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently v4l2_device_register_subdev_nodes() does not initialize the
dev_parent field of the video_device structs it creates for subdevices
being registered. This leads to __video_register_device() falling back
to the parent device of associated v4l2_device struct, which often does
not match the physical device the subdevice is registered for.

Due to the problem above, the links between real devices and v4l-subdev
nodes cannot be obtained from sysfs, which might be confusing for the
userspace trying to identify the hardware.

Fix this by initializing the dev_parent field of the video_device struct
with the value of dev field of the v4l2_subdev struct. In case of
subdevices without a parent struct device, the field will be NULL and the
old behavior will be preserved by the semantics of
__video_register_device().

Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/v4l2-core/v4l2-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 937c6de85606..450c97caf2c6 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -246,6 +246,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 
 		video_set_drvdata(vdev, sd);
 		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
+		vdev->dev_parent = sd->dev;
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
 		vdev->release = v4l2_device_release_subdev_node;
-- 
2.15.1.504.g5279b80103-goog
