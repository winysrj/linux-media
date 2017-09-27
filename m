Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33440
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752370AbdI0VrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 15/17] media: v4l2-ctrls: document nested members of structs
Date: Wed, 27 Sep 2017 18:46:58 -0300
Message-Id: <1e306b8be3c23175bc7d1c77208ce66094ff4549.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few nested members at v4l2-ctrls.h. Now that
kernel-doc supports, document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index dacfe54057f8..ca05f0f49bc5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -147,7 +147,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  * @type_ops:	The control type ops.
  * @id:	The control ID.
  * @name:	The control name.
- * @type:	The control type.
+ * @type:	The control type, as defined by &enum v4l2_ctrl_type.
  * @minimum:	The control's minimum value.
  * @maximum:	The control's maximum value.
  * @default_value: The control's default value.
@@ -166,8 +166,15 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  *		empty strings ("") correspond to non-existing menu items (this
  *		is in addition to the menu_skip_mask above). The last entry
  *		must be NULL.
+ *		Used only if the @type is %V4L2_CTRL_TYPE_MENU.
+ * @qmenu_int:	A 64-bit integer array for with integer menu items.
+ *		The size of array must be equal to the menu size, e. g.:
+ *		:math:`ceil(\frac{maximum - minimum}{step}) + 1`.
+ *		Used only if the @type is %V4L2_CTRL_TYPE_INTEGER_MENU.
  * @flags:	The control's flags.
- * @cur:	The control's current value.
+ * @cur:	Struct to store data about the current value.
+ * @cur.val:	The control's current value, if the @type is represented via
+ *		a u32 integer (see &enum v4l2_ctrl_type).
  * @val:	The control's new s32 value.
  * @priv:	The control's private pointer. For use by the driver. It is
  *		untouched by the control framework. Note that this pointer is
-- 
2.13.5
