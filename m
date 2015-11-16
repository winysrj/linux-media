Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34560 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbKPVS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 16:18:29 -0500
Received: by wmvv187 with SMTP id v187so197787601wmv.1
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 13:18:28 -0800 (PST)
Subject: Re: [PATCH 8/8] media: rc: define RC_BIT_ALL as ~0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <201511170448.dNasi5Xw%fengguang.wu@intel.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <564A47DE.4020204@gmail.com>
Date: Mon, 16 Nov 2015 22:17:18 +0100
MIME-Version: 1.0
In-Reply-To: <201511170448.dNasi5Xw%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.11.2015 um 21:47 schrieb kbuild test robot:
> Hi Heiner,
> 
> [auto build test WARNING on linuxtv-media/master]
> [also build test WARNING on v4.4-rc1 next-20151116]
> 
> url:    https://github.com/0day-ci/linux/commits/Heiner-Kallweit/media-rc-fix-decoder-module-unloading/20151117-035809
> base:   git://linuxtv.org/media_tree.git master
> config: parisc-allmodconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=parisc 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/media/rc-core.h:23:0,
>                     from drivers/media/pci/cx23885/cx23885-input.c:34:
>    drivers/media/pci/cx23885/cx23885-input.c: In function 'cx23885_input_init':
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>>> drivers/media/pci/cx23885/cx23885-input.c:289:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>    drivers/media/pci/cx23885/cx23885-input.c:303:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>    drivers/media/pci/cx23885/cx23885-input.c:310:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>    drivers/media/pci/cx23885/cx23885-input.c:318:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>    drivers/media/pci/cx23885/cx23885-input.c:330:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
>>> include/media/rc-map.h:57:21: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>     #define RC_BIT_ALL  ~RC_BIT_NONE
>                         ^
>    drivers/media/pci/cx23885/cx23885-input.c:336:20: note: in expansion of macro 'RC_BIT_ALL'
>       allowed_protos = RC_BIT_ALL;
>                        ^
> 
> vim +57 include/media/rc-map.h
> 
>     41	#define RC_BIT_RC5_SZ		(1ULL << RC_TYPE_RC5_SZ)
>     42	#define RC_BIT_JVC		(1ULL << RC_TYPE_JVC)
>     43	#define RC_BIT_SONY12		(1ULL << RC_TYPE_SONY12)
>     44	#define RC_BIT_SONY15		(1ULL << RC_TYPE_SONY15)
>     45	#define RC_BIT_SONY20		(1ULL << RC_TYPE_SONY20)
>     46	#define RC_BIT_NEC		(1ULL << RC_TYPE_NEC)
>     47	#define RC_BIT_SANYO		(1ULL << RC_TYPE_SANYO)
>     48	#define RC_BIT_MCE_KBD		(1ULL << RC_TYPE_MCE_KBD)
>     49	#define RC_BIT_RC6_0		(1ULL << RC_TYPE_RC6_0)
>     50	#define RC_BIT_RC6_6A_20	(1ULL << RC_TYPE_RC6_6A_20)
>     51	#define RC_BIT_RC6_6A_24	(1ULL << RC_TYPE_RC6_6A_24)
>     52	#define RC_BIT_RC6_6A_32	(1ULL << RC_TYPE_RC6_6A_32)
>     53	#define RC_BIT_RC6_MCE		(1ULL << RC_TYPE_RC6_MCE)
>     54	#define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
>     55	#define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
>     56	
>   > 57	#define RC_BIT_ALL		~RC_BIT_NONE
>     58	
>     59	#define RC_SCANCODE_UNKNOWN(x)			(x)
>     60	#define RC_SCANCODE_OTHER(x)			(x)
>     61	#define RC_SCANCODE_NEC(addr, cmd)		(((addr) << 8) | (cmd))
>     62	#define RC_SCANCODE_NECX(addr, cmd)		(((addr) << 8) | (cmd))
>     63	#define RC_SCANCODE_NEC32(data)			((data) & 0xffffffff)
>     64	#define RC_SCANCODE_RC5(sys, cmd)		(((sys) << 8) | (cmd))
>     65	#define RC_SCANCODE_RC5_SZ(sys, cmd)		(((sys) << 8) | (cmd))
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
To me this seems to be a bug in cx23885.
Variable allowed_protos should be of type u64 instead of unsigned long
because its value later is assigned to rc->allowed_protocols which is
of type u64.
If you agree I'd send a patch.

