Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13856 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2AYPaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:30:39 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYD00KN01R13U@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 15:30:37 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYD009OJ1R0DB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 15:30:37 +0000 (GMT)
Date: Wed, 25 Jan 2012 16:30:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Add driver documentation
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1327505433-2867-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add short documentation providing the driver usage details.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/video4linux/fimc.txt |  178 ++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/video4linux/fimc.txt

diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
new file mode 100644
index 0000000..81d6d2c
--- /dev/null
+++ b/Documentation/video4linux/fimc.txt
@@ -0,0 +1,178 @@
+Samsung S5P/EXYNOS4 FIMC driver
+
+Copyright (C) 2011 Samsung Electronics Co., Ltd.
+------------------------------------------------------------------------------
+
+This text describes the design of v4l2 driver for FIMC (Fully Interfactive
+Mobile Camera) devices present on Samsung SoC Application Processor series.
+FIMC IP is an integrated camera host interface, color space converter, image
+scaler and rotator. It's also capable of capturing data from LCD controller
+(FIMD) through the SoC internal writeback data path. On the SoCs this driver
+supports there are multiple instances of the IP (up to 4), having slightly
+different capabilities, like pixel alignment constraints, rotator availability,
+LCD writeback support, etc.
+The driver is located at drivers/media/video/s5p-fimc directory.
+
+
+1. Supported SoCs
+=================
+
+S5PC100 (mem-to-mem only), S5PV210, EXYNOS4210
+
+2. Supported features
+=====================
+
+ - camera parallel interface capture (ITU-R.BT601/565);
+ - camera serial interface capture (MIPI-CSI2);
+ - memory-to-memory processing (color space conversion, scaling, mirror;
+   and rotation);
+ - dynamic pipeline re-configuration at runtime (re-attachment of any FIMC
+   instance to any parallel video input or any MIPI-CSI front-end);
+ - runtime PM and system wide suspend/resume
+
+Not currently supported:
+ - LCD writeback input
+ - RGB alpha (exynos4 only)
+ - per frame clock gating (mem-to-mem)
+
+3. Files partitioning
+=====================
+
+- media device driver
+  drivers/media/video/s5p-fimc/fimc-mdevice.[ch]
+
+ - camera capture video device driver
+  drivers/media/video/s5p-fimc/fimc-capture.c
+
+ - MIPI-CSI2 receiver subdev
+  drivers/media/video/s5p-fimc/mipi-csis.[ch]
+
+ - video post-processor (mem-to-mem)
+  drivers/media/video/s5p-fimc/fimc-core.c
+
+ - common files
+  drivers/media/video/s5p-fimc/fimc-core.h
+  drivers/media/video/s5p-fimc/fimc-reg.h
+  drivers/media/video/s5p-fimc/regs-fimc.h
+
+4. User space interfaces
+========================
+
+4.1. Media device interface
+
+The driver supports Media Controller API as defined at
+http://http://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
+The media device driver name is "SAMSUNG S5P FIMC".
+
+The purpose of this interface is to allow changing the assignment of FIMC instance
+to the SoC peripheral camera input at runtime and optionally to control internal
+connections of the MIPI-CSIS device(s) to the FIMC entities.
+
+The media device interface allows to configure the SoC for capturing image data
+from the sensor through more than one FIMC instance (e.g. for simultaneous
+viewfinder and capture data stream).
+Reconfiguration is done by enabling/disabling the media links created by
+the driver during initialization. The internal device topology can be easily
+discovered through media entity and links enumeration.
+
+4.2. Memory-to-memory video node
+
+V4L2 memory-to-memory interface at /dev/video? device node. This is standalone
+video device, it has no media pads. However please note the mem-to-mem and
+capture video node operation on same FIMC instance is not allowed. The driver
+detects such cases but the applications should prevent them to avoid an
+undefined behaviour.
+
+4.3. Capture video node
+
+The driver supports V4L2 Video Capture Interface as defined at:
+http://linuxtv.org/downloads/v4l-dvb-apis/devices.html
+
+At the capture and mem-to-mem video nodes only the multi-planar API is supported.
+For more details see: http://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
+
+4.4. Camera capture subdevs
+
+Each FIMC instance exports a sub-device node (/dev/v4l-subdev?), a sub-device
+node is also created per each available and enabled at the platform level
+MIPI-CSI receiver device (currently up to two).
+
+4.5. sysfs
+
+In order to enable more precise camera pipeline control through the sub-device
+API the driver creates a sysfs entry associated with "s5p-fimc-md" platform
+device. The entry path is: /sys/platform/devices/s5p-fimc-md/subdev_conf_mode.
+
+In typical use case there could be a following capture pipeline configuration:
+sensor subdev -> mipi-csi subdev -> fimc subdev -> video node
+
+When we configure these devices through sub-device API at user space,
+the configuration flow must be from left to right, and the video node
+is configured as last one.
+When we don't use sub-device user space API the whole configuration of all
+devices belonging to the pipeline is done at video node.
+The sysfs entry allows to instruct the capture video node driver not to
+configure the sub-devices (format, crop), to avoid resetting the subdevs'
+configuration when the last configuration steps at the video node are performed.
+
+For full sub-device control support (subdevs configured at user space
+before starting streaming):
+# echo "sub-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
+
+For V4L2 video node control only (subdevs configured internally by the host
+driver):
+# echo "vid-dev" > /sys/platform/devices/s5p-fimc-md/subdev_conf_mode
+This is the default option.
+
+5. Device mapping to video and subdev device nodes
+==================================================
+
+Each FIMC instance creates two video device nodes, for camera capture and
+mem-to-mem, and a subdev node for more precise control of the FIMC capture
+subsystem. In addition separate v4l2 sub-device node is created per each
+MIPI-CSIS device.
+
+How to find out which /dev/video? or /dev/v4l-subdev? is assigned to which
+device?
+
+You can either grep through the kernel log to find relevant information, i.e.
+# dmesg | grep -i fimc
+(note that udev, if present, might still have rearranged the video nodes),
+
+or retrieve the information from /dev/media? with help of the media-ctl tool:
+# media-ctl -p
+
+6. Platform support
+===================
+
+The machine code (plat-s5p and arch/arm/mach-*) must select following options
+
+CONFIG_S5P_DEV_FIMC0 (mandatory)
+CONFIG_S5P_DEV_FIMC1 \
+CONFIG_S5P_DEV_FIMC2 | optional
+CONFIG_S5P_DEV_FIMC3 /
+CONFIG_S5P_SETUP_MIPIPHY \
+CONFIG_S5P_DEV_CSIS0     | optional for MIPI-CSI interface
+CONFIG_S5P_DEV_CSIS1     /
+
+Except that, relevant s5p_device_fimc? should be registered in the machine code
+in addition to a "s5p-fimc-md" platform device to which the media device driver
+is bound. The "s5p-fimc-md" device instance is required even if only mem-to-mem
+operation is used.
+
+The description of sensor(s) attached to FIMC/MIPI-CSIS camera inputs should be
+passed as the "s5p-fimc-md" device platform_data. The platform data structure
+is defined in file include/media/s5p_fimc.h.
+
+7. Build
+========
+
+This driver depends on following config options:
+PLAT_S5P,
+PM_RUNTIME,
+I2C,
+VIDEO_V4L2_SUBDEV_API,
+
+If the driver is built as a loadable kernel module (CONFIG_VIDEO_SAMSUNG_S5P_FIMC=m)
+two modules are created (in addition to the core v4l2 modules): s5p-fimc.ko and
+optional s5p-csis.ko (MIPI-CSI receiver subdev).
-- 
1.7.8.3

