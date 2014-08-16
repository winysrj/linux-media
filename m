Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaHPAIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 20:08:00 -0400
Message-ID: <53EEA0DF.6090903@infradead.org>
Date: Fri, 15 Aug 2014 17:07:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: Re: [linuxtv-media:devel 498/499] av7110.c:undefined reference to
 `av7110_ir_exit'
References: <53ee83cb.H8pPJAwEaBRBZftj%fengguang.wu@intel.com>
In-Reply-To: <53ee83cb.H8pPJAwEaBRBZftj%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/14 15:03, kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git devel
> head:   f1d2fd677f61bf4d649098317497db11a958a021
> commit: 277c0ffaea64c71c39f03b9ee6818de600c38fc3 [498/499] [media] media: ttpci: build av7110_ir.c only when allowed by CONFIG_INPUT_EVDEV
> config: x86_64-randconfig-s1-08160530 (attached as .config)

Argh, thanks, fix is on the way.


> All error/warnings:
> 
>    drivers/built-in.o: In function `av7110_detach':
>>> av7110.c:(.text+0x228d4a): undefined reference to `av7110_ir_exit'
>    drivers/built-in.o: In function `arm_thread':
>>> av7110.c:(.text+0x22a404): undefined reference to `av7110_check_ir_config'
>>> av7110.c:(.text+0x22a626): undefined reference to `av7110_check_ir_config'
>    drivers/built-in.o: In function `av7110_attach':
>>> av7110.c:(.text+0x22b08c): undefined reference to `av7110_ir_init'
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 


-- 
~Randy
