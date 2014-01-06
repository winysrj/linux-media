Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4165 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaAFOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 25/27] v4l2-ctrls: add support for u8, u16 and prop_selection types.
Date: Mon,  6 Jan 2014 15:21:24 +0100
Message-Id: <1389018086-15903-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 30 ++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2191451..6c7640b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1165,6 +1165,10 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		return !strcmp(ptr1.p_char + idx, ptr2.p_char + idx);
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ptr1.p_s64[idx] == ptr2.p_s64[idx];
+	case V4L2_PROP_TYPE_U8:
+		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
+	case V4L2_PROP_TYPE_U16:
+		return ptr1.p_u16[idx] == ptr2.p_u16[idx];
 	default:
 		if (ctrl->is_int)
 			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
@@ -1192,6 +1196,12 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = ctrl->default_value;
 		break;
+	case V4L2_PROP_TYPE_U8:
+		ptr.p_u8[idx] = ctrl->default_value;
+		break;
+	case V4L2_PROP_TYPE_U16:
+		ptr.p_u16[idx] = ctrl->default_value;
+		break;
 	default:
 		idx *= ctrl->elem_size;
 		memset(ptr.p + idx, 0, ctrl->elem_size);
@@ -1228,6 +1238,18 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_STRING:
 		pr_cont("%s", ptr.p_char);
 		break;
+	case V4L2_PROP_TYPE_U8:
+		pr_cont("%u", (unsigned)*ptr.p_u8);
+		break;
+	case V4L2_PROP_TYPE_U16:
+		pr_cont("%u", (unsigned)*ptr.p_u16);
+		break;
+	case V4L2_PROP_TYPE_SELECTION:
+		pr_cont("%ux%u@%dx%d (0x%x)",
+			ptr.p_sel->r.width, ptr.p_sel->r.height,
+			ptr.p_sel->r.left, ptr.p_sel->r.top,
+			ptr.p_sel->flags);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1258,6 +1280,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
+	case V4L2_PROP_TYPE_U8:
+		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
+	case V4L2_PROP_TYPE_U16:
+		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		ptr.p_s32[idx] = !!ptr.p_s32[idx];
@@ -1504,6 +1530,8 @@ static int check_range(enum v4l2_ctrl_type type,
 		if (step != 1 || max > 1 || min < 0)
 			return -ERANGE;
 		/* fall through */
+	case V4L2_PROP_TYPE_U8:
+	case V4L2_PROP_TYPE_U16:
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_INTEGER64:
 		if (step == 0 || min > max || def < min || def > max)
@@ -3259,6 +3287,8 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
+	case V4L2_PROP_TYPE_U8:
+	case V4L2_PROP_TYPE_U16:
 		if (ctrl->is_matrix)
 			return -EINVAL;
 		ret = check_range(ctrl->type, min, max, step, def);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 514c427..09257e4 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -45,7 +45,10 @@ struct poll_table_struct;
 union v4l2_ctrl_ptr {
 	s32 *p_s32;
 	s64 *p_s64;
+	u8 *p_u8;
+	u16 *p_u16;
 	char *p_char;
+	struct v4l2_prop_selection *p_sel;
 	void *p;
 };
 
-- 
1.8.5.2

