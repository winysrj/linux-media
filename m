Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39743 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LXLpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 06:45:30 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so6252411pdj.37
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 03:45:29 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org
Subject: [PATCH 1/3] [media] s5k5baf: Fix build warning
Date: Tue, 24 Dec 2013 17:12:03 +0530
Message-Id: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings:
drivers/media/i2c/s5k5baf.c: In function 's5k5baf_fw_parse':
drivers/media/i2c/s5k5baf.c:362:3: warning:
format '%d' expects argument of type 'int', but argument 3 has type 'size_t' [-Wformat=]
drivers/media/i2c/s5k5baf.c:383:4: warning:
format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/media/i2c/s5k5baf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index e3b44a87460b..139bdd4f5dde 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -359,7 +359,7 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
 	int ret;
 
 	if (count < S5K5BAG_FW_TAG_LEN + 1) {
-		dev_err(dev, "firmware file too short (%d)\n", count);
+		dev_err(dev, "firmware file too short (%zu)\n", count);
 		return -EINVAL;
 	}
 
@@ -379,7 +379,7 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
 
 	f = (struct s5k5baf_fw *)d;
 	if (count < 1 + 2 * f->count) {
-		dev_err(dev, "invalid firmware header (count=%d size=%d)\n",
+		dev_err(dev, "invalid firmware header (count=%d size=%zu)\n",
 			f->count, 2 * (count + S5K5BAG_FW_TAG_LEN));
 		return -EINVAL;
 	}
-- 
1.7.9.5

