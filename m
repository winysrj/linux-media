Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:33325 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdHaXjT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:39:19 -0400
Received: by mail-pg0-f49.google.com with SMTP id t3so3289578pgt.0
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 16:39:19 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/31] media/i2c/tc358743: Initialize timer
Date: Thu, 31 Aug 2017 16:29:29 -0700
Message-Id: <1504222183-61202-18-git-send-email-keescook@chromium.org>
In-Reply-To: <1504222183-61202-1-git-send-email-keescook@chromium.org>
References: <1504222183-61202-1-git-send-email-keescook@chromium.org>
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
index 5788af238b86..94e722e0f4e0 100644
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
