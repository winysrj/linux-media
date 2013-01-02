Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3ABKxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 05:53:48 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7768565pbc.19
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 02:53:48 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH Resend] [media] s5p-mfc: Fix an error check
Date: Wed,  2 Jan 2013 16:15:49 +0530
Message-Id: <1357123549-14264-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking unsigned variable for negative value always returns false.
Hence make this value signed as we expect it to be negative too.

Fixes the following smatch warning:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:572
s5p_mfc_set_enc_ref_buffer_v6() warn: unsigned 'buf_size1' is never
less than zero.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Added additional description in commit message.
Please ignore the previous patch.
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 5f9a5e0..91d5087 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -535,8 +535,8 @@ void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
 int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
-	size_t buf_addr1, buf_size1;
-	int i;
+	size_t buf_addr1;
+	int i, buf_size1;
 
 	mfc_debug_enter();
 
-- 
1.7.4.1

