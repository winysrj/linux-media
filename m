Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19168 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752402AbeBZJ5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 04:57:42 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: thierry.reding@gmail.com, shc_work@mail.ru, kgene@kernel.org,
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
In-Reply-To: <20180222123308.mypx2r7n6o63mj5z@oak.lan>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com> <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com> <20180222123308.mypx2r7n6o63mj5z@oak.lan>
Date: Mon, 26 Feb 2018 11:57:25 +0200
Message-ID: <87po4s2hve.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Feb 2018, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> On Thu, Feb 22, 2018 at 02:01:16PM +0200, Claudiu Beznea wrote:
>> Add PWM mode to pwm_config() function. The drivers which uses pwm_config()
>> were adapted to this change.
>> 
>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>> ---
>>  arch/arm/mach-s3c24xx/mach-rx1950.c  | 11 +++++++++--
>>  drivers/bus/ts-nbus.c                |  2 +-
>>  drivers/clk/clk-pwm.c                |  3 ++-
>>  drivers/gpu/drm/i915/intel_panel.c   | 17 ++++++++++++++---
>>  drivers/hwmon/pwm-fan.c              |  2 +-
>>  drivers/input/misc/max77693-haptic.c |  2 +-
>>  drivers/input/misc/max8997_haptic.c  |  6 +++++-
>>  drivers/leds/leds-pwm.c              |  5 ++++-
>>  drivers/media/rc/ir-rx51.c           |  5 ++++-
>>  drivers/media/rc/pwm-ir-tx.c         |  5 ++++-
>>  drivers/video/backlight/lm3630a_bl.c |  4 +++-
>>  drivers/video/backlight/lp855x_bl.c  |  4 +++-
>>  drivers/video/backlight/lp8788_bl.c  |  5 ++++-
>>  drivers/video/backlight/pwm_bl.c     | 11 +++++++++--
>>  drivers/video/fbdev/ssd1307fb.c      |  3 ++-
>>  include/linux/pwm.h                  |  6 ++++--
>>  16 files changed, 70 insertions(+), 21 deletions(-)
>> 
>> diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
>> index 2030a6b77a09..696fa25dafd2 100644
>> --- a/drivers/video/backlight/lm3630a_bl.c
>> +++ b/drivers/video/backlight/lm3630a_bl.c
>> @@ -165,8 +165,10 @@ static void lm3630a_pwm_ctrl(struct lm3630a_chip *pchip, int br, int br_max)
>>  {
>>  	unsigned int period = pchip->pdata->pwm_period;
>>  	unsigned int duty = br * period / br_max;
>> +	struct pwm_caps caps = { };
>>  
>> -	pwm_config(pchip->pwmd, duty, period);
>> +	pwm_get_caps(pchip->pwmd->chip, pchip->pwmd, &caps);
>> +	pwm_config(pchip->pwmd, duty, period, BIT(ffs(caps.modes) - 1));
>
> Well... I admit I've only really looked at the patches that impact 
> backlight but dispersing this really odd looking bit twiddling 
> throughout the kernel doesn't strike me a great API design.
>
> IMHO callers should not be required to find the first set bit in
> some specially crafted set of capability bits simply to get sane 
> default behaviour.

Agreed. IMHO the regular use case becomes rather tedious, ugly, and
error prone.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
