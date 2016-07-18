Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36303 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbcGROqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:46:15 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 2/6] radio: rtrack2: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:46:07 -0400
Message-Id: <b44e4729975e4f8e9310ca1259f3945e857d168f.1468852798.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not do anything special in module init/exit. This patch
eliminates the module init/exit boilerplate code by utilizing the
module_isa_driver macro.

Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/media/radio/radio-rtrack2.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index 09cfbc3..82b8794 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -127,15 +127,4 @@ static struct radio_isa_driver rtrack2_driver = {
 	.has_stereo = true,
 };
 
-static int __init rtrack2_init(void)
-{
-	return isa_register_driver(&rtrack2_driver.driver, RTRACK2_MAX);
-}
-
-static void __exit rtrack2_exit(void)
-{
-	isa_unregister_driver(&rtrack2_driver.driver);
-}
-
-module_init(rtrack2_init);
-module_exit(rtrack2_exit);
+module_isa_driver(rtrack2_driver.driver, RTRACK2_MAX);
-- 
2.7.3

