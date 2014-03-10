Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61611 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaCJIbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 04:31:18 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so6924387pbc.16
        for <linux-media@vger.kernel.org>; Mon, 10 Mar 2014 01:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531d3574.ABJnnOxkVY0Ybvpz%fengguang.wu@intel.com>
References: <531d3574.ABJnnOxkVY0Ybvpz%fengguang.wu@intel.com>
Date: Mon, 10 Mar 2014 09:31:16 +0100
Message-ID: <CAMuHMdWjZ=TmxXfwLmdWvx6Uzd5ome27OVd6Z8y2E6zxO9zD4g@mail.gmail.com>
Subject: Re: mcam-core.c:undefined reference to `vb2_dma_sg_memops'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 10, 2014 at 4:45 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   ca62eec4e524591b82d9edf7a18e3ae6b691517d
> commit: 866f321339988293a5bb3ec6634c2c9d8396bf54 Revert "staging/solo6x10: depend on CONFIG_FONTS"
> date:   9 months ago
> config: x86_64-randconfig-tt1-03101102 (attached as .config)
>
> All error/warnings:
>
>    drivers/built-in.o: In function `mcam_v4l_open':
>>> mcam-core.c:(.text+0x22b222): undefined reference to `vb2_dma_sg_memops'
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

Patch available and accepted according to patchwork:
https://patchwork.linuxtv.org/patch/20263/

But not yet in mainline

Also submitted by Randy: https://lkml.org/lkml/2013/10/31/395

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
