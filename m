Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:42669 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751268AbcHXIt6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 04:49:58 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@atmel.com>, <hverkuil@xs4all.nl>
CC: Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [RESEND PATCH] [media] atmel-isc: remove the warning
Date: Wed, 24 Aug 2016 16:49:28 +0800
Message-ID: <1472028568-19323-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the 'IS_ERR_VALUE(irq)' with 'ret < 0' in
function 'atmel_isc_probe'.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index f0c2512..db6773d 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1358,7 +1358,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (IS_ERR_VALUE(irq)) {
+	if (irq < 0) {
 		ret = irq;
 		dev_err(dev, "failed to get irq: %d\n", ret);
 		return ret;
-- 
2.7.4

