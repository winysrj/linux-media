Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2EJKbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:07 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S00C90YJJC2@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DE8YJR3I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 01/23] V4L: Add helper function for standard integer menu
 controls
In-reply-to: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336645858-30366-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds v4l2_ctrl_new_int_menu() helper function which can be used
in drivers for creating standard integer menu control with driver-specific
menu item list. It is similar to v4l2_ctrl_new_std_menu(), except it doesn't
have a mask parameter and an additional qmenu parameter allows passing
an array of signed 64-bit integers as the menu item list.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Tested-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/v4l2-controls.txt |   21 +++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c            |   21 +++++++++++++++++++++
 include/media/v4l2-ctrls.h                  |   17 +++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index e2492a9..43da22b 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -130,8 +130,18 @@ Menu controls are added by calling v4l2_ctrl_new_std_menu:
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 skip_mask, s32 def);
 
+Or alternatively for integer menu controls, by calling v4l2_ctrl_new_int_menu:
+
+	struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 max, s32 def, const s64 *qmenu_int);
+
 These functions are typically called right after the v4l2_ctrl_handler_init:
 
+	static const s64 exp_bias_qmenu[] = {
+	       -2, -1, 0, 1, 2
+	};
+
 	v4l2_ctrl_handler_init(&foo->ctrl_handler, nr_of_controls);
 	v4l2_ctrl_new_std(&foo->ctrl_handler, &foo_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
@@ -141,6 +151,11 @@ These functions are typically called right after the v4l2_ctrl_handler_init:
 			V4L2_CID_POWER_LINE_FREQUENCY,
 			V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0,
 			V4L2_CID_POWER_LINE_FREQUENCY_DISABLED);
+	v4l2_ctrl_new_int_menu(&foo->ctrl_handler, &foo_ctrl_ops,
+			V4L2_CID_EXPOSURE_BIAS,
+			ARRAY_SIZE(exp_bias_qmenu) - 1,
+			ARRAY_SIZE(exp_bias_qmenu) / 2 - 1,
+			exp_bias_qmenu);
 	...
 	if (foo->ctrl_handler.error) {
 		int err = foo->ctrl_handler.error;
@@ -164,6 +179,12 @@ controls. There is no min argument since that is always 0 for menu controls,
 and instead of a step there is a skip_mask argument: if bit X is 1, then menu
 item X is skipped.
 
+The v4l2_ctrl_new_int_menu function creates a new standard integer menu
+control with driver-specific items in the menu. It differs from
+v4l2_ctrl_new_std_menu in that it doesn't have the mask argument and takes
+as the last argument an array of signed 64-bit integers that form an exact
+menu item list.
+
 Note that if something fails, the function will return NULL or an error and
 set ctrl_handler->error to the error code. If ctrl_handler->error was already
 set, then it will just return and do nothing. This is also true for
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index bc97bcf..1bc8791 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1524,6 +1524,27 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
+/* Helper function for standard integer menu controls */
+struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 max, s32 def, const s64 *qmenu_int)
+{
+	const char *name;
+	enum v4l2_ctrl_type type;
+	s32 min;
+	s32 step;
+	u32 flags;
+
+	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	if (type != V4L2_CTRL_TYPE_INTEGER_MENU) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
+	return v4l2_ctrl_new(hdl, ops, id, name, type,
+			     0, max, 0, def, flags, NULL, qmenu_int, NULL);
+}
+EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
+
 /* Add a control from another handler to this handler */
 struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
 					  struct v4l2_ctrl *ctrl)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index c6f6b4c..4fd3cc9 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -347,6 +347,23 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 mask, s32 def);
 
+/** v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
+  * @hdl:	The control handler.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @max:	The control's maximum value.
+  * @def:	The control's default value.
+  * @qmenu_int:	The control's menu entries.
+  *
+  * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
+  * takes as an argument an array of integers determining the menu items.
+  *
+  * If @id refers to a non-integer-menu control, then this function will return NULL.
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 max, s32 def, const s64 *qmenu_int);
+
 /** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
   * @hdl:	The control handler.
   * @ctrl:	The control to add.
-- 
1.7.10

