Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34231 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932199AbeBVNBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 08:01:38 -0500
Date: Thu, 22 Feb 2018 13:01:31 +0000
From: Sean Young <sean@mess.org>
To: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: thierry.reding@gmail.com, shc_work@mail.ru, kgene@kernel.org,
        krzk@kernel.org, linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, kamil@wypas.org, b.zolnierkie@samsung.com,
        jdelvare@suse.com, linux@roeck-us.net, dmitry.torokhov@gmail.com,
        rpurdie@rpsys.net, jacek.anaszewski@gmail.com, pavel@ucw.cz,
        mchehab@kernel.org, lee.jones@linaro.org,
        daniel.thompson@linaro.org, jingoohan1@gmail.com, milo.kim@ti.com,
        robh+dt@kernel.org, mark.rutland@arm.com, corbet@lwn.net,
        nicolas.ferre@microchip.com, alexandre.belloni@free-electrons.com,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
Message-ID: <20180222130131.46fcuurp4h6dc7wb@gofer.mess.org>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
 <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 22, 2018 at 02:01:16PM +0200, Claudiu Beznea wrote:
> Add PWM mode to pwm_config() function. The drivers which uses pwm_config()
> were adapted to this change.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---

-snip-

> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> index 49265f02e772..a971b02ea021 100644
> --- a/drivers/media/rc/ir-rx51.c
> +++ b/drivers/media/rc/ir-rx51.c
> @@ -55,10 +55,13 @@ static int init_timing_params(struct ir_rx51 *ir_rx51)
>  {
>  	struct pwm_device *pwm = ir_rx51->pwm;
>  	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, ir_rx51->freq);
> +	struct pwm_caps caps = { };
>  
>  	duty = DIV_ROUND_CLOSEST(ir_rx51->duty_cycle * period, 100);
>  
> -	pwm_config(pwm, duty, period);
> +	pwm_get_caps(pwm->chip, pwm, &caps);
> +
> +	pwm_config(pwm, duty, period, BIT(ffs(caps.modes) - 1));
>  
>  	return 0;
>  }
> diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
> index 27d0f5837a76..c630e1b450a3 100644
> --- a/drivers/media/rc/pwm-ir-tx.c
> +++ b/drivers/media/rc/pwm-ir-tx.c
> @@ -61,6 +61,7 @@ static int pwm_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
>  {
>  	struct pwm_ir *pwm_ir = dev->priv;
>  	struct pwm_device *pwm = pwm_ir->pwm;
> +	struct pwm_caps caps = { };
>  	int i, duty, period;
>  	ktime_t edge;
>  	long delta;
> @@ -68,7 +69,9 @@ static int pwm_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
>  	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, pwm_ir->carrier);
>  	duty = DIV_ROUND_CLOSEST(pwm_ir->duty_cycle * period, 100);
>  
> -	pwm_config(pwm, duty, period);
> +	pwm_get_caps(pwm->chip, pwm, &caps);
> +
> +	pwm_config(pwm, duty, period, BIT(ffs(caps.modes) - 1));
>  
>  	edge = ktime_get();
>  

The two PWM rc-core drivers need PWM_MODE(NORMAL), not the first available
mode that the device supports. If mode normal is not supported, then probe
should fail.


Sean
