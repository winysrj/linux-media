Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34225 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbcGROq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:46:26 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 3/6] radio: trust: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:46:19 -0400
Message-Id: <b3b5728928df22f7e35903a438b745c93a6425fb.1468852798.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not do anything special in module init/exit. This patch
eliminates the module init/exit boilerplate code by utilizing the
module_isa_driver macro.

Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/media/radio/radio-trust.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 26a8c60..e4bec5e 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -229,15 +229,4 @@ static struct radio_isa_driver trust_driver = {
 	.max_volume = 31,
 };
 
-static int __init trust_init(void)
-{
-	return isa_register_driver(&trust_driver.driver, TRUST_MAX);
-}
-
-static void __exit trust_exit(void)
-{
-	isa_unregister_driver(&trust_driver.driver);
-}
-
-module_init(trust_init);
-module_exit(trust_exit);
+module_isa_driver(trust_driver.driver, TRUST_MAX);
-- 
2.7.3

