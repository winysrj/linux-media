Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39780 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662Ab2FUNnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 09:43:19 -0400
Received: by yenl2 with SMTP id l2so451673yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 06:43:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Thu, 21 Jun 2012 15:35:52 +0200
Message-ID: <CAGGh5h2NoojuguvRfQRsYx2xX1eRzXWw-sJYdnDgquWqoGbD-w@mail.gmail.com>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/6/18 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Rearrange the CFA interpolation coefficients table based on the Bayer
> pattern. Modifying the table during streaming isn't supported anymore,
> but didn't make sense in the first place anyway.
>
> Support for non-Bayer CFA patterns is dropped as they were not correctly
> supported, and have never been tested.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isppreview.c |  118 ++++++++++++++++------------
>  1 files changed, 67 insertions(+), 51 deletions(-)
>
> Jean-Philippe,
>
> Could you please test this patch on your hardware ?
>

Hi,

I have applied it on top of your omap3isp-next branch, but my board is
oopsing right after the boot.  I will try to get rid of this oops,
but if you eventually now another tree that includes the changes necessary
for this patch to apply, it could perhaps save me some time.

Here is a oops, in case somebody can point me to a patch, but the oops
is not very specific :

<6>Total of 96 interrupts on 1 active controller
<4>omap_hwmod: arm_fck: missing clockdomain for arm_fck.
<4>omap_hwmod: gpt1_fck: missing clockdomain for gpt1_fck.
<6>OMAP clockevent source: GPTIMER1 at 32768 Hz
<6>sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
<1>Unable to handle kernel NULL pointer dereference at virtual address 00000000
<1>pgd = c0004000
<1>[00000000] *pgd=00000000
<0>Internal error: Oops: 80000005 [#1] PREEMPT ARM
<d>Modules linked in:
CPU: 0    Not tainted  (3.4.0-rc3 #2)
PC is at 0x0
LR is at __irq_svc+0x40/0x70
pc : [<00000000>]    lr : [<c000e280>]    psr: 000001d3
sp : c0461f88  ip : 0000000f  fp : 00000000
r10: 00000000  r9 : 413fc082  r8 : 80004059
r7 : c0461fbc  r6 : ffffffff  r5 : 00000153  r4 : c04367e0
r3 : c0010108  r2 : c0461fd0  r1 : c046b00c  r0 : c0461f88
Flags: nzcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 80004019  DAC: 00000015
<0>Process swapper (pid: 0, stack limit = 0xc04602e8)
<0>Stack: (0xc0461f88 to 0xc0462000)
<0>1f80:                   00007735 000001d3 01ffffff c0468118 00000000 c046808c
<0>1fa0: c0456ec0 c046b004 80004059 413fc082 00000000 00000000 0000000f c0461fd0
<0>1fc0: c0010108 c04367e0 00000153 ffffffff 00000000 00000000 c04364fc 00000000
<0>1fe0: 00000000 c0456ec4 00000000 10c53c7d c046808c 8000803c 00000000 00000000
[<c000e280>] (__irq_svc+0x40/0x70) from [<c04367e0>] (start_kernel+0x138/0x254)
[<c04367e0>] (start_kernel+0x138/0x254) from [<8000803c>] (0x8000803c)
<0>Code: bad PC value



> diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
> index 8a4935e..bfa3107 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -309,36 +309,6 @@ preview_config_dcor(struct isp_prev_device *prev, const void *prev_dcor)
>  }
>
>  /*
> - * preview_config_cfa - Configures the CFA Interpolation parameters.
> - * @prev_cfa: Structure containing the CFA interpolation table, CFA format
> - *            in the image, vertical and horizontal gradient threshold.
> - */
> -static void
> -preview_config_cfa(struct isp_prev_device *prev, const void *prev_cfa)
> -{
> -       struct isp_device *isp = to_isp_device(prev);
> -       const struct omap3isp_prev_cfa *cfa = prev_cfa;
> -       unsigned int i;
> -
> -       isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> -                       ISPPRV_PCR_CFAFMT_MASK,
> -                       cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
> -
> -       isp_reg_writel(isp,
> -               (cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> -               (cfa->gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> -               OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> -
> -       isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> -                      OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> -
> -       for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
> -               isp_reg_writel(isp, cfa->table[i],
> -                              OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> -       }
> -}
> -
> -/*
>  * preview_config_gammacorrn - Configures the Gamma Correction table values
>  * @gtable: Structure containing the table for red, blue, green gamma table.
>  */
> @@ -813,7 +783,7 @@ static const struct preview_update update_attrs[] = {
>                FIELD_SIZEOF(struct prev_params, hmed),
>                offsetof(struct omap3isp_prev_update_config, hmed),
>        }, /* OMAP3ISP_PREV_CFA */ {
> -               preview_config_cfa,
> +               NULL,
>                NULL,
>                offsetof(struct prev_params, cfa),
>                FIELD_SIZEOF(struct prev_params, cfa),
> @@ -1043,42 +1013,88 @@ preview_config_ycpos(struct isp_prev_device *prev,
>  static void preview_config_averager(struct isp_prev_device *prev, u8 average)
>  {
>        struct isp_device *isp = to_isp_device(prev);
> -       struct prev_params *params;
> -       int reg = 0;
>
> -       params = (prev->params.active & OMAP3ISP_PREV_CFA)
> -              ? &prev->params.params[0] : &prev->params.params[1];
> -
> -       if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
> -               reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
> -                     ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
> -                     average;
> -       else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
> -               reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
> -                     ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
> -                     average;
> -       isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
> +       isp_reg_writel(isp, ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
> +                      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
> +                      average, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
>  }
>
> +
> +#define OMAP3ISP_PREV_CFA_BLK_SIZE     (OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
> +
>  /*
>  * preview_config_input_format - Configure the input format
>  * @prev: The preview engine
>  * @format: Format on the preview engine sink pad
>  *
> - * Enable CFA interpolation for Bayer formats and disable it for greyscale
> - * formats.
> + * Enable and configure CFA interpolation for Bayer formats and disable it for
> + * greyscale formats.
> + *
> + * The CFA table is organised in four blocks, one per Bayer component. The
> + * hardware expects blocks to follow the Bayer order of the input data, while
> + * the driver stores the table in GRBG order in memory. The blocks need to be
> + * reordered to support non-GRBG Bayer patterns.
>  */
>  static void preview_config_input_format(struct isp_prev_device *prev,
>                                        const struct v4l2_mbus_framefmt *format)
>  {
> +       static const unsigned int cfa_coef_order[4][4] = {
> +               { 0, 1, 2, 3 }, /* GRBG */
> +               { 1, 0, 3, 2 }, /* RGGB */
> +               { 2, 3, 0, 1 }, /* BGGR */
> +               { 3, 2, 1, 0 }, /* GBRG */
> +       };
>        struct isp_device *isp = to_isp_device(prev);
> +       struct prev_params *params;
> +       const unsigned int *order;
> +       unsigned int i;
> +       unsigned int j;
>
> -       if (format->code != V4L2_MBUS_FMT_Y10_1X10)
> -               isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> -                           ISPPRV_PCR_CFAEN);
> -       else
> +       if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
>                isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
>                            ISPPRV_PCR_CFAEN);
> +               return;
> +       }
> +
> +       params = (prev->params.active & OMAP3ISP_PREV_CFA)
> +              ? &prev->params.params[0] : &prev->params.params[1];
> +
> +       isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR, ISPPRV_PCR_CFAEN);
> +       isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> +                       ISPPRV_PCR_CFAFMT_MASK, ISPPRV_PCR_CFAFMT_BAYER);
> +
> +       isp_reg_writel(isp,
> +               (params->cfa.gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> +               (params->cfa.gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> +               OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> +
> +       switch (prev->formats[PREV_PAD_SINK].code) {
> +       case V4L2_MBUS_FMT_SGRBG10_1X10:
> +       default:
> +               order = cfa_coef_order[0];
> +               break;
> +       case V4L2_MBUS_FMT_SRGGB10_1X10:
> +               order = cfa_coef_order[1];
> +               break;
> +       case V4L2_MBUS_FMT_SBGGR10_1X10:
> +               order = cfa_coef_order[2];
> +               break;
> +       case V4L2_MBUS_FMT_SGBRG10_1X10:
> +               order = cfa_coef_order[3];
> +               break;
> +       }
> +
> +       isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> +                      OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> +
> +       for (i = 0; i < 4; ++i) {
> +               __u32 *block = params->cfa.table
> +                            + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
> +
> +               for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
> +                       isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
> +                                      ISPPRV_SET_TBL_DATA);
> +       }
>  }
>
>  /*
> --
> Regards,
>
> Laurent Pinchart
>
