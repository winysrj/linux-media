Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39136 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932196AbdKAMdv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 08:33:51 -0400
Date: Wed, 1 Nov 2017 13:33:46 +0100
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] media: rc: remove ir-rx51 in favour of generic pwm-ir-tx
Message-ID: <20171101123346.2j3pggnqs4itief5@earth>
References: <20171101115533.14418-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xkhdurdowbml6xju"
Content-Disposition: inline
In-Reply-To: <20171101115533.14418-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xkhdurdowbml6xju
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 01, 2017 at 11:55:33AM +0000, Sean Young wrote:
> The ir-rx51 is a pwm-based TX driver specific to the n900. This can be
> handled entirely by the generic pwm-ir-tx driver.
>=20
> Note that the suspend code in the ir-rx51 driver is unnecessary, since
> during transmit, the current process is not in interruptable sleep. The
> process is not put to sleep until the transmit completes.

Nice to see, that we can use generic driver now :)

> Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Cc: Pali Roh=E1r <pali.rohar@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  arch/arm/boot/dts/omap3-n900.dts |   2 +-
>  drivers/media/rc/Kconfig         |  10 --
>  drivers/media/rc/Makefile        |   1 -
>  drivers/media/rc/ir-rx51.c       | 316 ---------------------------------=
------
>  4 files changed, 1 insertion(+), 328 deletions(-)
>  delete mode 100644 drivers/media/rc/ir-rx51.c
>=20
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n=
900.dts
> index 4acd32a1c4ef..fccd2b119c0a 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -152,7 +152,7 @@
>  	};
> =20
>  	ir: n900-ir {
> -		compatible =3D "nokia,n900-ir";
> +		compatible =3D "pwm-ir-tx";

I think we should update DTS to look like this:

compatible =3D "nokia,n900-ir", "pwm-ir-tx";

This will keep new DTS working with old kernel. Also we want it
working the other way around (old DTS with new kernel), so we
need to add the "nokia,n900-ir" compatible to the generic PWM
IR driver.

Also the DT binding document needs update:

Documentation/devicetree/bindings/media/nokia,n900-ir

[Adding Rob Herring to Cc]

-- Sebastian

>  		pwms =3D <&pwm9 0 26316 0>; /* 38000 Hz */
>  	};
> =20
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 0f863822889e..354ee5224758 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -353,16 +353,6 @@ config IR_TTUSBIR
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called ttusbir.
> =20
> -config IR_RX51
> -	tristate "Nokia N900 IR transmitter diode"
> -	depends on (OMAP_DM_TIMER && PWM_OMAP_DMTIMER && ARCH_OMAP2PLUS || COMP=
ILE_TEST) && RC_CORE
> -	---help---
> -	   Say Y or M here if you want to enable support for the IR
> -	   transmitter diode built in the Nokia N900 (RX51) device.
> -
> -	   The driver uses omap DM timers for generating the carrier
> -	   wave and pulses.
> -
>  source "drivers/media/rc/img-ir/Kconfig"
> =20
>  config RC_LOOPBACK
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index a1ef86767aef..59b99a2dc2d4 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -25,7 +25,6 @@ obj-$(CONFIG_IR_MESON) +=3D meson-ir.o
>  obj-$(CONFIG_IR_NUVOTON) +=3D nuvoton-cir.o
>  obj-$(CONFIG_IR_ENE) +=3D ene_ir.o
>  obj-$(CONFIG_IR_REDRAT3) +=3D redrat3.o
> -obj-$(CONFIG_IR_RX51) +=3D ir-rx51.o
>  obj-$(CONFIG_IR_SPI) +=3D ir-spi.o
>  obj-$(CONFIG_IR_STREAMZAP) +=3D streamzap.o
>  obj-$(CONFIG_IR_WINBOND_CIR) +=3D winbond-cir.o
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
> -	struct pwm_device *pwm =3D ir_rx51->pwm;
> -	int duty, period =3D DIV_ROUND_CLOSEST(NSEC_PER_SEC, ir_rx51->freq);
> -
> -	duty =3D DIV_ROUND_CLOSEST(ir_rx51->duty_cycle * period, 100);
> -
> -	pwm_config(pwm, duty, period);
> -
> -	return 0;
> -}
> -
> -static enum hrtimer_restart ir_rx51_timer_cb(struct hrtimer *timer)
> -{
> -	struct ir_rx51 *ir_rx51 =3D container_of(timer, struct ir_rx51, timer);
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
> -		if (ir_rx51->wbuf_index >=3D WBUF_LEN)
> -			goto end;
> -		if (ir_rx51->wbuf[ir_rx51->wbuf_index] =3D=3D -1)
> -			goto end;
> -
> -		if (ir_rx51->wbuf_index % 2)
> -			ir_rx51_off(ir_rx51);
> -		else
> -			ir_rx51_on(ir_rx51);
> -
> -		ns =3D US_TO_NS(ir_rx51->wbuf[ir_rx51->wbuf_index]);
> -		hrtimer_add_expires_ns(timer, ns);
> -
> -		ir_rx51->wbuf_index++;
> -
> -		now =3D timer->base->get_time();
> -
> -	} while (hrtimer_get_expires_tv64(timer) < now);
> -
> -	return HRTIMER_RESTART;
> -end:
> -	/* Stop TX here */
> -	ir_rx51_off(ir_rx51);
> -	ir_rx51->wbuf_index =3D -1;
> -
> -	wake_up_interruptible(&ir_rx51->wqueue);
> -
> -	return HRTIMER_NORESTART;
> -}
> -
> -static int ir_rx51_tx(struct rc_dev *dev, unsigned int *buffer,
> -		      unsigned int count)
> -{
> -	struct ir_rx51 *ir_rx51 =3D dev->priv;
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
> -		ir_rx51->wbuf[count] =3D -1; /* Insert termination mark */
> -
> -	/*
> -	 * Adjust latency requirements so the device doesn't go in too
> -	 * deep sleep states
> -	 */
> -	ir_rx51->pdata->set_max_mpu_wakeup_lat(ir_rx51->dev, 50);
> -
> -	ir_rx51_on(ir_rx51);
> -	ir_rx51->wbuf_index =3D 1;
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
> -	struct ir_rx51 *ir_rx51 =3D dev->priv;
> -
> -	if (test_and_set_bit(1, &ir_rx51->device_is_open))
> -		return -EBUSY;
> -
> -	ir_rx51->pwm =3D pwm_get(ir_rx51->dev, NULL);
> -	if (IS_ERR(ir_rx51->pwm)) {
> -		int res =3D PTR_ERR(ir_rx51->pwm);
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
> -	struct ir_rx51 *ir_rx51 =3D dev->priv;
> -
> -	hrtimer_cancel(&ir_rx51->timer);
> -	ir_rx51_off(ir_rx51);
> -	pwm_put(ir_rx51->pwm);
> -
> -	clear_bit(1, &ir_rx51->device_is_open);
> -}
> -
> -static struct ir_rx51 ir_rx51 =3D {
> -	.duty_cycle	=3D 50,
> -	.wbuf_index	=3D -1,
> -};
> -
> -static int ir_rx51_set_duty_cycle(struct rc_dev *dev, u32 duty)
> -{
> -	struct ir_rx51 *ir_rx51 =3D dev->priv;
> -
> -	ir_rx51->duty_cycle =3D duty;
> -
> -	return 0;
> -}
> -
> -static int ir_rx51_set_tx_carrier(struct rc_dev *dev, u32 carrier)
> -{
> -	struct ir_rx51 *ir_rx51 =3D dev->priv;
> -
> -	if (carrier > 500000 || carrier < 20000)
> -		return -EINVAL;
> -
> -	ir_rx51->freq =3D carrier;
> -
> -	return 0;
> -}
> -
> -#ifdef CONFIG_PM
> -
> -static int ir_rx51_suspend(struct platform_device *dev, pm_message_t sta=
te)
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
> -	ir_rx51.pdata =3D dev->dev.platform_data;
> -
> -	if (!ir_rx51.pdata) {
> -		dev_err(&dev->dev, "Platform Data is missing\n");
> -		return -ENXIO;
> -	}
> -
> -	pwm =3D pwm_get(&dev->dev, NULL);
> -	if (IS_ERR(pwm)) {
> -		int err =3D PTR_ERR(pwm);
> -
> -		if (err !=3D -EPROBE_DEFER)
> -			dev_err(&dev->dev, "pwm_get failed: %d\n", err);
> -		return err;
> -	}
> -
> -	/* Use default, in case userspace does not set the carrier */
> -	ir_rx51.freq =3D DIV_ROUND_CLOSEST(pwm_get_period(pwm), NSEC_PER_SEC);
> -	pwm_put(pwm);
> -
> -	hrtimer_init(&ir_rx51.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -	ir_rx51.timer.function =3D ir_rx51_timer_cb;
> -
> -	ir_rx51.dev =3D &dev->dev;
> -
> -	rcdev =3D devm_rc_allocate_device(&dev->dev, RC_DRIVER_IR_RAW_TX);
> -	if (!rcdev)
> -		return -ENOMEM;
> -
> -	rcdev->priv =3D &ir_rx51;
> -	rcdev->open =3D ir_rx51_open;
> -	rcdev->close =3D ir_rx51_release;
> -	rcdev->tx_ir =3D ir_rx51_tx;
> -	rcdev->s_tx_duty_cycle =3D ir_rx51_set_duty_cycle;
> -	rcdev->s_tx_carrier =3D ir_rx51_set_tx_carrier;
> -	rcdev->driver_name =3D KBUILD_MODNAME;
> -
> -	ir_rx51.rcdev =3D rcdev;
> -
> -	return devm_rc_register_device(&dev->dev, ir_rx51.rcdev);
> -}
> -
> -static int ir_rx51_remove(struct platform_device *dev)
> -{
> -	return 0;
> -}
> -
> -static const struct of_device_id ir_rx51_match[] =3D {
> -	{
> -		.compatible =3D "nokia,n900-ir",
> -	},
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, ir_rx51_match);
> -
> -static struct platform_driver ir_rx51_platform_driver =3D {
> -	.probe		=3D ir_rx51_probe,
> -	.remove		=3D ir_rx51_remove,
> -	.suspend	=3D ir_rx51_suspend,
> -	.resume		=3D ir_rx51_resume,
> -	.driver		=3D {
> -		.name	=3D KBUILD_MODNAME,
> -		.of_match_table =3D of_match_ptr(ir_rx51_match),
> -	},
> -};
> -module_platform_driver(ir_rx51_platform_driver);
> -
> -MODULE_DESCRIPTION("IR TX driver for Nokia RX51");
> -MODULE_AUTHOR("Nokia Corporation");
> -MODULE_LICENSE("GPL");
> --=20
> 2.13.6
>=20

--xkhdurdowbml6xju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln5vyQACgkQ2O7X88g7
+pqWcg//VXFOaYCzSHniVUNbvAEkE5vJsGHrYC7rFWQMyRuYFrSj8l7JKB6rIWu/
X+L6d3wm1Lu9nWrDpO8tTy1wQwCVOW5KyIdpIw3dYAWrfl42yjHpyqAPR7K6Uw3x
N/MatxnpNu5AUhlUG1RjkPQRcEyIvuBugwvX9UQWagek2vlPmHcXgAXy+QchLKlZ
krItDxOiWAHCWcgeRz+P8ngIC9I6qSuNwVbbkWrFNbjB0MKdXROhoLRWemc3CpqJ
7bRz2fQzsz6u3OIWL7sj6uGKFB5MkdX76is8x8CNj6t5Xm3GIdsVcSVnoD8qYl3g
MdV1DBkC7H2egMtaNFmaBvluhxbHXjf7zXQO1tRb6O2wDAk4giznKyKUp/bsUzdE
RdZgnxgf2K/FqmHI7ff7Y/Ef9ybilCKGGst/x1gyow4KR7+yNXbZnx3HL6hg9eug
6FwPrNvy1sM44NIrVFuBdM5gCfrYmqWjuU4us3RcUOXq+ju4hJkDpCTTSaJ0nYxk
JwF6KpnlE9on6SsAWaDzlfZh7cfL4PZDExmd53GAbo1Bx5WNUvrTv1aTToj9OkZU
dFW3GYp5c+aqswg4iwpqJj3j0LIoZ3ojASQdjZzV1Hl/Ca23D2KDshXdhnmu693e
417fUlNMTL7KYh0znTCdP5uFo+5FpZSpavjt6KSGe4xkTfe1N6I=
=a3+9
-----END PGP SIGNATURE-----

--xkhdurdowbml6xju--
