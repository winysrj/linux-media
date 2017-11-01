Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:48465 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754260AbdKAL6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 07:58:24 -0400
Received: by mail-wm0-f66.google.com with SMTP id p75so4307808wmg.3
        for <linux-media@vger.kernel.org>; Wed, 01 Nov 2017 04:58:23 -0700 (PDT)
Date: Wed, 1 Nov 2017 12:58:21 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [PATCH] media: rc: remove ir-rx51 in favour of generic pwm-ir-tx
Message-ID: <20171101115821.anem4aatlruks2in@pali>
References: <20171101115533.14418-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171101115533.14418-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 01 November 2017 11:55:33 Sean Young wrote:
> The ir-rx51 is a pwm-based TX driver specific to the n900. This can be
> handled entirely by the generic pwm-ir-tx driver.
> 
> Note that the suspend code in the ir-rx51 driver is unnecessary, since
> during transmit, the current process is not in interruptable sleep. The
> process is not put to sleep until the transmit completes.

Hello, have you tested this patch that IR transmitter is still working
fine on the real Nokia N900 device?

> Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Cc: Pali Rohár <pali.rohar@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  arch/arm/boot/dts/omap3-n900.dts |   2 +-
>  drivers/media/rc/Kconfig         |  10 --
>  drivers/media/rc/Makefile        |   1 -
>  drivers/media/rc/ir-rx51.c       | 316 ---------------------------------------
>  4 files changed, 1 insertion(+), 328 deletions(-)
>  delete mode 100644 drivers/media/rc/ir-rx51.c
> 
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 4acd32a1c4ef..fccd2b119c0a 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -152,7 +152,7 @@
>  	};
>  
>  	ir: n900-ir {
> -		compatible = "nokia,n900-ir";
> +		compatible = "pwm-ir-tx";
>  		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
>  	};
>  
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 0f863822889e..354ee5224758 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -353,16 +353,6 @@ config IR_TTUSBIR
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called ttusbir.
>  
> -config IR_RX51
> -	tristate "Nokia N900 IR transmitter diode"
> -	depends on (OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS || COMPILE_TEST) && RC_CORE
> -	---help---
> -	   Say Y or M here if you want to enable support for the IR
> -	   transmitter diode built in the Nokia N900 (RX51) device.
> -
> -	   The driver uses omap DM timers for generating the carrier
> -	   wave and pulses.
> -
>  source "drivers/media/rc/img-ir/Kconfig"
>  
>  config RC_LOOPBACK
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index a1ef86767aef..59b99a2dc2d4 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -25,7 +25,6 @@ obj-$(CONFIG_IR_MESON) += meson-ir.o
>  obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
>  obj-$(CONFIG_IR_ENE) += ene_ir.o
>  obj-$(CONFIG_IR_REDRAT3) += redrat3.o
> -obj-$(CONFIG_IR_RX51) += ir-rx51.o
>  obj-$(CONFIG_IR_SPI) += ir-spi.o
>  obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
>  obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> deleted file mode 100644
> index 49265f02e772..000000000000
> --- a/drivers/media/rc/ir-rx51.c
> +++ /dev/null
> @@ -1,316 +0,0 @@
> -/*
> - *  Copyright (C) 2008 Nokia Corporation
> - *
> - *  Based on lirc_serial.c
> - *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation; either version 2 of the License, or
> - *  (at your option) any later version.
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - */
> -#include <linux/clk.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/wait.h>
> -#include <linux/pwm.h>
> -#include <linux/of.h>
> -#include <linux/hrtimer.h>
> -
> -#include <media/rc-core.h>
> -#include <linux/platform_data/media/ir-rx51.h>
> -
> -#define WBUF_LEN 256
> -
> -struct ir_rx51 {
> -	struct rc_dev *rcdev;
> -	struct pwm_device *pwm;
> -	struct hrtimer timer;
> -	struct device	     *dev;
> -	struct ir_rx51_platform_data *pdata;
> -	wait_queue_head_t     wqueue;
> -
> -	unsigned int	freq;		/* carrier frequency */
> -	unsigned int	duty_cycle;	/* carrier duty cycle */
> -	int		wbuf[WBUF_LEN];
> -	int		wbuf_index;
> -	unsigned long	device_is_open;
> -};
> -
> -static inline void ir_rx51_on(struct ir_rx51 *ir_rx51)
> -{
> -	pwm_enable(ir_rx51->pwm);
> -}
> -
> -static inline void ir_rx51_off(struct ir_rx51 *ir_rx51)
> -{
> -	pwm_disable(ir_rx51->pwm);
> -}
> -
> -static int init_timing_params(struct ir_rx51 *ir_rx51)
> -{
> -	struct pwm_device *pwm = ir_rx51->pwm;
> -	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, ir_rx51->freq);
> -
> -	duty = DIV_ROUND_CLOSEST(ir_rx51->duty_cycle * period, 100);
> -
> -	pwm_config(pwm, duty, period);
> -
> -	return 0;
> -}
> -
> -static enum hrtimer_restart ir_rx51_timer_cb(struct hrtimer *timer)
> -{
> -	struct ir_rx51 *ir_rx51 = container_of(timer, struct ir_rx51, timer);
> -	ktime_t now;
> -
> -	if (ir_rx51->wbuf_index < 0) {
> -		dev_err_ratelimited(ir_rx51->dev,
> -				    "BUG wbuf_index has value of %i\n",
> -				    ir_rx51->wbuf_index);
> -		goto end;
> -	}
> -
> -	/*
> -	 * If we happen to hit an odd latency spike, loop through the
> -	 * pulses until we catch up.
> -	 */
> -	do {
> -		u64 ns;
> -
> -		if (ir_rx51->wbuf_index >= WBUF_LEN)
> -			goto end;
> -		if (ir_rx51->wbuf[ir_rx51->wbuf_index] == -1)
> -			goto end;
> -
> -		if (ir_rx51->wbuf_index % 2)
> -			ir_rx51_off(ir_rx51);
> -		else
> -			ir_rx51_on(ir_rx51);
> -
> -		ns = US_TO_NS(ir_rx51->wbuf[ir_rx51->wbuf_index]);
> -		hrtimer_add_expires_ns(timer, ns);
> -
> -		ir_rx51->wbuf_index++;
> -
> -		now = timer->base->get_time();
> -
> -	} while (hrtimer_get_expires_tv64(timer) < now);
> -
> -	return HRTIMER_RESTART;
> -end:
> -	/* Stop TX here */
> -	ir_rx51_off(ir_rx51);
> -	ir_rx51->wbuf_index = -1;
> -
> -	wake_up_interruptible(&ir_rx51->wqueue);
> -
> -	return HRTIMER_NORESTART;
> -}
> -
> -static int ir_rx51_tx(struct rc_dev *dev, unsigned int *buffer,
> -		      unsigned int count)
> -{
> -	struct ir_rx51 *ir_rx51 = dev->priv;
> -
> -	if (count > WBUF_LEN)
> -		return -EINVAL;
> -
> -	memcpy(ir_rx51->wbuf, buffer, count * sizeof(unsigned int));
> -
> -	/* Wait any pending transfers to finish */
> -	wait_event_interruptible(ir_rx51->wqueue, ir_rx51->wbuf_index < 0);
> -
> -	init_timing_params(ir_rx51);
> -	if (count < WBUF_LEN)
> -		ir_rx51->wbuf[count] = -1; /* Insert termination mark */
> -
> -	/*
> -	 * Adjust latency requirements so the device doesn't go in too
> -	 * deep sleep states
> -	 */
> -	ir_rx51->pdata->set_max_mpu_wakeup_lat(ir_rx51->dev, 50);
> -
> -	ir_rx51_on(ir_rx51);
> -	ir_rx51->wbuf_index = 1;
> -	hrtimer_start(&ir_rx51->timer,
> -		      ns_to_ktime(US_TO_NS(ir_rx51->wbuf[0])),
> -		      HRTIMER_MODE_REL);
> -	/*
> -	 * Don't return back to the userspace until the transfer has
> -	 * finished
> -	 */
> -	wait_event_interruptible(ir_rx51->wqueue, ir_rx51->wbuf_index < 0);
> -
> -	/* We can sleep again */
> -	ir_rx51->pdata->set_max_mpu_wakeup_lat(ir_rx51->dev, -1);
> -
> -	return count;
> -}
> -
> -static int ir_rx51_open(struct rc_dev *dev)
> -{
> -	struct ir_rx51 *ir_rx51 = dev->priv;
> -
> -	if (test_and_set_bit(1, &ir_rx51->device_is_open))
> -		return -EBUSY;
> -
> -	ir_rx51->pwm = pwm_get(ir_rx51->dev, NULL);
> -	if (IS_ERR(ir_rx51->pwm)) {
> -		int res = PTR_ERR(ir_rx51->pwm);
> -
> -		dev_err(ir_rx51->dev, "pwm_get failed: %d\n", res);
> -		return res;
> -	}
> -
> -	return 0;
> -}
> -
> -static void ir_rx51_release(struct rc_dev *dev)
> -{
> -	struct ir_rx51 *ir_rx51 = dev->priv;
> -
> -	hrtimer_cancel(&ir_rx51->timer);
> -	ir_rx51_off(ir_rx51);
> -	pwm_put(ir_rx51->pwm);
> -
> -	clear_bit(1, &ir_rx51->device_is_open);
> -}
> -
> -static struct ir_rx51 ir_rx51 = {
> -	.duty_cycle	= 50,
> -	.wbuf_index	= -1,
> -};
> -
> -static int ir_rx51_set_duty_cycle(struct rc_dev *dev, u32 duty)
> -{
> -	struct ir_rx51 *ir_rx51 = dev->priv;
> -
> -	ir_rx51->duty_cycle = duty;
> -
> -	return 0;
> -}
> -
> -static int ir_rx51_set_tx_carrier(struct rc_dev *dev, u32 carrier)
> -{
> -	struct ir_rx51 *ir_rx51 = dev->priv;
> -
> -	if (carrier > 500000 || carrier < 20000)
> -		return -EINVAL;
> -
> -	ir_rx51->freq = carrier;
> -
> -	return 0;
> -}
> -
> -#ifdef CONFIG_PM
> -
> -static int ir_rx51_suspend(struct platform_device *dev, pm_message_t state)
> -{
> -	/*
> -	 * In case the device is still open, do not suspend. Normally
> -	 * this should not be a problem as lircd only keeps the device
> -	 * open only for short periods of time. We also don't want to
> -	 * get involved with race conditions that might happen if we
> -	 * were in a middle of a transmit. Thus, we defer any suspend
> -	 * actions until transmit has completed.
> -	 */
> -	if (test_and_set_bit(1, &ir_rx51.device_is_open))
> -		return -EAGAIN;
> -
> -	clear_bit(1, &ir_rx51.device_is_open);
> -
> -	return 0;
> -}
> -
> -static int ir_rx51_resume(struct platform_device *dev)
> -{
> -	return 0;
> -}
> -
> -#else
> -
> -#define ir_rx51_suspend	NULL
> -#define ir_rx51_resume	NULL
> -
> -#endif /* CONFIG_PM */
> -
> -static int ir_rx51_probe(struct platform_device *dev)
> -{
> -	struct pwm_device *pwm;
> -	struct rc_dev *rcdev;
> -
> -	ir_rx51.pdata = dev->dev.platform_data;
> -
> -	if (!ir_rx51.pdata) {
> -		dev_err(&dev->dev, "Platform Data is missing\n");
> -		return -ENXIO;
> -	}
> -
> -	pwm = pwm_get(&dev->dev, NULL);
> -	if (IS_ERR(pwm)) {
> -		int err = PTR_ERR(pwm);
> -
> -		if (err != -EPROBE_DEFER)
> -			dev_err(&dev->dev, "pwm_get failed: %d\n", err);
> -		return err;
> -	}
> -
> -	/* Use default, in case userspace does not set the carrier */
> -	ir_rx51.freq = DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
> -	pwm_put(pwm);
> -
> -	hrtimer_init(&ir_rx51.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	ir_rx51.timer.function = ir_rx51_timer_cb;
> -
> -	ir_rx51.dev = &dev->dev;
> -
> -	rcdev = devm_rc_allocate_device(&dev->dev, RC_DRIVER_IR_RAW_TX);
> -	if (!rcdev)
> -		return -ENOMEM;
> -
> -	rcdev->priv = &ir_rx51;
> -	rcdev->open = ir_rx51_open;
> -	rcdev->close = ir_rx51_release;
> -	rcdev->tx_ir = ir_rx51_tx;
> -	rcdev->s_tx_duty_cycle = ir_rx51_set_duty_cycle;
> -	rcdev->s_tx_carrier = ir_rx51_set_tx_carrier;
> -	rcdev->driver_name = KBUILD_MODNAME;
> -
> -	ir_rx51.rcdev = rcdev;
> -
> -	return devm_rc_register_device(&dev->dev, ir_rx51.rcdev);
> -}
> -
> -static int ir_rx51_remove(struct platform_device *dev)
> -{
> -	return 0;
> -}
> -
> -static const struct of_device_id ir_rx51_match[] = {
> -	{
> -		.compatible = "nokia,n900-ir",
> -	},
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, ir_rx51_match);
> -
> -static struct platform_driver ir_rx51_platform_driver = {
> -	.probe		= ir_rx51_probe,
> -	.remove		= ir_rx51_remove,
> -	.suspend	= ir_rx51_suspend,
> -	.resume		= ir_rx51_resume,
> -	.driver		= {
> -		.name	= KBUILD_MODNAME,
> -		.of_match_table = of_match_ptr(ir_rx51_match),
> -	},
> -};
> -module_platform_driver(ir_rx51_platform_driver);
> -
> -MODULE_DESCRIPTION("IR TX driver for Nokia RX51");
> -MODULE_AUTHOR("Nokia Corporation");
> -MODULE_LICENSE("GPL");

-- 
Pali Rohár
pali.rohar@gmail.com
