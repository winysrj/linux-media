Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41906 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3EYL0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:26:36 -0400
Received: by mail-bk0-f53.google.com with SMTP id mx1so2980865bkb.12
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:26:35 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 1/5] s5c73m3: Do not ignore errors from regulator_enable()
Date: Sat, 25 May 2013 13:25:51 +0200
Message-Id: <1369481155-30446-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes following compilation warning:

drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘__s5c73m3_power_off’:
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1389:19: warning: ignoring return value
of ‘regulator_enable’, declared with attribute warn_unused_result

Cc: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index d3e867a..402da96 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1385,9 +1385,12 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 	}
 	return 0;
 err:
-	for (++i; i < S5C73M3_MAX_SUPPLIES; i++)
-		regulator_enable(state->supplies[i].consumer);
-
+	for (++i; i < S5C73M3_MAX_SUPPLIES; i++) {
+		int r = regulator_enable(state->supplies[i].consumer);
+		if (r < 0)
+			v4l2_err(&state->oif_sd, "Failed to reenable %s: %d\n",
+				 state->supplies[i].supply, r);
+	}
 	return ret;
 }
 
-- 
1.7.4.1

