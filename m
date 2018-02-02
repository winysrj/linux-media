Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47679 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751959AbeBBOLy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 09:11:54 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: v4l2-ctrls.h: remove wrong copy-and-paste comment
Message-ID: <b7bd5b6b-9fcf-318e-634b-0ee3b71523ae@xs4all.nl>
Date: Fri, 2 Feb 2018 15:11:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __v4l2_ctrl_modify_range is the unlocked variant, so the comment about
taking a lock is obviously wrong.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5253b5471897..33ce194a7481 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -760,9 +760,6 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
  *
  * An error is returned if one of the range arguments is invalid for this
  * control type.
- *
- * This function assumes that the control handler is not locked and will
- * take the lock itself.
  */
 int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			     s64 min, s64 max, u64 step, s64 def);
