Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2DHP5z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:55 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 08/10] uvcvideo: Properly report the inactive flag for inactive controls
Date: Sun,  8 Apr 2012 17:59:52 +0200
Message-Id: <1333900794-1932-9-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note the unused in this patch slave_ids addition to the mappings will get
used in a follow up patch to generate control change events for the slave
ctrls when their flags change due to the master control changing value.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   33 +++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h |    4 ++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index bc837a4..75a4995 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -421,6 +421,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+		.master_id	= V4L2_CID_HUE_AUTO,
+		.master_manual	= 0,
 	},
 	{
 		.id		= V4L2_CID_SATURATION,
@@ -493,6 +495,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.slave_ids	= { V4L2_CID_HUE, },
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO,
@@ -505,6 +508,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
 		.menu_info	= exposure_auto_controls,
 		.menu_count	= ARRAY_SIZE(exposure_auto_controls),
+		.slave_ids	= { V4L2_CID_EXPOSURE_ABSOLUTE, },
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO_PRIORITY,
@@ -525,6 +529,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+		.master_id	= V4L2_CID_EXPOSURE_AUTO,
+		.master_manual	= V4L2_EXPOSURE_MANUAL,
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
@@ -535,6 +541,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.slave_ids	= { V4L2_CID_WHITE_BALANCE_TEMPERATURE, },
 	},
 	{
 		.id		= V4L2_CID_WHITE_BALANCE_TEMPERATURE,
@@ -545,6 +552,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+		.master_id	= V4L2_CID_AUTO_WHITE_BALANCE,
+		.master_manual	= 0,
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
@@ -555,6 +564,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.slave_ids	= { V4L2_CID_BLUE_BALANCE,
+				    V4L2_CID_RED_BALANCE },
 	},
 	{
 		.id		= V4L2_CID_BLUE_BALANCE,
@@ -565,6 +576,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+		.master_id	= V4L2_CID_AUTO_WHITE_BALANCE,
+		.master_manual	= 0,
 	},
 	{
 		.id		= V4L2_CID_RED_BALANCE,
@@ -575,6 +588,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 16,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+		.master_id	= V4L2_CID_AUTO_WHITE_BALANCE,
+		.master_manual	= 0,
 	},
 	{
 		.id		= V4L2_CID_FOCUS_ABSOLUTE,
@@ -585,6 +600,8 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
 		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+		.master_id	= V4L2_CID_FOCUS_AUTO,
+		.master_manual	= 0,
 	},
 	{
 		.id		= V4L2_CID_FOCUS_AUTO,
@@ -595,6 +612,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.offset		= 0,
 		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
+		.slave_ids	= { V4L2_CID_FOCUS_ABSOLUTE, },
 	},
 	{
 		.id		= V4L2_CID_IRIS_ABSOLUTE,
@@ -943,6 +961,8 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct uvc_control_mapping *mapping,
 	struct v4l2_queryctrl *v4l2_ctrl)
 {
+	struct uvc_control_mapping *master_map = NULL;
+	struct uvc_control *master_ctrl = NULL;
 	struct uvc_menu_info *menu;
 	unsigned int i;
 
@@ -957,6 +977,19 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
+	if (mapping->master_id)
+		__uvc_find_control(ctrl->entity, mapping->master_id,
+				   &master_map, &master_ctrl, 0);
+	if (master_ctrl && (master_ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR)) {
+		s32 val;
+		int ret = __uvc_ctrl_get(chain, master_ctrl, master_map, &val);
+		if (ret < 0)
+			return ret;
+
+		if (val != mapping->master_manual)
+				v4l2_ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+	}
+
 	if (!ctrl->cached) {
 		int ret = uvc_ctrl_populate_cache(chain, ctrl);
 		if (ret < 0)
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index e43deb7..777bb75 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -172,6 +172,10 @@ struct uvc_control_mapping {
 	struct uvc_menu_info *menu_info;
 	__u32 menu_count;
 
+	__u32 master_id;
+	__s32 master_manual;
+	__u32 slave_ids[2];
+
 	__s32 (*get) (struct uvc_control_mapping *mapping, __u8 query,
 		      const __u8 *data);
 	void (*set) (struct uvc_control_mapping *mapping, __s32 value,
-- 
1.7.9.3

