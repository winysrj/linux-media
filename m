Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64519 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3EYL1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:27:17 -0400
Received: by mail-bk0-f46.google.com with SMTP id my13so2941504bkb.5
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:27:16 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 2/5] s5p-tv: Don't ignore return value of regulator_enable() in sii9234_drv.c
Date: Sat, 25 May 2013 13:25:52 +0200
Message-Id: <1369481155-30446-3-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following compilation warning:

  CC [M]  drivers/media/platform/s5p-tv/sii9234_drv.o
drivers/media/platform/s5p-tv/sii9234_drv.c: In function ‘sii9234_runtime_resume’:
drivers/media/platform/s5p-tv/sii9234_drv.c:252:18: warning: ignoring return
  value of ‘regulator_enable’, declared with attribute warn_unused_result

Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s5p-tv/sii9234_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 39b77d2..3dd762e 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -249,7 +249,9 @@ static int sii9234_runtime_resume(struct device *dev)
 	int ret;
 
 	dev_info(dev, "resume start\n");
-	regulator_enable(ctx->power);
+	ret = regulator_enable(ctx->power);
+	if (ret < 0)
+		return ret;
 
 	ret = sii9234_reset(ctx);
 	if (ret)
-- 
1.7.4.1

