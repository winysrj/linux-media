Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:03 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so6487315pbc.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:03 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/6] [media] s5p-fimc: Use devm_clk_get in mipi-csis.c
Date: Fri, 23 Nov 2012 17:20:38 +0530
Message-Id: <1353671443-2978-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get is device managed and makes error handling and cleanup
a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4c961b1..d624bfa 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -341,8 +341,6 @@ static void s5pcsis_clk_put(struct csis_state *state)
 		if (IS_ERR_OR_NULL(state->clock[i]))
 			continue;
 		clk_unprepare(state->clock[i]);
-		clk_put(state->clock[i]);
-		state->clock[i] = NULL;
 	}
 }
 
@@ -352,13 +350,11 @@ static int s5pcsis_clk_get(struct csis_state *state)
 	int i, ret;
 
 	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
-		state->clock[i] = clk_get(dev, csi_clock_name[i]);
+		state->clock[i] = devm_clk_get(dev, csi_clock_name[i]);
 		if (IS_ERR(state->clock[i]))
 			goto err;
 		ret = clk_prepare(state->clock[i]);
 		if (ret < 0) {
-			clk_put(state->clock[i]);
-			state->clock[i] = NULL;
 			goto err;
 		}
 	}
-- 
1.7.4.1

