Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42465 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3HDWTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Aug 2013 18:19:01 -0400
Date: Mon, 5 Aug 2013 00:11:23 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] [media] winbond: wire up rc feedback led
Message-ID: <20130804221123.GB28343@hardeman.nu>
References: <1375225204-5082-1-git-send-email-sean@mess.org>
 <1375225204-5082-4-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375225204-5082-4-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 31, 2013 at 12:00:03AM +0100, Sean Young wrote:
>Note that with the rc-feedback trigger, the cir-rx trigger is now
>redundant. The cir-tx trigger is not used by default; if this
>functionality is desired then it should exist in rc-core, not in
>a driver.
>
>Also make sure that the led is suspended on suspend.
>
>Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: David Härdeman <david@hardeman.nu>

>---
> drivers/media/rc/Kconfig       |  1 -
> drivers/media/rc/winbond-cir.c | 38 ++++++--------------------------------
> 2 files changed, 6 insertions(+), 33 deletions(-)
>
>diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>index 5a79c33..7fa6b22 100644
>--- a/drivers/media/rc/Kconfig
>+++ b/drivers/media/rc/Kconfig
>@@ -248,7 +248,6 @@ config IR_WINBOND_CIR
> 	depends on RC_CORE
> 	select NEW_LEDS
> 	select LEDS_CLASS
>-	select LEDS_TRIGGERS
> 	select BITREVERSE
> 	---help---
> 	   Say Y here if you want to use the IR remote functionality found
>diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
>index 87af2d3..98bd496 100644
>--- a/drivers/media/rc/winbond-cir.c
>+++ b/drivers/media/rc/winbond-cir.c
>@@ -213,13 +213,11 @@ struct wbcir_data {
> 
> 	/* RX state */
> 	enum wbcir_rxstate rxstate;
>-	struct led_trigger *rxtrigger;
> 	int carrier_report_enabled;
> 	u32 pulse_duration;
> 
> 	/* TX state */
> 	enum wbcir_txstate txstate;
>-	struct led_trigger *txtrigger;
> 	u32 txlen;
> 	u32 txoff;
> 	u32 *txbuf;
>@@ -366,14 +364,11 @@ wbcir_idle_rx(struct rc_dev *dev, bool idle)
> {
> 	struct wbcir_data *data = dev->priv;
> 
>-	if (!idle && data->rxstate == WBCIR_RXSTATE_INACTIVE) {
>+	if (!idle && data->rxstate == WBCIR_RXSTATE_INACTIVE)
> 		data->rxstate = WBCIR_RXSTATE_ACTIVE;
>-		led_trigger_event(data->rxtrigger, LED_FULL);
>-	}
> 
> 	if (idle && data->rxstate != WBCIR_RXSTATE_INACTIVE) {
> 		data->rxstate = WBCIR_RXSTATE_INACTIVE;
>-		led_trigger_event(data->rxtrigger, LED_OFF);
> 
> 		if (data->carrier_report_enabled)
> 			wbcir_carrier_report(data);
>@@ -425,7 +420,6 @@ wbcir_irq_tx(struct wbcir_data *data)
> 	case WBCIR_TXSTATE_INACTIVE:
> 		/* TX FIFO empty */
> 		space = 16;
>-		led_trigger_event(data->txtrigger, LED_FULL);
> 		break;
> 	case WBCIR_TXSTATE_ACTIVE:
> 		/* TX FIFO low (3 bytes or less) */
>@@ -464,7 +458,6 @@ wbcir_irq_tx(struct wbcir_data *data)
> 			/* Clear TX underrun bit */
> 			outb(WBCIR_TX_UNDERRUN, data->sbase + WBCIR_REG_SP3_ASCR);
> 		wbcir_set_irqmask(data, WBCIR_IRQ_RX | WBCIR_IRQ_ERR);
>-		led_trigger_event(data->txtrigger, LED_OFF);
> 		kfree(data->txbuf);
> 		data->txbuf = NULL;
> 		data->txstate = WBCIR_TXSTATE_INACTIVE;
>@@ -878,15 +871,13 @@ finish:
> 	 */
> 	wbcir_set_irqmask(data, WBCIR_IRQ_NONE);
> 	disable_irq(data->irq);
>-
>-	/* Disable LED */
>-	led_trigger_event(data->rxtrigger, LED_OFF);
>-	led_trigger_event(data->txtrigger, LED_OFF);
> }
> 
> static int
> wbcir_suspend(struct pnp_dev *device, pm_message_t state)
> {
>+	struct wbcir_data *data = pnp_get_drvdata(device);
>+	led_classdev_suspend(&data->led);
> 	wbcir_shutdown(device);
> 	return 0;
> }
>@@ -1015,6 +1006,7 @@ wbcir_resume(struct pnp_dev *device)
> 
> 	wbcir_init_hw(data);
> 	enable_irq(data->irq);
>+	led_classdev_resume(&data->led);
> 
> 	return 0;
> }
>@@ -1058,25 +1050,13 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
> 		"(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
> 		data->wbase, data->ebase, data->sbase, data->irq);
> 
>-	led_trigger_register_simple("cir-tx", &data->txtrigger);
>-	if (!data->txtrigger) {
>-		err = -ENOMEM;
>-		goto exit_free_data;
>-	}
>-
>-	led_trigger_register_simple("cir-rx", &data->rxtrigger);
>-	if (!data->rxtrigger) {
>-		err = -ENOMEM;
>-		goto exit_unregister_txtrigger;
>-	}
>-
> 	data->led.name = "cir::activity";
>-	data->led.default_trigger = "cir-rx";
>+	data->led.default_trigger = "rc-feedback";
> 	data->led.brightness_set = wbcir_led_brightness_set;
> 	data->led.brightness_get = wbcir_led_brightness_get;
> 	err = led_classdev_register(&device->dev, &data->led);
> 	if (err)
>-		goto exit_unregister_rxtrigger;
>+		goto exit_free_data;
> 
> 	data->dev = rc_allocate_device();
> 	if (!data->dev) {
>@@ -1156,10 +1136,6 @@ exit_free_rc:
> 	rc_free_device(data->dev);
> exit_unregister_led:
> 	led_classdev_unregister(&data->led);
>-exit_unregister_rxtrigger:
>-	led_trigger_unregister_simple(data->rxtrigger);
>-exit_unregister_txtrigger:
>-	led_trigger_unregister_simple(data->txtrigger);
> exit_free_data:
> 	kfree(data);
> 	pnp_set_drvdata(device, NULL);
>@@ -1187,8 +1163,6 @@ wbcir_remove(struct pnp_dev *device)
> 
> 	rc_unregister_device(data->dev);
> 
>-	led_trigger_unregister_simple(data->rxtrigger);
>-	led_trigger_unregister_simple(data->txtrigger);
> 	led_classdev_unregister(&data->led);
> 
> 	/* This is ok since &data->led isn't actually used */
>-- 
>1.8.3.1
>

-- 
David Härdeman
