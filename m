Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58202 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932117AbdIYIC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 04:02:59 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-gpio: don't generate spurious HPD events
Message-ID: <2348ff8e-19e4-2917-f3b5-2f23a22b7809@xs4all.nl>
Date: Mon, 25 Sep 2017 10:02:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only send HPD_LOW/HIGH event if the gpio actually changed value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/cec-gpio/cec-gpio.c b/drivers/media/platform/cec-gpio/cec-gpio.c
index 548c9dffec73..4a96856f8b36 100644
--- a/drivers/media/platform/cec-gpio/cec-gpio.c
+++ b/drivers/media/platform/cec-gpio/cec-gpio.c
@@ -80,9 +80,12 @@ static irqreturn_t cec_hpd_gpio_irq_handler_thread(int irq, void *priv)
 static irqreturn_t cec_hpd_gpio_irq_handler(int irq, void *priv)
 {
 	struct cec_gpio *cec = priv;
+	bool is_high = gpiod_get_value(cec->hpd_gpio);

+	if (is_high == cec->hpd_is_high)
+		return IRQ_HANDLED;
 	cec->hpd_ts = ktime_get();
-	cec->hpd_is_high = gpiod_get_value(cec->hpd_gpio);
+	cec->hpd_is_high = is_high;
 	return IRQ_WAKE_THREAD;
 }
