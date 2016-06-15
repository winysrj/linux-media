Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15908 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbcFOGs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 02:48:56 -0400
Message-id: <5760FA52.7010806@samsung.com>
Date: Wed, 15 Jun 2016 08:48:50 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: "Andrew F. Davis" <afd@ti.com>
Cc: Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-pwm@vger.kernel.org,
	lguest@lists.ozlabs.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 12/12] leds: Only descend into leds directory when
 CONFIG_NEW_LEDS is set
References: <20160613200211.14790-1-afd@ti.com>
 <20160613200211.14790-13-afd@ti.com>
In-reply-to: <20160613200211.14790-13-afd@ti.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

Thanks for the patch.

Please address the issue [1] raised by test bot and resubmit.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2016/6/13/1091

On 06/13/2016 10:02 PM, Andrew F. Davis wrote:
> When CONFIG_NEW_LEDS is not set make will still descend into the leds
> directory but nothing will be built. This produces unneeded build
> artifacts and messages in addition to slowing the build. Fix this here.
>
> Signed-off-by: Andrew F. Davis <afd@ti.com>
> ---
>   drivers/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 567e32c..fa514d5 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -127,7 +127,7 @@ obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
>   obj-$(CONFIG_CPU_IDLE)		+= cpuidle/
>   obj-$(CONFIG_MMC)		+= mmc/
>   obj-$(CONFIG_MEMSTICK)		+= memstick/
> -obj-y				+= leds/
> +obj-$(CONFIG_NEW_LEDS)		+= leds/
>   obj-$(CONFIG_INFINIBAND)	+= infiniband/
>   obj-$(CONFIG_SGI_SN)		+= sn/
>   obj-y				+= firmware/
>


-- 
Best regards,
Jacek Anaszewski
