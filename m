Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35272 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763128AbdLSNyy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 08:54:54 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: fabien.dessenne@st.com, mchehab@kernel.org,
        benjamin.gaignard@st.com, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH V3 1/2] bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_reset
Date: Tue, 19 Dec 2017 21:57:29 +0800
Message-Id: <1513691849-6378-1-git-send-email-baijiaju1990@gmail.com>
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
 drivers/media/platform/sti/bdisp/bdisp-hw.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index b7892f3..b63d9c9 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -4,7 +4,7 @@
  * License terms:  GNU General Public License (GPL), version 2
  */
 
-#include <linux/delay.h>
+#include <linux/iopoll.h>
 
 #include "bdisp.h"
 #include "bdisp-filter.h"
@@ -15,7 +15,7 @@
 
 /* Reset & boot poll config */
 #define POLL_RST_MAX            50
-#define POLL_RST_DELAY_MS       20
+#define POLL_RST_DELAY_US       20000
 
 enum bdisp_target_plan {
 	BDISP_RGB,
@@ -366,7 +366,7 @@ struct bdisp_filter_addr {
  */
 int bdisp_hw_reset(struct bdisp_dev *bdisp)
 {
-	unsigned int i;
+	u32 tmp;
 
 	dev_dbg(bdisp->dev, "%s\n", __func__);
 
@@ -378,16 +378,17 @@ int bdisp_hw_reset(struct bdisp_dev *bdisp)
 	       bdisp->regs + BLT_CTL);
 	writel(0, bdisp->regs + BLT_CTL);
 
-	/* Wait for reset done */
-	for (i = 0; i < POLL_RST_MAX; i++) {
-		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
-			break;
-		msleep(POLL_RST_DELAY_MS);
-	}
-	if (i == POLL_RST_MAX)
+	/* Wait for reset done.
+	 * Despite the large timeout, most of the time the reset happens without
+	 * needing any delays */
+	if (readl_poll_timeout_atomic(bdisp->regs + BLT_STA1, tmp,
+		(tmp & BLT_STA1_IDLE), POLL_RST_DELAY_US,
+			POLL_RST_DELAY_US * POLL_RST_MAX)) {
 		dev_err(bdisp->dev, "Reset timeout\n");
+		return -EAGAIN;
+	}
 
-	return (i == POLL_RST_MAX) ? -EAGAIN : 0;
+	return 0;
 }
 
 /**
-- 
1.7.9.5
