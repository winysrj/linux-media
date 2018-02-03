Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33881 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751638AbeBCNSU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 08:18:20 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] v4l2-ctrls.h: fix wrong copy-and-paste comment
Message-ID: <60d1388f-5e34-72bd-851c-8e33f9dfe3c1@xs4all.nl>
Date: Sat, 3 Feb 2018 14:18:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __v4l2_ctrl_modify_range is the unlocked variant, so the comment about
taking a lock is obviously wrong.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Change since v1: replace the comment with something better instead of deleting it.
---
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5253b5471897..1e599f10c893 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -761,8 +761,8 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
  * An error is returned if one of the range arguments is invalid for this
  * control type.
  *
- * This function assumes that the control handler is not locked and will
- * take the lock itself.
+ * The caller is responsible for acquiring the control handler mutex on behalf
+ * of __v4l2_ctrl_modify_range().
  */
 int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			     s64 min, s64 max, u64 step, s64 def);
