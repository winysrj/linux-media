Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2JEPff (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:35:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3471240BB7
	for <linux-media@vger.kernel.org>; Fri,  5 Oct 2012 17:35:33 +0200 (CEST)
Date: Fri, 5 Oct 2012 17:35:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media: soc-camera: update documentation
Message-ID: <Pine.LNX.4.64.1210051735080.13761@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update soc-camera documentation to reflect the current camera host API and
the use of the common V4L2 subdev API.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 Documentation/video4linux/soc-camera.txt |  146 +++++++++++++++---------------
 1 files changed, 75 insertions(+), 71 deletions(-)

diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/video4linux/soc-camera.txt
index 3f87c7d..f62fcdb 100644
--- a/Documentation/video4linux/soc-camera.txt
+++ b/Documentation/video4linux/soc-camera.txt
@@ -9,32 +9,36 @@ The following terms are used in this document:
    of connecting to a variety of systems and interfaces, typically uses i2c for
    control and configuration, and a parallel or a serial bus for data.
  - camera host - an interface, to which a camera is connected. Typically a
-   specialised interface, present on many SoCs, e.g., PXA27x and PXA3xx, SuperH,
+   specialised interface, present on many SoCs, e.g. PXA27x and PXA3xx, SuperH,
    AVR32, i.MX27, i.MX31.
  - camera host bus - a connection between a camera host and a camera. Can be
-   parallel or serial, consists of data and control lines, e.g., clock, vertical
+   parallel or serial, consists of data and control lines, e.g. clock, vertical
    and horizontal synchronization signals.
 
 Purpose of the soc-camera subsystem
 -----------------------------------
 
-The soc-camera subsystem provides a unified API between camera host drivers and
-camera sensor drivers. It implements a V4L2 interface to the user, currently
-only the mmap method is supported.
+The soc-camera subsystem initially provided a unified API between camera host
+drivers and camera sensor drivers. Later the soc-camera sensor API has been
+replaced with the V4L2 standard subdev API. This also made camera driver re-use
+with non-soc-camera hosts possible. The camera host API to the soc-camera core
+has been preserved.
 
-This subsystem has been written to connect drivers for System-on-Chip (SoC)
-video capture interfaces with drivers for CMOS camera sensor chips to enable
-the reuse of sensor drivers with various hosts. The subsystem has been designed
-to support multiple camera host interfaces and multiple cameras per interface,
-although most applications have only one camera sensor.
+Soc-camera implements a V4L2 interface to the user, currently only the "mmap"
+method is supported by host drivers. However, the soc-camera core also provides
+support for the "read" method.
+
+The subsystem has been designed to support multiple camera host interfaces and
+multiple cameras per interface, although most applications have only one camera
+sensor.
 
 Existing drivers
 ----------------
 
-As of 2.6.27-rc4 there are two host drivers in the mainline: pxa_camera.c for
-PXA27x SoCs and sh_mobile_ceu_camera.c for SuperH SoCs, and four sensor drivers:
-mt9m001.c, mt9m111.c, mt9v022.c and a generic soc_camera_platform.c driver. This
-list is not supposed to be updated, look for more examples in your tree.
+As of 3.7 there are seven host drivers in the mainline: atmel-isi.c,
+mx1_camera.c (broken, scheduled for removal), mx2_camera.c, mx3_camera.c,
+omap1_camera.c, pxa_camera.c, sh_mobile_ceu_camera.c, and multiple sensor
+drivers under drivers/media/i2c/soc_camera/.
 
 Camera host API
 ---------------
@@ -45,38 +49,37 @@ soc_camera_host_register(struct soc_camera_host *);
 
 function. The host object can be initialized as follows:
 
-static struct soc_camera_host pxa_soc_camera_host = {
-	.drv_name	= PXA_CAM_DRV_NAME,
-	.ops		= &pxa_soc_camera_host_ops,
-};
+	struct soc_camera_host	*ici;
+	ici->drv_name		= DRV_NAME;
+	ici->ops		= &camera_host_ops;
+	ici->priv		= pcdev;
+	ici->v4l2_dev.dev	= &pdev->dev;
+	ici->nr			= pdev->id;
 
 All camera host methods are passed in a struct soc_camera_host_ops:
 
-static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
+static struct soc_camera_host_ops camera_host_ops = {
 	.owner		= THIS_MODULE,
-	.add		= pxa_camera_add_device,
-	.remove		= pxa_camera_remove_device,
-	.suspend	= pxa_camera_suspend,
-	.resume		= pxa_camera_resume,
-	.set_fmt_cap	= pxa_camera_set_fmt_cap,
-	.try_fmt_cap	= pxa_camera_try_fmt_cap,
-	.init_videobuf	= pxa_camera_init_videobuf,
-	.reqbufs	= pxa_camera_reqbufs,
-	.poll		= pxa_camera_poll,
-	.querycap	= pxa_camera_querycap,
-	.try_bus_param	= pxa_camera_try_bus_param,
-	.set_bus_param	= pxa_camera_set_bus_param,
+	.add		= camera_add_device,
+	.remove		= camera_remove_device,
+	.set_fmt	= camera_set_fmt_cap,
+	.try_fmt	= camera_try_fmt_cap,
+	.init_videobuf2	= camera_init_videobuf2,
+	.poll		= camera_poll,
+	.querycap	= camera_querycap,
+	.set_bus_param	= camera_set_bus_param,
+	/* The rest of host operations are optional */
 };
 
 .add and .remove methods are called when a sensor is attached to or detached
-from the host, apart from performing host-internal tasks they shall also call
-sensor driver's .init and .release methods respectively. .suspend and .resume
-methods implement host's power-management functionality and its their
-responsibility to call respective sensor's methods. .try_bus_param and
-.set_bus_param are used to negotiate physical connection parameters between the
-host and the sensor. .init_videobuf is called by soc-camera core when a
-video-device is opened, further video-buffer management is implemented completely
-by the specific camera host driver. The rest of the methods are called from
+from the host. .set_bus_param is used to configure physical connection
+parameters between the host and the sensor. .init_videobuf2 is called by
+soc-camera core when a video-device is opened, the host driver would typically
+call vb2_queue_init() in this method. Further video-buffer management is
+implemented completely by the specific camera host driver. If the host driver
+supports non-standard pixel format conversion, it should implement a
+.get_formats and, possibly, a .put_formats operations. See below for more
+details about format conversion. The rest of the methods are called from
 respective V4L2 operations.
 
 Camera API
@@ -84,37 +87,21 @@ Camera API
 
 Sensor drivers can use struct soc_camera_link, typically provided by the
 platform, and used to specify to which camera host bus the sensor is connected,
-and arbitrarily provide platform .power and .reset methods for the camera.
-soc_camera_device_register() and soc_camera_device_unregister() functions are
-used to add a sensor driver to or remove one from the system. The registration
-function takes a pointer to struct soc_camera_device as the only parameter.
-This struct can be initialized as follows:
-
-	/* link to driver operations */
-	icd->ops	= &mt9m001_ops;
-	/* link to the underlying physical (e.g., i2c) device */
-	icd->control	= &client->dev;
-	/* window geometry */
-	icd->x_min	= 20;
-	icd->y_min	= 12;
-	icd->x_current	= 20;
-	icd->y_current	= 12;
-	icd->width_min	= 48;
-	icd->width_max	= 1280;
-	icd->height_min	= 32;
-	icd->height_max	= 1024;
-	icd->y_skip_top	= 1;
-	/* camera bus ID, typically obtained from platform data */
-	icd->iface	= icl->bus_id;
-
-struct soc_camera_ops provides .probe and .remove methods, which are called by
-the soc-camera core, when a camera is matched against or removed from a camera
-host bus, .init, .release, .suspend, and .resume are called from the camera host
-driver as discussed above. Other members of this struct provide respective V4L2
-functionality.
-
-struct soc_camera_device also links to an array of struct soc_camera_data_format,
-listing pixel formats, supported by the camera.
+and optionally provide platform .power and .reset methods for the camera. This
+struct is provided to the camera driver via the I2C client device platform data
+and can be obtained, using the soc_camera_i2c_to_link() macro. Care should be
+taken, when using soc_camera_vdev_to_subdev() and when accessing struct
+soc_camera_device, using v4l2_get_subdev_hostdata(): both only work, when
+running on an soc-camera host. The actual camera driver operation is implemented
+using the V4L2 subdev API. Additionally soc-camera camera drivers can use
+auxiliary soc-camera helper functions like soc_camera_power_on() and
+soc_camera_power_off(), which switch regulators, provided by the platform and call
+board-specific power switching methods. soc_camera_apply_board_flags() takes
+camera bus configuration capability flags and applies any board transformations,
+e.g. signal polarity inversion. soc_mbus_get_fmtdesc() can be used to obtain a
+pixel format descriptor, corresponding to a certain media-bus pixel format code.
+soc_camera_limit_side() can be used to restrict beginning and length of a frame
+side, based on camera capabilities.
 
 VIDIOC_S_CROP and VIDIOC_S_FMT behaviour
 ----------------------------------------
@@ -153,8 +140,25 @@ implemented.
 User window geometry is kept in .user_width and .user_height fields in struct
 soc_camera_device and used by the soc-camera core and host drivers. The core
 updates these fields upon successful completion of a .s_fmt() call, but if these
-fields change elsewhere, e.g., during .s_crop() processing, the host driver is
+fields change elsewhere, e.g. during .s_crop() processing, the host driver is
 responsible for updating them.
 
+Format conversion
+-----------------
+
+V4L2 distinguishes between pixel formats, as they are stored in memory, and as
+they are transferred over a media bus. Soc-camera provides support to
+conveniently manage these formats. A table of standard transformations is
+maintained by soc-camera core, which describes, what FOURCC pixel format will
+be obtained, if a media-bus pixel format is stored in memory according to
+certain rules. E.g. if V4L2_MBUS_FMT_YUYV8_2X8 data is sampled with 8 bits per
+sample and stored in memory in the little-endian order with no gaps between
+bytes, data in memory will represent the V4L2_PIX_FMT_YUYV FOURCC format. These
+standard transformations will be used by soc-camera or by camera host drivers to
+configure camera drivers to produce the FOURCC format, requested by the user,
+using the VIDIOC_S_FMT ioctl(). Apart from those standard format conversions,
+host drivers can also provide their own conversion rules by implementing a
+.get_formats and, if required, a .put_formats methods.
+
 --
 Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
1.7.2.5

