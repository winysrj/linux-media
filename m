Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:24160 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeBZIL6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 03:11:58 -0500
Subject: Re: [PATCH v3 01/10] pwm: extend PWM framework with PWM modes
To: kbuild test robot <lkp@intel.com>
CC: <kbuild-all@01.org>, <thierry.reding@gmail.com>,
        <shc_work@mail.ru>, <kgene@kernel.org>, <krzk@kernel.org>,
        <linux@armlinux.org.uk>, <mturquette@baylibre.com>,
        <sboyd@codeaurora.org>, <jani.nikula@linux.intel.com>,
        <joonas.lahtinen@linux.intel.com>, <rodrigo.vivi@intel.com>,
        <airlied@linux.ie>, <kamil@wypas.org>, <b.zolnierkie@samsung.com>,
        <jdelvare@suse.com>, <linux@roeck-us.net>,
        <dmitry.torokhov@gmail.com>, <rpurdie@rpsys.net>,
        <jacek.anaszewski@gmail.com>, <pavel@ucw.cz>, <mchehab@kernel.org>,
        <sean@mess.org>, <lee.jones@linaro.org>,
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
References: <1519300881-8136-2-git-send-email-claudiu.beznea@microchip.com>
 <201802250410.reI8wAy2%fengguang.wu@intel.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <a26cdf7b-024e-957b-8691-c3c898d0d9d6@microchip.com>
Date: Mon, 26 Feb 2018 10:11:45 +0200
MIME-Version: 1.0
In-Reply-To: <201802250410.reI8wAy2%fengguang.wu@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll rebase it on latest for-next in next version.

Thank you,
Claudiu Beznea

On 24.02.2018 22:49, kbuild test robot wrote:
> Hi Claudiu,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on pwm/for-next]
> [also build test WARNING on v4.16-rc2 next-20180223]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Claudiu-Beznea/extend-PWM-framework-to-support-PWM-modes/20180225-024011
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git for-next
> config: xtensa-allmodconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
> 
> All warnings (new ones prefixed by >>):
> 
>>> drivers//pwm/pwm-sun4i.c:36:0: warning: "PWM_MODE" redefined
>     #define PWM_MODE  BIT(7)
>     
>    In file included from drivers//pwm/pwm-sun4i.c:19:0:
>    include/linux/pwm.h:40:0: note: this is the location of the previous definition
>     #define PWM_MODE(name)  BIT(PWM_MODE_##name##_BIT)
>     
> 
> vim +/PWM_MODE +36 drivers//pwm/pwm-sun4i.c
> 
> 09853ce7 Alexandre Belloni 2014-12-17  29  
> 09853ce7 Alexandre Belloni 2014-12-17  30  #define PWMCH_OFFSET		15
> 09853ce7 Alexandre Belloni 2014-12-17  31  #define PWM_PRESCAL_MASK	GENMASK(3, 0)
> 09853ce7 Alexandre Belloni 2014-12-17  32  #define PWM_PRESCAL_OFF		0
> 09853ce7 Alexandre Belloni 2014-12-17  33  #define PWM_EN			BIT(4)
> 09853ce7 Alexandre Belloni 2014-12-17  34  #define PWM_ACT_STATE		BIT(5)
> 09853ce7 Alexandre Belloni 2014-12-17  35  #define PWM_CLK_GATING		BIT(6)
> 09853ce7 Alexandre Belloni 2014-12-17 @36  #define PWM_MODE		BIT(7)
> 09853ce7 Alexandre Belloni 2014-12-17  37  #define PWM_PULSE		BIT(8)
> 09853ce7 Alexandre Belloni 2014-12-17  38  #define PWM_BYPASS		BIT(9)
> 09853ce7 Alexandre Belloni 2014-12-17  39  
> 
> :::::: The code at line 36 was first introduced by commit
> :::::: 09853ce7bc1003a490c7ee74a5705d7a7cf16b7d pwm: Add Allwinner SoC support
> 
> :::::: TO: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> :::::: CC: Thierry Reding <thierry.reding@gmail.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
