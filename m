Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38801 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0GJSLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 14:11:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, greg@kroah.com, sfr@canb.auug.org.au
Subject: [PATCH FOR 2.6.36] uvc: Move constants and structures definitions to linux/usb/video.h
Date: Sat, 10 Jul 2010 20:03:20 +0200
Message-Id: <1278785000-8980-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC host and gadget drivers both define constants and structures in
private header files. Move all those definitions to linux/usb/video.h
where they can be shared by the two drivers (and be available for
userspace applications).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvcvideo.h |   19 --
 drivers/usb/gadget/f_uvc.c         |   16 +-
 drivers/usb/gadget/f_uvc.h         |  352 +-------------------------------
 drivers/usb/gadget/uvc.h           |   36 ----
 drivers/usb/gadget/webcam.c        |   24 +-
 include/linux/usb/video.h          |  397 ++++++++++++++++++++++++++++++++++++
 6 files changed, 418 insertions(+), 426 deletions(-)

This patch replaces
usb-uvc-move-constants-and-structures-definitions-to-linux-usb-video.h.patch
from Greg Kroah-Hartman's patches.git tree. It fixes the conflicts between the
original patch and commits c3810b43416155d040a200e7a7301f379c8ae8a0 and
da1df555fcbb98a9d2054304ea54545d9ff523cf in the v4l-dvb.git tree.

Regards,

Laurent Pinchart

diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 47b20e7..ac27245 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -196,25 +196,6 @@ struct uvc_device;
 /* TODO: Put the most frequently accessed fields at the beginning of
  * structures to maximize cache efficiency.
  */
-struct uvc_streaming_control {
-	__u16 bmHint;
-	__u8  bFormatIndex;
-	__u8  bFrameIndex;
-	__u32 dwFrameInterval;
-	__u16 wKeyFrameRate;
-	__u16 wPFrameRate;
-	__u16 wCompQuality;
-	__u16 wCompWindowSize;
-	__u16 wDelay;
-	__u32 dwMaxVideoFrameSize;
-	__u32 dwMaxPayloadTransferSize;
-	__u32 dwClockFrequency;
-	__u8  bmFramingInfo;
-	__u8  bPreferedVersion;
-	__u8  bMinVersion;
-	__u8  bMaxVersion;
-};
-
 struct uvc_control_info {
 	struct list_head list;
 	struct list_head mappings;
diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index fc2611f..b6aed97 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -61,12 +61,12 @@ static struct usb_gadget_strings *uvc_function_strings[] = {
 #define UVC_INTF_VIDEO_STREAMING		1
 
 static struct usb_interface_assoc_descriptor uvc_iad __initdata = {
-	.bLength		= USB_DT_INTERFACE_ASSOCIATION_SIZE,
+	.bLength		= sizeof(uvc_iad),
 	.bDescriptorType	= USB_DT_INTERFACE_ASSOCIATION,
 	.bFirstInterface	= 0,
 	.bInterfaceCount	= 2,
 	.bFunctionClass		= USB_CLASS_VIDEO,
-	.bFunctionSubClass	= 0x03,
+	.bFunctionSubClass	= UVC_SC_VIDEO_INTERFACE_COLLECTION,
 	.bFunctionProtocol	= 0x00,
 	.iFunction		= 0,
 };
@@ -78,7 +78,7 @@ static struct usb_interface_descriptor uvc_control_intf __initdata = {
 	.bAlternateSetting	= 0,
 	.bNumEndpoints		= 1,
 	.bInterfaceClass	= USB_CLASS_VIDEO,
-	.bInterfaceSubClass	= 0x01,
+	.bInterfaceSubClass	= UVC_SC_VIDEOCONTROL,
 	.bInterfaceProtocol	= 0x00,
 	.iInterface		= 0,
 };
@@ -106,7 +106,7 @@ static struct usb_interface_descriptor uvc_streaming_intf_alt0 __initdata = {
 	.bAlternateSetting	= 0,
 	.bNumEndpoints		= 0,
 	.bInterfaceClass	= USB_CLASS_VIDEO,
-	.bInterfaceSubClass	= 0x02,
+	.bInterfaceSubClass	= UVC_SC_VIDEOSTREAMING,
 	.bInterfaceProtocol	= 0x00,
 	.iInterface		= 0,
 };
@@ -118,7 +118,7 @@ static struct usb_interface_descriptor uvc_streaming_intf_alt1 __initdata = {
 	.bAlternateSetting	= 1,
 	.bNumEndpoints		= 1,
 	.bInterfaceClass	= USB_CLASS_VIDEO,
-	.bInterfaceSubClass	= 0x02,
+	.bInterfaceSubClass	= UVC_SC_VIDEOSTREAMING,
 	.bInterfaceProtocol	= 0x00,
 	.iInterface		= 0,
 };
@@ -603,15 +603,15 @@ uvc_bind_config(struct usb_configuration *c,
 
 	/* Validate the descriptors. */
 	if (control == NULL || control[0] == NULL ||
-	    control[0]->bDescriptorSubType != UVC_DT_HEADER)
+	    control[0]->bDescriptorSubType != UVC_VC_HEADER)
 		goto error;
 
 	if (fs_streaming == NULL || fs_streaming[0] == NULL ||
-	    fs_streaming[0]->bDescriptorSubType != UVC_DT_INPUT_HEADER)
+	    fs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
 		goto error;
 
 	if (hs_streaming == NULL || hs_streaming[0] == NULL ||
-	    hs_streaming[0]->bDescriptorSubType != UVC_DT_INPUT_HEADER)
+	    hs_streaming[0]->bDescriptorSubType != UVC_VS_INPUT_HEADER)
 		goto error;
 
 	uvc->desc.control = control;
diff --git a/drivers/usb/gadget/f_uvc.h b/drivers/usb/gadget/f_uvc.h
index 8a5db7c..e18a663 100644
--- a/drivers/usb/gadget/f_uvc.h
+++ b/drivers/usb/gadget/f_uvc.h
@@ -15,357 +15,7 @@
 #define _F_UVC_H_
 
 #include <linux/usb/composite.h>
-
-#define USB_CLASS_VIDEO_CONTROL		1
-#define USB_CLASS_VIDEO_STREAMING	2
-
-struct uvc_descriptor_header {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-} __attribute__ ((packed));
-
-struct uvc_header_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u16 bcdUVC;
-	__u16 wTotalLength;
-	__u32 dwClockFrequency;
-	__u8  bInCollection;
-	__u8  baInterfaceNr[];
-} __attribute__((__packed__));
-
-#define UVC_HEADER_DESCRIPTOR(n)	uvc_header_descriptor_##n
-
-#define DECLARE_UVC_HEADER_DESCRIPTOR(n) 			\
-struct UVC_HEADER_DESCRIPTOR(n) {				\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u16 bcdUVC;						\
-	__u16 wTotalLength;					\
-	__u32 dwClockFrequency;					\
-	__u8  bInCollection;					\
-	__u8  baInterfaceNr[n];					\
-} __attribute__ ((packed))
-
-struct uvc_input_terminal_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bTerminalID;
-	__u16 wTerminalType;
-	__u8  bAssocTerminal;
-	__u8  iTerminal;
-} __attribute__((__packed__));
-
-struct uvc_output_terminal_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bTerminalID;
-	__u16 wTerminalType;
-	__u8  bAssocTerminal;
-	__u8  bSourceID;
-	__u8  iTerminal;
-} __attribute__((__packed__));
-
-struct uvc_camera_terminal_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bTerminalID;
-	__u16 wTerminalType;
-	__u8  bAssocTerminal;
-	__u8  iTerminal;
-	__u16 wObjectiveFocalLengthMin;
-	__u16 wObjectiveFocalLengthMax;
-	__u16 wOcularFocalLength;
-	__u8  bControlSize;
-	__u8  bmControls[3];
-} __attribute__((__packed__));
-
-struct uvc_selector_unit_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bUnitID;
-	__u8  bNrInPins;
-	__u8  baSourceID[0];
-	__u8  iSelector;
-} __attribute__((__packed__));
-
-#define UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
-	uvc_selector_unit_descriptor_##n
-
-#define DECLARE_UVC_SELECTOR_UNIT_DESCRIPTOR(n) 		\
-struct UVC_SELECTOR_UNIT_DESCRIPTOR(n) {			\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bUnitID;						\
-	__u8  bNrInPins;					\
-	__u8  baSourceID[n];					\
-	__u8  iSelector;					\
-} __attribute__ ((packed))
-
-struct uvc_processing_unit_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bUnitID;
-	__u8  bSourceID;
-	__u16 wMaxMultiplier;
-	__u8  bControlSize;
-	__u8  bmControls[2];
-	__u8  iProcessing;
-} __attribute__((__packed__));
-
-struct uvc_extension_unit_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bUnitID;
-	__u8  guidExtensionCode[16];
-	__u8  bNumControls;
-	__u8  bNrInPins;
-	__u8  baSourceID[0];
-	__u8  bControlSize;
-	__u8  bmControls[0];
-	__u8  iExtension;
-} __attribute__((__packed__));
-
-#define UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) \
-	uvc_extension_unit_descriptor_##p_##n
-
-#define DECLARE_UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) 		\
-struct UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) {			\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bUnitID;						\
-	__u8  guidExtensionCode[16];				\
-	__u8  bNumControls;					\
-	__u8  bNrInPins;					\
-	__u8  baSourceID[p];					\
-	__u8  bControlSize;					\
-	__u8  bmControls[n];					\
-	__u8  iExtension;					\
-} __attribute__ ((packed))
-
-struct uvc_control_endpoint_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u16 wMaxTransferSize;
-} __attribute__((__packed__));
-
-#define UVC_DT_HEADER				1
-#define UVC_DT_INPUT_TERMINAL			2
-#define UVC_DT_OUTPUT_TERMINAL			3
-#define UVC_DT_SELECTOR_UNIT			4
-#define UVC_DT_PROCESSING_UNIT			5
-#define UVC_DT_EXTENSION_UNIT			6
-
-#define UVC_DT_HEADER_SIZE(n)			(12+(n))
-#define UVC_DT_INPUT_TERMINAL_SIZE		8
-#define UVC_DT_OUTPUT_TERMINAL_SIZE		9
-#define UVC_DT_CAMERA_TERMINAL_SIZE(n)		(15+(n))
-#define UVC_DT_SELECTOR_UNIT_SIZE(n)		(6+(n))
-#define UVC_DT_PROCESSING_UNIT_SIZE(n)		(9+(n))
-#define UVC_DT_EXTENSION_UNIT_SIZE(p,n)		(24+(p)+(n))
-#define UVC_DT_CONTROL_ENDPOINT_SIZE		5
-
-struct uvc_input_header_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bNumFormats;
-	__u16 wTotalLength;
-	__u8  bEndpointAddress;
-	__u8  bmInfo;
-	__u8  bTerminalLink;
-	__u8  bStillCaptureMethod;
-	__u8  bTriggerSupport;
-	__u8  bTriggerUsage;
-	__u8  bControlSize;
-	__u8  bmaControls[];
-} __attribute__((__packed__));
-
-#define UVC_INPUT_HEADER_DESCRIPTOR(n, p) \
-	uvc_input_header_descriptor_##n_##p
-
-#define DECLARE_UVC_INPUT_HEADER_DESCRIPTOR(n, p)		\
-struct UVC_INPUT_HEADER_DESCRIPTOR(n, p) {			\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bNumFormats;					\
-	__u16 wTotalLength;					\
-	__u8  bEndpointAddress;					\
-	__u8  bmInfo;						\
-	__u8  bTerminalLink;					\
-	__u8  bStillCaptureMethod;				\
-	__u8  bTriggerSupport;					\
-	__u8  bTriggerUsage;					\
-	__u8  bControlSize;					\
-	__u8  bmaControls[p][n];				\
-} __attribute__ ((packed))
-
-struct uvc_output_header_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bNumFormats;
-	__u16 wTotalLength;
-	__u8  bEndpointAddress;
-	__u8  bTerminalLink;
-	__u8  bControlSize;
-	__u8  bmaControls[];
-} __attribute__((__packed__));
-
-#define UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) \
-	uvc_output_header_descriptor_##n_##p
-
-#define DECLARE_UVC_OUTPUT_HEADER_DESCRIPTOR(n, p)		\
-struct UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) {			\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bNumFormats;					\
-	__u16 wTotalLength;					\
-	__u8  bEndpointAddress;					\
-	__u8  bTerminalLink;					\
-	__u8  bControlSize;					\
-	__u8  bmaControls[p][n];				\
-} __attribute__ ((packed))
-
-struct uvc_format_uncompressed {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bFormatIndex;
-	__u8  bNumFrameDescriptors;
-	__u8  guidFormat[16];
-	__u8  bBitsPerPixel;
-	__u8  bDefaultFrameIndex;
-	__u8  bAspectRatioX;
-	__u8  bAspectRatioY;
-	__u8  bmInterfaceFlags;
-	__u8  bCopyProtect;
-} __attribute__((__packed__));
-
-struct uvc_frame_uncompressed {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bFrameIndex;
-	__u8  bmCapabilities;
-	__u16 wWidth;
-	__u16 wHeight;
-	__u32 dwMinBitRate;
-	__u32 dwMaxBitRate;
-	__u32 dwMaxVideoFrameBufferSize;
-	__u32 dwDefaultFrameInterval;
-	__u8  bFrameIntervalType;
-	__u32 dwFrameInterval[];
-} __attribute__((__packed__));
-
-#define UVC_FRAME_UNCOMPRESSED(n) \
-	uvc_frame_uncompressed_##n
-
-#define DECLARE_UVC_FRAME_UNCOMPRESSED(n) 			\
-struct UVC_FRAME_UNCOMPRESSED(n) {				\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bFrameIndex;					\
-	__u8  bmCapabilities;					\
-	__u16 wWidth;						\
-	__u16 wHeight;						\
-	__u32 dwMinBitRate;					\
-	__u32 dwMaxBitRate;					\
-	__u32 dwMaxVideoFrameBufferSize;			\
-	__u32 dwDefaultFrameInterval;				\
-	__u8  bFrameIntervalType;				\
-	__u32 dwFrameInterval[n];				\
-} __attribute__ ((packed))
-
-struct uvc_format_mjpeg {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bFormatIndex;
-	__u8  bNumFrameDescriptors;
-	__u8  bmFlags;
-	__u8  bDefaultFrameIndex;
-	__u8  bAspectRatioX;
-	__u8  bAspectRatioY;
-	__u8  bmInterfaceFlags;
-	__u8  bCopyProtect;
-} __attribute__((__packed__));
-
-struct uvc_frame_mjpeg {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bFrameIndex;
-	__u8  bmCapabilities;
-	__u16 wWidth;
-	__u16 wHeight;
-	__u32 dwMinBitRate;
-	__u32 dwMaxBitRate;
-	__u32 dwMaxVideoFrameBufferSize;
-	__u32 dwDefaultFrameInterval;
-	__u8  bFrameIntervalType;
-	__u32 dwFrameInterval[];
-} __attribute__((__packed__));
-
-#define UVC_FRAME_MJPEG(n) \
-	uvc_frame_mjpeg_##n
-
-#define DECLARE_UVC_FRAME_MJPEG(n) 				\
-struct UVC_FRAME_MJPEG(n) {					\
-	__u8  bLength;						\
-	__u8  bDescriptorType;					\
-	__u8  bDescriptorSubType;				\
-	__u8  bFrameIndex;					\
-	__u8  bmCapabilities;					\
-	__u16 wWidth;						\
-	__u16 wHeight;						\
-	__u32 dwMinBitRate;					\
-	__u32 dwMaxBitRate;					\
-	__u32 dwMaxVideoFrameBufferSize;			\
-	__u32 dwDefaultFrameInterval;				\
-	__u8  bFrameIntervalType;				\
-	__u32 dwFrameInterval[n];				\
-} __attribute__ ((packed))
-
-struct uvc_color_matching_descriptor {
-	__u8  bLength;
-	__u8  bDescriptorType;
-	__u8  bDescriptorSubType;
-	__u8  bColorPrimaries;
-	__u8  bTransferCharacteristics;
-	__u8  bMatrixCoefficients;
-} __attribute__((__packed__));
-
-#define UVC_DT_INPUT_HEADER			1
-#define UVC_DT_OUTPUT_HEADER			2
-#define UVC_DT_FORMAT_UNCOMPRESSED		4
-#define UVC_DT_FRAME_UNCOMPRESSED		5
-#define UVC_DT_FORMAT_MJPEG			6
-#define UVC_DT_FRAME_MJPEG			7
-#define UVC_DT_COLOR_MATCHING			13
-
-#define UVC_DT_INPUT_HEADER_SIZE(n, p)		(13+(n*p))
-#define UVC_DT_OUTPUT_HEADER_SIZE(n, p)		(9+(n*p))
-#define UVC_DT_FORMAT_UNCOMPRESSED_SIZE		27
-#define UVC_DT_FRAME_UNCOMPRESSED_SIZE(n)	(26+4*(n))
-#define UVC_DT_FORMAT_MJPEG_SIZE		11
-#define UVC_DT_FRAME_MJPEG_SIZE(n)		(26+4*(n))
-#define UVC_DT_COLOR_MATCHING_SIZE		6
+#include <linux/usb/video.h>
 
 extern int uvc_bind_config(struct usb_configuration *c,
 			   const struct uvc_descriptor_header * const *control,
diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
index 0a705e6..b05bcb7 100644
--- a/drivers/usb/gadget/uvc.h
+++ b/drivers/usb/gadget/uvc.h
@@ -48,39 +48,6 @@ struct uvc_event
 #define UVC_INTF_STREAMING		1
 
 /* ------------------------------------------------------------------------
- * UVC constants & structures
- */
-
-/* Values for bmHeaderInfo (Video and Still Image Payload Headers, 2.4.3.3) */
-#define UVC_STREAM_EOH				(1 << 7)
-#define UVC_STREAM_ERR				(1 << 6)
-#define UVC_STREAM_STI				(1 << 5)
-#define UVC_STREAM_RES				(1 << 4)
-#define UVC_STREAM_SCR				(1 << 3)
-#define UVC_STREAM_PTS				(1 << 2)
-#define UVC_STREAM_EOF				(1 << 1)
-#define UVC_STREAM_FID				(1 << 0)
-
-struct uvc_streaming_control {
-	__u16 bmHint;
-	__u8  bFormatIndex;
-	__u8  bFrameIndex;
-	__u32 dwFrameInterval;
-	__u16 wKeyFrameRate;
-	__u16 wPFrameRate;
-	__u16 wCompQuality;
-	__u16 wCompWindowSize;
-	__u16 wDelay;
-	__u32 dwMaxVideoFrameSize;
-	__u32 dwMaxPayloadTransferSize;
-	__u32 dwClockFrequency;
-	__u8  bmFramingInfo;
-	__u8  bPreferedVersion;
-	__u8  bMinVersion;
-	__u8  bMaxVersion;
-} __attribute__((__packed__));
-
-/* ------------------------------------------------------------------------
  * Debugging, printing and logging
  */
 
@@ -137,9 +104,6 @@ extern unsigned int uvc_trace_param;
 #define UVC_MAX_REQUEST_SIZE			64
 #define UVC_MAX_EVENTS				4
 
-#define USB_DT_INTERFACE_ASSOCIATION_SIZE	8
-#define USB_CLASS_MISC				0xef
-
 /* ------------------------------------------------------------------------
  * Structures
  */
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index 417fd68..98e9c8b 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -90,7 +90,7 @@ DECLARE_UVC_HEADER_DESCRIPTOR(1);
 static const struct UVC_HEADER_DESCRIPTOR(1) uvc_control_header = {
 	.bLength		= UVC_DT_HEADER_SIZE(1),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_HEADER,
+	.bDescriptorSubType	= UVC_VC_HEADER,
 	.bcdUVC			= cpu_to_le16(0x0100),
 	.wTotalLength		= 0, /* dynamic */
 	.dwClockFrequency	= cpu_to_le32(48000000),
@@ -101,7 +101,7 @@ static const struct UVC_HEADER_DESCRIPTOR(1) uvc_control_header = {
 static const struct uvc_camera_terminal_descriptor uvc_camera_terminal = {
 	.bLength		= UVC_DT_CAMERA_TERMINAL_SIZE(3),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_INPUT_TERMINAL,
+	.bDescriptorSubType	= UVC_VC_INPUT_TERMINAL,
 	.bTerminalID		= 1,
 	.wTerminalType		= cpu_to_le16(0x0201),
 	.bAssocTerminal		= 0,
@@ -118,7 +118,7 @@ static const struct uvc_camera_terminal_descriptor uvc_camera_terminal = {
 static const struct uvc_processing_unit_descriptor uvc_processing = {
 	.bLength		= UVC_DT_PROCESSING_UNIT_SIZE(2),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_PROCESSING_UNIT,
+	.bDescriptorSubType	= UVC_VC_PROCESSING_UNIT,
 	.bUnitID		= 2,
 	.bSourceID		= 1,
 	.wMaxMultiplier		= cpu_to_le16(16*1024),
@@ -131,7 +131,7 @@ static const struct uvc_processing_unit_descriptor uvc_processing = {
 static const struct uvc_output_terminal_descriptor uvc_output_terminal = {
 	.bLength		= UVC_DT_OUTPUT_TERMINAL_SIZE,
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_OUTPUT_TERMINAL,
+	.bDescriptorSubType	= UVC_VC_OUTPUT_TERMINAL,
 	.bTerminalID		= 3,
 	.wTerminalType		= cpu_to_le16(0x0101),
 	.bAssocTerminal		= 0,
@@ -144,7 +144,7 @@ DECLARE_UVC_INPUT_HEADER_DESCRIPTOR(1, 2);
 static const struct UVC_INPUT_HEADER_DESCRIPTOR(1, 2) uvc_input_header = {
 	.bLength		= UVC_DT_INPUT_HEADER_SIZE(1, 2),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_INPUT_HEADER,
+	.bDescriptorSubType	= UVC_VS_INPUT_HEADER,
 	.bNumFormats		= 2,
 	.wTotalLength		= 0, /* dynamic */
 	.bEndpointAddress	= 0, /* dynamic */
@@ -161,7 +161,7 @@ static const struct UVC_INPUT_HEADER_DESCRIPTOR(1, 2) uvc_input_header = {
 static const struct uvc_format_uncompressed uvc_format_yuv = {
 	.bLength		= UVC_DT_FORMAT_UNCOMPRESSED_SIZE,
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FORMAT_UNCOMPRESSED,
+	.bDescriptorSubType	= UVC_VS_FORMAT_UNCOMPRESSED,
 	.bFormatIndex		= 1,
 	.bNumFrameDescriptors	= 2,
 	.guidFormat		=
@@ -181,7 +181,7 @@ DECLARE_UVC_FRAME_UNCOMPRESSED(3);
 static const struct UVC_FRAME_UNCOMPRESSED(3) uvc_frame_yuv_360p = {
 	.bLength		= UVC_DT_FRAME_UNCOMPRESSED_SIZE(3),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FRAME_UNCOMPRESSED,
+	.bDescriptorSubType	= UVC_VS_FRAME_UNCOMPRESSED,
 	.bFrameIndex		= 1,
 	.bmCapabilities		= 0,
 	.wWidth			= cpu_to_le16(640),
@@ -199,7 +199,7 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) uvc_frame_yuv_360p = {
 static const struct UVC_FRAME_UNCOMPRESSED(1) uvc_frame_yuv_720p = {
 	.bLength		= UVC_DT_FRAME_UNCOMPRESSED_SIZE(1),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FRAME_UNCOMPRESSED,
+	.bDescriptorSubType	= UVC_VS_FRAME_UNCOMPRESSED,
 	.bFrameIndex		= 2,
 	.bmCapabilities		= 0,
 	.wWidth			= cpu_to_le16(1280),
@@ -215,7 +215,7 @@ static const struct UVC_FRAME_UNCOMPRESSED(1) uvc_frame_yuv_720p = {
 static const struct uvc_format_mjpeg uvc_format_mjpg = {
 	.bLength		= UVC_DT_FORMAT_MJPEG_SIZE,
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FORMAT_MJPEG,
+	.bDescriptorSubType	= UVC_VS_FORMAT_MJPEG,
 	.bFormatIndex		= 2,
 	.bNumFrameDescriptors	= 2,
 	.bmFlags		= 0,
@@ -232,7 +232,7 @@ DECLARE_UVC_FRAME_MJPEG(3);
 static const struct UVC_FRAME_MJPEG(3) uvc_frame_mjpg_360p = {
 	.bLength		= UVC_DT_FRAME_MJPEG_SIZE(3),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FRAME_MJPEG,
+	.bDescriptorSubType	= UVC_VS_FRAME_MJPEG,
 	.bFrameIndex		= 1,
 	.bmCapabilities		= 0,
 	.wWidth			= cpu_to_le16(640),
@@ -250,7 +250,7 @@ static const struct UVC_FRAME_MJPEG(3) uvc_frame_mjpg_360p = {
 static const struct UVC_FRAME_MJPEG(1) uvc_frame_mjpg_720p = {
 	.bLength		= UVC_DT_FRAME_MJPEG_SIZE(1),
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_FRAME_MJPEG,
+	.bDescriptorSubType	= UVC_VS_FRAME_MJPEG,
 	.bFrameIndex		= 2,
 	.bmCapabilities		= 0,
 	.wWidth			= cpu_to_le16(1280),
@@ -266,7 +266,7 @@ static const struct UVC_FRAME_MJPEG(1) uvc_frame_mjpg_720p = {
 static const struct uvc_color_matching_descriptor uvc_color_matching = {
 	.bLength		= UVC_DT_COLOR_MATCHING_SIZE,
 	.bDescriptorType	= USB_DT_CS_INTERFACE,
-	.bDescriptorSubType	= UVC_DT_COLOR_MATCHING,
+	.bDescriptorSubType	= UVC_VS_COLORFORMAT,
 	.bColorPrimaries	= 1,
 	.bTransferCharacteristics	= 1,
 	.bMatrixCoefficients	= 4,
diff --git a/include/linux/usb/video.h b/include/linux/usb/video.h
index 2d5b7fc..3b3b95e 100644
--- a/include/linux/usb/video.h
+++ b/include/linux/usb/video.h
@@ -160,6 +160,16 @@
 #define UVC_STATUS_TYPE_CONTROL				1
 #define UVC_STATUS_TYPE_STREAMING			2
 
+/* 2.4.3.3. Payload Header Information */
+#define UVC_STREAM_EOH					(1 << 7)
+#define UVC_STREAM_ERR					(1 << 6)
+#define UVC_STREAM_STI					(1 << 5)
+#define UVC_STREAM_RES					(1 << 4)
+#define UVC_STREAM_SCR					(1 << 3)
+#define UVC_STREAM_PTS					(1 << 2)
+#define UVC_STREAM_EOF					(1 << 1)
+#define UVC_STREAM_FID					(1 << 0)
+
 /* 4.1.2. Control Capabilities */
 #define UVC_CONTROL_CAP_GET				(1 << 0)
 #define UVC_CONTROL_CAP_SET				(1 << 1)
@@ -167,5 +177,392 @@
 #define UVC_CONTROL_CAP_AUTOUPDATE			(1 << 3)
 #define UVC_CONTROL_CAP_ASYNCHRONOUS			(1 << 4)
 
+/* ------------------------------------------------------------------------
+ * UVC structures
+ */
+
+/* All UVC descriptors have these 3 fields at the beginning */
+struct uvc_descriptor_header {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+} __attribute__((packed));
+
+/* 3.7.2. Video Control Interface Header Descriptor */
+struct uvc_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u16 bcdUVC;
+	__u16 wTotalLength;
+	__u32 dwClockFrequency;
+	__u8  bInCollection;
+	__u8  baInterfaceNr[];
+} __attribute__((__packed__));
+
+#define UVC_DT_HEADER_SIZE(n)				(12+(n))
+
+#define UVC_HEADER_DESCRIPTOR(n) \
+	uvc_header_descriptor_##n
+
+#define DECLARE_UVC_HEADER_DESCRIPTOR(n)		\
+struct UVC_HEADER_DESCRIPTOR(n) {			\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u16 bcdUVC;					\
+	__u16 wTotalLength;				\
+	__u32 dwClockFrequency;				\
+	__u8  bInCollection;				\
+	__u8  baInterfaceNr[n];				\
+} __attribute__ ((packed))
+
+/* 3.7.2.1. Input Terminal Descriptor */
+struct uvc_input_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  iTerminal;
+} __attribute__((__packed__));
+
+#define UVC_DT_INPUT_TERMINAL_SIZE			8
+
+/* 3.7.2.2. Output Terminal Descriptor */
+struct uvc_output_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  bSourceID;
+	__u8  iTerminal;
+} __attribute__((__packed__));
+
+#define UVC_DT_OUTPUT_TERMINAL_SIZE			9
+
+/* 3.7.2.3. Camera Terminal Descriptor */
+struct uvc_camera_terminal_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bTerminalID;
+	__u16 wTerminalType;
+	__u8  bAssocTerminal;
+	__u8  iTerminal;
+	__u16 wObjectiveFocalLengthMin;
+	__u16 wObjectiveFocalLengthMax;
+	__u16 wOcularFocalLength;
+	__u8  bControlSize;
+	__u8  bmControls[3];
+} __attribute__((__packed__));
+
+#define UVC_DT_CAMERA_TERMINAL_SIZE(n)			(15+(n))
+
+/* 3.7.2.4. Selector Unit Descriptor */
+struct uvc_selector_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  bNrInPins;
+	__u8  baSourceID[0];
+	__u8  iSelector;
+} __attribute__((__packed__));
+
+#define UVC_DT_SELECTOR_UNIT_SIZE(n)			(6+(n))
+
+#define UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
+	uvc_selector_unit_descriptor_##n
+
+#define DECLARE_UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
+struct UVC_SELECTOR_UNIT_DESCRIPTOR(n) {		\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bUnitID;					\
+	__u8  bNrInPins;				\
+	__u8  baSourceID[n];				\
+	__u8  iSelector;				\
+} __attribute__ ((packed))
+
+/* 3.7.2.5. Processing Unit Descriptor */
+struct uvc_processing_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  bSourceID;
+	__u16 wMaxMultiplier;
+	__u8  bControlSize;
+	__u8  bmControls[2];
+	__u8  iProcessing;
+} __attribute__((__packed__));
+
+#define UVC_DT_PROCESSING_UNIT_SIZE(n)			(9+(n))
+
+/* 3.7.2.6. Extension Unit Descriptor */
+struct uvc_extension_unit_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bUnitID;
+	__u8  guidExtensionCode[16];
+	__u8  bNumControls;
+	__u8  bNrInPins;
+	__u8  baSourceID[0];
+	__u8  bControlSize;
+	__u8  bmControls[0];
+	__u8  iExtension;
+} __attribute__((__packed__));
+
+#define UVC_DT_EXTENSION_UNIT_SIZE(p, n)		(24+(p)+(n))
+
+#define UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) \
+	uvc_extension_unit_descriptor_##p_##n
+
+#define DECLARE_UVC_EXTENSION_UNIT_DESCRIPTOR(p, n)	\
+struct UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) {		\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bUnitID;					\
+	__u8  guidExtensionCode[16];			\
+	__u8  bNumControls;				\
+	__u8  bNrInPins;				\
+	__u8  baSourceID[p];				\
+	__u8  bControlSize;				\
+	__u8  bmControls[n];				\
+	__u8  iExtension;				\
+} __attribute__ ((packed))
+
+/* 3.8.2.2. Video Control Interrupt Endpoint Descriptor */
+struct uvc_control_endpoint_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u16 wMaxTransferSize;
+} __attribute__((__packed__));
+
+#define UVC_DT_CONTROL_ENDPOINT_SIZE			5
+
+/* 3.9.2.1. Input Header Descriptor */
+struct uvc_input_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bNumFormats;
+	__u16 wTotalLength;
+	__u8  bEndpointAddress;
+	__u8  bmInfo;
+	__u8  bTerminalLink;
+	__u8  bStillCaptureMethod;
+	__u8  bTriggerSupport;
+	__u8  bTriggerUsage;
+	__u8  bControlSize;
+	__u8  bmaControls[];
+} __attribute__((__packed__));
+
+#define UVC_DT_INPUT_HEADER_SIZE(n, p)			(13+(n*p))
+
+#define UVC_INPUT_HEADER_DESCRIPTOR(n, p) \
+	uvc_input_header_descriptor_##n_##p
+
+#define DECLARE_UVC_INPUT_HEADER_DESCRIPTOR(n, p)	\
+struct UVC_INPUT_HEADER_DESCRIPTOR(n, p) {		\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bNumFormats;				\
+	__u16 wTotalLength;				\
+	__u8  bEndpointAddress;				\
+	__u8  bmInfo;					\
+	__u8  bTerminalLink;				\
+	__u8  bStillCaptureMethod;			\
+	__u8  bTriggerSupport;				\
+	__u8  bTriggerUsage;				\
+	__u8  bControlSize;				\
+	__u8  bmaControls[p][n];			\
+} __attribute__ ((packed))
+
+/* 3.9.2.2. Output Header Descriptor */
+struct uvc_output_header_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bNumFormats;
+	__u16 wTotalLength;
+	__u8  bEndpointAddress;
+	__u8  bTerminalLink;
+	__u8  bControlSize;
+	__u8  bmaControls[];
+} __attribute__((__packed__));
+
+#define UVC_DT_OUTPUT_HEADER_SIZE(n, p)			(9+(n*p))
+
+#define UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) \
+	uvc_output_header_descriptor_##n_##p
+
+#define DECLARE_UVC_OUTPUT_HEADER_DESCRIPTOR(n, p)	\
+struct UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) {		\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bNumFormats;				\
+	__u16 wTotalLength;				\
+	__u8  bEndpointAddress;				\
+	__u8  bTerminalLink;				\
+	__u8  bControlSize;				\
+	__u8  bmaControls[p][n];			\
+} __attribute__ ((packed))
+
+/* 3.9.2.6. Color matching descriptor */
+struct uvc_color_matching_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bColorPrimaries;
+	__u8  bTransferCharacteristics;
+	__u8  bMatrixCoefficients;
+} __attribute__((__packed__));
+
+#define UVC_DT_COLOR_MATCHING_SIZE			6
+
+/* 4.3.1.1. Video Probe and Commit Controls */
+struct uvc_streaming_control {
+	__u16 bmHint;
+	__u8  bFormatIndex;
+	__u8  bFrameIndex;
+	__u32 dwFrameInterval;
+	__u16 wKeyFrameRate;
+	__u16 wPFrameRate;
+	__u16 wCompQuality;
+	__u16 wCompWindowSize;
+	__u16 wDelay;
+	__u32 dwMaxVideoFrameSize;
+	__u32 dwMaxPayloadTransferSize;
+	__u32 dwClockFrequency;
+	__u8  bmFramingInfo;
+	__u8  bPreferedVersion;
+	__u8  bMinVersion;
+	__u8  bMaxVersion;
+} __attribute__((__packed__));
+
+/* Uncompressed Payload - 3.1.1. Uncompressed Video Format Descriptor */
+struct uvc_format_uncompressed {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFormatIndex;
+	__u8  bNumFrameDescriptors;
+	__u8  guidFormat[16];
+	__u8  bBitsPerPixel;
+	__u8  bDefaultFrameIndex;
+	__u8  bAspectRatioX;
+	__u8  bAspectRatioY;
+	__u8  bmInterfaceFlags;
+	__u8  bCopyProtect;
+} __attribute__((__packed__));
+
+#define UVC_DT_FORMAT_UNCOMPRESSED_SIZE			27
+
+/* Uncompressed Payload - 3.1.2. Uncompressed Video Frame Descriptor */
+struct uvc_frame_uncompressed {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFrameIndex;
+	__u8  bmCapabilities;
+	__u16 wWidth;
+	__u16 wHeight;
+	__u32 dwMinBitRate;
+	__u32 dwMaxBitRate;
+	__u32 dwMaxVideoFrameBufferSize;
+	__u32 dwDefaultFrameInterval;
+	__u8  bFrameIntervalType;
+	__u32 dwFrameInterval[];
+} __attribute__((__packed__));
+
+#define UVC_DT_FRAME_UNCOMPRESSED_SIZE(n)		(26+4*(n))
+
+#define UVC_FRAME_UNCOMPRESSED(n) \
+	uvc_frame_uncompressed_##n
+
+#define DECLARE_UVC_FRAME_UNCOMPRESSED(n)		\
+struct UVC_FRAME_UNCOMPRESSED(n) {			\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bFrameIndex;				\
+	__u8  bmCapabilities;				\
+	__u16 wWidth;					\
+	__u16 wHeight;					\
+	__u32 dwMinBitRate;				\
+	__u32 dwMaxBitRate;				\
+	__u32 dwMaxVideoFrameBufferSize;		\
+	__u32 dwDefaultFrameInterval;			\
+	__u8  bFrameIntervalType;			\
+	__u32 dwFrameInterval[n];			\
+} __attribute__ ((packed))
+
+/* MJPEG Payload - 3.1.1. MJPEG Video Format Descriptor */
+struct uvc_format_mjpeg {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFormatIndex;
+	__u8  bNumFrameDescriptors;
+	__u8  bmFlags;
+	__u8  bDefaultFrameIndex;
+	__u8  bAspectRatioX;
+	__u8  bAspectRatioY;
+	__u8  bmInterfaceFlags;
+	__u8  bCopyProtect;
+} __attribute__((__packed__));
+
+#define UVC_DT_FORMAT_MJPEG_SIZE			11
+
+/* MJPEG Payload - 3.1.2. MJPEG Video Frame Descriptor */
+struct uvc_frame_mjpeg {
+	__u8  bLength;
+	__u8  bDescriptorType;
+	__u8  bDescriptorSubType;
+	__u8  bFrameIndex;
+	__u8  bmCapabilities;
+	__u16 wWidth;
+	__u16 wHeight;
+	__u32 dwMinBitRate;
+	__u32 dwMaxBitRate;
+	__u32 dwMaxVideoFrameBufferSize;
+	__u32 dwDefaultFrameInterval;
+	__u8  bFrameIntervalType;
+	__u32 dwFrameInterval[];
+} __attribute__((__packed__));
+
+#define UVC_DT_FRAME_MJPEG_SIZE(n)			(26+4*(n))
+
+#define UVC_FRAME_MJPEG(n) \
+	uvc_frame_mjpeg_##n
+
+#define DECLARE_UVC_FRAME_MJPEG(n)			\
+struct UVC_FRAME_MJPEG(n) {				\
+	__u8  bLength;					\
+	__u8  bDescriptorType;				\
+	__u8  bDescriptorSubType;			\
+	__u8  bFrameIndex;				\
+	__u8  bmCapabilities;				\
+	__u16 wWidth;					\
+	__u16 wHeight;					\
+	__u32 dwMinBitRate;				\
+	__u32 dwMaxBitRate;				\
+	__u32 dwMaxVideoFrameBufferSize;		\
+	__u32 dwDefaultFrameInterval;			\
+	__u8  bFrameIntervalType;			\
+	__u32 dwFrameInterval[n];			\
+} __attribute__ ((packed))
+
 #endif /* __LINUX_USB_VIDEO_H */
 
-- 
1.7.1

