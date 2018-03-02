Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:59064 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425206AbeCBJ2V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:28:21 -0500
Subject: Re: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <shc_work@mail.ru>, <kgene@kernel.org>, <krzk@kernel.org>,
        <linux@armlinux.org.uk>, <mturquette@baylibre.com>,
        <sboyd@codeaurora.org>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <kamil@wypas.org>,
        <b.zolnierkie@samsung.com>, <jdelvare@suse.com>,
        <linux@roeck-us.net>, <dmitry.torokhov@gmail.com>,
        <rpurdie@rpsys.net>, <jacek.anaszewski@gmail.com>, <pavel@ucw.cz>,
        <mchehab@kernel.org>, <sean@mess.org>, <lee.jones@linaro.org>,
        <daniel.thompson@linaro.org>, <jingoohan1@gmail.com>,
        <milo.kim@ti.com>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <corbet@lwn.net>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@free-electrons.com>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
 <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
 <20180228194429.GD22932@mithrandir> <87r2p4hod7.fsf@intel.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <585cc4ae-3674-c119-295b-e59f4242e619@microchip.com>
Date: Fri, 2 Mar 2018 11:28:09 +0200
MIME-Version: 1.0
In-Reply-To: <87r2p4hod7.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28.02.2018 22:04, Jani Nikula wrote:
> On Wed, 28 Feb 2018, Thierry Reding <thierry.reding@gmail.com> wrote:
>> Anyone that needs something other than normal mode should use the new
>> atomic PWM API.
> 
> At the risk of revealing my true ignorance, what is the new atomic PWM
> API? Where? Examples of how one would convert old code over to the new
> API?
As far as I know, the old PWM core code uses config(), set_polarity(),
enable(), disable() methods of driver, registered as pwm_ops:
struct pwm_ops {

        int (*request)(struct pwm_chip *chip, struct pwm_device *pwm);

        void (*free)(struct pwm_chip *chip, struct pwm_device *pwm);

        int (*config)(struct pwm_chip *chip, struct pwm_device *pwm,

                      int duty_ns, int period_ns);

        int (*set_polarity)(struct pwm_chip *chip, struct pwm_device *pwm,

                            enum pwm_polarity polarity);

        int (*capture)(struct pwm_chip *chip, struct pwm_device *pwm,

                       struct pwm_capture *result, unsigned long timeout);

        int (*enable)(struct pwm_chip *chip, struct pwm_device *pwm);

        void (*disable)(struct pwm_chip *chip, struct pwm_device *pwm);

        int (*apply)(struct pwm_chip *chip, struct pwm_device *pwm,

                     struct pwm_state *state);

        void (*get_state)(struct pwm_chip *chip, struct pwm_device *pwm,

                          struct pwm_state *state);

#ifdef CONFIG_DEBUG_FS

        void (*dbg_show)(struct pwm_chip *chip, struct seq_file *s);

#endif

        struct module *owner;

};


to do settings on hardware. In order to so settings on a PWM the users
should have been follow the below steps:
->config()
->set_polarity()
->enable()
Moreover, if the PWM was previously enabled it should have been first
disable and then to follow the above steps in order to apply a new settings
on hardware.
The driver should have been provide, at probe, all the above function:
->config(), ->set_polarity(), ->disable(), ->enable(), function that were
used by PWM core.

Now, having atomic PWM, the driver should provide one function to PWM core,
which is ->apply() function. Every PWM has a state associated, which keeps
the period, duty cycle, polarity and enable/disable status. The driver's
->apply() function takes as argument the state that should be applied and
it takes care of applying this new state directly without asking user to
call ->disable(), then ->config()/->set_polarity(), then ->enable() to
apply new hardware settings.

The PWM consumer could set a new state for PWM it uses, using
pwm_apply_state(pwm, new_state);

Regarding the models to switch on atomic PWM, on the controller side you
can check for drivers that registers apply function at probe time.
Regarding the PWM users, you can look for pwm_apply_state()
(drivers/hwmon/pwm-fan.c or drivers/input/misc/pwm-beeper.c are some examples).

Thierry, please correct me if I'm wrong.

Thank you,
Claudiu Beznea

> 
> BR,
> Jani.
> 
