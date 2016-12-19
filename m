Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35368 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932908AbcLSQNe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 11:13:34 -0500
From: Santosh Kumar Singh <kumar.san1093@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH v2] vim2m: Clean up file handle in open() error path.
Date: Mon, 19 Dec 2016 21:42:46 +0530
Message-Id: <1482163966-2692-1-git-send-email-kumar.san1093@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to avoid possible memory leak and exit file handle
in error paths.

Signed-off-by: Santosh Kumar Singh <kumar.san1093@gmail.com>
---
 drivers/media/platform/vim2m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a98f679..9fd24b8 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -907,6 +907,7 @@ static int vim2m_open(struct file *file)
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
+		kfree(ctx);
 		goto open_unlock;
 	}
 	ctx->fh.ctrl_handler = hdl;
@@ -929,6 +930,7 @@ static int vim2m_open(struct file *file)
 
 		v4l2_ctrl_handler_free(hdl);
+		v4l2_fh_exit(&ctx->fh);
 		kfree(ctx);
 		goto open_unlock;
 	}
 
-- 
1.9.1

