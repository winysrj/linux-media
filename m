Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58354 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbcLAFBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 00:01:22 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] Platform: Sti: Bdisp: Clean up file handle in open() error
 path.
Date: Thu, 01 Dec 2016 10:17:51 +0530
Message-id: <1480567671-13239-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The File handle is not yet added in the vdev list.So no need to call 
v4l2_fh_del(&ctx->fh)if it fails to create control.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 45f82b5..fbf302f 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -632,8 +632,8 @@ static int bdisp_open(struct file *file)
 
 error_ctrls:
 	bdisp_ctrls_delete(ctx);
-error_fh:
 	v4l2_fh_del(&ctx->fh);
+error_fh:
 	v4l2_fh_exit(&ctx->fh);
 	bdisp_hw_free_nodes(ctx);
 mem_ctx:
-- 
1.7.9.5

