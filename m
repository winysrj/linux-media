Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta12.web4all.fr ([178.33.204.89]:47805 "EHLO
	zose-mta12.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2FRTIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:08:39 -0400
Date: Mon, 18 Jun 2012 21:03:06 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	linux-media@vger.kernel.org
Message-ID: <659567571.2884478.1340046186135.JavaMail.root@advansee.com>
Subject: [PATCH 3 of 3] media: gpio-ir-recv: switch to
 module_platform_driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/media/rc/gpio-ir-recv.c                |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
index 15e346e..59fe60c 100644
--- linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c
+++ linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
@@ -194,18 +194,7 @@ static struct platform_driver gpio_ir_recv_driver = {
 #endif
 	},
 };
-
-static int __init gpio_ir_recv_init(void)
-{
-	return platform_driver_register(&gpio_ir_recv_driver);
-}
-module_init(gpio_ir_recv_init);
-
-static void __exit gpio_ir_recv_exit(void)
-{
-	platform_driver_unregister(&gpio_ir_recv_driver);
-}
-module_exit(gpio_ir_recv_exit);
+module_platform_driver(gpio_ir_recv_driver);
 
 MODULE_DESCRIPTION("GPIO IR Receiver driver");
 MODULE_LICENSE("GPL v2");
