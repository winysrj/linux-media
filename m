Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44040 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753314AbeC1Num (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [RFCv9 PATCH 14/29] v4l2-ctrls: do not clone non-standard controls
Date: Wed, 28 Mar 2018 15:50:15 +0200
Message-Id: <20180328135030.7116-15-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

Only standard controls can be successfully cloned: handler_new_ref, used
by v4l2_ctrl_request_clone(), forcibly calls v4l2_ctrl_new_std() which
fails to find custom controls names, and we eventually hit the condition
that name == NULL in v4l2_ctrl_new().

This prevents us from using non-standard controls with requests, but
that is enough for testing purposes.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 62f91c0f1e5f..6cf6b2154462 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2876,6 +2876,11 @@ static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 		if (filter && !filter(ctrl))
 			continue;
 		err = handler_new_ref(hdl, ctrl, &new_ref, false);
+		if (err) {
+			printk("%s: handler_new_ref on control %x (%s) returned %d\n", __func__, ctrl->id, ctrl->name, err);
+			err = 0;
+			continue;
+		}
 		if (err)
 			break;
 		if (from->req_obj.req)
-- 
2.16.1
