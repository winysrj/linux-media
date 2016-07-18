Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35586 "EHLO
	mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcGROrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:47:19 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5/6] radio: aztech: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:46:42 -0400
Message-Id: <1d95eda3b0cc95932ee74bb1d027d5ec21efbadc.1468852798.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1468852798.git.vilhelm.gray@gmail.com>
References: <cover.1468852798.git.vilhelm.gray@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not do anything special in module init/exit. This patch
eliminates the module init/exit boilerplate code by utilizing the
module_isa_driver macro.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/media/radio/radio-aztech.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 705dd6f..7b39655 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -147,15 +147,4 @@ static struct radio_isa_driver aztech_driver = {
 	.max_volume = 3,
 };
 
-static int __init aztech_init(void)
-{
-	return isa_register_driver(&aztech_driver.driver, AZTECH_MAX);
-}
-
-static void __exit aztech_exit(void)
-{
-	isa_unregister_driver(&aztech_driver.driver);
-}
-
-module_init(aztech_init);
-module_exit(aztech_exit);
+module_isa_driver(aztech_driver.driver, AZTECH_MAX);
-- 
2.7.3

