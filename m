Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50507 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbaG3VX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 17:23:56 -0400
Message-ID: <53D96269.2080902@iki.fi>
Date: Thu, 31 Jul 2014 00:23:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [next:master 8790/9825] tuner-core.c:undefined reference to `tda829x_attach'
References: <53d8fde5.1k1Ii3dzHq6aFnfz%fengguang.wu@intel.com>
In-Reply-To: <53d8fde5.1k1Ii3dzHq6aFnfz%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
Could you look that? I simply cannot understand why it does not see for 
example xc2028_attach(). All those tuners seems to be analog or hybrid.

$ grep CONFIG_MEDIA_TUNER= .config
CONFIG_MEDIA_TUNER=y
$ grep CONFIG_VIDEO_TUNER= .config
CONFIG_VIDEO_TUNER=y
$ grep CONFIG_MEDIA_TUNER_XC2028= .config
CONFIG_MEDIA_TUNER_XC2028=m
$ grep CONFIG_MEDIA_ATTACH= .config
$ grep CONFIG_MEDIA_SUBDRV_AUTOSELECT= .config


Why these ATV tuners are selected when MEDIA_SUBDRV_AUTOSELECT, but DTV not?

# Analog TV tuners, auto-loaded via tuner.ko
config MEDIA_TUNER
	tristate
	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || 
MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT) && I2C
	default y
	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && 
MEDIA_RADIO_SUPPORT
	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && 
MEDIA_RADIO_SUPPORT
	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT

regards
Antti

On 07/30/2014 05:15 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   fcf6395d41087217d4b88d5b2ad7a1ce66ca6ced
> commit: f5b44da1ac4146e06147a5df3058f4c265c932ec [8790/9825] [media] Kconfig: fix tuners build warnings
> config: i386-randconfig-ib1-07302105 (attached as .config)
>
> All error/warnings:
>
>     drivers/built-in.o: In function `set_type':
>>> tuner-core.c:(.text+0x340ee6): undefined reference to `tda829x_attach'
>>> tuner-core.c:(.text+0x340fac): undefined reference to `xc2028_attach'
>>> tuner-core.c:(.text+0x34103e): undefined reference to `tda18271_attach'
>>> tuner-core.c:(.text+0x34106e): undefined reference to `xc4000_attach'
>     drivers/built-in.o: In function `tuner_probe':
>>> tuner-core.c:(.text+0x341484): undefined reference to `tda829x_probe'
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>

-- 
http://palosaari.fi/
