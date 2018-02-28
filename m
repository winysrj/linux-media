Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:62603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933981AbeB1UFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 15:05:12 -0500
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: shc_work@mail.ru, kgene@kernel.org, krzk@kernel.org,
        linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, kamil@wypas.org,
        b.zolnierkie@samsung.com, jdelvare@suse.com, linux@roeck-us.net,
        dmitry.torokhov@gmail.com, rpurdie@rpsys.net,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, mchehab@kernel.org,
        sean@mess.org, lee.jones@linaro.org, daniel.thompson@linaro.org,
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
In-Reply-To: <20180228194429.GD22932@mithrandir>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com> <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com> <20180228194429.GD22932@mithrandir>
Date: Wed, 28 Feb 2018 22:04:52 +0200
Message-ID: <87r2p4hod7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Feb 2018, Thierry Reding <thierry.reding@gmail.com> wrote:
> Anyone that needs something other than normal mode should use the new
> atomic PWM API.

At the risk of revealing my true ignorance, what is the new atomic PWM
API? Where? Examples of how one would convert old code over to the new
API?

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
