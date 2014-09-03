Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 34/46] [media] siano: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:06 -0300
Message-Id: <69be89802adaea64bbba12ace3e7bab9db70b465.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 050984c5b1e3..a3677438205e 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -2129,8 +2129,6 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 
 static int __init smscore_module_init(void)
 {
-	int rc = 0;
-
 	INIT_LIST_HEAD(&g_smscore_notifyees);
 	INIT_LIST_HEAD(&g_smscore_devices);
 	kmutex_init(&g_smscore_deviceslock);
@@ -2138,7 +2136,7 @@ static int __init smscore_module_init(void)
 	INIT_LIST_HEAD(&g_smscore_registry);
 	kmutex_init(&g_smscore_registrylock);
 
-	return rc;
+	return 0;
 }
 
 static void __exit smscore_module_exit(void)
-- 
1.9.3

