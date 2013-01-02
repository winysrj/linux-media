Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54565 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ABJWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 04:22:01 -0500
Received: by mail-pb0-f54.google.com with SMTP id wz12so7767824pbc.27
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 01:22:01 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sylvester.nawrocki@gmail.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH-Trivial] [media] s5p-mfc: Fix a typo in error message in s5p_mfc_pm.c
Date: Wed,  2 Jan 2013 14:43:33 +0530
Message-Id: <1357118013-20967-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a trivial typo.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 2895333..6aa38a5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -46,7 +46,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 
 	ret = clk_prepare(pm->clock_gate);
 	if (ret) {
-		mfc_err("Failed to preapre clock-gating control\n");
+		mfc_err("Failed to prepare clock-gating control\n");
 		goto err_p_ip_clk;
 	}
 
-- 
1.7.4.1

