Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51038 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbcKYEtO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 23:49:14 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] Media: Platform: Sti: Bdisp: - Fix for error handling
Date: Fri, 25 Nov 2016 10:16:46 +0530
Message-id: <1480049206-20139-1-git-send-email-shailendra.v@samsung.com>
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

