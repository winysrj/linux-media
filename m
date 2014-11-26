Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:49458 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbaKZHuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 02:50:44 -0500
Message-ID: <1416988241.29407.5.camel@x220>
Subject: Re: [linuxtv-media:master 7661/7664] ERROR: "omapdss_compat_init"
 [drivers/media/platform/omap/omap-vout.ko] undefined!
From: Paul Bolle <pebolle@tiscali.nl>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 26 Nov 2014 08:50:41 +0100
In-Reply-To: <201411260931.8e2dBfm8%fengguang.wu@intel.com>
References: <201411260931.8e2dBfm8%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang,

On Wed, 2014-11-26 at 09:34 +0800, kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git master
> head:   504febc3f98c87a8bebd8f2f274f32c0724131e4
> commit: 6b213e81ddf8b265383c9a1a1884432df88f701e [7661/7664] [media] omap: Fix typo "HAS_MMU"
> config: m68k-allmodconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout 6b213e81ddf8b265383c9a1a1884432df88f701e
>   # save the attached .config to linux build tree
>   make.cross ARCH=m68k 

This is the first time I've made the kbuild test robot trip. So I'm not
sure how to interpret this.

Is ARCH=m68k the only build that failed through this commit? Or is it
the first build that failed? If so, how can I determine which arches
build correctly?

> All error/warnings:
> 
> >> ERROR: "omapdss_compat_init" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_overlay_manager" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_num_overlay_managers" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_overlay" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omapdss_is_initialized" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dispc_register_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omapdss_get_version" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_put_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_next_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dispc_unregister_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omapdss_compat_uninit" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> >> ERROR: "omap_dss_get_num_overlays" [drivers/media/platform/omap/omap-vout.ko] undefined!
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

Thanks,

Paul Bolle

