Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54768 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaKWMk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:40:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] v4l2-common: move v4l2_ctrl_check to cx2341x
Date: Sun, 23 Nov 2014 13:39:55 +0100
Message-Id: <1416746395-48631-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
References: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_ctrl_check() helper function is now only used in cx2341x.
Move it there and make it static.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/cx2341x.c        | 29 +++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-common.c | 30 ------------------------------
 include/media/v4l2-common.h           |  4 +---
 3 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index be76315..c07b9db 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -931,6 +931,35 @@ static void cx2341x_calc_audio_properties(struct cx2341x_mpeg_params *params)
 	}
 }
 
+/* Check for correctness of the ctrl's value based on the data from
+   struct v4l2_queryctrl and the available menu items. Note that
+   menu_items may be NULL, in that case it is ignored. */
+static int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
+		const char * const *menu_items)
+{
+	if (qctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+		return -EINVAL;
+	if (qctrl->flags & V4L2_CTRL_FLAG_GRABBED)
+		return -EBUSY;
+	if (qctrl->type == V4L2_CTRL_TYPE_STRING)
+		return 0;
+	if (qctrl->type == V4L2_CTRL_TYPE_BUTTON ||
+	    qctrl->type == V4L2_CTRL_TYPE_INTEGER64 ||
+	    qctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return 0;
+	if (ctrl->value < qctrl->minimum || ctrl->value > qctrl->maximum)
+		return -ERANGE;
+	if (qctrl->type == V4L2_CTRL_TYPE_MENU && menu_items != NULL) {
+		if (menu_items[ctrl->value] == NULL ||
+		    menu_items[ctrl->value][0] == '\0')
+			return -EINVAL;
+	}
+	if (qctrl->type == V4L2_CTRL_TYPE_BITMASK &&
+			(ctrl->value & ~qctrl->maximum))
+		return -ERANGE;
+	return 0;
+}
+
 int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
 		  struct v4l2_ext_controls *ctrls, unsigned int cmd)
 {
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 8493209..5b80850 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -80,36 +80,6 @@ MODULE_LICENSE("GPL");
 
 /* Helper functions for control handling			     */
 
-/* Check for correctness of the ctrl's value based on the data from
-   struct v4l2_queryctrl and the available menu items. Note that
-   menu_items may be NULL, in that case it is ignored. */
-int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
-		const char * const *menu_items)
-{
-	if (qctrl->flags & V4L2_CTRL_FLAG_DISABLED)
-		return -EINVAL;
-	if (qctrl->flags & V4L2_CTRL_FLAG_GRABBED)
-		return -EBUSY;
-	if (qctrl->type == V4L2_CTRL_TYPE_STRING)
-		return 0;
-	if (qctrl->type == V4L2_CTRL_TYPE_BUTTON ||
-	    qctrl->type == V4L2_CTRL_TYPE_INTEGER64 ||
-	    qctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
-		return 0;
-	if (ctrl->value < qctrl->minimum || ctrl->value > qctrl->maximum)
-		return -ERANGE;
-	if (qctrl->type == V4L2_CTRL_TYPE_MENU && menu_items != NULL) {
-		if (menu_items[ctrl->value] == NULL ||
-		    menu_items[ctrl->value][0] == '\0')
-			return -EINVAL;
-	}
-	if (qctrl->type == V4L2_CTRL_TYPE_BITMASK &&
-			(ctrl->value & ~qctrl->maximum))
-		return -ERANGE;
-	return 0;
-}
-EXPORT_SYMBOL(v4l2_ctrl_check);
-
 /* Fill in a struct v4l2_queryctrl */
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 _min, s32 _max, s32 _step, s32 _def)
 {
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index c69d91d..1cc0c5b 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -80,10 +80,8 @@
 
 /* ------------------------------------------------------------------------- */
 
-/* Control helper functions */
+/* Control helper function */
 
-int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
-		const char * const *menu_items);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 
 /* ------------------------------------------------------------------------- */
-- 
2.1.3

