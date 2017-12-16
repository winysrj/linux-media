Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:43315 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdLPLvp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 06:51:45 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: fabien.dessenne@st.com, hverkuil@xs4all.nl,
        benjamin.gaignard@st.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH V2 1/2] bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_reset
Date: Sat, 16 Dec 2017 19:54:11 +0800
Message-Id: <1513425251-4143-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep under a spinlock.
The function call path is:
bdisp_device_run (acquire the spinlock)
  bdisp_hw_reset
    msleep --> may sleep

To fix it, readl_poll_timeout_atomic is used to replace msleep.

This bug is found by my static analysis tool(DSAC) and 
checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index b7892f3..e94a371 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/iopoll.h>
 
 #include "bdisp.h"
 #include "bdisp-filter.h"
@@ -366,7 +367,7 @@ struct bdisp_filter_addr {
  */
 int bdisp_hw_reset(struct bdisp_dev *bdisp)
 {
-	unsigned int i;
+	u32 tmp;
 
 	dev_dbg(bdisp->dev, "%s\n", __func__);
 
@@ -379,15 +380,14 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
 	writel(0, bdisp->regs + BLT_CTL);
 
 	/* Wait for reset done */
-	for (i = 0; i < POLL_RST_MAX; i++) {
-		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
-			break;
-		msleep(POLL_RST_DELAY_MS);
-	}
-	if (i == POLL_RST_MAX)
+	if (readl_poll_timeout_atomic(bdisp->regs + BLT_STA1, tmp,
+		(tmp & BLT_STA1_IDLE), POLL_RST_DELAY_MS,
+			POLL_RST_DELAY_MS * POLL_RST_MAX)) {
 		dev_err(bdisp->dev, "Reset timeout\n");
+		return -EAGAIN;
+	}
 
-	return (i == POLL_RST_MAX) ? -EAGAIN : 0;
+	return 0;
 }
 
 /**
-- 
1.7.9.5
