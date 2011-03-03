Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:48596 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab1CCCQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 21:16:57 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHG002XBMBKWC50@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Mar 2011 11:16:32 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHG0069LMBLDE@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Mar 2011 11:16:33 +0900 (KST)
Date: Thu, 03 Mar 2011 11:16:32 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use new
 menu type of V4L2_CID_FOCUS_AUTO
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"???/Mobile S/W Platform Lab(DMC?)/E4(??)/????"
	<sw0312.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D6EFA00.80009@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
this uvc is modified the usage of V4L2_CID_FOCUS_AUTO, maintaining v4l2 menu
index.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 59f8a9a..064827f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] = {
 	{ 8, "Aperture Priority Mode" },
 };
 
+static struct uvc_menu_info focus_auto_controls[] = {
+	{ 0, "Manual Mode" },
+	{ 1, "Auto Mode" },
+};
+
 static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
 	__u8 query, const __u8 *data)
 {
@@ -560,8 +565,10 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
 		.size		= 1,
 		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.menu_info	= focus_auto_controls,
+		.menu_count	= ARRAY_SIZE(focus_auto_controls),
 	},
 	{
 		.id		= V4L2_CID_IRIS_ABSOLUTE,
-- 
1.7.0.4
