Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:64060 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZFLQvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 12:51:01 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1550839ywb.1
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 09:51:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 12:51:03 -0400
Message-ID: <b24e53350906120951l552301c8x71b17fa4d45c8d1b@mail.gmail.com>
Subject: [PATCH 1/2] uvc: Fix for no return value check of uvc_ctrl_set()
	which calls mutex_lock_interruptible()
From: Robert Krakora <rob.krakora@messagenetsystems.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Krakora <rob.krakora@messagenetsystems.com>

Fix for no return value check of uvc_ctrl_set() which calls
mutex_lock_interruptible().

Priority: normal

Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

diff -r bff77ec33116 linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c  Thu Jun 11 18:44:23 2009 -0300
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c  Fri Jun 12 11:35:04 2009 -0400
@@ -538,7 +538,10 @@
                memset(&xctrl, 0, sizeof xctrl);
                xctrl.id = ctrl->id;

-               uvc_ctrl_begin(video);
+               ret = uvc_ctrl_begin(video);
+               if (ret < 0)
+                       return ret;
+
                ret = uvc_ctrl_get(video, &xctrl);
                uvc_ctrl_rollback(video);
                if (ret >= 0)
@@ -555,7 +558,10 @@
                xctrl.id = ctrl->id;
                xctrl.value = ctrl->value;

-               uvc_ctrl_begin(video);
+               ret = uvc_ctrl_begin(video);
+               if (ret < 0)
+                       return ret;
+
                ret = uvc_ctrl_set(video, &xctrl);
                if (ret < 0) {
                        uvc_ctrl_rollback(video);
@@ -574,7 +580,10 @@
                struct v4l2_ext_control *ctrl = ctrls->controls;
                unsigned int i;

-               uvc_ctrl_begin(video);
+               ret = uvc_ctrl_begin(video);
+               if (ret < 0)
+                       return ret;
+
                for (i = 0; i < ctrls->count; ++ctrl, ++i) {
                        ret = uvc_ctrl_get(video, ctrl);
                        if (ret < 0) {
