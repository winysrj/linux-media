Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38721 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbeHMTPw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 15:15:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14-v6so14810597wro.5
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2018 09:32:55 -0700 (PDT)
From: petrcvekcz@gmail.com
To: mchehab@kernel.org, sakari.ailus@linux.intel.com
Cc: Petr Cvek <petrcvekcz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [BUG, RFC] media: Wrong module gets acquired
Date: Mon, 13 Aug 2018 18:33:12 +0200
Message-Id: <d2bc538126492151ad325fa653924ca158a39b07.1534177949.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

When transferring a media sensor driver from the soc_camera I've found
the controller module can get removed (which will cause a stack dump
because the sensor driver depends on resources from the controller driver).

When I've tried to remove the driver module of the sensor it said the
resource was busy (without a reference name) though is should be
possible to remove the sensor driver because it is at the end of
the dependency list and not to remove the controller driver.

I've dig into the called functions and I've found this in
drivers/media/v4l2-core/v4l2-device.c:

	/*
	 * The reason to acquire the module here is to avoid unloading
	 * a module of sub-device which is registered to a media
	 * device. To make it possible to unload modules for media
	 * devices that also register sub-devices, do not
	 * try_module_get() such sub-device owners.
	 */
	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
		sd->owner == v4l2_dev->dev->driver->owner;

	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
		return -ENODEV;

It basicaly checks if subdevice (=sensor) is a same module as the media
device (=controller) and if they are different it acquires the module.

The acquired module is the one in sd->owner, which is the same module from
which the function is called (-> sensor aquires itself). Is this
functionality valid (should the subdevice really be unloadable)? When
I've patched the module to aquire the controller instead the module, the
removal worked as expected (sensor free to go, controller not).

If this is really a bug (= there isn't a sensor which cannot be unloaded from
a controller?) then I send a new patch with reworded commentary.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/v4l2-core/v4l2-device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 3940e55c72f1..1dec61cd560c 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -173,7 +173,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	sd->owner_v4l2_dev = v4l2_dev->dev && v4l2_dev->dev->driver &&
 		sd->owner == v4l2_dev->dev->driver->owner;
 
-	if (!sd->owner_v4l2_dev && !try_module_get(sd->owner))
+	if (!sd->owner_v4l2_dev &&
+		!try_module_get(v4l2_dev->dev->driver->owner))
 		return -ENODEV;
 
 	sd->v4l2_dev = v4l2_dev;
@@ -209,7 +210,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 #endif
 error_module:
 	if (!sd->owner_v4l2_dev)
-		module_put(sd->owner);
+		module_put(v4l2_dev->dev->driver->owner);
 	sd->v4l2_dev = NULL;
 	return err;
 }
@@ -318,6 +319,6 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
 #endif
 	video_unregister_device(sd->devnode);
 	if (!sd->owner_v4l2_dev)
-		module_put(sd->owner);
+		module_put(v4l2_dev->dev->driver->owner);
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
-- 
2.18.0
