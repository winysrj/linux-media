Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44830 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754272AbeDCHNg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 03:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <201804030025.FmWPyArN%fengguang.wu@intel.com>
References: <20180402142656.26815-13-robert.jarzmik@free.fr> <201804030025.FmWPyArN%fengguang.wu@intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 3 Apr 2018 09:13:34 +0200
Message-ID: <CAK8P3a0T3HV9ee4Kk7+Y16S-51SLzbn5fRBsr4bSV0ZQnthPVg@mail.gmail.com>
Subject: Re: [PATCH 12/15] dmaengine: pxa: make the filter function internal
To: kbuild test robot <lkp@intel.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, kbuild-all@01.org,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>, dmaengine@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 2, 2018 at 6:35 PM, kbuild test robot <lkp@intel.com> wrote:

>
>    drivers/mtd/nand/marvell_nand.c:2621:17: sparse: undefined identifier 'pxad_filter_fn'
>>> drivers/mtd/nand/marvell_nand.c:2621:17: sparse: call with no type!
>    In file included from drivers/mtd/nand/marvell_nand.c:21:0:
>    drivers/mtd/nand/marvell_nand.c: In function 'marvell_nfc_init_dma':
>    drivers/mtd/nand/marvell_nand.c:2621:42: error: 'pxad_filter_fn' undeclared (first use in this function); did you mean 'dma_filter_fn'?
>       dma_request_slave_channel_compat(mask, pxad_filter_fn,
>                                              ^
>    include/linux/dmaengine.h:1408:46: note: in definition of macro 'dma_request_slave_channel_compat'
>      __dma_request_slave_channel_compat(&(mask), x, y, dev, name)
>                                                  ^
>    drivers/mtd/nand/marvell_nand.c:2621:42: note: each undeclared identifier is reported only once for each function it appears in
>       dma_request_slave_channel_compat(mask, pxad_filter_fn,
>                                              ^
>    include/linux/dmaengine.h:1408:46: note: in definition of macro 'dma_request_slave_channel_compat'
>      __dma_request_slave_channel_compat(&(mask), x, y, dev, name)

The driver is a replacement for the pxa3xx nand driver, so it now has
to get changed as well.

       Arnd
