Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34771 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbdAYHiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 02:38:12 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls.c: add NULL check
Message-ID: <cbf75ba8-3deb-e82a-3007-7bc3465493c4@xs4all.nl>
Date: Wed, 25 Jan 2017 08:38:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check that the control whose events we want to delete is still there.

Normally this will always be the case, but I am not 100% certain if there aren't
any corner cases when a device is forcibly unbound.

In any case, this will satisfy static checkers and simply make it more robust.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Shaobo <shaobo@cs.utah.edu>
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 47001e25fd9e..b9e08e3d6e0e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3367,6 +3367,9 @@ static void v4l2_ctrl_del_event(struct v4l2_subscribed_event *sev)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);

+	if (ctrl == NULL)
+		return;
+
 	v4l2_ctrl_lock(ctrl);
 	list_del(&sev->node);
 	v4l2_ctrl_unlock(ctrl);
