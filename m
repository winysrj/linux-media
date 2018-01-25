Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39578 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbeAYHfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 02:35:13 -0500
From: Akash Gajjar <gajjar04akash@gmail.com>
Cc: gajjar04akash@gmail.com, Akash Gajjar <Akash_Gajjar@mentor.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: leds: as3645a: Add CONFIG_OF support
Date: Thu, 25 Jan 2018 13:04:36 +0530
Message-Id: <1516865677-16006-1-git-send-email-gajjar04akash@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akash Gajjar <Akash_Gajjar@mentor.com>

Witth this changes, the driver builds with CONFIG_OF support

Signed-off-by: Akash Gajjar <gajjar04akash@gmail.com>
---
 drivers/media/i2c/as3645a.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index af5db71..24233fa 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -858,6 +858,14 @@ static int as3645a_remove(struct i2c_client *client)
 };
 MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id as3645a_of_match[] = {
+	{ .compatible = "ams,as3645a", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, as3645a_of_match);
+#endif
+
 static const struct dev_pm_ops as3645a_pm_ops = {
 	.suspend = as3645a_suspend,
 	.resume = as3645a_resume,
@@ -867,6 +875,7 @@ static int as3645a_remove(struct i2c_client *client)
 	.driver	= {
 		.name = AS3645A_NAME,
 		.pm   = &as3645a_pm_ops,
+		.of_match_table = of_match_ptr(as3645a_of_match),
 	},
 	.probe	= as3645a_probe,
 	.remove	= as3645a_remove,
-- 
1.9.1
