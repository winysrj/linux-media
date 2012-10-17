Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45779 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2JQLQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:49 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so7059174pbb.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:49 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 7/8] [media] s5p-mfc: Make 'clk_ref' static in s5p_mfc_pm.c
Date: Wed, 17 Oct 2012 16:41:50 +0530
Message-Id: <1350472311-9748-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/platform/s5p-mfc/s5p_mfc_pm.c:31:10: warning:
symbol 'clk_ref' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index f7c5c5a..19c46fb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -28,7 +28,7 @@ static struct s5p_mfc_pm *pm;
 static struct s5p_mfc_dev *p_dev;
 
 #ifdef CLK_DEBUG
-atomic_t clk_ref;
+static atomic_t clk_ref;
 #endif
 
 int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
-- 
1.7.4.1

