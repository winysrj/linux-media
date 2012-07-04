Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2GDGpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 02:45:35 -0400
Received: by pbbrp8 with SMTP id rp8so10562233pbb.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2012 23:45:34 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, mchehab@infradead.org,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-tv: Use module_i2c_driver in sii9234_drv.c file
Date: Wed,  4 Jul 2012 12:03:15 +0530
Message-Id: <1341383595-4386-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

module_i2c_driver makes the code simpler by eliminating module_init
and module_exit calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/sii9234_drv.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/video/s5p-tv/sii9234_drv.c
index 0f31ecc..6d348f9 100644
--- a/drivers/media/video/s5p-tv/sii9234_drv.c
+++ b/drivers/media/video/s5p-tv/sii9234_drv.c
@@ -419,14 +419,4 @@ static struct i2c_driver sii9234_driver = {
 	.id_table = sii9234_id,
 };
 
-static int __init sii9234_init(void)
-{
-	return i2c_add_driver(&sii9234_driver);
-}
-module_init(sii9234_init);
-
-static void __exit sii9234_exit(void)
-{
-	i2c_del_driver(&sii9234_driver);
-}
-module_exit(sii9234_exit);
+module_i2c_driver(sii9234_driver);
-- 
1.7.4.1

