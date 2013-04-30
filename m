Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43823 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760237Ab3D3OS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 10:18:29 -0400
Received: by mail-pd0-f170.google.com with SMTP id 15so331924pdi.15
        for <linux-media@vger.kernel.org>; Tue, 30 Apr 2013 07:18:28 -0700 (PDT)
Message-ID: <1367331503.4899.1.camel@phoenix>
Subject: [PATCH] [media] exynos4-is: Fix off-by-one valid range checking for
 is->config_index
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Younghwan Joo <yhwan.joo@samsung.com>,
	linux-media@vger.kernel.org
Date: Tue, 30 Apr 2013 22:18:23 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current code uses is->config_index as array subscript, thus the valid value
range is 0 ... ARRAY_SIZE(cmd) - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/platform/exynos4-is/fimc-is-regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index b0ff67b..d05eaa2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -174,7 +174,7 @@ int fimc_is_hw_change_mode(struct fimc_is *is)
 		HIC_CAPTURE_STILL, HIC_CAPTURE_VIDEO,
 	};
 
-	if (WARN_ON(is->config_index > ARRAY_SIZE(cmd)))
+	if (WARN_ON(is->config_index >= ARRAY_SIZE(cmd)))
 		return -EINVAL;
 
 	mcuctl_write(cmd[is->config_index], is, MCUCTL_REG_ISSR(0));
-- 
1.8.1.2



