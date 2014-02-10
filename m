Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3856 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJIsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:48:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 15/34] v4l2-ctrls: type_ops can handle matrix elements.
Date: Mon, 10 Feb 2014 09:46:40 +0100
Message-Id: <1392022019-5519-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Extend the control type operations to handle matrix elements.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 40 ++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 16c29e1..a61e602 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1140,14 +1140,16 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_BUTTON:
 		return false;
 	case V4L2_CTRL_TYPE_STRING:
+		idx *= ctrl->elem_size;
 		/* strings are always 0-terminated */
-		return !strcmp(ptr1.p_char, ptr2.p_char);
+		return !strcmp(ptr1.p_char + idx, ptr2.p_char + idx);
 	case V4L2_CTRL_TYPE_INTEGER64:
-		return *ptr1.p_s64 == *ptr2.p_s64;
+		return ptr1.p_s64[idx] == ptr2.p_s64[idx];
 	default:
-		if (ctrl->is_ptr)
-			return !memcmp(ptr1.p, ptr2.p, ctrl->elem_size);
-		return *ptr1.p_s32 == *ptr2.p_s32;
+		if (ctrl->is_int)
+			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
+		idx *= ctrl->elem_size;
+		return !memcmp(ptr1.p + idx, ptr2.p + idx, ctrl->elem_size);
 	}
 }
 
@@ -1156,18 +1158,19 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 {
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
-		memset(ptr.p_char, ' ', ctrl->minimum);
-		ptr.p_char[ctrl->minimum] = '\0';
+		idx *= ctrl->elem_size;
+		memset(ptr.p_char + idx, ' ', ctrl->minimum);
+		ptr.p_char[idx + ctrl->minimum] = '\0';
 		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
-		*ptr.p_s64 = ctrl->default_value;
+		ptr.p_s64[idx] = ctrl->default_value;
 		break;
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
 	case V4L2_CTRL_TYPE_BOOLEAN:
-		*ptr.p_s32 = ctrl->default_value;
+		ptr.p_s32[idx] = ctrl->default_value;
 		break;
 	default:
 		break;
@@ -1230,36 +1233,37 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
-		return ROUND_TO_RANGE(*ptr.p_s32, u32, ctrl);
+		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
-		return ROUND_TO_RANGE(*ptr.p_s64, u64, ctrl);
+		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
-		*ptr.p_s32 = !!*ptr.p_s32;
+		ptr.p_s32[idx] = !!ptr.p_s32[idx];
 		return 0;
 
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
-		if (*ptr.p_s32 < ctrl->minimum || *ptr.p_s32 > ctrl->maximum)
+		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1 << *ptr.p_s32))
+		if (ctrl->menu_skip_mask & (1 << ptr.p_s32[idx]))
 			return -EINVAL;
 		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
-		    ctrl->qmenu[*ptr.p_s32][0] == '\0')
+		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')
 			return -EINVAL;
 		return 0;
 
 	case V4L2_CTRL_TYPE_BITMASK:
-		*ptr.p_s32 &= ctrl->maximum;
+		ptr.p_s32[idx] &= ctrl->maximum;
 		return 0;
 
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
-		*ptr.p_s32 = 0;
+		ptr.p_s32[idx] = 0;
 		return 0;
 
 	case V4L2_CTRL_TYPE_STRING:
-		len = strlen(ptr.p_char);
+		idx *= ctrl->elem_size;
+		len = strlen(ptr.p_char + idx);
 		if (len < ctrl->minimum)
 			return -ERANGE;
 		if ((len - ctrl->minimum) % ctrl->step)
-- 
1.8.5.2

