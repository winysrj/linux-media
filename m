Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32924 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbbGMJye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 05:54:34 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH] [media] bdisp: fix debug info memory access
Date: Mon, 13 Jul 2015 11:54:11 +0200
Message-ID: <1436781251-24245-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bdisp_dev->dbg.copy_node shall be a copy of (and not point to)
bdisp_ctx->node, since this resource is freed upon driver release.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index c83f9c2..052c932 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -768,12 +768,12 @@ static void bdisp_hw_save_request(struct bdisp_ctx *ctx)
 		/* Allocate memory if not done yet */
 		if (!copy_node[i]) {
 			copy_node[i] = devm_kzalloc(ctx->bdisp_dev->dev,
-						    sizeof(*copy_node),
+						    sizeof(*copy_node[i]),
 						    GFP_KERNEL);
 			if (!copy_node[i])
 				return;
 		}
-		copy_node[i] = node[i];
+		*copy_node[i] = *node[i];
 	}
 }
 
-- 
1.9.1

