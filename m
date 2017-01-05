Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:53507 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934597AbdAEVnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 16:43:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: "Andrew F. Davis" <afd@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, linux-pwm@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 6/6] [media] Only descend into directory when CONFIG_MEDIA_SUPPORT is set
Date: Thu, 05 Jan 2017 22:42:16 +0100
Message-ID: <4225650.R96pl5clWf@wuerfel>
In-Reply-To: <20170105210158.14204-7-afd@ti.com>
References: <20170105210158.14204-1-afd@ti.com> <20170105210158.14204-7-afd@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, January 5, 2017 3:01:58 PM CET Andrew F. Davis wrote:
> @@ -109,7 +109,8 @@ obj-$(CONFIG_SERIO)         += input/serio/
>  obj-$(CONFIG_GAMEPORT)         += input/gameport/
>  obj-$(CONFIG_INPUT)            += input/
>  obj-$(CONFIG_RTC_LIB)          += rtc/
> -obj-y                          += i2c/ media/
> +obj-y                          += i2c/
> +obj-$(CONFIG_MEDIA_SUPPORT)    += media/
>  obj-$(CONFIG_PPS)              += pps/
>  obj-y                          += ptp/
>  obj-$(CONFIG_W1)               += w1/
> 

This one seems wrong: if CONFIG_MEDIA_SUPPORT=m, but some I2C drivers
inside of drivers/media/ are built-in, we will fail to enter the directory,
see drivers/media/Makefile.

I checked the other five patches in the series as well, they all look
ok to me.

	Arnd
