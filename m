Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47088 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732201AbeHGBAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 21:00:12 -0400
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4A02557
        for <linux-media@vger.kernel.org>; Tue,  7 Aug 2018 00:48:56 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: uvcvideo: Make uvc_control_mapping menu_info field const
Date: Tue,  7 Aug 2018 01:49:34 +0300
Message-Id: <20180806224934.25292-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The menu_info field of the uvc_control_mapping structure points to an
array of menu info data that are never changed by the driver. Make the
pointer const and constify the related static arrays in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 10 +++++-----
 drivers/media/usb/uvc/uvcvideo.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 146e0ac09ba2..79fdb7ced565 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -354,13 +354,13 @@ static const struct uvc_control_info uvc_ctrls[] = {
 	},
 };
 
-static struct uvc_menu_info power_line_frequency_controls[] = {
+static const struct uvc_menu_info power_line_frequency_controls[] = {
 	{ 0, "Disabled" },
 	{ 1, "50 Hz" },
 	{ 2, "60 Hz" },
 };
 
-static struct uvc_menu_info exposure_auto_controls[] = {
+static const struct uvc_menu_info exposure_auto_controls[] = {
 	{ 2, "Auto Mode" },
 	{ 1, "Manual Mode" },
 	{ 4, "Shutter Priority Mode" },
@@ -978,7 +978,7 @@ static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
 	s32 value = mapping->get(mapping, UVC_GET_CUR, data);
 
 	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
-		struct uvc_menu_info *menu = mapping->menu_info;
+		const struct uvc_menu_info *menu = mapping->menu_info;
 		unsigned int i;
 
 		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
@@ -1025,7 +1025,7 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 {
 	struct uvc_control_mapping *master_map = NULL;
 	struct uvc_control *master_ctrl = NULL;
-	struct uvc_menu_info *menu;
+	const struct uvc_menu_info *menu;
 	unsigned int i;
 
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
@@ -1145,7 +1145,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 	struct v4l2_querymenu *query_menu)
 {
-	struct uvc_menu_info *menu_info;
+	const struct uvc_menu_info *menu_info;
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
 	u32 index = query_menu->index;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f7dcd3295a99..067cd5bb5a8a 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -234,7 +234,7 @@ struct uvc_control_mapping {
 	enum v4l2_ctrl_type v4l2_type;
 	u32 data_type;
 
-	struct uvc_menu_info *menu_info;
+	const struct uvc_menu_info *menu_info;
 	u32 menu_count;
 
 	u32 master_id;
-- 
Regards,

Laurent Pinchart
