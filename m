Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3FRMeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 08:34:25 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MOL000QS9L732Y0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 21:34:24 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 6/8] [media] V4L: Add support for integer menu controls with
 standard menu items
Date: Tue, 18 Jun 2013 18:26:21 +0530
Message-id: <1371560183-23244-7-git-send-email-arun.kk@samsung.com>
In-reply-to: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

The patch modifies the helper function v4l2_ctrl_new_std_menu
to accept integer menu controls with standard menu items.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 Documentation/video4linux/v4l2-controls.txt |   21 ++++++++++---------
 drivers/media/v4l2-core/v4l2-ctrls.c        |   29 ++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 676f873..e06e768 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -124,26 +124,27 @@ You add non-menu controls by calling v4l2_ctrl_new_std:
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 min, s32 max, u32 step, s32 def);
 
-Menu controls are added by calling v4l2_ctrl_new_std_menu:
+Menu and integer menu controls are added by calling v4l2_ctrl_new_std_menu:
 
 	struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 skip_mask, s32 def);
 
-Or alternatively for integer menu controls, by calling v4l2_ctrl_new_int_menu:
+Menu controls with a driver specific menu are added by calling
+v4l2_ctrl_new_std_menu_items:
+
+       struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(
+                       struct v4l2_ctrl_handler *hdl,
+                       const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
+                       s32 skip_mask, s32 def, const char * const *qmenu);
+
+Integer menu controls with driver specific menu can be added by calling
+v4l2_ctrl_new_int_menu:
 
 	struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 def, const s64 *qmenu_int);
 
-Standard menu controls with a driver specific menu are added by calling
-v4l2_ctrl_new_std_menu_items:
-
-	struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(
-		struct v4l2_ctrl_handler *hdl,
-		const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
-		s32 skip_mask, s32 def, const char * const *qmenu);
-
 These functions are typically called right after the v4l2_ctrl_handler_init:
 
 	static const s64 exp_bias_qmenu[] = {
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fccd08b..3cb1cff 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -552,6 +552,20 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 }
 EXPORT_SYMBOL(v4l2_ctrl_get_menu);
 
+/*
+ * Returns NULL or an s64 type array containing the menu for given
+ * control ID. The total number of the menu items is returned in @len.
+ */
+const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
+{
+	switch (id) {
+	default:
+		*len = 0;
+		return NULL;
+	};
+}
+EXPORT_SYMBOL(v4l2_ctrl_get_int_menu);
+
 /* Return the control name. */
 const char *v4l2_ctrl_get_name(u32 id)
 {
@@ -806,6 +820,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+
 	default:
 		return NULL;
 	}
@@ -1712,20 +1727,28 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 mask, s32 def)
 {
-	const char * const *qmenu = v4l2_ctrl_get_menu(id);
+	const char * const *qmenu = NULL;
+	const s64 *qmenu_int = NULL;
 	const char *name;
 	enum v4l2_ctrl_type type;
+	unsigned int qmenu_int_len;
 	s32 min;
 	s32 step;
 	u32 flags;
 
 	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
-	if (type != V4L2_CTRL_TYPE_MENU) {
+
+	if (type == V4L2_CTRL_TYPE_MENU)
+		qmenu = v4l2_ctrl_get_menu(id);
+	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
+		qmenu_int = v4l2_ctrl_get_int_menu(id, &qmenu_int_len);
+
+	if ((!qmenu && !qmenu_int) || (qmenu_int && max > qmenu_int_len)) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-			     0, max, mask, def, flags, qmenu, NULL, NULL);
+			     0, max, mask, def, flags, qmenu, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
-- 
1.7.9.5

