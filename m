Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:33324 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753353AbeEKPGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:06:39 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, chen.chenchacha@foxmail.com,
        keescook@chromium.org, arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] media: staging: atomisp: Fix an error handling path in 'lm3554_probe()'
Date: Fri, 11 May 2018 17:06:17 +0200
Message-Id: <f762630a681c08d9903cf73243dd98416ae96a7c.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of 'fail1' and 'fail2' is not correct. Reorder these calls to
branch at the right place of the error handling path.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 723fa74ff815..1e5f516f6e50 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -871,7 +871,7 @@ static int lm3554_probe(struct i2c_client *client)
 				     ARRAY_SIZE(lm3554_controls));
 	if (err) {
 		dev_err(&client->dev, "error initialize a ctrl_handler.\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lm3554_controls); i++)
@@ -879,7 +879,6 @@ static int lm3554_probe(struct i2c_client *client)
 				     NULL);
 
 	if (flash->ctrl_handler.error) {
-
 		dev_err(&client->dev, "ctrl_handler error.\n");
 		goto fail2;
 	}
@@ -888,7 +887,7 @@ static int lm3554_probe(struct i2c_client *client)
 	err = media_entity_pads_init(&flash->sd.entity, 0, NULL);
 	if (err) {
 		dev_err(&client->dev, "error initialize a media entity.\n");
-		goto fail1;
+		goto fail2;
 	}
 
 	flash->sd.entity.function = MEDIA_ENT_F_FLASH;
-- 
2.17.0
