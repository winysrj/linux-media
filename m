Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 22/39] [media] v4l2-ctrls.h: Document a few missing arguments
Date: Sat, 22 Aug 2015 14:28:07 -0300
Message-Id: <757d005520590b29b5740f73ceb363f047d2ac78.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Warning(.//include/media/v4l2-ctrls.h:217): No description found for parameter 'p_new'
Warning(.//include/media/v4l2-ctrls.h:217): No description found for parameter 'p_cur'
Warning(.//include/media/v4l2-ctrls.h:217): Excess struct/union/enum/typedef member 'val64' description in 'v4l2_ctrl'
Warning(.//include/media/v4l2-ctrls.h:314): No description found for parameter 'qmenu_int'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 946d5d3d6ff7..da6fe9802fee 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -159,12 +159,17 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  * @flags:	The control's flags.
  * @cur:	The control's current value.
  * @val:	The control's new s32 value.
- * @val64:	The control's new s64 value.
  * @priv:	The control's private pointer. For use by the driver. It is
  *		untouched by the control framework. Note that this pointer is
  *		not freed when the control is deleted. Should this be needed
  *		then a new internal bitfield can be added to tell the framework
  *		to free this pointer.
+ * @p_cur:	The control's current value represented via an union with
+ *		provides a standard way of accessing control types
+ *		through a pointer.
+ * @p_new:	The control's new value represented via an union with provides
+ *		a standard way of accessing control types
+ *		through a pointer.
  */
 struct v4l2_ctrl {
 	/* Administrative fields */
@@ -291,6 +296,8 @@ struct v4l2_ctrl_handler {
  *		empty strings ("") correspond to non-existing menu items (this
  *		is in addition to the menu_skip_mask above). The last entry
  *		must be NULL.
+ * @qmenu_int:	A const s64 integer array for all menu items of the type
+ * 		V4L2_CTRL_TYPE_INTEGER_MENU.
  * @is_private: If set, then this control is private to its handler and it
  *		will not be added to any other handlers.
  */
-- 
2.4.3

