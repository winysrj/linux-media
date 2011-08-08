Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16924 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHPgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 11:36:35 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPM0023W8OX0O@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Aug 2011 16:36:33 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPM003K28OW4N@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Aug 2011 16:36:32 +0100 (BST)
Date: Mon, 08 Aug 2011 17:36:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC] The clock dependencies between sensor subdevs and the host
 interface drivers
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
Message-id: <4E400280.7070100@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

Nowadays many of the V4L2 camera device drivers heavily depend on the board
code to set up voltage supplies, clocks, and some control signals, like 'reset'
and 'standby' signals for the sensors. Those things are often being done
by means of the driver specific platform data callbacks.

There has been recently quite a lot effort on ARM towards migration to the
device tree. Unfortunately the custom platform data callbacks effectively
prevent the boards to be booted and configured through the device tree
bindings.

The following is usually handled in the board files:

1) sensor/frontend power supply
2) sensor's master clock (provided by the host device)
3) reset and standby signals (GPIO)
4) other signals applied by the host processor to the sensor device, e.g.
   I2C level shifter enable, etc.

For 1), the regulator API should possibly be used. It should be applicable
for most, if not all cases.
3) and 4) are a bit hard as there might be huge differences across boards 
as how many GPIOs are used, what are the required delays between changes
of their states, etc. Still we could try to find a common description of the
behaviour and pass such information to the drivers.  

For 2) I'd like to propose adding a callback to struct v4l2_device, for
instance as in the below patch. The host driver would implement such an
operation and the sensor subdev driver would use it in its s_power op.
 
If there is more than one output clock at the host, to distinguish which
clock applies to a given sensor the host driver could be passed the
assignment information in it's platform data.

AFAICS in the omap3isp case the clock control is done through the board
code. I wonder what prevents making direct calls between the drivers,
as the sensor subdevs call a board code callback there, which in turn only
calls into the omap3isp driver.
What am I missing ?

In order to support fully DT based builds it would be desired to change
that method so the board specific callbacks in platform data structures
are avoided.


diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index d61febf..08b6699 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -36,6 +36,15 @@
 
 struct v4l2_ctrl_handler;
 
+struct v4l2_device_ops {
+	/* notify callback called by some sub-devices */
+	void (*notify)(struct v4l2_subdev *sd,
+			unsigned int notification, void *arg);
+	/* clock control callback */
+	void (*set_clock)(struct v4l2_subdev *sd,
+			  u_long *frequency, bool enable);
+};
+
 struct v4l2_device {
 	/* dev->driver_data points to this struct.
 	   Note: dev might be NULL if there is no parent device
@@ -51,9 +60,8 @@ struct v4l2_device {
 	spinlock_t lock;
 	/* unique device name, by default the driver name + bus ID */
 	char name[V4L2_DEVICE_NAME_SIZE];
-	/* notify callback called by some sub-devices. */
-	void (*notify)(struct v4l2_subdev *sd,
-			unsigned int notification, void *arg);
+	/* ops for sub-devices */
+	struct v4l2_device_ops ops;
 	/* The control handler. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 	/* Device's priority state */


Comments, critics ?


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
