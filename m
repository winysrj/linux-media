Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35251 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbeB0Kyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 05:54:50 -0500
Received: by mail-wr0-f193.google.com with SMTP id l43so24397743wrc.2
        for <linux-media@vger.kernel.org>; Tue, 27 Feb 2018 02:54:49 -0800 (PST)
Date: Tue, 27 Feb 2018 10:54:44 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        thierry.reding@gmail.com, shc_work@mail.ru, kgene@kernel.org,
        krzk@kernel.org, linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, kamil@wypas.org,
        b.zolnierkie@samsung.com, jdelvare@suse.com, linux@roeck-us.net,
        dmitry.torokhov@gmail.com, rpurdie@rpsys.net,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, mchehab@kernel.org,
        sean@mess.org, lee.jones@linaro.org, jingoohan1@gmail.com,
        milo.kim@ti.com, robh+dt@kernel.org, mark.rutland@arm.com,
        corbet@lwn.net, nicolas.ferre@microchip.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
Message-ID: <20180227105444.lo4pee7vh4we3foq@oak.lan>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
 <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
 <20180222123308.mypx2r7n6o63mj5z@oak.lan>
 <87po4s2hve.fsf@intel.com>
 <3a70b89c-b470-3723-760c-5294d0a75230@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a70b89c-b470-3723-760c-5294d0a75230@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 26, 2018 at 04:24:15PM +0200, Claudiu Beznea wrote:
> On 26.02.2018 11:57, Jani Nikula wrote:
> > On Thu, 22 Feb 2018, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> >> On Thu, Feb 22, 2018 at 02:01:16PM +0200, Claudiu Beznea wrote:
> >>> Add PWM mode to pwm_config() function. The drivers which uses pwm_config()
> >>> were adapted to this change.
> >>>
> >>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> >>> ---
> >>>  arch/arm/mach-s3c24xx/mach-rx1950.c  | 11 +++++++++--
> >>>  drivers/bus/ts-nbus.c                |  2 +-
> >>>  drivers/clk/clk-pwm.c                |  3 ++-
> >>>  drivers/gpu/drm/i915/intel_panel.c   | 17 ++++++++++++++---
> >>>  drivers/hwmon/pwm-fan.c              |  2 +-
> >>>  drivers/input/misc/max77693-haptic.c |  2 +-
> >>>  drivers/input/misc/max8997_haptic.c  |  6 +++++-
> >>>  drivers/leds/leds-pwm.c              |  5 ++++-
> >>>  drivers/media/rc/ir-rx51.c           |  5 ++++-
> >>>  drivers/media/rc/pwm-ir-tx.c         |  5 ++++-
> >>>  drivers/video/backlight/lm3630a_bl.c |  4 +++-
> >>>  drivers/video/backlight/lp855x_bl.c  |  4 +++-
> >>>  drivers/video/backlight/lp8788_bl.c  |  5 ++++-
> >>>  drivers/video/backlight/pwm_bl.c     | 11 +++++++++--
> >>>  drivers/video/fbdev/ssd1307fb.c      |  3 ++-
> >>>  include/linux/pwm.h                  |  6 ++++--
> >>>  16 files changed, 70 insertions(+), 21 deletions(-)
> >>>
> >>> diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
> >>> index 2030a6b77a09..696fa25dafd2 100644
> >>> --- a/drivers/video/backlight/lm3630a_bl.c
> >>> +++ b/drivers/video/backlight/lm3630a_bl.c
> >>> @@ -165,8 +165,10 @@ static void lm3630a_pwm_ctrl(struct lm3630a_chip *pchip, int br, int br_max)
> >>>  {
> >>>  	unsigned int period = pchip->pdata->pwm_period;
> >>>  	unsigned int duty = br * period / br_max;
> >>> +	struct pwm_caps caps = { };
> >>>  
> >>> -	pwm_config(pchip->pwmd, duty, period);
> >>> +	pwm_get_caps(pchip->pwmd->chip, pchip->pwmd, &caps);
> >>> +	pwm_config(pchip->pwmd, duty, period, BIT(ffs(caps.modes) - 1));
> >>
> >> Well... I admit I've only really looked at the patches that impact 
> >> backlight but dispersing this really odd looking bit twiddling 
> >> throughout the kernel doesn't strike me a great API design.
> >>
> >> IMHO callers should not be required to find the first set bit in
> >> some specially crafted set of capability bits simply to get sane 
> >> default behaviour.
> > 
> > Agreed. IMHO the regular use case becomes rather tedious, ugly, and
> > error prone.
> 
> Using simply PWM_MODE(NORMAL) instead of BIT(ffs(caps.modes) - 1) would be OK
> from your side?
>
> Or, what about using a function like pwm_mode_first() to get the first supported
> mode by PWM channel?
> 
> Or, would you prefer to solve this inside pwm_config() function, let's say, in
> case an invalid mode is passed as argument, to let pwm_config() to choose the
> first available PWM mode for PWM channel passed as argument?

What is it that actually needs solving?

If a driver requests normal mode and the PWM driver cannot support it
why not just return an error an move on.

Put another way, what is the use case for secretly adopting a mode the
caller didn't want? Under what circumstances is this a good thing?


Daniel.
