Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41985 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbaFQOqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 10:46:04 -0400
Received: by mail-yh0-f74.google.com with SMTP id b6so1037990yha.1
        for <linux-media@vger.kernel.org>; Tue, 17 Jun 2014 07:46:03 -0700 (PDT)
From: Vincent Palatin <vpalatin@chromium.org>
To: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Zach Kuznia <zork@chromium.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH v2] V4L: uvcvideo: Add support for relative pan/tilt controls
Date: Tue, 17 Jun 2014 07:45:48 -0700
Message-Id: <1403016348-10129-1-git-send-email-vpalatin@chromium.org>
In-Reply-To: <539FDC4F.4030000@redhat.com>
References: <539FDC4F.4030000@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Map V4L2_CID_TILT_RELATIVE and V4L2_CID_PAN_RELATIVE to the standard UVC
CT_PANTILT_RELATIVE_CONTROL terminal control request.

Tested by plugging a Logitech ConferenceCam C3000e USB camera
and controlling pan/tilt from the userspace using the VIDIOC_S_CTRL ioctl.
Verified that it can pan and tilt at the same time in both directions.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>

Change-Id: I7b70b228e5c0126683f5f0be34ffd2807f5783dc
---

Changes
v2: fix control request name in description.

 drivers/media/usb/uvc/uvc_ctrl.c | 58 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 0eb82106..af18120 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -309,9 +309,8 @@ static struct uvc_control_info uvc_ctrls[] = {
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.index		= 12,
 		.size		= 4,
-		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
-				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
-				| UVC_CTRL_FLAG_GET_DEF
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
 				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
@@ -391,6 +390,35 @@ static void uvc_ctrl_set_zoom(struct uvc_control_mapping *mapping,
 	data[2] = min((int)abs(value), 0xff);
 }
 
+static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
+	__u8 query, const __u8 *data)
+{
+	int first = mapping->offset / 8;
+	__s8 rel = (__s8)data[first];
+
+	switch (query) {
+	case UVC_GET_CUR:
+		return (rel == 0) ? 0 : (rel > 0 ? data[first+1]
+						 : -data[first+1]);
+	case UVC_GET_MIN:
+		return -data[first+1];
+	case UVC_GET_MAX:
+	case UVC_GET_RES:
+	case UVC_GET_DEF:
+	default:
+		return data[first+1];
+	}
+}
+
+static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
+	__s32 value, __u8 *data)
+{
+	int first = mapping->offset / 8;
+
+	data[first] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
+	data[first+1] = min_t(int, abs(value), 0xff);
+}
+
 static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	{
 		.id		= V4L2_CID_BRIGHTNESS,
@@ -677,6 +705,30 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
 	},
 	{
+		.id		= V4L2_CID_PAN_RELATIVE,
+		.name		= "Pan (Relative)",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+		.get		= uvc_ctrl_get_rel_speed,
+		.set		= uvc_ctrl_set_rel_speed,
+	},
+	{
+		.id		= V4L2_CID_TILT_RELATIVE,
+		.name		= "Tilt (Relative)",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
+		.size		= 16,
+		.offset		= 16,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+		.get		= uvc_ctrl_get_rel_speed,
+		.set		= uvc_ctrl_set_rel_speed,
+	},
+	{
 		.id		= V4L2_CID_PRIVACY,
 		.name		= "Privacy",
 		.entity		= UVC_GUID_UVC_CAMERA,
-- 
2.0.0.526.g5318336

