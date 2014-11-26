Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37969 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaKZM0I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 07:26:08 -0500
Date: Wed, 26 Nov 2014 10:26:03 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 7661/7664] ERROR: "omapdss_compat_init"
 [drivers/media/platform/omap/omap-vout.ko] undefined!
Message-ID: <20141126102603.440cb221@recife.lan>
In-Reply-To: <1416988241.29407.5.camel@x220>
References: <201411260931.8e2dBfm8%fengguang.wu@intel.com>
	<1416988241.29407.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Nov 2014 08:50:41 +0100
Paul Bolle <pebolle@tiscali.nl> escreveu:

> Hi Fengguang,
> 
> On Wed, 2014-11-26 at 09:34 +0800, kbuild test robot wrote:
> > tree:   git://linuxtv.org/media_tree.git master
> > head:   504febc3f98c87a8bebd8f2f274f32c0724131e4
> > commit: 6b213e81ddf8b265383c9a1a1884432df88f701e [7661/7664] [media] omap: Fix typo "HAS_MMU"
> > config: m68k-allmodconfig (attached as .config)
> > reproduce:
> >   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> >   chmod +x ~/bin/make.cross
> >   git checkout 6b213e81ddf8b265383c9a1a1884432df88f701e
> >   # save the attached .config to linux build tree
> >   make.cross ARCH=m68k 
> 
> This is the first time I've made the kbuild test robot trip. So I'm not
> sure how to interpret this.

I did some tests yesterday, and compilation of this driver also broke
on other archs.

So, I removed COMPILE_TEST:
	http://git.linuxtv.org/cgit.cgi/mchehab/media-next.git/commit/

We may be able to re-enable if someone do some work on this driver for
it to use the standard DMA API, instead of an omap-specific one.

Btw, I had to do a similar patch also for OMAP1 driver sometime ago:

commit 4228cd5682f07b6cf5dfd3eb5e003766f5640ee2
Author: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date:   Tue Sep 9 14:55:15 2014 -0300

    [media] disable COMPILE_TEST for omap1_camera
    
    This driver depends on a legacy OMAP DMA API. So, it won't
    compile-test on other archs.
    
    While we might add stubs to the functions, this is not a
    good idea, as the hole API should be replaced.
    
    So, for now, let's just remove COMPILE_TEST and wait for
    some time for people to fix. If not fixed, then we'll end
    by removing this driver as a hole.

> 
> Is ARCH=m68k the only build that failed through this commit? Or is it
> the first build that failed? If so, how can I determine which arches
> build correctly?
> 
> > All error/warnings:
> > 
> > >> ERROR: "omapdss_compat_init" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_overlay_manager" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_num_overlay_managers" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_overlay" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omapdss_is_initialized" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dispc_register_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omapdss_get_version" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_put_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_next_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dispc_unregister_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omapdss_compat_uninit" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > >> ERROR: "omap_dss_get_num_overlays" [drivers/media/platform/omap/omap-vout.ko] undefined!
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
> Thanks,
> 
> Paul Bolle
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
