Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3KBQdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:38 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 09/29] radio-si470x-i2c: fix a warning on ia64
Date: Sat,  2 Nov 2013 11:31:17 -0200
Message-Id: <1383399097-11615-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

on ia64, those warnings appear:
	drivers/media/radio/si470x/radio-si470x-i2c.c:470:12: warning: 'si470x_i2c_suspend' defined but not used [-Wunused-function]
	drivers/media/radio/si470x/radio-si470x-i2c.c:487:12: warning: 'si470x_i2c_resume' defined but not used [-Wunused-function]

They're caused because the PM logic uses this define:
	#define SET_SYSTEM_SLEEP_PM_OPS()

With is only defined for CONFIG_PM_SLEEP.

So, change the logic there to test for CONFIG_PM_SLEEP, instead of
CONFIG_PM.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index e5fc9acd0c4f..2a497c80c77f 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -463,7 +463,7 @@ static int si470x_i2c_remove(struct i2c_client *client)
 }
 
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * si470x_i2c_suspend - suspend the device
  */
@@ -509,7 +509,7 @@ static struct i2c_driver si470x_i2c_driver = {
 	.driver = {
 		.name		= "si470x",
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 		.pm		= &si470x_i2c_pm,
 #endif
 	},
-- 
1.8.3.1

