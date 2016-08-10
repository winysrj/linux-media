Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:34075 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935066AbcHJULv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 16:11:51 -0400
Date: Wed, 10 Aug 2016 13:56:10 +0200
From: Max Kellermann <max@duempel.org>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] [media] dvb_frontend: merge duplicate
 dvb_tuner_ops.release implementations
Message-ID: <20160810115610.GA4143@swift.blarg.de>
References: <147077834639.21835.9626267699459771690.stgit@woodpecker.blarg.de>
 <201608100642.lXQqbCz6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201608100642.lXQqbCz6%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016/08/10 01:01, kbuild test robot <lkp@intel.com> wrote:
> url:    https://github.com/0day-ci/linux/commits/Max-Kellermann/rc-main-clear-rc_map-name-in-ir_free_table/20160810-054811
> base:   git://linuxtv.org/media_tree.git master
> config: i386-randconfig-n0-201632 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/built-in.o:(.rodata+0x55f58): undefined reference to `dvb_tuner_simple_release'
>    drivers/built-in.o:(.rodata+0x56038): undefined reference to `dvb_tuner_simple_release'
>    drivers/built-in.o:(.rodata+0x56618): undefined reference to `dvb_tuner_simple_release'
>    drivers/built-in.o:(.rodata+0x566f8): undefined reference to `dvb_tuner_simple_release'
>    drivers/built-in.o:(.rodata+0x57998): undefined reference to `dvb_tuner_simple_release'

This configuration breaks because there is no dependency from those
tuners to dvb_frontend.c (where dvb_tuner_simple_release).  However,
without dvb_frontend.c, there is no user of such a tuner, and this
configuration doesn't make sense.

Before I spend time on fixing this, I'd like to know if this patch has
a chance to be merged, or if you generally reject my idea of folding
duplicate code.

Two solutions come to my mind:

1.) add a dependency

2.) move dvb_tuner_simple_release() to a new library, which all tuner
    implementations depend on (which may some day have more common
    tuner code)

Opinions?

Max

