Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44034 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbeBTEpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:05 -0500
Received: by mail-pf0-f194.google.com with SMTP id 17so3017431pfw.11
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:05 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 08/21] [WAR] v4l2-ctrls: do not clone non-standard controls
Date: Tue, 20 Feb 2018 13:44:12 +0900
Message-Id: <20180220044425.169493-9-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index 166647817efb..7a81aa5959c3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2772,6 +2772,11 @@ int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
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
 		if (from->is_request)
-- 
2.16.1.291.g4437f3f132-goog
