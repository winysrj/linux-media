Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33750 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbcLGRX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 12:23:57 -0500
From: Santosh Kumar Singh <kumar.san1093@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        PJunghak Sung <jh1009.sung@samsung.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH] vim2m: Clean up file handle in open() error path.
Date: Wed,  7 Dec 2016 22:53:39 +0530
Message-Id: <1481131419-2921-1-git-send-email-kumar.san1093@gmail.com>
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
 		kfree(ctx);
+		v4l2_fh_exit(&ctx->fh);
 		goto open_unlock;
 	}
 
-- 
1.9.1

