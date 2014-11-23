Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54768 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaKWMkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:40:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] v4l2-ctrl: move function prototypes from common.h to ctrls.h
Date: Sun, 23 Nov 2014 13:39:54 +0100
Message-Id: <1416746395-48631-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
References: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For some unknown reason several control prototypes where in v4l2-common.c
instead of in v4l2-ctrls.h. Move them and document them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-common.h |  3 ---
 include/media/v4l2-ctrls.h  | 25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 6b4951d..c69d91d 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -84,9 +84,6 @@
 
 int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		const char * const *menu_items);
-const char *v4l2_ctrl_get_name(u32 id);
-const char * const *v4l2_ctrl_get_menu(u32 id);
-const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 
 /* ------------------------------------------------------------------------- */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index b7cd7a6..911f3e5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -670,6 +670,31 @@ static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
   */
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv);
 
+/** v4l2_ctrl_get_name() - Get the name of the control
+ * @id:		The control ID.
+ *
+ * This function returns the name of the given control ID or NULL if it isn't
+ * a known control.
+ */
+const char *v4l2_ctrl_get_name(u32 id);
+
+/** v4l2_ctrl_get_menu() - Get the menu string array of the control
+ * @id:		The control ID.
+ *
+ * This function returns the NULL-terminated menu string array name of the
+ * given control ID or NULL if it isn't a known menu control.
+ */
+const char * const *v4l2_ctrl_get_menu(u32 id);
+
+/** v4l2_ctrl_get_int_menu() - Get the integer menu array of the control
+ * @id:		The control ID.
+ * @len:	The size of the integer array.
+ *
+ * This function returns the integer array of the given control ID or NULL if it
+ * if it isn't a known integer menu control.
+ */
+const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
+
 /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
   * @ctrl:	The control.
   *
-- 
2.1.3

