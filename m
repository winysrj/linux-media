Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40769 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752589AbdJaOW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 10:22:29 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v1 15/15] media: i2c: adv748x: Remove duplicate NULL check
Date: Tue, 31 Oct 2017 16:21:49 +0200
Message-Id: <20171031142149.32512-15-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20171031142149.32512-1-andriy.shevchenko@linux.intel.com>
References: <20171031142149.32512-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since i2c_unregister_device() became NULL-aware we may remove duplicate
NULL check.

Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 5ee14f2c2747..10c3d469175c 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -225,10 +225,8 @@ static void adv748x_unregister_clients(struct adv748x_state *state)
 {
 	unsigned int i;
 
-	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i) {
-		if (state->i2c_clients[i])
-			i2c_unregister_device(state->i2c_clients[i]);
-	}
+	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i)
+		i2c_unregister_device(state->i2c_clients[i]);
 }
 
 static int adv748x_initialise_clients(struct adv748x_state *state)
-- 
2.14.2
