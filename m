Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MDG15c018850
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 09:16:01 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MDEqFd014377
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 09:14:53 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Mon, 22 Sep 2008 15:14:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221514.59977.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Declare missing camera and processing unit
	controls.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This declares all missing UVC camera and processing unit controls. V4L2
mappings are not supported yet for those controls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_ctrl.c |  164 +++++++++++++++++++++++++++++++----
 1 files changed, 145 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 6ef3e52..6da37cd 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -83,6 +83,22 @@ static struct uvc_control_info uvc_ctrls[] = {
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
+		.index		= 6,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_CONTROL,
+		.index		= 7,
+		.size		= 4,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= PU_BACKLIGHT_COMPENSATION_CONTROL,
 		.index		= 8,
 		.size		= 2,
@@ -114,6 +130,60 @@ static struct uvc_control_info uvc_ctrls[] = {
 				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
 	},
 	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
+		.index		= 12,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
+		.index		= 13,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_DIGITAL_MULTIPLIER_CONTROL,
+		.index		= 14,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_DIGITAL_MULTIPLIER_LIMIT_CONTROL,
+		.index		= 15,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_ANALOG_VIDEO_STANDARD_CONTROL,
+		.index		= 16,
+		.size		= 1,
+		.flags		= UVC_CONTROL_GET_CUR,
+	},
+	{
+		.entity		= UVC_GUID_UVC_PROCESSING,
+		.selector	= PU_ANALOG_LOCK_STATUS_CONTROL,
+		.index		= 17,
+		.size		= 1,
+		.flags		= UVC_CONTROL_GET_CUR,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_SCANNING_MODE_CONTROL,
+		.index		= 0,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_RESTORE,
+	},
+	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= CT_AE_MODE_CONTROL,
 		.index		= 1,
@@ -140,6 +210,14 @@ static struct uvc_control_info uvc_ctrls[] = {
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_EXPOSURE_TIME_RELATIVE_CONTROL,
+		.index		= 4,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
+				| UVC_CONTROL_RESTORE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= CT_FOCUS_ABSOLUTE_CONTROL,
 		.index		= 5,
 		.size		= 2,
@@ -148,42 +226,90 @@ static struct uvc_control_info uvc_ctrls[] = {
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
-		.selector	= CT_FOCUS_AUTO_CONTROL,
-		.index		= 17,
-		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.selector	= CT_FOCUS_RELATIVE_CONTROL,
+		.index		= 6,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_AUTO_UPDATE,
 	},
 	{
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
-		.index		= 12,
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_IRIS_ABSOLUTE_CONTROL,
+		.index		= 7,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_IRIS_RELATIVE_CONTROL,
+		.index		= 8,
 		.size		= 1,
 		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+				| UVC_CONTROL_AUTO_UPDATE,
 	},
 	{
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
-		.index		= 6,
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_ZOOM_ABSOLUTE_CONTROL,
+		.index		= 9,
 		.size		= 2,
 		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
 				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
 	},
 	{
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_ZOOM_RELATIVE_CONTROL,
+		.index		= 10,
+		.size		= 3,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_PANTILT_ABSOLUTE_CONTROL,
+		.index		= 11,
+		.size		= 8,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_PANTILT_RELATIVE_CONTROL,
+		.index		= 12,
+		.size		= 4,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_ROLL_ABSOLUTE_CONTROL,
 		.index		= 13,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_ROLL_RELATIVE_CONTROL,
+		.index		= 14,
+		.size		= 2,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+				| UVC_CONTROL_AUTO_UPDATE,
+	},
+	{
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_FOCUS_AUTO_CONTROL,
+		.index		= 17,
 		.size		= 1,
 		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
 				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
 	},
 	{
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= PU_WHITE_BALANCE_COMPONENT_CONTROL,
-		.index		= 7,
-		.size		= 4,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= CT_PRIVACY_CONTROL,
+		.index		= 18,
+		.size		= 1,
+		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
 				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
 	},
 };
-- 
1.5.6.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
