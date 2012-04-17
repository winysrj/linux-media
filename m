Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2DQKKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:04 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M005XMC8LYC@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M0046SC8PI3@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:01 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 02/15] V4L: Add helper function for standard integer menu
 controls
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
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
index 13e6e8d..aa0934c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1522,6 +1522,27 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
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
index 533315b..16581c0 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -348,6 +348,23 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
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

