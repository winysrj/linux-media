Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51847
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753866AbdBIWLS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 17:11:18 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix s5p_mfc_set_dec_frame_buffer_v6() to print buf size in hex
Date: Thu,  9 Feb 2017 15:10:51 -0700
Message-Id: <20170209221051.26234-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix s5p_mfc_set_dec_frame_buffer_v6() to print buffer size in hex to be
consistent with the rest of the messages in the routine.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index d6f207e..fc45980 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -497,7 +497,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		}
 	}
 
-	mfc_debug(2, "Buf1: %zu, buf_size1: %d (frames %d)\n",
+	mfc_debug(2, "Buf1: %zx, buf_size1: %d (frames %d)\n",
 			buf_addr1, buf_size1, ctx->total_dpb_count);
 	if (buf_size1 < 0) {
 		mfc_debug(2, "Not enough memory has been allocated.\n");
-- 
2.7.4

