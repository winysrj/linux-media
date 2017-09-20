Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:54574 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdITXiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 19:38:03 -0400
Received: by mail-pf0-f181.google.com with SMTP id d187so2297951pfg.11
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 16:38:03 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/31] media/i2c/tc358743: Initialize timer
Date: Wed, 20 Sep 2017 16:27:41 -0700
Message-Id: <1505950075-50223-18-git-send-email-keescook@chromium.org>
In-Reply-To: <1505950075-50223-1-git-send-email-keescook@chromium.org>
References: <1505950075-50223-1-git-send-email-keescook@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This converts to use setup_timer() to set callback and data, though it
doesn't look like this would have worked with timer checking enabled
since no init_timer() was ever called before.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/i2c/tc358743.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c363ccab..07ad6a3ff1ec 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1964,8 +1964,8 @@ static int tc358743_probe(struct i2c_client *client,
 	} else {
 		INIT_WORK(&state->work_i2c_poll,
 			  tc358743_work_i2c_poll);
-		state->timer.data = (unsigned long)state;
-		state->timer.function = tc358743_irq_poll_timer;
+		setup_timer(&state->timer, tc358743_irq_poll_timer,
+			    (unsigned long)state);
 		state->timer.expires = jiffies +
 				       msecs_to_jiffies(POLL_INTERVAL_MS);
 		add_timer(&state->timer);
-- 
2.7.4
