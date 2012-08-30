Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:47175 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2H3Rye (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 13:54:34 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCHv3 3/9] ir-rx51: Trivial fixes
Date: Thu, 30 Aug 2012 20:54:25 +0300
Message-Id: <1346349271-28073-4-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-Fix typo

-Change pwm_timer_num type to match type in platform data

-Remove extra parenthesis

-Replace magic constant with proper bit defintions

-Remove duplicate exit pointer

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/Kconfig   |  2 +-
 drivers/media/rc/ir-rx51.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 093982b..4a68014 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -278,7 +278,7 @@ config IR_RX51
 	   Say Y or M here if you want to enable support for the IR
 	   transmitter diode built in the Nokia N900 (RX51) device.
 
-	   The driver uses omap DM timers for gereating the carrier
+	   The driver uses omap DM timers for generating the carrier
 	   wave and pulses.
 
 config RC_LOOPBACK
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index e2db94e..125d4c3 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -59,7 +59,7 @@ struct lirc_rx51 {
 	int		wbuf[WBUF_LEN];
 	int		wbuf_index;
 	unsigned long	device_is_open;
-	unsigned int	pwm_timer_num;
+	int		pwm_timer_num;
 };
 
 static void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
@@ -138,11 +138,14 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
 	if (!retval)
 		return IRQ_NONE;
 
-	if ((retval & ~OMAP_TIMER_INT_MATCH))
+	if (retval & ~OMAP_TIMER_INT_MATCH)
 		dev_err_ratelimited(lirc_rx51->dev,
 				": Unexpected interrupt source: %x\n", retval);
 
-	omap_dm_timer_write_status(lirc_rx51->pulse_timer, 7);
+	omap_dm_timer_write_status(lirc_rx51->pulse_timer,
+				OMAP_TIMER_INT_MATCH	|
+				OMAP_TIMER_INT_OVERFLOW	|
+				OMAP_TIMER_INT_CAPTURE);
 	if (lirc_rx51->wbuf_index < 0) {
 		dev_err_ratelimited(lirc_rx51->dev,
 				": BUG wbuf_index has value of %i\n",
@@ -489,7 +492,6 @@ struct platform_driver lirc_rx51_platform_driver = {
 	.remove		= __exit_p(lirc_rx51_remove),
 	.suspend	= lirc_rx51_suspend,
 	.resume		= lirc_rx51_resume,
-	.remove		= __exit_p(lirc_rx51_remove),
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
-- 
1.7.12

