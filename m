Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37421 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab2D0OXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:37 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3500A476KRUP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:22:03 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3500MPP6N9YR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:33 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 01/14] V4L: Add helper function for standard integer
 menu controls
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds v4l2_ctrl_new_std_int_menu() helper function which can
be used in drivers for creating standard integer menu control. It is
similar to v4l2_ctrl_new_std_menu(), except it doesn't have a mask
parameter and an additional qmenu parameter allows passing an array
of signed 64-bit integers constituting the menu items.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/v4l2-ctrls.c |   21 +++++++++++++++++++++
 include/media/v4l2-ctrls.h       |   17 +++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index c93a979..e0725b5 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1517,6 +1517,27 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
+/* Helper function for standard integer menu controls */
+struct v4l2_ctrl *v4l2_ctrl_new_std_int_menu(struct v4l2_ctrl_handler *hdl,
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
+EXPORT_SYMBOL(v4l2_ctrl_new_std_int_menu);
+
 /* Add a control from another handler to this handler */
 struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
 					  struct v4l2_ctrl *ctrl)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 8920f82..15116d2 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -347,6 +347,23 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 mask, s32 def);
 
+/** v4l2_ctrl_new_std_int_menu() - Create a new standard V4L2 integer menu control.
+  * @hdl:	The control handler.
+  * @ops:	The control ops.
+  * @id:	The control ID.
+  * @max:	The control's maximum value.
+  * @def:	The control's default value.
+  * @qmenu_int:	The control's menu entries.
+  *
+  * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
+  * needs an array of integers determining the menu entries.
+  *
+  * If @id refers to a non-integer-menu control, then this function will return NULL.
+  */
+struct v4l2_ctrl *v4l2_ctrl_new_std_int_menu(struct v4l2_ctrl_handler *hdl,
+			const struct v4l2_ctrl_ops *ops,
+			u32 id, s32 max, s32 def, const s64 *qmenu_int);
+
 /** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
   * @hdl:	The control handler.
   * @ctrl:	The control to add.
-- 
1.7.10

