Return-path: <linux-media-owner@vger.kernel.org>
Received: from fed1rmfepo101.cox.net ([68.230.241.143]:43244 "EHLO
	fed1rmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbbIUTIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 15:08:49 -0400
Received: from fed1rmimpo306 ([68.230.241.174]) by fed1rmfepo101.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150921190848.ZXUO18929.fed1rmfepo101.cox.net@fed1rmimpo306>
          for <linux-media@vger.kernel.org>;
          Mon, 21 Sep 2015 15:08:48 -0400
From: Eric Nelson <eric@nelint.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mchehab@osg.samsung.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, patrice.chotard@st.com, fabf@skynet.be,
	wsa@the-dreams.de, heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br, Eric Nelson <eric@nelint.com>
Subject: [PATCH V2 2/2] rc: gpio-ir-recv: add timeout on idle
Date: Mon, 21 Sep 2015 12:08:44 -0700
Message-Id: <1442862524-3694-3-git-send-email-eric@nelint.com>
In-Reply-To: <1442862524-3694-1-git-send-email-eric@nelint.com>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
 <1442862524-3694-1-git-send-email-eric@nelint.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many decoders require a trailing space (period without IR illumination)
to be delivered before completing a decode.

Since the gpio-ir-recv driver only delivers events on gpio transitions,
a single IR symbol (caused by a quick touch on an IR remote) will not
be properly decoded without the use of a timer to flush the tail end
state of the IR receiver.

This patch initializes and uses a timer and the timeout field of rcdev
to complete the stream and allow decode.

The timeout can be overridden through the use of the LIRC_SET_REC_TIMEOUT
ioctl.

Signed-off-by: Eric Nelson <eric@nelint.com>
---
 drivers/media/rc/gpio-ir-recv.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 7dbc9ca..d3b216a 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -30,6 +30,7 @@ struct gpio_rc_dev {
 	struct rc_dev *rcdev;
 	int gpio_nr;
 	bool active_low;
+	struct timer_list flush_timer;
 };
 
 #ifdef CONFIG_OF
@@ -93,12 +94,26 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	if (rc < 0)
 		goto err_get_value;
 
+	mod_timer(&gpio_dev->flush_timer,
+		  jiffies + nsecs_to_jiffies(gpio_dev->rcdev->timeout));
+
 	ir_raw_event_handle(gpio_dev->rcdev);
 
 err_get_value:
 	return IRQ_HANDLED;
 }
 
+static void flush_timer(unsigned long arg)
+{
+	struct gpio_rc_dev *gpio_dev = (struct gpio_rc_dev *)arg;
+	DEFINE_IR_RAW_EVENT(ev);
+
+	ev.timeout = true;
+	ev.duration =  gpio_dev->rcdev->timeout;
+	ir_raw_event_store(gpio_dev->rcdev, &ev);
+	ir_raw_event_handle(gpio_dev->rcdev);
+}
+
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev;
@@ -144,6 +159,9 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.version = 0x0100;
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
+	rcdev->min_timeout = 1;
+	rcdev->timeout = IR_DEFAULT_TIMEOUT;
+	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	if (pdata->allowed_protos)
 		rcdev->allowed_protocols = pdata->allowed_protos;
 	else
@@ -154,6 +172,10 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	gpio_dev->gpio_nr = pdata->gpio_nr;
 	gpio_dev->active_low = pdata->active_low;
 
+	init_timer(&gpio_dev->flush_timer);
+	gpio_dev->flush_timer.function = flush_timer;
+	gpio_dev->flush_timer.data = (unsigned long)gpio_dev;
+
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
 		goto err_gpio_request;
-- 
2.5.2

