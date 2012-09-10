Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36325 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2IJL6R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 07:58:17 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	<linux-kernel@vger.kernel.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-doc@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Landley <rob@landley.net>
Subject: [PATCH] media: v4l2-ctrl: add a helper fucntion to modify the menu
Date: Mon, 10 Sep 2012 17:27:36 +0530
Message-ID: <1347278256-4560-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/video4linux/v4l2-controls.txt |   26 +++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c        |   28 +++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h                  |   14 +++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 43da22b..54a9539 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -196,6 +196,32 @@ the error code at the end. Saves a lot of repetitive error checking.
 It is recommended to add controls in ascending control ID order: it will be
 a bit faster that way.
 
+2.1) Changing the menu of a standard control:
+There are suitations when the control is standard but the menu items may be
+device specific, in such cases the framework provides the helper to do that.
+
+struct v4l2_ctrl * v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
+	const char * const *qmenu, s32 min, s32 max,
+	u32 menu_skip_mask, s32 def);
+
+This helper, function is used to modify the menu, min, max, mask and
+the default value to set.
+Example for usage:
+	static const char * const test_pattern[] = {
+		"Disabled",
+		"Vertical Bars",
+		"Vertical Bars",
+		"Solid Black",
+		"Solid White",
+		NULL
+	};
+	struct v4l2_ctrl *test_pattern_ctrl =
+		v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
+			V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
+			V4L2_TEST_PATTERN_DISABLED);
+
+	v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 0, 5, 0x3, 0);
+
 3) Optionally force initial control setup:
 
 	v4l2_ctrl_handler_setup(&foo->ctrl_handler);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d731422..ac0fb28 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2666,3 +2666,31 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_poll);
+
+/* Helper function for standard menu controls to modify the menu */
+struct v4l2_ctrl *v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
+					 const char * const *qmenu, s32 min,
+					 s32 max, u32 menu_skip_mask, s32 def)
+{
+	if (ctrl->type != V4L2_CTRL_TYPE_MENU)
+		return NULL;
+
+	if (qmenu == NULL)
+		return NULL;
+
+	/* Determine if it is standard menu control */
+	if (!v4l2_ctrl_get_menu(ctrl->id))
+		return NULL;
+
+	if ((def > max) || (max < min))
+		return NULL;
+
+	ctrl->qmenu = qmenu;
+	ctrl->minimum = min;
+	ctrl->maximum = max;
+	ctrl->menu_skip_mask = menu_skip_mask;
+	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
+
+	return ctrl;
+}
+EXPORT_SYMBOL(v4l2_ctrl_modify_menu);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..5b0ea04 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -488,6 +488,20 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 	mutex_unlock(ctrl->handler->lock);
 }
 
+/**
+ * v4l2_ctrl_modify_menu() - Modify the menu. This function is used when the
+ * control is standard but the menu is specific to device.
+ * @ctrl:		The control to change the menu.
+ * @qmenu:		The menu to which control will point to.
+ * @min:		Minimum value of the control.
+ * @max:		Maximum valur of the control.
+ * @menu_skip_mask:	The control's skip mask for menu controls.
+ * @def:		The default value for control.
+ */
+struct v4l2_ctrl *v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
+					 const char * const *qmenu, s32 min,
+					 s32 max, u32 menu_skip_mask, s32 def);
+
 /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
   * @ctrl:	The control.
   *
-- 
1.7.0.4

