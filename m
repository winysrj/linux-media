Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3356 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaIUOss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/11] v4l2-ctrls: add multi-selection controls
Date: Sun, 21 Sep 2014 16:48:28 +0200
Message-Id: <1411310909-32825-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 24 ++++++++++++++++++++++++
 include/uapi/linux/v4l2-controls.h   |  7 ++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 21560b0..af76bda 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -643,6 +643,10 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Min Number of Output Buffers";
 	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
 	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
+	case V4L2_CID_CAPTURE_CROP:		return "Capture Crop Selections";
+	case V4L2_CID_CAPTURE_COMPOSE:		return "Capture Compose Selections";
+	case V4L2_CID_OUTPUT_CROP:		return "Output Crop Selections";
+	case V4L2_CID_OUTPUT_COMPOSE:		return "Output Compose Selections";
 
 	/* Codec controls */
 	/* The MPEG controls are applicable to all codec controls
@@ -1122,6 +1126,13 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_CAPTURE_CROP:
+	case V4L2_CID_CAPTURE_COMPOSE:
+	case V4L2_CID_OUTPUT_CROP:
+	case V4L2_CID_OUTPUT_COMPOSE:
+		*type = V4L2_CTRL_TYPE_SELECTION;
+		*min = *max = *step = *def = 0;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1336,6 +1347,12 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	case V4L2_CTRL_TYPE_U32:
 		pr_cont("%u", (unsigned)*ptr.p_u32);
 		break;
+	case V4L2_CTRL_TYPE_SELECTION:
+		pr_cont("%ux%u@%dx%d (0x%x)",
+			ptr.p_sel->r.width, ptr.p_sel->r.height,
+			ptr.p_sel->r.left, ptr.p_sel->r.top,
+			ptr.p_sel->flags);
+		break;
 	default:
 		pr_cont("unknown type %d", ctrl->type);
 		break;
@@ -1429,6 +1446,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	case V4L2_CTRL_TYPE_SELECTION:
+		/* TODO: check for valid rectangle */
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -1998,6 +2019,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_SELECTION:
+		elem_size = sizeof(struct v4l2_ctrl_selection);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 8b93021..1c2fbf3 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -140,8 +140,13 @@ enum v4l2_colorfx {
 #define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
 #define V4L2_CID_COLORFX_CBCR			(V4L2_CID_BASE+42)
 
+#define V4L2_CID_CAPTURE_CROP			(V4L2_CID_BASE+43)
+#define V4L2_CID_CAPTURE_COMPOSE		(V4L2_CID_BASE+44)
+#define V4L2_CID_OUTPUT_CROP			(V4L2_CID_BASE+45)
+#define V4L2_CID_OUTPUT_COMPOSE			(V4L2_CID_BASE+46)
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+47)
 
 /* USER-class private control IDs */
 
-- 
2.1.0

