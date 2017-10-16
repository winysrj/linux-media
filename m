Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:43970 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932776AbdJPXKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:10:55 -0400
Received: by mail-pg0-f54.google.com with SMTP id s75so7171783pgs.0
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 16:10:55 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:10:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: tvaudio: Convert timers to use timer_setup()
Message-ID: <20171016231053.GA99808@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/i2c/tvaudio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index ce86534450ac..16a1e08ce06c 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -300,9 +300,9 @@ static int chip_cmd(struct CHIPSTATE *chip, char *name, audiocmd *cmd)
  *   if available, ...
  */
 
-static void chip_thread_wake(unsigned long data)
+static void chip_thread_wake(struct timer_list *t)
 {
-	struct CHIPSTATE *chip = (struct CHIPSTATE*)data;
+	struct CHIPSTATE *chip = from_timer(chip, t, wt);
 	wake_up_process(chip->thread);
 }
 
@@ -1995,7 +1995,7 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 	v4l2_ctrl_handler_setup(&chip->hdl);
 
 	chip->thread = NULL;
-	init_timer(&chip->wt);
+	timer_setup(&chip->wt, chip_thread_wake, 0);
 	if (desc->flags & CHIP_NEED_CHECKMODE) {
 		if (!desc->getrxsubchans || !desc->setaudmode) {
 			/* This shouldn't be happen. Warn user, but keep working
@@ -2005,8 +2005,6 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 			return 0;
 		}
 		/* start async thread */
-		chip->wt.function = chip_thread_wake;
-		chip->wt.data     = (unsigned long)chip;
 		chip->thread = kthread_run(chip_thread, chip, "%s",
 					   client->name);
 		if (IS_ERR(chip->thread)) {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
