Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:42215
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751874AbbFASrV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 14:47:21 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] radio-si470x-i2c: Pass the IRQF_ONESHOT flag
Date: Mon, 1 Jun 2015 14:14:07 -0300
Message-ID: <1433178847-19850-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 1c6c69525b40 ("genirq: Reject bogus threaded irq requests")
threaded IRQs without a primary handler need to be requested with
IRQF_ONESHOT, otherwise the request will fail.

So pass the IRQF_ONESHOT flag in this case.

The semantic patch that makes this change is available
in scripts/coccinelle/misc/irqf_oneshot.cocci.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 2a497c8..49fe845 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -421,7 +421,8 @@ static int si470x_i2c_probe(struct i2c_client *client,
 	init_waitqueue_head(&radio->read_queue);
 
 	retval = request_threaded_irq(client->irq, NULL, si470x_i2c_interrupt,
-			IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);
+			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, DRIVER_NAME,
+			radio);
 	if (retval) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
 		goto err_rds;
-- 
1.9.1

