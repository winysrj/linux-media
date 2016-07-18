Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36248 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbcGROp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:45:56 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 1/6] radio: terratec: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:45:35 -0400
Message-Id: <7cf0d0cbfcaf6cb1e0538755ebec0096ac054f83.1468852798.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not do anything special in module init/exit. This patch
eliminates the module init/exit boilerplate code by utilizing the
module_isa_driver macro.

Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/media/radio/radio-terratec.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index be10a80..621bbb2 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -155,16 +155,4 @@ static struct radio_isa_driver terratec_driver = {
 	.max_volume = 10,
 };
 
-static int __init terratec_init(void)
-{
-	return isa_register_driver(&terratec_driver.driver, 1);
-}
-
-static void __exit terratec_exit(void)
-{
-	isa_unregister_driver(&terratec_driver.driver);
-}
-
-module_init(terratec_init);
-module_exit(terratec_exit);
-
+module_isa_driver(terratec_driver.driver, 1);
-- 
2.7.3

