Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52553 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3I3HJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 03:09:13 -0400
Received: by mail-pa0-f44.google.com with SMTP id lf10so5477723pab.31
        for <linux-media@vger.kernel.org>; Mon, 30 Sep 2013 00:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130930030518.GA3024@localhost>
References: <5248d26d.XCpLjin/D8FfRGFk%fengguang.wu@intel.com>
	<20130930030518.GA3024@localhost>
Date: Mon, 30 Sep 2013 09:09:13 +0200
Message-ID: <CAMuHMdWj2BBQ88Wrx_sNNELVG5LiupsaG+RxWpidC2HC-=Y8MA@mail.gmail.com>
Subject: Re: mcam-core.c:undefined reference to `vb2_dma_sg_memops'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang,

On Mon, Sep 30, 2013 at 5:05 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> FYI, kernel build failed on
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   15c03dd4859ab16f9212238f29dd315654aa94f6
> commit: 866f321339988293a5bb3ec6634c2c9d8396bf54 Revert "staging/solo6x10: depend on CONFIG_FONTS"
> date:   3 months ago
> config: x86_64-randconfig-c5-0930 (attached as .config)
>
> All error/warnings:
>
>    drivers/built-in.o: In function `mcam_v4l_open':
>>> mcam-core.c:(.text+0x3bf73a): undefined reference to `vb2_dma_sg_memops'

The referenced commit above is completely unrelated to this failure, as
both CONFIG_SOLO6X10=m and CONFIG_VIDEOBUF2_DMA_SG=m,
while this is about a missing symbol in builtin code.

However, there's something wrong with the VIDEO_CAFE_CCIC dependencies.
Untested gmail-white-space-damaged patch below (so your trick of emailing random
people to obtain a solution worked ;-)

>From 8a53ff3c33cfaa8641c9ba3e16bc5b0a35c74842 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Sep 2013 09:03:20 +0200
Subject: [PATCH] [media] VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG

If VIDEO_CAFE_CCIC=y, but VIDEOBUF2_DMA_SG=m:

drivers/built-in.o: In function `mcam_v4l_open':
>> mcam-core.c:(.text+0x3bf73a): undefined reference to `vb2_dma_sg_memops'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/marvell-ccic/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig
b/drivers/media/platform/marvell-ccic/Kconfig
index bf739e3..ec4c771 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_CAFE_CCIC
  select VIDEO_OV7670
  select VIDEOBUF2_VMALLOC
  select VIDEOBUF2_DMA_CONTIG
+ select VIDEOBUF2_DMA_SG
  ---help---
   This is a video4linux2 driver for the Marvell 88ALP01 integrated
   CMOS camera controller.  This is the controller found on first-
-- 
1.7.9.5

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
