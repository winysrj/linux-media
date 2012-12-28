Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2L1K0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 05:26:23 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so5828877pbc.5
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 02:26:23 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 2/3] [media] s5p-mfc: Remove redundant 'break'
Date: Fri, 28 Dec 2012 15:48:27 +0530
Message-Id: <1356689908-6866-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code returns before this statement. Hence not required.
Silences the following smatch message:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:525
s5p_mfc_set_dec_frame_buffer_v5() info: ignoring unreachable code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index bb99d3d..b0f277e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -522,7 +522,6 @@ int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 		mfc_err("Unknown codec for decoding (%x)\n",
 			ctx->codec_mode);
 		return -EINVAL;
-		break;
 	}
 	frame_size = ctx->luma_size;
 	frame_size_ch = ctx->chroma_size;
-- 
1.7.4.1

