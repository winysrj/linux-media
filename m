Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39421 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbeHCNdI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 09:33:08 -0400
Date: Fri, 3 Aug 2018 13:37:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 2/2] uvcvideo: add a D4M camera description
In-Reply-To: <5991411.ejCQOIbS9u@avalon>
Message-ID: <alpine.DEB.2.20.1808031335310.13762@axis700.grange>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange> <5991411.ejCQOIbS9u@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

D4M is a mobile model from the D4XX family of Intel RealSense cameras.
This patch adds a descriptor for it, which enables reading per-frame
metadata from it.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 Documentation/media/uapi/v4l/meta-formats.rst     |   1 +
 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 204 ++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_driver.c                |  11 ++
 include/uapi/linux/videodev2.h                    |   1 +
 4 files changed, 217 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst

diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
index 0c4e1ec..cf971d5 100644
--- a/Documentation/media/uapi/v4l/meta-formats.rst
+++ b/Documentation/media/uapi/v4l/meta-formats.rst
@@ -12,6 +12,7 @@ These formats are used for the :ref:`metadata` interface only.
 .. toctree::
     :maxdepth: 1
 
+    pixfmt-meta-d4xx
     pixfmt-meta-uvc
     pixfmt-meta-vsp1-hgo
     pixfmt-meta-vsp1-hgt
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
new file mode 100644
index 0000000..57ecfd9
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
@@ -0,0 +1,204 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _v4l2-meta-fmt-d4xx:
+
+*******************************
+V4L2_META_FMT_D4XX ('D4XX')
+*******************************
+
+Intel D4xx UVC Cameras Metadata
+
+
+Description
+===========
+
+Intel D4xx (D435 and other) cameras include per-frame metadata in their UVC
+payload headers, following the Microsoft(R) UVC extension proposal [1_]. That
+means, that the private D4XX metadata, following the standard UVC header, is
+organised in blocks. D4XX cameras implement several standard block types,
+proposed by Microsoft, and several proprietary ones. Supported standard metadata
+types are MetadataId_CaptureStats (ID 3), MetadataId_CameraExtrinsics (ID 4),
+and MetadataId_CameraIntrinsics (ID 5). For their description see [1_]. This
+document describes proprietary metadata types, used by D4xx cameras.
+
+V4L2_META_FMT_D4XX buffers follow the metadata buffer layout of
+V4L2_META_FMT_UVC with the only difference, that it also includes proprietary
+payload header data. D4xx cameras use bulk transfers and only send one payload
+per frame, therefore their headers cannot be larger than 255 bytes.
+
+Below are proprietary Microsoft style metadata types, used by D4xx cameras,
+where all fields are in little endian order:
+
+.. flat-table:: D4xx metadata
+    :widths: 1 4
+    :header-rows:  1
+    :stub-columns: 0
+
+    * - Field
+      - Description
+    * - :cspan:`1` *Depth Control*
+    * - __u32 ID
+      - 0x80000000
+    * - __u32 Size
+      - Size in bytes (currently 56)
+    * - __u32 Version
+      - Version of the struct
+    * - __u32 Flags
+      - A bitmask of flags: see [2_] below
+    * - __u32 Gain
+      - Gain value in internal units, same as the V4L2_CID_GAIN control, used to
+	capture the frame
+    * - __u32 Exposure
+      - Exposure time (in microseconds) used to capture the frame
+    * - __u32 Laser power
+      - Power of the laser LED 0-360, used for depth measurement
+    * - __u32 AE mode
+      - 0: manual; 1: automatic exposure
+    * - __u32 Exposure priority
+      - Exposure priority value: 0 - constant frame rate
+    * - __u32 AE ROI left
+      - Left border of the AE Region of Interest (all ROI values are in pixels
+	and lie between 0 and maximum width or height respectively)
+    * - __u32 AE ROI right
+      - Right border of the AE Region of Interest
+    * - __u32 AE ROI top
+      - Top border of the AE Region of Interest
+    * - __u32 AE ROI bottom
+      - Bottom border of the AE Region of Interest
+    * - __u32 Preset
+      - Preset selector value, default: 0, unless changed by the user
+    * - __u32 Laser mode
+      - 0: off, 1: on
+    * - :cspan:`1` *Capture Timing*
+    * - __u32 ID
+      - 0x80000001
+    * - __u32 Size
+      - Size in bytes (currently 40)
+    * - __u32 Version
+      - Version of the struct
+    * - __u32 Flags
+      - A bitmask of flags: see [3_] below
+    * - __u32 Frame counter
+      - Monotonically increasing counter
+    * - __u32 Optical time
+      - Time in microseconds from the beginning of a frame till its middle
+    * - __u32 Readout time
+      - Time, used to read out a frame in microseconds
+    * - __u32 Exposure time
+      - Frame exposure time in microseconds
+    * - __u32 Frame interval
+      - In microseconds = 1000000 / framerate
+    * - __u32 Pipe latency
+      - Time in microseconds from start of frame to data in USB buffer
+    * - :cspan:`1` *Configuration*
+    * - __u32 ID
+      - 0x80000002
+    * - __u32 Size
+      - Size in bytes (currently 40)
+    * - __u32 Version
+      - Version of the struct
+    * - __u32 Flags
+      - A bitmask of flags: see [4_] below
+    * - __u8 Hardware type
+      - Camera hardware version [5_]
+    * - __u8 SKU ID
+      - Camera hardware configuration [6_]
+    * - __u32 Cookie
+      - Internal synchronisation
+    * - __u16 Format
+      - Image format code [7_]
+    * - __u16 Width
+      - Width in pixels
+    * - __u16 Height
+      - Height in pixels
+    * - __u16 Framerate
+      - Requested frame rate per second
+    * - __u16 Trigger
+      - Byte 0: bit 0: depth and RGB are synchronised, bit 1: external trigger
+
+.. _1:
+
+[1] https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-extensions-1-5
+
+.. _2:
+
+[2] Depth Control flags specify which fields are valid: ::
+
+  0x00000001 Gain
+  0x00000002 Exposure
+  0x00000004 Laser power
+  0x00000008 AE mode
+  0x00000010 Exposure priority
+  0x00000020 AE ROI
+  0x00000040 Preset
+
+.. _3:
+
+[3] Capture Timing flags specify which fields are valid: ::
+
+  0x00000001 Frame counter
+  0x00000002 Optical time
+  0x00000004 Readout time
+  0x00000008 Exposure time
+  0x00000010 Frame interval
+  0x00000020 Pipe latency
+
+.. _4:
+
+[4] Configuration flags specify which fields are valid: ::
+
+  0x00000001 Hardware type
+  0x00000002 SKU ID
+  0x00000004 Cookie
+  0x00000008 Format
+  0x00000010 Width
+  0x00000020 Height
+  0x00000040 Framerate
+  0x00000080 Trigger
+  0x00000100 Cal count
+
+.. _5:
+
+[5] Camera model: ::
+
+  0 DS5
+  1 IVCAM2
+
+.. _6:
+
+[6] 8-bit camera hardware configuration bitfield: ::
+
+  [1:0] depthCamera
+	00: no depth
+	01: standard depth
+	10: wide depth
+	11: reserved
+  [2]   depthIsActive - has a laser projector
+  [3]   RGB presence
+  [4]   IMU presence
+  [5]   projectorType
+	0: HPTG
+	1: Princeton
+  [6]   0: a projector, 1: an LED
+  [7]   reserved
+
+.. _7:
+
+[7] Image format codes per camera interface:
+
+Depth: ::
+
+  1 Z16
+  2 Z
+
+Left sensor: ::
+
+  1 Y8
+  2 UYVY
+  3 R8L8
+  4 Calibration
+  5 W10
+
+Fish Eye sensor: ::
+
+  1 RAW8
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 699984b..1dcd250 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2345,6 +2345,8 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 };
 
 #define UVC_INFO_QUIRK(q) (kernel_ulong_t)&(struct uvc_device_info){.quirks = q}
+#define UVC_INFO_META(m) (kernel_ulong_t)&(struct uvc_device_info) \
+	{.meta_format = m}
 
 /*
  * The Logitech cameras listed below have their interface class set to
@@ -2818,6 +2820,15 @@ static int uvc_clock_param_set(const char *val, const struct kernel_param *kp)
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_force_y8 },
+	/* Intel RealSense D4M */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x8086,
+	  .idProduct		= 0x0b03,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_META(V4L2_META_FMT_D4XX) },
 	/* Generic USB Video Class */
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_UNDEFINED) },
 	{ USB_INTERFACE_INFO(USB_CLASS_VIDEO, 1, UVC_PC_PROTOCOL_15) },
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index d8b3309..40aff26 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -697,6 +697,7 @@ struct v4l2_pix_format {
 #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
 #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
 #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
+#define V4L2_META_FMT_D4XX        v4l2_fourcc('D', '4', 'X', 'X') /* D4XX Payload Header metadata */
 
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
-- 
1.9.3
