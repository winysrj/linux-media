Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37642 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbdLLNp0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 08:45:26 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: fabien.dessenne@st.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/2] bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_save_request
Date: Tue, 12 Dec 2017 21:47:38 +0800
Message-Id: <1513086458-29304-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep under a spinlock.
The function call path is:
bdisp_device_run (acquire the spinlock)
  bdisp_hw_update
    bdisp_hw_save_request
      devm_kzalloc(GFP_KERNEL) --> may sleep

To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool(DSAC) and checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index 4b62ceb..7b45b43 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -1064,7 +1064,7 @@ static void bdisp_hw_save_request(struct bdisp_ctx *ctx)
 		if (!copy_node[i]) {
 			copy_node[i] = devm_kzalloc(ctx->bdisp_dev->dev,
 						    sizeof(*copy_node[i]),
-						    GFP_KERNEL);
+						    GFP_ATOMIC);
 			if (!copy_node[i])
 				return;
 		}
-- 
1.7.9.5
