Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:13768 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbcFOM5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 08:57:52 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv2] v4l2-ctrl.h: fix comments
Message-ID: <576150CC.9010201@cisco.com>
Date: Wed, 15 Jun 2016 14:57:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments for the unlocked v4l2_ctrl_s_ctrl* functions were wrong (copy
and pasted from the locked variants). Fix this, since it is confusing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Fixed the v4l2_ctrl_s_ctrl_int64() comment, which was inadvertently changed
as well.

Thanks to Ian Arkver for reporting this.
---
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 0bc9b35..5c2ed0c 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -759,9 +759,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
  * @ctrl:	The control.
  * @val:	The new value.
  *
- * This set the control's new value safely by going through the control
- * framework. This function will lock the control's handler, so it cannot be
- * used from within the &v4l2_ctrl_ops functions.
+ * This sets the control's new value safely by going through the control
+ * framework. This function assumes the control's handler is already locked,
+ * allowing it to be used from within the &v4l2_ctrl_ops functions.
  *
  * This function is for integer type controls only.
  */
@@ -771,7 +771,7 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
  * @ctrl:	The control.
  * @val:	The new value.
  *
- * This set the control's new value safely by going through the control
+ * This sets the control's new value safely by going through the control
  * framework. This function will lock the control's handler, so it cannot be
  * used from within the &v4l2_ctrl_ops functions.
  *
@@ -807,9 +807,9 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
  * @ctrl:	The control.
  * @val:	The new value.
  *
- * This set the control's new value safely by going through the control
- * framework. This function will lock the control's handler, so it cannot be
- * used from within the &v4l2_ctrl_ops functions.
+ * This sets the control's new value safely by going through the control
+ * framework. This function assumes the control's handler is already locked,
+ * allowing it to be used from within the &v4l2_ctrl_ops functions.
  *
  * This function is for 64-bit integer type controls only.
  */
@@ -821,7 +821,7 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
  * @ctrl:	The control.
  * @val:	The new value.
  *
- * This set the control's new value safely by going through the control
+ * This sets the control's new value safely by going through the control
  * framework. This function will lock the control's handler, so it cannot be
  * used from within the &v4l2_ctrl_ops functions.
  *
@@ -843,9 +843,9 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
  * @ctrl:	The control.
  * @s:		The new string.
  *
- * This set the control's new string safely by going through the control
- * framework. This function will lock the control's handler, so it cannot be
- * used from within the &v4l2_ctrl_ops functions.
+ * This sets the control's new string safely by going through the control
+ * framework. This function assumes the control's handler is already locked,
+ * allowing it to be used from within the &v4l2_ctrl_ops functions.
  *
  * This function is for string type controls only.
  */
@@ -857,7 +857,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
  * @ctrl:	The control.
  * @s:		The new string.
  *
- * This set the control's new string safely by going through the control
+ * This sets the control's new string safely by going through the control
  * framework. This function will lock the control's handler, so it cannot be
  * used from within the &v4l2_ctrl_ops functions.
  *
