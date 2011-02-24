Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:59577 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1BXKzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 05:55:44 -0500
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH400GTYBGRNJB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 19:50:51 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH400MU2BGSZU@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Feb 2011 19:50:52 +0900 (KST)
Date: Thu, 24 Feb 2011 19:50:51 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC PATCH 2/2] v4l2-ctrls: modify uvc driver to use new menu type of
 V4L2_CID_FOCUS_AUTO
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D66380B.7000101@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

The place using V4L2_CID_FOCUS_AUTO is one, in only this uvc driver here.
So, only this driver affects the changes of V4L2_CID_FOCUS_AUTO type changes.

---
 drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 59f8a9a..795fd3f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] = {
 	{ 8, "Aperture Priority Mode" },
 };
 
+static struct uvc_menu_info focus_auto_controls[] = {
+	{ 2, "Auto Mode" },
+	{ 1, "Manual Mode" },
+};
+
 static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
 	__u8 query, const __u8 *data)
 {
@@ -558,10 +563,12 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.name		= "Focus, Auto",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
-		.size		= 1,
+		.size		= 2,
 		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
-		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
+		.menu_info	= focus_auto_controls,
+		.menu_count	= ARRAY_SIZE(focus_auto_controls),
 	},
 	{
 		.id		= V4L2_CID_IRIS_ABSOLUTE,
-- 
1.7.0.4
