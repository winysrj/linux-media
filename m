Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51451 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaHGVHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Aug 2014 17:07:10 -0400
Message-ID: <53E3EA78.5040607@iki.fi>
Date: Fri, 08 Aug 2014 00:07:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: [media:v4l_for_linus 393/499] tuner-core.c:undefined reference
 to `xc5000_attach'
References: <53e1c569.+9t1lBrjysNHBgah%fengguang.wu@intel.com>
In-Reply-To: <53e1c569.+9t1lBrjysNHBgah%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
could you look that one? There is now multiple reports for ~all those 
silicon tuners which are used by tuner.ko module (CONFIG MEDIA_TUNER). 
Even it blames SDR Kconfig tuner patch I made, it is not the real issue. 
In my understanding issue is that tuner.ko is build-in and those tuner 
drivers it uses are build as a module. I think those used tuners 
(xc5000, xc4000, etc.) should be defaulted to same as MEDIA_TUNER when 
!MEDIA_SUBDRV_AUTOSELECT.


regards
Antti



On 08/06/2014 09:04 AM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> head:   0f3bf3dc1ca394a8385079a5653088672b65c5c4
> commit: f5b44da1ac4146e06147a5df3058f4c265c932ec [393/499] [media] Kconfig: fix tuners build warnings
> config: x86_64-randconfig-s1-08061342 (attached as .config)
>
> All error/warnings:
>
>     drivers/built-in.o: In function `set_type':
>>> tuner-core.c:(.text+0x32ed52): undefined reference to `xc5000_attach'
>>> tuner-core.c:(.text+0x32f123): undefined reference to `xc5000_attach'
>     tuner-core.c:(.text+0x32f1e6): undefined reference to `xc4000_attach'
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>

-- 
http://palosaari.fi/
