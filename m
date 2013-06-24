Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXLVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 07:21:22 -0400
Date: Mon, 24 Jun 2013 13:20:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2] V4L2: add documentation for V4L2 clock helpers and
 asynchronous probing
Message-ID: <Pine.LNX.4.64.1306241311420.19735@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for the V4L2 clock and V4L2 asynchronous probing APIs
to v4l2-framework.txt.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2: addressed comments by Hans and Laurent (thanks), including
(a) language clean up
(b) extended the V4L2 clock API section with an explanation, what special 
requirements V4L2 has and a mention of it being temporary until CCF is 
used by all
(c) added an explanation of the use of -EPROBE_DEFER

 Documentation/video4linux/v4l2-framework.txt |   73 +++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index b5e6347..00a9d21 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -325,8 +325,27 @@ that width, height and the media bus pixel code are equal on both source and
 sink of the link. Subdev drivers are also free to use this function to
 perform the checks mentioned above in addition to their own checks.
 
-A device (bridge) driver needs to register the v4l2_subdev with the
-v4l2_device:
+There are currently two ways to register subdevices with the V4L2 core. The
+first (traditional) possibility is to have subdevices registered by bridge
+drivers. This can be done when the bridge driver has the complete information
+about subdevices connected to it and knows exactly when to register them. This
+is typically the case for internal subdevices, like video data processing units
+within SoCs or complex PCI(e) boards, camera sensors in USB cameras or connected
+to SoCs, which pass information about them to bridge drivers, usually in their
+platform data.
+
+There are however also situations where subdevices have to be registered
+asynchronously to bridge devices. An example of such a configuration is a Device
+Tree based systems where information about subdevices is made available to the
+system independently from the bridge devices, e.g. when subdevices are defined
+in DT as I2C device nodes. The API used in this second case is described further
+below.
+
+Using one or the other registration method only affects the probing process, the
+run-time bridge-subdevice interaction is in both cases the same.
+
+In the synchronous case a device (bridge) driver needs to register the
+v4l2_subdev with the v4l2_device:
 
 	int err = v4l2_device_register_subdev(v4l2_dev, sd);
 
@@ -393,6 +412,30 @@ controlled through GPIO pins. This distinction is only relevant when setting
 up the device, but once the subdev is registered it is completely transparent.
 
 
+In the asynchronous case subdevice probing can be invoked independently of the
+bridge driver availability. The subdevice driver then has to verify whether all
+the requirements for a successful probing are satisfied. This can include a
+check for a master clock availability. If any of the conditions aren't satisfied
+the driver might decide to return -EPROBE_DEFER to request further reprobing
+attempts. Once all conditions are met the subdevice shall be registered using
+the v4l2_async_register_subdev() function. Unregistration is performed using
+the v4l2_async_unregister_subdev() call. Subdevices registered this way are
+stored in a global list of subdevices, ready to be picked up by bridge drivers.
+
+Bridge drivers in turn have to register a notifier object with an array of
+subdevice descriptors that the bridge device needs for its operation. This is
+performed using the v4l2_async_notifier_register() call. To unregister the
+notifier the driver has to call v4l2_async_notifier_unregister(). The former of
+the two functions takes two arguments: a pointer to struct v4l2_device and a
+pointer to struct v4l2_async_notifier. The latter contains a pointer to an array
+of pointers to subdevice descriptors of type struct v4l2_async_subdev type. The
+V4L2 core will then use these descriptors to match asynchronously registered
+subdevices to them. If a match is detected the .bound() notifier callback is
+called. After all subdevices have been located the .complete() callback is
+called. When a subdevice is removed from the system the .unbind() method is
+called. All three callbacks are optional.
+
+
 V4L2 sub-device userspace API
 -----------------------------
 
@@ -1065,3 +1108,29 @@ available event type is 'class base + 1'.
 
 An example on how the V4L2 events may be used can be found in the OMAP
 3 ISP driver (drivers/media/platform/omap3isp).
+
+
+V4L2 clocks
+-----------
+
+Many subdevices, like camera sensors, TV decoders and encoders, need a clock
+signal to be supplied by the system. Often this clock is supplied by the
+respective bridge device. The Linux kernel provides a Common Clock Framework for
+this purpose. However, it is not (yet) available on all architectures. Besides,
+the nature of the multi-functional (clock, data + synchronisation, I2C control)
+connection of subdevices to the system might impose special requirements on the
+clock API usage. E.g. V4L2 has to support clock provider driver unregistration
+while a subdevice driver is holding a reference to the clock. For these reasons
+a V4L2 clock helper API has been developed and is provided to bridge and
+subdevice drivers.
+
+The API consists of two parts: two functions to register and unregister a V4L2
+clock source: v4l2_clk_register() and v4l2_clk_unregister() and calls to control
+a clock object, similar to the respective generic clock API calls:
+v4l2_clk_get(), v4l2_clk_put(), v4l2_clk_enable(), v4l2_clk_disable(),
+v4l2_clk_get_rate(), and v4l2_clk_set_rate(). Clock suppliers have to provide
+clock operations that will be called when clock users invoke respective API
+methods.
+
+It is expected that once the CCF becomes available on all relevant
+architectures this API will be removed.
-- 
1.7.2.5

