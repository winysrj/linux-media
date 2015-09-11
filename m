Return-path: <linux-media-owner@vger.kernel.org>
Received: from fed1rmfepo102.cox.net ([68.230.241.144]:36396 "EHLO
	fed1rmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbIKOA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:00:29 -0400
Received: from fed1rmimpo209 ([68.230.241.160]) by fed1rmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150911140028.JYEZ19282.fed1rmfepo102.cox.net@fed1rmimpo209>
          for <linux-media@vger.kernel.org>;
          Fri, 11 Sep 2015 10:00:28 -0400
From: Eric Nelson <eric@nelint.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mchehab@osg.samsung.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, patrice.chotard@st.com, fabf@skynet.be,
	wsa@the-dreams.de, heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br, Eric Nelson <eric@nelint.com>
Subject: [PATCH][resend] rc: gpio-ir-recv: allow flush space on idle
Date: Fri, 11 Sep 2015 07:00:24 -0700
Message-Id: <1441980024-1944-1-git-send-email-eric@nelint.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many decoders require a trailing space (period without IR illumination)
to be delivered before completing a decode.

Since the gpio-ir-recv driver only delivers events on gpio transitions,
a single IR symbol (caused by a quick touch on an IR remote) will not
be properly decoded without the use of a timer to flush the tail end
state of the IR receiver.

This patch adds an optional device tree node "flush-ms" which, if
present, will use a jiffie-based timer to complete the last pulse
stream and allow decode.

The "flush-ms" value should be chosen with a value that will convert
well to jiffies (multiples of 10 are good).

Signed-off-by: Eric Nelson <eric@nelint.com>
---
Re-sending with expanded CC list.

 .../devicetree/bindings/media/gpio-ir-receiver.txt |  1 +
 drivers/media/rc/gpio-ir-recv.c                    | 39 ++++++++++++++++++----
 include/media/gpio-ir-recv.h                       |  1 +
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
index 56e726e..13ff92d 100644
--- a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
+++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
@@ -6,6 +6,7 @@ Required properties:
 
 Optional properties:
 	- linux,rc-map-name: Linux specific remote control map name.
+	- flush-ms: time for final flush of 'space' pulse (period with no IR)
 
 Example node:
 
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 7dbc9ca..e3c353e 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -29,7 +29,9 @@
 struct gpio_rc_dev {
 	struct rc_dev *rcdev;
 	int gpio_nr;
+	int flush_jiffies;
 	bool active_low;
+	struct timer_list flush_timer;
 };
 
 #ifdef CONFIG_OF
@@ -42,6 +44,7 @@ static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
 	struct device_node *np = dev->of_node;
 	enum of_gpio_flags flags;
 	int gpio;
+	u32 flush_ms = 0;
 
 	gpio = of_get_gpio_flags(np, 0, &flags);
 	if (gpio < 0) {
@@ -50,6 +53,9 @@ static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
 		return gpio;
 	}
 
+	of_property_read_u32(np, "flush-ms", &flush_ms);
+	pdata->flush_jiffies = msecs_to_jiffies(flush_ms);
+
 	pdata->gpio_nr = gpio;
 	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW);
 	/* probe() takes care of map_name == NULL or allowed_protos == 0 */
@@ -71,9 +77,8 @@ MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
 
 #endif
 
-static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
+static void flush_gp(struct gpio_rc_dev *gpio_dev)
 {
-	struct gpio_rc_dev *gpio_dev = dev_id;
 	int gval;
 	int rc = 0;
 	enum raw_event_type type = IR_SPACE;
@@ -81,7 +86,7 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	gval = gpio_get_value(gpio_dev->gpio_nr);
 
 	if (gval < 0)
-		goto err_get_value;
+		return;
 
 	if (gpio_dev->active_low)
 		gval = !gval;
@@ -90,15 +95,30 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 		type = IR_PULSE;
 
 	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
-	if (rc < 0)
-		goto err_get_value;
+	if (rc >= 0)
+		ir_raw_event_handle(gpio_dev->rcdev);
+}
 
-	ir_raw_event_handle(gpio_dev->rcdev);
+static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
+{
+	struct gpio_rc_dev *gpio_dev = dev_id;
+
+	flush_gp(gpio_dev);
+
+	if (gpio_dev->flush_jiffies)
+		mod_timer(&gpio_dev->flush_timer,
+			  jiffies + gpio_dev->flush_jiffies);
 
-err_get_value:
 	return IRQ_HANDLED;
 }
 
+static void flush_timer(unsigned long arg)
+{
+	struct gpio_rc_dev *gpio_dev = (struct gpio_rc_dev *)arg;
+
+	flush_gp(gpio_dev);
+}
+
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev;
@@ -152,8 +172,13 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	gpio_dev->rcdev = rcdev;
 	gpio_dev->gpio_nr = pdata->gpio_nr;
+	gpio_dev->flush_jiffies = pdata->flush_jiffies;
 	gpio_dev->active_low = pdata->active_low;
 
+	init_timer(&gpio_dev->flush_timer);
+	gpio_dev->flush_timer.function = flush_timer;
+	gpio_dev->flush_timer.data = (unsigned long)gpio_dev;
+
 	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
 	if (rc < 0)
 		goto err_gpio_request;
diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
index 0142736..88fae78 100644
--- a/include/media/gpio-ir-recv.h
+++ b/include/media/gpio-ir-recv.h
@@ -17,6 +17,7 @@ struct gpio_ir_recv_platform_data {
 	int		gpio_nr;
 	bool		active_low;
 	u64		allowed_protos;
+	int		flush_jiffies;
 	const char	*map_name;
 };
 
-- 
2.5.1

