Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:34282 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbbKCXu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2015 18:50:27 -0500
From: Vladimir Zapolskiy <vz@mleia.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] v4l2-ctrls: remove unclaimed v4l2_ctrl_add_ctrl() interface
Date: Wed,  4 Nov 2015 01:50:23 +0200
Message-Id: <1446594623-32667-1-git-send-email-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_add_ctrl() interface has no users since its introduction in
commit 0996517cf8ea ("V4L/DVB: v4l2: Add new control handling framework")
and its functionality is covered by v4l2_ctrl_new() and derivative
interfaces, so it is safe to remove the interface from the kernel.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 Documentation/video4linux/v4l2-controls.txt |  1 -
 drivers/media/v4l2-core/v4l2-ctrls.c        | 16 ----------------
 include/media/v4l2-ctrls.h                  | 12 ------------
 3 files changed, 29 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 5517db6..5e759ca 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -647,7 +647,6 @@ Or you can add specific controls to a handler:
 	volume = v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_AUDIO_VOLUME, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_BRIGHTNESS, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &ops, V4L2_CID_CONTRAST, ...);
-	v4l2_ctrl_add_ctrl(&radio_ctrl_handler, volume);
 
 What you should not do is make two identical controls for two handlers.
 For example:
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc..3b14485 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2198,22 +2198,6 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
 
-/* Add a control from another handler to this handler */
-struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
-					  struct v4l2_ctrl *ctrl)
-{
-	if (hdl == NULL || hdl->error)
-		return NULL;
-	if (ctrl == NULL) {
-		handler_set_err(hdl, -EINVAL);
-		return NULL;
-	}
-	if (ctrl->handler == hdl)
-		return ctrl;
-	return handler_new_ref(hdl, ctrl) ? NULL : ctrl;
-}
-EXPORT_SYMBOL(v4l2_ctrl_add_ctrl);
-
 /* Add the controls from another handler to our own. */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index da6fe98..0bc9b35 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -535,18 +535,6 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			u32 id, u8 max, u8 def, const s64 *qmenu_int);
 
 /**
- * v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
- * @hdl:	The control handler.
- * @ctrl:	The control to add.
- *
- * It will return NULL if it was unable to add the control reference.
- * If the control already belonged to the handler, then it will do
- * nothing and just return @ctrl.
- */
-struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
-					  struct v4l2_ctrl *ctrl);
-
-/**
  * v4l2_ctrl_add_handler() - Add all controls from handler @add to
  * handler @hdl.
  * @hdl:	The control handler.
-- 
2.1.4

