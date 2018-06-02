Return-path: <linux-media-owner@vger.kernel.org>
Received: from conssluserg-04.nifty.com ([210.131.2.83]:21635 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeFBMAD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 08:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <20180530090946.1635-4-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com> <20180530090946.1635-4-suzuki.katsuhiro@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Sat, 2 Jun 2018 20:59:00 +0900
Message-ID: <CAK7LNASZwdiuWjaZ-AokQYPpU-uH8RZZxL2kGPG=EckmCKCx9g@mail.gmail.com>
Subject: Re: [PATCH 3/8] media: uniphier: add submodules of HSC MPEG2-TS I/O driver
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-30 18:09 GMT+09:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> This patch adds submodules of HSC for UniPhier SoCs.
> These work as follows:
>   ucode: Load uCode and start subsystems
>   css  : Switch stream path
>   ts   : Receive MPEG2-TS clock and signal
>   dma  : Transfer MPEG2-TS data bytes to main memory
>
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> ---
>  drivers/media/platform/uniphier/Makefile    |   3 +
>  drivers/media/platform/uniphier/hsc-css.c   | 258 ++++++++++++
>  drivers/media/platform/uniphier/hsc-dma.c   | 302 ++++++++++++++
>  drivers/media/platform/uniphier/hsc-ts.c    |  99 +++++
>  drivers/media/platform/uniphier/hsc-ucode.c | 436 ++++++++++++++++++++
>  5 files changed, 1098 insertions(+)
>  create mode 100644 drivers/media/platform/uniphier/hsc-css.c
>  create mode 100644 drivers/media/platform/uniphier/hsc-dma.c
>  create mode 100644 drivers/media/platform/uniphier/hsc-ts.c
>  create mode 100644 drivers/media/platform/uniphier/hsc-ucode.c
>
> diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
> index f66554cd5c45..92536bc56b31 100644
> --- a/drivers/media/platform/uniphier/Makefile
> +++ b/drivers/media/platform/uniphier/Makefile
> @@ -1 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> +uniphier-dvb-y += hsc-ucode.o hsc-css.o hsc-ts.o hsc-dma.o
> +
> +obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o



If you claim this driver is tristate,
you need to do compile-test with =m.


I see the following warning for allmodconfig.


  CC [M]  drivers/media/platform/uniphier/hsc-ucode.o
  CC [M]  drivers/media/platform/uniphier/hsc-css.o
  CC [M]  drivers/media/platform/uniphier/hsc-ts.o
  CC [M]  drivers/media/platform/uniphier/hsc-dma.o
  LD [M]  drivers/media/platform/uniphier/uniphier-dvb.o
WARNING: modpost: missing MODULE_LICENSE() in
drivers/media/platform/uniphier/uniphier-dvb.o
see include/linux/module.h for more information










-- 
Best Regards
Masahiro Yamada
