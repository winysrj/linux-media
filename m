Return-path: <linux-media-owner@vger.kernel.org>
Received: from conssluserg-05.nifty.com ([210.131.2.90]:47358 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeFBL5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2018 07:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <20180530090946.1635-3-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com> <20180530090946.1635-3-suzuki.katsuhiro@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Sat, 2 Jun 2018 20:56:36 +0900
Message-ID: <CAK7LNARTBEv0opWUXQ-of0rtNcGQcOD0Kawzv44_HNhd299Uog@mail.gmail.com>
Subject: Re: [PATCH 2/8] media: uniphier: add headers of HSC MPEG2-TS I/O driver
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
> This patch adds register definitions of  HSC (High speed Stream
> Controller) driver for Socionext UniPhier SoCs. The HSC enables to
> input and output MPEG2-TS stream from/to outer world of SoC.
>
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> ---
>  drivers/media/platform/Kconfig            |   1 +
>  drivers/media/platform/Makefile           |   2 +
>  drivers/media/platform/uniphier/Kconfig   |   9 +
>  drivers/media/platform/uniphier/Makefile  |   1 +
>  drivers/media/platform/uniphier/hsc-reg.h | 491 ++++++++++++++++++++++
>  drivers/media/platform/uniphier/hsc.h     | 480 +++++++++++++++++++++
>  6 files changed, 984 insertions(+)
>  create mode 100644 drivers/media/platform/uniphier/Kconfig
>  create mode 100644 drivers/media/platform/uniphier/Makefile
>  create mode 100644 drivers/media/platform/uniphier/hsc-reg.h
>  create mode 100644 drivers/media/platform/uniphier/hsc.h

What's the point of adding an empty Makefile,
and header files in a separate commit?

Anyway, ...


>
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 2728376b04b5..289ab4dfd30e 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -525,6 +525,7 @@ menuconfig DVB_PLATFORM_DRIVERS
>
>  if DVB_PLATFORM_DRIVERS
>  source "drivers/media/platform/sti/c8sectpfe/Kconfig"
> +source "drivers/media/platform/uniphier/Kconfig"
>  endif #DVB_PLATFORM_DRIVERS
>
>  menuconfig CEC_PLATFORM_DRIVERS
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 04bc1502a30e..08d5052119ef 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -93,3 +93,5 @@ obj-$(CONFIG_VIDEO_QCOM_CAMSS)                += qcom/camss-8x16/
>  obj-$(CONFIG_VIDEO_QCOM_VENUS)         += qcom/venus/
>
>  obj-y                                  += meson/
> +
> +obj-$(CONFIG_DVB_UNIPHIER)             += uniphier/
> diff --git a/drivers/media/platform/uniphier/Kconfig b/drivers/media/platform/uniphier/Kconfig
> new file mode 100644
> index 000000000000..1b4543ec1e3c
> --- /dev/null
> +++ b/drivers/media/platform/uniphier/Kconfig
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +config DVB_UNIPHIER
> +       tristate "Socionext UniPhier Frontend"
> +       depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> +       depends on ARCH_UNIPHIER


depends on ARCH_UNIPHIER || COMPILE_TEST


Not so sure if regmap is useful here.
Anyway this driver uses regmap_{read,write},
but 'select REGMAP_MMIO' is missing.





> +       help
> +         Driver for UniPhier frontend for MPEG2-TS input/output,
> +         demux and descramble.
> +         Say Y when you want to support this frontend.
> diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
> new file mode 100644
> index 000000000000..f66554cd5c45
> --- /dev/null
> +++ b/drivers/media/platform/uniphier/Makefile
> @@ -0,0 +1 @@
> +# SPDX-License-Identifier: GPL-2.0
> diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
> new file mode 100644
> index 000000000000..5f0a9b86cf49
> --- /dev/null
> +++ b/drivers/media/platform/uniphier/hsc-reg.h
> @@ -0,0 +1,491 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
> + *
> + * Copyright (c) 2018 Socionext Inc.
> + */
> +
> +#ifndef DVB_UNIPHIER_HSC_REG_H__
> +#define DVB_UNIPHIER_HSC_REG_H__
> +
> +/*
> + * CH_0 : CIP-R8, W9
> + * CH_1 : CIP-R10,W11
> + * CH_2 : CIP-R12,W13
> + * CH_3 : CIP-R14,W15
> + * CH_4 : CIP-R16,W17
> + */
> +enum HSC_CIP_FILE_NO {


Please use lower cases for enum.


> +       HSC_CIP_FILE_NO_0 = 0x0,
> +       HSC_CIP_FILE_NO_1,
> +       HSC_CIP_FILE_NO_2,
> +       HSC_CIP_FILE_NO_3,
> +       HSC_CIP_FILE_NO_4,
> +       HSC_CIP_FILE_NO_END,
> +       HSC_CIP_FILE_NO_DISABLE,
> +};

This is OK.

The members of enum should be capitalized.





[ snip ]

> +
> +/* MBC
> + * i: channel number
> + *    1- 3: Record0,1,2
> + *   19-21: Record3,4,5
> + */


Why is this block comment sylte?


Documentation/process/coding-style.rst says
this style is used only files under net/ and drivers/net.




> +#define CDMBC_CHTDCTRLH(i)            (((i) < 19) ? \
> +                                       (0x23a4 + ((i) - 1) * 0x20) : \
> +                                       (0x23b4 + ((i) - 19) * 0x20))
> +#define   CDMBC_CHTDCTRLH_STREM_MASK    GENMASK(20, 16)
> +#define   CDMBC_CHTDCTRLH_NOT_FLT       BIT(7)
> +#define   CDMBC_CHTDCTRLH_ALL_EN        BIT(6)
> +#define CDMBC_CHTDCTRLU(i)            (((i) < 19) ? \
> +                                       (0x23a8 + ((i) - 1) * 0x20) : \
> +                                       (0x23b8 + ((i) - 19) * 0x20))


Hmm, OK this is macro...



> +#define CDMBC_TDSTAT                  0x23f8
> +#define CDMBC_TDIR                    0x23fc
> +#define CDMBC_REPRATECTRL             0x2400
> +#define CDMBC_ATRIBUTE0               0x24e8
> +#define CDMBC_ATRIBUTE1               0x24ec
> +#define CDMBC_ATRIBUTE2               0x24f0
> +#define CDMBC_ATRIBUTE3               0x24f4
> +#define CDMBC_ATRIBUTE4               0x24f8
> +#define CDMBC_CIPMODE(i)              (0x24fc + (i) * 0x4)
> +#define   CDMBC_CIPMODE_PUSH            BIT(0)
> +#define CDMBC_CIPPRIORITY(i)          (0x2510 + (i) * 0x4)
> +#define   CDMBC_CIPPRIORITY_PRIOR_MASK  GENMASK(1, 0)
> +#define CDMBC_CH18ATTRIBUTE           (0x2524)
> +
> +/* MBC Channel
> + * i: channel number
> + *    0   : Section
> + *    1- 3: Record0,1,2
> + *    4   : Partial
> + *    5- 7: Replay0,1,2
> + *    8-17: Even: CIP-Read
> + *          Odd : CIP-Write
> + *   18   : AM32
> + *   19-21: Record3,4,5
> + *   22-24: Replay3,4,5
> + */
> +#define CDMBC_CHCTRL1(i)                  (0x2540 + (i) * 0x50)
> +#define   CDMBC_CHCTRL1_LINKCH1_MASK        GENMASK(12, 10)
> +#define   CDMBC_CHCTRL1_STATSEL_MASK        GENMASK(9, 7)
> +#define   CDMBC_CHCTRL1_TYPE_INTERMIT       BIT(1)
> +#define   CDMBC_CHCTRL1_IND_SIZE_UND        BIT(0)
> +#define CDMBC_CHCTRL2(i)                  (0x2544 + (i) * 0x50)
> +#define CDMBC_CHDDR(i)                    (0x2548 + (i) * 0x50)
> +#define   CDMBC_CHDDR_REG_LOAD_ON           BIT(4)
> +#define   CDMBC_CHDDR_AT_CHEN_ON            BIT(3)
> +#define   CDMBC_CHDDR_SET_MCB_MASK          GENMASK(2, 1)
> +#define   CDMBC_CHDDR_SET_MCB_WR            (0x0 << 1)
> +#define   CDMBC_CHDDR_SET_MCB_RD            (0x3 << 1)
> +#define   CDMBC_CHDDR_SET_DDR_1             BIT(0)
> +#define CDMBC_CHCAUSECTRL(i)              (0x254c + (i) * 0x50)
> +#define   CDMBC_CHCAUSECTRL_MODE_MASK       BIT(31)
> +#define   CDMBC_CHCAUSECTRL_CSEL2_MASK      GENMASK(20, 12)
> +#define   CDMBC_CHCAUSECTRL_CSEL1_MASK      GENMASK(8, 0)
> +#define CDMBC_CHSTAT(i)                   (0x2550 + (i) * 0x50)
> +#define CDMBC_CHIR(i)                     (0x2554 + (i) * 0x50)
> +#define CDMBC_CHIE(i)                     (0x2558 + (i) * 0x50)
> +#define CDMBC_CHID(i)                     (0x255c + (i) * 0x50)
> +#define   CDMBC_CHI_STOPPED                 BIT(13)
> +#define   CDMBC_CHI_TRANSIT                 BIT(6)
> +#define   CDMBC_CHI_STARTING                BIT(1)
> +#define CDMBC_CHSRCAMODE(i)               (0x2560 + (i) * 0x50)
> +#define CDMBC_CHDSTAMODE(i)               (0x2564 + (i) * 0x50)
> +#define   CDMBC_CHAMODE_TUNIT_MASK          GENMASK(29, 28)
> +#define   CDMBC_CHAMODE_ENDIAN_MASK         GENMASK(17, 16)
> +#define   CDMBC_CHAMODE_AUPDT_MASK          GENMASK(5, 4)
> +#define   CDMBC_CHAMODE_TYPE_RB             BIT(2)
> +#define CDMBC_CHSRCSTRTADRSD(i)           (0x2568 + (i) * 0x50)
> +#define CDMBC_CHSRCSTRTADRSU(i)           (0x256c + (i) * 0x50)
> +#define CDMBC_CHDSTSTRTADRSD(i)           (0x2570 + (i) * 0x50)
> +#define CDMBC_CHDSTSTRTADRSU(i)           (0x2574 + (i) * 0x50)
> +#define   CDMBC_CHDSTSTRTADRS_TID_MASK      GENMASK(31, 28)
> +#define   CDMBC_CHDSTSTRTADRS_ID1_EN_MASK   BIT(15)
> +#define   CDMBC_CHDSTSTRTADRS_KEY_ID1_MASK  GENMASK(12, 8)
> +#define   CDMBC_CHDSTSTRTADRS_KEY_ID0_MASK  GENMASK(4, 0)
> +#define CDMBC_CHSIZE(i)                   (0x2578 + (i) * 0x50)
> +#define CDMBC_CHIRADRSD(i)                (0x2580 + (i) * 0x50)
> +#define CDMBC_CHIRADRSU(i)                (0x2584 + (i) * 0x50)
> +#define CDMBC_CHDST1STUSIZE(i)            (0x258C + (i) * 0x50)
> +
> +/* MBC DMA
> + * i: channel number
> + *    5- 7: Replay0,1,2
> + *    8-17: Even: CIP-Read
> + *          Odd : CIP-Write
> + *   22-24: Replay3-5
> + */
> +static inline int HSC_IT_INT(int i)
> +{
> +       if (i > 21)
> +               return i - 9;
> +
> +       return i - 5;
> +}
> +
> +#define CDMBC_ITCTRL(i)              (0x3000 + HSC_IT_INT(i) * 0x20)
> +#define CDMBC_ITSTEPS(i)             (0x3018 + HSC_IT_INT(i) * 0x20)
> +
> +/* MBC Ring buffer
> + * i: channel number
> + *    0   : Section (RB0)
> + *    1- 3: Record0,1,2 (RB1-3)
> + *    5- 7: Replay0,1,2 (RB4-6)
> + *    8-17: Even: CIP-Read
> + *          Odd : CIP-Write (RB7-16)
> + *   19-21: Record3-4 (RB17-19)
> + *   22-24: Replay3-4 (RB20-22)
> + */
> +static inline int HSC_INT(int i)
> +{
> +       if (i > 18)
> +               return i - 2;
> +       if (i > 4)
> +               return i - 1;
> +
> +       return i;
> +}

CDMBC_CHTDCTRLH(i) was a macro,
but HSC_INT() is a static inline function inconsistently,
then used from the lots of macros below...
Wow.

This is already enough crap.
Is there any other way instead of
putting all the mess into registers?


> +#define CDMBC_RBBGNADRS(i)           (0x3200 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBBGNADRSD(i)          (0x3200 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBBGNADRSU(i)          (0x3204 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBENDADRS(i)           (0x3208 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBENDADRSD(i)          (0x3208 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBENDADRSU(i)          (0x320C + HSC_INT(i) * 0x40)
> +#define CDMBC_RBIR(i)                (0x3214 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBIE(i)                (0x3218 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBID(i)                (0x321c + HSC_INT(i) * 0x40)
> +#define CDMBC_RBRDPTR(i)             (0x3220 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBRDPTRD(i)            (0x3220 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBRDPTRU(i)            (0x3224 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBWRPTR(i)             (0x3228 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBWRPTRD(i)            (0x3228 + HSC_INT(i) * 0x40)
> +#define CDMBC_RBWRPTRU(i)            (0x322C + HSC_INT(i) * 0x40)
> +#define CDMBC_RBERRCNFG(i)           (0x3238 + HSC_INT(i) * 0x40)
> +
> +/* MBC Rate */
> +#define CDMBC_RCNMSKCYC(i)           (MBC6_TOP_ADDR + 0x000 + (i) * 0x04)
> +
> +/* MBC Address Transfer */
> +#define CDMBC_CHPSIZE(i)             (0x3c00 + ((i) - 1) * 0x48)
> +#define CDMBC_CHATCTRL(i)            (0x3c04 + ((i) - 1) * 0x48)
> +#define CDMBC_CHBTPAGE(i, j)         (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
> +#define CDMBC_CHBTPAGED(i, j)        (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
> +#define CDMBC_CHBTPAGEU(i, j)        (0x3c0C + ((i) - 1) * 0x48 + (j) * 0x10)
> +#define CDMBC_CHATPAGE(i, j)         (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
> +#define CDMBC_CHATPAGED(i, j)        (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
> +#define CDMBC_CHATPAGEU(i, j)        (0x3c14 + ((i) - 1) * 0x48 + (j) * 0x10)
> +
> +/* CSS */
> +#define CSS_PTSOCONFIG                   0x1c00
> +#define CSS_PTSISIGNALPOL                0x1c04
> +#define CSS_SIGNALPOLCH(i)               (0x1c08 + (i) * 0x4)
> +#define CSS_OUTPUTENABLE                 0x1c10
> +#define CSS_OUTPUTCTRL(i)                (0x1c14 + (i) * 0x4)
> +#define CSS_STSOCONFIG                   0x1c2c
> +#define CSS_STSOSIGNALPOL                0x1c30
> +#define CSS_DMDSIGNALPOL                 0x1c34
> +#define CSS_PTSOSIGNALPOL                0x1c38
> +#define CSS_PF0CONFIG                    0x1c3c
> +#define CSS_PF1CONFIG                    0x1c40
> +#define CSS_PFINTENABLE                  0x1c44
> +#define CSS_PFINTSTATUS                  0x1c48
> +#define CSS_AVOUTPUTCTRL(i)              (0x1c4c + (i) * 0x4)
> +#define CSS_DPCTRL(i)                    (0x1c54 + (i) * 0x4)
> +#define   CSS_DPCTRL_DPSEL_MASK            GENMASK(22, 0)
> +#define   CSS_DPCTRL_DPSEL_PLAY5           BIT(15)
> +#define   CSS_DPCTRL_DPSEL_PLAY4           BIT(14)
> +#define   CSS_DPCTRL_DPSEL_PLAY3           BIT(13)
> +#define   CSS_DPCTRL_DPSEL_PLAY2           BIT(12)
> +#define   CSS_DPCTRL_DPSEL_PLAY1           BIT(11)
> +#define   CSS_DPCTRL_DPSEL_PLAY0           BIT(10)
> +#define   CSS_DPCTRL_DPSEL_TSI4            BIT(4)
> +#define   CSS_DPCTRL_DPSEL_TSI3            BIT(3)
> +#define   CSS_DPCTRL_DPSEL_TSI2            BIT(2)
> +#define   CSS_DPCTRL_DPSEL_TSI1            BIT(1)
> +#define   CSS_DPCTRL_DPSEL_TSI0            BIT(0)
> +
> +/* TSI */
> +#define TSI_SYNCCNTROL(i)                (0x7100 + (i) * 0x70)
> +#define   TSI_SYNCCNTROL_FRAME_MASK        GENMASK(18, 16)
> +#define   TSI_SYNCCNTROL_FRAME_EXTSYNC1    (0x0 << 16)
> +#define   TSI_SYNCCNTROL_FRAME_EXTSYNC2    (0x1 << 16)
> +#define TSI_CONFIG(i)                    (0x7104 + (i) * 0x70)
> +#define   TSI_CONFIG_ATSMD_MASK            GENMASK(22, 21)
> +#define   TSI_CONFIG_ATSMD_PCRPLL0         (0x0 << 21)
> +#define   TSI_CONFIG_ATSMD_PCRPLL1         (0x1 << 21)
> +#define   TSI_CONFIG_ATSMD_DPLL            (0x3 << 21)
> +#define   TSI_CONFIG_ATSADD_ON             BIT(20)
> +#define   TSI_CONFIG_STCMD_MASK            GENMASK(7, 6)
> +#define   TSI_CONFIG_STCMD_PCRPLL0         (0x0 << 6)
> +#define   TSI_CONFIG_STCMD_PCRPLL1         (0x1 << 6)
> +#define   TSI_CONFIG_STCMD_DPLL            (0x3 << 6)
> +#define   TSI_CONFIG_CHEN_START            BIT(0)
> +#define TSI_RATEUPLMT(i)                 (0x7108 + (i) * 0x70)
> +#define TSI_RATELOWLMT(i)                (0x710c + (i) * 0x70)
> +#define TSI_CNTINTR(i)                   (0x7110 + (i) * 0x70)
> +#define TSI_INTREN(i)                    (0x7114 + (i) * 0x70)
> +#define   TSI_INTR_NTP                     BIT(13)
> +#define   TSI_INTR_NTPCNT                  BIT(12)
> +#define   TSI_INTR_PKTEND                  BIT(11)
> +#define   TSI_INTR_PCR                     BIT(9)
> +#define   TSI_INTR_LOAD                    BIT(8)
> +#define   TSI_INTR_SERR                    BIT(7)
> +#define   TSI_INTR_SOF                     BIT(6)
> +#define   TSI_INTR_TOF                     BIT(5)
> +#define   TSI_INTR_UL                      BIT(4)
> +#define   TSI_INTR_LL                      BIT(3)
> +#define   TSI_INTR_CNT                     BIT(2)
> +#define   TSI_INTR_LOST                    BIT(1)
> +#define   TSI_INTR_LOCK                    BIT(0)
> +#define TSI_SYNCSTATUS(i)                (0x7118 + (i) * 0x70)
> +#define   TSI_STAT_PKTST_ERR               BIT(21)
> +#define   TSI_STAT_LARGE_ERR               BIT(20)
> +#define   TSI_STAT_SMALL_ERR               BIT(19)
> +#define   TSI_STAT_LOCK                    BIT(18)
> +#define   TSI_STAT_SYNC                    BIT(17)
> +#define   TSI_STAT_SEARCH                  BIT(16)
> +#define TSI_PCRPID(i)                    (0x711c + (i) * 0x70)
> +#define TSI_PCRCTRL(i)                   (0x7120 + (i) * 0x70)
> +#define TSI_STCBASE(i)                   (0x7124 + (i) * 0x70)
> +#define TSI_STCEXT(i)                    (0x7128 + (i) * 0x70)
> +#define TSI_CURSTC1(i)                   (0x712c + (i) * 0x70)
> +#define TSI_CURSTCBASE(i)                (0x712c + (i) * 0x70)
> +#define TSI_CURSTC2(i)                   (0x7130 + (i) * 0x70)
> +#define TSI_CURSTCEXT(i)                 (0x7130 + (i) * 0x70)
> +#define TSI_STC2BASE(i)                  (0x7134 + (i) * 0x70)
> +#define TSI_STC2EXT(i)                   (0x7138 + (i) * 0x70)
> +#define TSI_PCRBASE(i)                   (0x713c + (i) * 0x70)
> +#define TSI_PCREXT(i)                    (0x7140 + (i) * 0x70)
> +#define TSI_TIMESTAMP(i)                 (0x7144 + (i) * 0x70)
> +#define TSI_CNTCTRL0(i)                  (0x7148 + (i) * 0x70)
> +#define TSI_CNTCTRL1(i)                  (0x714c + (i) * 0x70)
> +#define TSI_DEBUG(i)                     (0x7150 + (i) * 0x70)
> +
> +#define TSI_STCCMPCTRL                   0x7000
> +#define VCXOSTCBASE(i)                   (0x7010 + (i) * 0x18)
> +#define VCXOSTCEXT(i)                    (0x7014 + (i) * 0x18)
> +#define VCXOCURSTC1(i)                   (0x7018 + (i) * 0x18)
> +#define VCXOCURSTC2(i)                   (0x701c + (i) * 0x18)
> +#define VCXOSTC2BASE(i)                  (0x7020 + (i) * 0x18)
> +#define VCXOSTC2EXT(i)                   (0x7024 + (i) * 0x18)
> +
> +/* UCODE DL */
> +#define UCODE_REVISION_AM                0x10fd0
> +#define CIP_UCODEADDR_AM1                0x10fd4
> +#define CIP_UCODEADDR_AM0                0x10fd8
> +#define CORRECTATS_CTRL                  0x10fdc
> +#define UCODE_REVISION                   0x10fe0
> +#define AM_UCODE_IGPGCTRL                0x10fe4
> +#define REPDPLLCTRLEN                    0x10fe8
> +#define UCODE_DLADDR1                    0x10fec
> +#define UCODE_DLADDR0                    0x10ff0
> +#define UCODE_ERRLOGCTRL                 0x10ff4
> +
> +#endif /* DVB_UNIPHIER_HSC_REG_H__ */
> diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
> new file mode 100644
> index 000000000000..ad57fea58675
> --- /dev/null
> +++ b/drivers/media/platform/uniphier/hsc.h
> @@ -0,0 +1,480 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
> + *
> + * Copyright (c) 2018 Socionext Inc.
> + */
> +
> +#ifndef DVB_UNIPHIER_HSC_H__
> +#define DVB_UNIPHIER_HSC_H__
> +
> +#include <linux/gpio/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>
> +
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +
> +enum HSC_CORE {
> +       HSC_CORE_0,
> +       HSC_CORE_1,
> +       HSC_CORE_2,
> +};
> +
> +enum HSC_UCODE {
> +       HSC_UCODE_SPU_0,
> +       HSC_UCODE_SPU_1,
> +       HSC_UCODE_ACE,
> +};
> +
> +enum HSC_INTR_IOB {
> +       HSC_INTR_IOB_0,
> +       HSC_INTR_IOB_0_1,
> +       HSC_INTR_IOB_0_2,
> +       HSC_INTR_IOB_1,
> +       HSC_INTR_IOB_1_1,
> +       HSC_INTR_IOB_2,
> +       HSC_INTR_IOB_3,
> +       HSC_INTR_IOB_4,
> +       HSC_INTR_IOB_5,
> +       HSC_INTR_IOB_5_1,
> +       HSC_INTR_IOB_5_2,
> +       HSC_INTR_IOB_6,
> +       HSC_INTR_IOB_6_1,
> +       HSC_INTR_IOB_7,
> +       HSC_INTR_IOB_8,
> +       HSC_INTR_IOB_9,
> +
> +       HSC_INTR_IOB_NUM,
> +};
> +
> +enum HSC_DPLL {
> +       HSC_DPLL0,
> +       HSC_DPLL1,
> +       HSC_DPLL2,
> +       HSC_DPLL3,
> +
> +       HSC_DPLL_NUM,
> +};
> +
> +enum HSC_DPLL_SRC {
> +       HSC_DPLL_SRC_NONE = -1,
> +       HSC_DPLL_SRC_TSI0 = 0x00,
> +       HSC_DPLL_SRC_TSI1,
> +       HSC_DPLL_SRC_TSI2,
> +       HSC_DPLL_SRC_TSI3,
> +       HSC_DPLL_SRC_TSI4,
> +       HSC_DPLL_SRC_TSI5,
> +       HSC_DPLL_SRC_TSI6,
> +       HSC_DPLL_SRC_TSI7,
> +       HSC_DPLL_SRC_TSI8,
> +       HSC_DPLL_SRC_TSI9,
> +       HSC_DPLL_SRC_REP0 = 0x0a,
> +       HSC_DPLL_SRC_REP1,
> +       HSC_DPLL_SRC_REP2,
> +       HSC_DPLL_SRC_REP3,
> +       HSC_DPLL_SRC_REP4,
> +       HSC_DPLL_SRC_REP5,
> +
> +       HSC_DPLL_SRC_NUM,
> +};
> +
> +/* Port to send to CSS */
> +enum HSC_CSS_IN {
> +       HSC_CSS_IN_1394_0 = 0x00,
> +       HSC_CSS_IN_1394_1,
> +       HSC_CSS_IN_1394_2,
> +       HSC_CSS_IN_1394_3,
> +       HSC_CSS_IN_DMD0 = 0x04,
> +       HSC_CSS_IN_DMD1,
> +       HSC_CSS_IN_SRLTS0 = 0x06,
> +       HSC_CSS_IN_SRLTS1,
> +       HSC_CSS_IN_SRLTS2,
> +       HSC_CSS_IN_SRLTS3,
> +       HSC_CSS_IN_SRLTS4,
> +       HSC_CSS_IN_SRLTS5,
> +       HSC_CSS_IN_SRLTS6,
> +       HSC_CSS_IN_SRLTS7,
> +       HSC_CSS_IN_PARTS0 = 0x10,
> +       HSC_CSS_IN_PARTS1,
> +       HSC_CSS_IN_PARTS2,
> +       HSC_CSS_IN_PARTS3,
> +       HSC_CSS_IN_TSO0 = 0x18,

Look like each must have a particular value.

Is it important to HSC_CSS_IN_TSO0 == 0x18 ?

If so, it might be better to do


#define HSC_CSS_IN_TSO0     0x18



> +       HSC_CSS_IN_TSO1,
> +       HSC_CSS_IN_TSO2,
> +       HSC_CSS_IN_TSO3,
> +       HSC_CSS_IN_ENCORDER0_IN = 0x1c,
> +       HSC_CSS_IN_ENCORDER1_IN,
> +
> +       HSC_CSS_IN_NUM,
> +};


[snip]

> +struct hsc_spec_dma {
> +       int dma_ch;
> +       struct hsc_dma_en en;
> +       struct hsc_cmn_intr intr;
> +};
> +
> +struct hsc_spec {
> +       const struct hsc_spec_ucode ucode_spu;

Suspicious usage of 'const'
since ucode_spu is not a pointer.

Look like you constified the whole hsc_spec,
so this 'const' should be here.


> +       const struct hsc_spec_ucode ucode_ace;

Ditto.

> +       const struct hsc_spec_init_ram *init_rams;

OK, this 'const' is legitimate since init-rams a pointer.


> +       size_t num_init_rams;
> +       const struct hsc_spec_css_in *css_in;
> +       size_t num_css_in;
> +       const struct hsc_spec_css_out *css_out;
> +       size_t num_css_out;
> +       const struct hsc_spec_ts *ts_in;
> +       size_t num_ts_in;
> +       const struct hsc_spec_dma *dma_in;
> +       size_t num_dma_in;
> +       const struct hsc_spec_dma *dma_out;
> +       size_t num_dma_out;
> +};
> +
> +struct hsc_tsif {
> +       struct hsc_chip *chip;
> +
> +       struct dvb_adapter adapter;
> +       struct dvb_demux demux;
> +       struct dmxdev dmxdev;
> +       struct dvb_frontend *fe;
> +       int valid_adapter;
> +       int valid_demux;
> +       int valid_dmxdev;
> +       int valid_fe;
> +
> +       enum HSC_CSS_IN css_in;
> +       enum HSC_CSS_OUT css_out;
> +       enum HSC_TS_IN tsi;
> +       enum HSC_DPLL dpll;
> +       enum HSC_DPLL_SRC dpll_src;
> +       struct hsc_dmaif *dmaif;
> +
> +       int running;
> +       struct delayed_work recover_work;
> +       unsigned long recover_delay;
> +};
> +
> +struct hsc_dma_in {
> +       struct hsc_chip *chip;
> +
> +       enum HSC_DMA_IN id;
> +       const struct hsc_spec_dma *spec;
> +       struct hsc_dma_buf *buf;
> +};
> +
> +struct hsc_dma_out {
> +       struct hsc_chip *chip;
> +
> +       enum HSC_DMA_OUT id;
> +       const struct hsc_spec_dma *spec;
> +       struct hsc_dma_buf *buf;
> +};
> +
> +struct hsc_dma_buf {
> +       void *virt;
> +       dma_addr_t phys;
> +       u64 size;
> +       u64 size_chk;
> +       u64 rd_offs;
> +       u64 wr_offs;
> +       u64 chk_offs;
> +};
> +
> +struct hsc_dmaif {
> +       struct hsc_chip *chip;
> +
> +       struct hsc_dma_buf buf_out;
> +       struct hsc_dma_out dma_out;
> +
> +       struct hsc_tsif *tsif;
> +
> +       /* guard read/write pointer of DMA buffer from interrupt handler */
> +       spinlock_t lock;
> +       int running;
> +       struct work_struct feed_work;
> +};
> +
> +struct hsc_chip {
> +       const struct hsc_spec *spec;
> +       short *adapter_nums;
> +
> +       struct platform_device *pdev;
> +       struct regmap *regmap;
> +       struct clk *clk_stdmac;
> +       struct clk *clk_hsc;
> +       struct reset_control *rst_stdmac;
> +       struct reset_control *rst_hsc;
> +
> +       struct hsc_dmaif dmaif[HSC_STREAM_IF_NUM];
> +       struct hsc_tsif tsif[HSC_STREAM_IF_NUM];
> +
> +       struct hsc_ucode_buf ucode_spu;
> +       struct hsc_ucode_buf ucode_am;
> +};
> +
> +struct hsc_conf {
> +       enum HSC_CSS_IN css_in;
> +       enum HSC_CSS_OUT css_out;
> +       enum HSC_DPLL dpll;
> +       enum HSC_DMA_OUT dma_out;
> +};
> +
> +static inline u32 field_prep(u32 mask, u32 v)
> +{
> +       int sft = ffs(mask) - 1;
> +
> +       return (v << sft) & mask;
> +}
> +
> +static inline u32 field_get(u32 mask, u32 v)
> +{
> +       int sft = ffs(mask) - 1;
> +
> +       return (v & mask) >> sft;
> +}

A good thing of <linux/bitfield.h> is, it is compile-time computable,
but this is not.

It might be better to re-consider the hsc_spec_css_out data arrangement.
For example, shift & width pair instead of shifted-mask.





> +/* CSS */
> +enum HSC_TS_IN hsc_css_out_to_ts_in(enum HSC_CSS_OUT out);
> +enum HSC_DPLL_SRC hsc_css_out_to_dpll_src(enum HSC_CSS_OUT out);
> +
> +int hsc_dpll_get_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
> +                    enum HSC_DPLL_SRC *src);
> +int hsc_dpll_set_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
> +                    enum HSC_DPLL_SRC src);
> +int hsc_css_in_get_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
> +                           bool *sync_bit, bool *val_bit, bool *clk_fall);
> +int hsc_css_in_set_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
> +                           bool sync_bit, bool val_bit, bool clk_fall);
> +int hsc_css_out_get_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
> +                            bool *sync_bit, bool *val_bit, bool *clk_fall);
> +int hsc_css_out_set_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
> +                            bool sync_bit, bool val_bit, bool clk_fall);
> +int hsc_css_out_get_src(struct hsc_chip *chip, enum HSC_CSS_IN *in,
> +                       enum HSC_CSS_OUT out, bool *en);
> +int hsc_css_out_set_src(struct hsc_chip *chip, enum HSC_CSS_IN in,
> +                       enum HSC_CSS_OUT out, bool en);
> +
> +/* TSI */
> +const struct hsc_spec_tsi *hsc_ts_in_get_spec(struct hsc_chip *chip,
> +                                             enum HSC_TS_IN in);
> +int hsc_ts_in_set_enable(struct hsc_chip *chip, enum HSC_TS_IN in, bool en);
> +int hsc_ts_in_set_dmaparam(struct hsc_chip *chip, enum HSC_TS_IN in,
> +                          enum HSC_TSIF_FMT ifmt);
> +
> +/* DMA */
> +u64 hsc_rb_cnt(struct hsc_dma_buf *buf);
> +u64 hsc_rb_cnt_to_end(struct hsc_dma_buf *buf);
> +u64 hsc_rb_space(struct hsc_dma_buf *buf);
> +u64 hsc_rb_space_to_end(struct hsc_dma_buf *buf);
> +int hsc_dma_in_init(struct hsc_dma_in *dma_in, struct hsc_chip *chip,
> +                   enum HSC_DMA_IN in, struct hsc_dma_buf *buf);
> +void hsc_dma_in_start(struct hsc_dma_in *dma_in, bool en);
> +void hsc_dma_in_sync(struct hsc_dma_in *dma_in);
> +int hsc_dma_in_get_intr(struct hsc_dma_in *dma_in, u32 *stat);
> +void hsc_dma_in_clear_intr(struct hsc_dma_in *dma_in, u32 clear);
> +int hsc_dma_out_init(struct hsc_dma_out *dma_out, struct hsc_chip *chip,
> +                    enum HSC_DMA_OUT out, struct hsc_dma_buf *buf);
> +void hsc_dma_out_set_src_ts_in(struct hsc_dma_out *dma_out,
> +                              enum HSC_TS_IN ts_in);
> +void hsc_dma_out_start(struct hsc_dma_out *dma_out, bool en);
> +void hsc_dma_out_sync(struct hsc_dma_out *dma_out);
> +int hsc_dma_out_get_intr(struct hsc_dma_out *dma_out, u32 *stat);
> +void hsc_dma_out_clear_intr(struct hsc_dma_out *dma_out, u32 clear);
> +
> +/* UCODE DL */
> +int hsc_ucode_load_all(struct hsc_chip *chip);
> +int hsc_ucode_unload_all(struct hsc_chip *chip);
> +
> +/* For Adapter */
> +int hsc_register_dvb(struct hsc_tsif *tsif);
> +void hsc_unregister_dvb(struct hsc_tsif *tsif);
> +int hsc_tsif_init(struct hsc_tsif *tsif, const struct hsc_conf *conf);
> +void hsc_tsif_release(struct hsc_tsif *tsif);
> +int hsc_dmaif_init(struct hsc_dmaif *dmaif, const struct hsc_conf *conf);
> +void hsc_dmaif_release(struct hsc_dmaif *dmaif);
> +extern const struct hsc_spec uniphier_hsc_ld11_spec;
> +extern const struct hsc_spec uniphier_hsc_ld20_spec;
> +
> +#endif /* DVB_UNIPHIER_HSC_H__ */
> --
> 2.17.0
>



-- 
Best Regards
Masahiro Yamada
