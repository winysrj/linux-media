Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta-15.w4a.fr ([176.31.217.10]:60629 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464Ab2FRTFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:05:31 -0400
Date: Mon, 18 Jun 2012 21:02:44 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	linux-media@vger.kernel.org
Message-ID: <1213929032.2884470.1340046164433.JavaMail.root@advansee.com>
Subject: [PATCH 2 of 3] media: gpio-ir-recv: add map name
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make it possible for gpio-ir-recv users to choose a map name.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/media/rc/gpio-ir-recv.c                |    2 +-
 .../include/media/gpio-ir-recv.h                   |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
index b41e13c..15e346e 100644
--- linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c
+++ linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
@@ -93,7 +93,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.version = 0x0100;
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
-	rcdev->map_name = RC_MAP_EMPTY;
+	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
 	gpio_dev->gpio_nr = pdata->gpio_nr;
diff --git linux-next-HEAD-6c86b58.orig/include/media/gpio-ir-recv.h linux-next-HEAD-6c86b58/include/media/gpio-ir-recv.h
index 67797bf..91546f3 100644
--- linux-next-HEAD-6c86b58.orig/include/media/gpio-ir-recv.h
+++ linux-next-HEAD-6c86b58/include/media/gpio-ir-recv.h
@@ -16,6 +16,7 @@
 struct gpio_ir_recv_platform_data {
 	int gpio_nr;
 	bool active_low;
+	const char *map_name;
 };
 
 #endif /* __GPIO_IR_RECV_H__ */
