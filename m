Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:54818 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdJXIWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 04:22:15 -0400
Received: by mail-pf0-f196.google.com with SMTP id n89so19125219pfk.11
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 01:22:15 -0700 (PDT)
Date: Tue, 24 Oct 2017 01:22:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Chen Guanqiao <chen.chenchacha@foxmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: i2c: Convert timers to use timer_setup()
Message-ID: <20171024082211.GA49652@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/media/atomisp/i2c/lm3554.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index 679176f7c542..a815f208409f 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -171,10 +171,9 @@ static int lm3554_set_config1(struct lm3554 *flash)
 /* -----------------------------------------------------------------------------
  * Hardware trigger
  */
-static void lm3554_flash_off_delay(long unsigned int arg)
+static void lm3554_flash_off_delay(struct timer_list *t)
 {
-	struct v4l2_subdev *sd = i2c_get_clientdata((struct i2c_client *)arg);
-	struct lm3554 *flash = to_lm3554(sd);
+	struct lm3554 *flash = from_timer(flash, t, flash_off_delay);
 	struct lm3554_platform_data *pdata = flash->pdata;
 
 	gpio_set_value(pdata->gpio_strobe, 0);
@@ -915,8 +914,7 @@ static int lm3554_probe(struct i2c_client *client,
 
 	mutex_init(&flash->power_lock);
 
-	setup_timer(&flash->flash_off_delay, lm3554_flash_off_delay,
-		    (unsigned long)client);
+	timer_setup(&flash->flash_off_delay, lm3554_flash_off_delay, 0);
 
 	err = lm3554_gpio_init(client);
 	if (err) {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
