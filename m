Return-path: <linux-media-owner@vger.kernel.org>
Received: from zose-mta12.web4all.fr ([178.33.204.89]:47701 "EHLO
	zose-mta12.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2FRTDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:03:39 -0400
Date: Mon, 18 Jun 2012 21:02:20 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?=
	<benoit.thebaudeau@advansee.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	linux-media@vger.kernel.org
Message-ID: <658568472.2884466.1340046140263.JavaMail.root@advansee.com>
Subject: [PATCH 1 of 3] media: gpio-ir-recv: fix missing udev by-path entry
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing information so that udev can create an entry for gpio-ir-recv under
/dev/input/by-path/ .

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
---
 .../drivers/media/rc/gpio-ir-recv.c                |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
index 0d87545..b41e13c 100644
--- linux-next-HEAD-6c86b58.orig/drivers/media/rc/gpio-ir-recv.c
+++ linux-next-HEAD-6c86b58/drivers/media/rc/gpio-ir-recv.c
@@ -82,10 +82,16 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 		goto err_allocate_device;
 	}
 
+	rcdev->priv = gpio_dev;
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
 	rcdev->allowed_protos = RC_TYPE_ALL;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
+	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
+	rcdev->input_id.vendor = 0x0001;
+	rcdev->input_id.product = 0x0001;
+	rcdev->input_id.version = 0x0100;
+	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
 	rcdev->map_name = RC_MAP_EMPTY;
 
