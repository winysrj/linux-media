Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55748 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbeBVMdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:33:16 -0500
Received: by mail-wm0-f65.google.com with SMTP id q83so3622518wme.5
        for <linux-media@vger.kernel.org>; Thu, 22 Feb 2018 04:33:15 -0800 (PST)
Date: Thu, 22 Feb 2018 12:33:08 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: thierry.reding@gmail.com, shc_work@mail.ru, kgene@kernel.org,
        krzk@kernel.org, linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, kamil@wypas.org, b.zolnierkie@samsung.com,
        jdelvare@suse.com, linux@roeck-us.net, dmitry.torokhov@gmail.com,
        rpurdie@rpsys.net, jacek.anaszewski@gmail.com, pavel@ucw.cz,
        mchehab@kernel.org, sean@mess.org, lee.jones@linaro.org,
        jingoohan1@gmail.com, milo.kim@ti.com, robh+dt@kernel.org,
        mark.rutland@arm.com, corbet@lwn.net, nicolas.ferre@microchip.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
Message-ID: <20180222123308.mypx2r7n6o63mj5z@oak.lan>
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
>  arch/arm/mach-s3c24xx/mach-rx1950.c  | 11 +++++++++--
>  drivers/bus/ts-nbus.c                |  2 +-
>  drivers/clk/clk-pwm.c                |  3 ++-
>  drivers/gpu/drm/i915/intel_panel.c   | 17 ++++++++++++++---
>  drivers/hwmon/pwm-fan.c              |  2 +-
>  drivers/input/misc/max77693-haptic.c |  2 +-
>  drivers/input/misc/max8997_haptic.c  |  6 +++++-
>  drivers/leds/leds-pwm.c              |  5 ++++-
>  drivers/media/rc/ir-rx51.c           |  5 ++++-
>  drivers/media/rc/pwm-ir-tx.c         |  5 ++++-
>  drivers/video/backlight/lm3630a_bl.c |  4 +++-
>  drivers/video/backlight/lp855x_bl.c  |  4 +++-
>  drivers/video/backlight/lp8788_bl.c  |  5 ++++-
>  drivers/video/backlight/pwm_bl.c     | 11 +++++++++--
>  drivers/video/fbdev/ssd1307fb.c      |  3 ++-
>  include/linux/pwm.h                  |  6 ++++--
>  16 files changed, 70 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
> index 2030a6b77a09..696fa25dafd2 100644
> --- a/drivers/video/backlight/lm3630a_bl.c
> +++ b/drivers/video/backlight/lm3630a_bl.c
> @@ -165,8 +165,10 @@ static void lm3630a_pwm_ctrl(struct lm3630a_chip *pchip, int br, int br_max)
>  {
>  	unsigned int period = pchip->pdata->pwm_period;
>  	unsigned int duty = br * period / br_max;
> +	struct pwm_caps caps = { };
>  
> -	pwm_config(pchip->pwmd, duty, period);
> +	pwm_get_caps(pchip->pwmd->chip, pchip->pwmd, &caps);
> +	pwm_config(pchip->pwmd, duty, period, BIT(ffs(caps.modes) - 1));

Well... I admit I've only really looked at the patches that impact 
backlight but dispersing this really odd looking bit twiddling 
throughout the kernel doesn't strike me a great API design.

IMHO callers should not be required to find the first set bit in
some specially crafted set of capability bits simply to get sane 
default behaviour.


Daniel.




>  	if (duty)
>  		pwm_enable(pchip->pwmd);
>  	else
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index 939f057836e1..3d274c604862 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -240,6 +240,7 @@ static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
>  	unsigned int period = lp->pdata->period_ns;
>  	unsigned int duty = br * period / max_br;
>  	struct pwm_device *pwm;
> +	struct pwm_caps caps = { };
>  
>  	/* request pwm device with the consumer name */
>  	if (!lp->pwm) {
> @@ -256,7 +257,8 @@ static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
>  		pwm_apply_args(pwm);
>  	}
>  
> -	pwm_config(lp->pwm, duty, period);
> +	pwm_get_caps(lp->pwm->chip, lp->pwm, &caps);
> +	pwm_config(lp->pwm, duty, period, BIT(ffs(caps.modes) - 1));
>  	if (duty)
>  		pwm_enable(lp->pwm);
>  	else
> diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
> index cf869ec90cce..06de3163650d 100644
> --- a/drivers/video/backlight/lp8788_bl.c
> +++ b/drivers/video/backlight/lp8788_bl.c
> @@ -128,6 +128,7 @@ static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
>  	unsigned int duty;
>  	struct device *dev;
>  	struct pwm_device *pwm;
> +	struct pwm_caps caps = { };
>  
>  	if (!bl->pdata)
>  		return;
> @@ -153,7 +154,9 @@ static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
>  		pwm_apply_args(pwm);
>  	}
>  
> -	pwm_config(bl->pwm, duty, period);
> +	pwm_get_caps(bl->pwm->chip, bl->pwm, &caps);
> +
> +	pwm_config(bl->pwm, duty, period, BIT(ffs(caps.modes) - 1));
>  	if (duty)
>  		pwm_enable(bl->pwm);
>  	else
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 1c2289ddd555..706a9ab053a7 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -63,10 +63,14 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness)
>  
>  static void pwm_backlight_power_off(struct pwm_bl_data *pb)
>  {
> +	struct pwm_caps caps = { };
> +
>  	if (!pb->enabled)
>  		return;
>  
> -	pwm_config(pb->pwm, 0, pb->period);
> +	pwm_get_caps(pb->pwm->chip, pb->pwm, &caps);
> +
> +	pwm_config(pb->pwm, 0, pb->period, BIT(ffs(caps.modes) - 1));
>  	pwm_disable(pb->pwm);
>  
>  	if (pb->enable_gpio)
> @@ -96,6 +100,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  {
>  	struct pwm_bl_data *pb = bl_get_data(bl);
>  	int brightness = bl->props.brightness;
> +	struct pwm_caps caps = { };
>  	int duty_cycle;
>  
>  	if (bl->props.power != FB_BLANK_UNBLANK ||
> @@ -108,7 +113,9 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  
>  	if (brightness > 0) {
>  		duty_cycle = compute_duty_cycle(pb, brightness);
> -		pwm_config(pb->pwm, duty_cycle, pb->period);
> +		pwm_get_caps(pb->pwm->chip, pb->pwm, &caps);
> +		pwm_config(pb->pwm, duty_cycle, pb->period,
> +			   BIT(ffs(caps.modes) - 1));
>  		pwm_backlight_power_on(pb, brightness);
>  	} else
>  		pwm_backlight_power_off(pb);
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
> index f599520374dd..4b57dcb5799a 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -308,7 +308,8 @@ static int ssd1307fb_init(struct ssd1307fb_par *par)
>  
>  		par->pwm_period = pargs.period;
>  		/* Enable the PWM */
> -		pwm_config(par->pwm, par->pwm_period / 2, par->pwm_period);
> +		pwm_config(par->pwm, par->pwm_period / 2, par->pwm_period,
> +			   pargs.mode);
>  		pwm_enable(par->pwm);
>  
>  		dev_dbg(&par->client->dev, "Using PWM%d with a %dns period.\n",
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index e62349f48129..0ba416ab2772 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -357,11 +357,12 @@ int pwm_adjust_config(struct pwm_device *pwm);
>   * @pwm: PWM device
>   * @duty_ns: "on" time (in nanoseconds)
>   * @period_ns: duration (in nanoseconds) of one cycle
> + * @mode: PWM mode
>   *
>   * Returns: 0 on success or a negative error code on failure.
>   */
>  static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
> -			     int period_ns)
> +			     int period_ns, unsigned long mode)
>  {
>  	struct pwm_state state;
>  
> @@ -377,6 +378,7 @@ static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
>  
>  	state.duty_cycle = duty_ns;
>  	state.period = period_ns;
> +	state.mode = mode;
>  	return pwm_apply_state(pwm, &state);
>  }
>  
> @@ -537,7 +539,7 @@ static inline int pwm_adjust_config(struct pwm_device *pwm)
>  }
>  
>  static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
> -			     int period_ns)
> +			     int period_ns, unsigned long mode)
>  {
>  	return -EINVAL;
>  }
> -- 
> 2.7.4
> 
