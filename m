Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:52939 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932762AbdJPXK3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:10:29 -0400
Received: by mail-pf0-f176.google.com with SMTP id e64so16894928pfk.9
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 16:10:29 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:10:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: tc358743: Convert timers to use timer_setup()
Message-ID: <20171016231027.GA99719@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/i2c/tc358743.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a9355032076f..359f63d7dfca 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1481,9 +1481,9 @@ static irqreturn_t tc358743_irq_handler(int irq, void *dev_id)
 	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static void tc358743_irq_poll_timer(unsigned long arg)
+static void tc358743_irq_poll_timer(struct timer_list *t)
 {
-	struct tc358743_state *state = (struct tc358743_state *)arg;
+	struct tc358743_state *state = from_timer(state, t, timer);
 	unsigned int msecs;
 
 	schedule_work(&state->work_i2c_poll);
@@ -2147,8 +2147,7 @@ static int tc358743_probe(struct i2c_client *client,
 	} else {
 		INIT_WORK(&state->work_i2c_poll,
 			  tc358743_work_i2c_poll);
-		setup_timer(&state->timer, tc358743_irq_poll_timer,
-			    (unsigned long)state);
+		timer_setup(&state->timer, tc358743_irq_poll_timer, 0);
 		state->timer.expires = jiffies +
 				       msecs_to_jiffies(POLL_INTERVAL_MS);
 		add_timer(&state->timer);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
