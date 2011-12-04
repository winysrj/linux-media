Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35399 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1LDPQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2011 10:16:42 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so5379144wgb.1
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2011 07:16:42 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RFC/PATCH 2/5] uvc: Adapt the driver to new type of V4L2_CID_FOCUS_AUTO control
Date: Sun,  4 Dec 2011 16:16:13 +0100
Message-Id: <1323011776-15967-3-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Heungjun Kim <riverful.kim@samsung.com>

The V4L2_CID_FOCUS_AUTO control has been converted from boolean type,
where control's value 0 and 1 were corresponding to manual and automatic
focus respectively, to menu type with following menu items:
  0 - V4L2_FOCUS_MANUAL,
  1 - V4L2_FOCUS_AUTO,
  2 - V4L2_FOCUS_AUTO_MACRO,
  3 - V4L2_FOCUS_AUTO_CONTINUOUS.

According to this change the uvc control mappings are modified to retain
original sematics, where 0 corresponds to manual and 1 to auto focus.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

---
The V4L2_CID_FOCUS_AUTO control in V4L2_FOCUS_AUTO mode does only
a one-shot auto focus, when switched from V4L2_FOCUS_MANUAL.
It might be worth to implement also the V4L2_CID_DO_AUTO_FOCUS button
control in uvc, however I didn't take time yet to better understand
the driver and add this. I also don't have any uvc hardware to test
this patch so it's just compile tested.
---
 drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 254d326..6860ca1 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -365,6 +365,11 @@ static struct uvc_menu_info exposure_auto_controls[] = {
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
@@ -592,8 +597,10 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
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
1.7.4.1

