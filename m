Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36674 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbcGROqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:46:37 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 4/6] radio: zoltrix: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:46:30 -0400
Message-Id: <f2ba4f4c519bcb59b30e5d895ea7230c73bdbdd2.1468852798.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not do anything special in module init/exit. This patch
eliminates the module init/exit boilerplate code by utilizing the
module_isa_driver macro.

Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/media/radio/radio-zoltrix.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index 026e88e..597da26 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -233,16 +233,4 @@ static struct radio_isa_driver zoltrix_driver = {
 	.max_volume = 15,
 };
 
-static int __init zoltrix_init(void)
-{
-	return isa_register_driver(&zoltrix_driver.driver, ZOLTRIX_MAX);
-}
-
-static void __exit zoltrix_exit(void)
-{
-	isa_unregister_driver(&zoltrix_driver.driver);
-}
-
-module_init(zoltrix_init);
-module_exit(zoltrix_exit);
-
+module_isa_driver(zoltrix_driver.driver, ZOLTRIX_MAX);
-- 
2.7.3

