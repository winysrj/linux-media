Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:48776 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753515AbeEKPGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:06:40 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, chen.chenchacha@foxmail.com,
        keescook@chromium.org, arvind.yadav.cs@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] media: staging: atomisp: Fix usage of 'media_entity_cleanup()'
Date: Fri, 11 May 2018 17:06:18 +0200
Message-Id: <7c1d9505a90619764bc2f2a29fcfc9132a72e391.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the doc, 'media_entity_cleanup()' must be called after
unregistering the entity.
All places I've check do it that way.
So, move the call after 'v4l2_device_unregister_subdev()' as done
elsewhere.

Actually, this is not an issue, because 'media_entity_cleanup()' does
nothing, but it is more future proof.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The change from '&flash->sd.entity' to '&sd->entity' in the last hunk is
done because most of the drivers I've checked do it that way. Not sure if
it is correct. It looks logical to me and it can be compiled. That's all
I know.


If this patch is reviewed and confirmed, I'll propose similar fixes for
some other drivers.
---
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 1e5f516f6e50..b369b101abe7 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -902,11 +902,12 @@ static int lm3554_probe(struct i2c_client *client)
 		goto fail2;
 	}
 	return atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
+
 fail2:
-	media_entity_cleanup(&flash->sd.entity);
 	v4l2_ctrl_handler_free(&flash->ctrl_handler);
 fail1:
 	v4l2_device_unregister_subdev(&flash->sd);
+	media_entity_cleanup(&flash->sd.entity);
 	kfree(flash);
 
 	return err;
@@ -918,9 +919,9 @@ static int lm3554_remove(struct i2c_client *client)
 	struct lm3554 *flash = to_lm3554(sd);
 	int ret;
 
-	media_entity_cleanup(&flash->sd.entity);
 	v4l2_ctrl_handler_free(&flash->ctrl_handler);
 	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
 
 	atomisp_gmin_remove_subdev(sd);
 
-- 
2.17.0
