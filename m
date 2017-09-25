Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:46219 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934239AbdIYJlG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:41:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls.c: allow empty control handlers
Message-ID: <98443a09-f861-0976-3b6e-cfd52c0cce43@xs4all.nl>
Date: Mon, 25 Sep 2017 11:41:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you have a control handler that does not contain any controls, then
currently calling VIDIOC_G/S/TRY_EXT_CTRLS with count == 0 will return
-EINVAL in the class_check() function.

This is not correct, there is no reason why this should return an error.

The purpose of setting count to 0 is to test if the ioctl can mix controls
from different control classes. And this is possible. The fact that there
are not actually any controls defined is another matter that is unrelated
to this test.

This caused v4l2-compliance to fail, so that is fixed with this patch applied.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index dd1db678718c..4e53a8654690 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2818,7 +2818,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 {
 	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
-		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
+		return 0;
 	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
 }
