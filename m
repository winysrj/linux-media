Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4600 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaBOMFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 07:05:33 -0500
Message-ID: <52FF57E9.2020707@xs4all.nl>
Date: Sat, 15 Feb 2014 13:04:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [REVIEWv2 PATCH 39/34] v4l2-ctrls: allow HIDDEN controls in the user
 class
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously hidden controls were not allowed in the user class due to
backwards compatibility reasons (QUERYCTRL should not see them), but
by simply testing if QUERYCTRL found a hidden control and returning
-EINVAL this limitation can be lifted.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index bc30c50..859ac29 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1853,15 +1853,6 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	/* Complex controls are always hidden */
 	if (is_matrix || type >= V4L2_CTRL_COMPLEX_TYPES)
 		flags |= V4L2_CTRL_FLAG_HIDDEN;
-	/*
-	 * No hidden controls are allowed in the USER class
-	 * due to backwards compatibility with old applications.
-	 */
-	if (V4L2_CTRL_ID2CLASS(id) == V4L2_CTRL_CLASS_USER &&
-	    (flags & V4L2_CTRL_FLAG_HIDDEN)) {
-		handler_set_err(hdl, -EINVAL);
-		return NULL;
-	}
 	err = check_range(type, min, max, step, def);
 	if (err) {
 		handler_set_err(hdl, err);
@@ -2469,6 +2460,9 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	if (rc)
 		return rc;
 
+	/* VIDIOC_QUERYCTRL is not allowed to see hidden controls */
+	if (qc->flags & V4L2_CTRL_FLAG_HIDDEN)
+		return -EINVAL;
 	qc->id = qec.id;
 	qc->type = qec.type;
 	qc->flags = qec.flags;
-- 
1.8.5.2

