Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36853 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcGROrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:47:24 -0400
From: William Breathitt Gray <vilhelm.gray@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6/6] radio: aimslab: Utilize the module_isa_driver macro
Date: Mon, 18 Jul 2016 10:47:17 -0400
Message-Id: <8f4ded054bbf7dcc49f87a7ba8464e6baeb328e4.1468852798.git.vilhelm.gray@gmail.com>
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
 drivers/media/radio/radio-aimslab.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index ea930879..d1566a3 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -180,15 +180,4 @@ static struct radio_isa_driver rtrack_driver = {
 	.max_volume = 0xff,
 };
 
-static int __init rtrack_init(void)
-{
-	return isa_register_driver(&rtrack_driver.driver, RTRACK_MAX);
-}
-
-static void __exit rtrack_exit(void)
-{
-	isa_unregister_driver(&rtrack_driver.driver);
-}
-
-module_init(rtrack_init);
-module_exit(rtrack_exit);
+module_isa_driver(rtrack_driver.driver, RTRACK_MAX);
-- 
2.7.3

