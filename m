Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:28903 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeEKPGi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:06:38 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, chen.chenchacha@foxmail.com,
        keescook@chromium.org, arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] media: staging: atomisp: Return an error code in case of error in 'lm3554_probe()'
Date: Fri, 11 May 2018 17:06:16 +0200
Message-Id: <2eff9a8d6d67b60aed87277ab4f8b48b2251d559.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If 'v4l2_ctrl_handler_init()' fails, we go to the error handling path, do
some clean-up and return err, which is known to be 0 (i.e. success).

Axe the 'ret' variable and use 'err' directly in order to return the error
code instead.
Also remove the initialization of 'err' which was hiding this issue.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 7098bf317f16..723fa74ff815 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -852,10 +852,9 @@ static void *lm3554_platform_data_func(struct i2c_client *client)
 
 static int lm3554_probe(struct i2c_client *client)
 {
-	int err = 0;
+	int err;
 	struct lm3554 *flash;
 	unsigned int i;
-	int ret;
 
 	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
 	if (!flash)
@@ -868,10 +867,9 @@ static int lm3554_probe(struct i2c_client *client)
 	flash->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	flash->mode = ATOMISP_FLASH_MODE_OFF;
 	flash->timeout = LM3554_MAX_TIMEOUT / LM3554_TIMEOUT_STEPSIZE - 1;
-	ret =
-	    v4l2_ctrl_handler_init(&flash->ctrl_handler,
-				   ARRAY_SIZE(lm3554_controls));
-	if (ret) {
+	err = v4l2_ctrl_handler_init(&flash->ctrl_handler,
+				     ARRAY_SIZE(lm3554_controls));
+	if (err) {
 		dev_err(&client->dev, "error initialize a ctrl_handler.\n");
 		goto fail2;
 	}
-- 
2.17.0
