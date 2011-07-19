Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53455 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab1GSKvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 06:51:45 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Date: Tue, 19 Jul 2011 16:21:17 +0530
Subject: RE: [RFC PATCH 1/8] davinci: vpfe: add dm3xx IPIPEIF hardware
 support module
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF740@dbde02.ent.ti.com>
References: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
 <1309439597-15998-2-git-send-email-manjunath.hadli@ti.com>
 <20110713185050.GC27451@valkosipuli.localdomain>
In-Reply-To: <20110713185050.GC27451@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,
 Thank you for your comments. I agree with them and fix. Please comment on the rest of the patches as well.
-Manju

On Thu, Jul 14, 2011 at 00:20:50, Sakari Ailus wrote:
> Hi Manju,
>
> Thanks for the patchset!
>
> I have a few comments on this patch below. I haven't read the rest of the patches yet so I may have more comments on this one when I do that.
>
> On Thu, Jun 30, 2011 at 06:43:10PM +0530, Manjunath Hadli wrote:
> > add support for dm3xx IPIPEIF hardware setup. This is the lowest
> > software layer for the dm3x vpfe driver which directly accesses
> > hardware. Add support for features like default pixel correction, dark
> > frame substraction  and hardware setup.
> >
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
> > ---
> >  drivers/media/video/davinci/dm3xx_ipipeif.c |  368 +++++++++++++++++++++++++++
> >  include/media/davinci/dm3xx_ipipeif.h       |  292 +++++++++++++++++++++
> >  2 files changed, 660 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
> >  create mode 100644 include/media/davinci/dm3xx_ipipeif.h
> >
> > diff --git a/drivers/media/video/davinci/dm3xx_ipipeif.c
> > b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > new file mode 100644
> > index 0000000..36cb61b
> > --- /dev/null
> > +++ b/drivers/media/video/davinci/dm3xx_ipipeif.c
> > @@ -0,0 +1,368 @@
> > +/*
> > +* Copyright (C) 2011 Texas Instruments Inc
> > +*
> > +* This program is free software; you can redistribute it and/or
> > +* modify it under the terms of the GNU General Public License as
> > +* published by the Free Software Foundation version 2.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*
> > +* You should have received a copy of the GNU General Public License
> > +* along with this program; if not, write to the Free Software
> > +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> > +02111-1307 USA
> > +*
> > +* ipipe module to hold common functionality across DM355 and DM365 */
> > +#include <linux/kernel.h> #include <linux/platform_device.h> #include
> > +<linux/uaccess.h> #include <linux/io.h> #include
> > +<linux/v4l2-mediabus.h> #include <media/davinci/dm3xx_ipipeif.h>
> > +
> > +#define DM355      0
> > +#define DM365      1
> > +
> > +static void *__iomem ipipeif_base_addr;
>
> This looks device specific. What about using dev_set/get_drvdata and remove this one?
>
> > +static int device_type;
>
> Ditto. Both should be in a device specific struct.
I will move both of the  above  to platform file.
>
> > +static inline u32 regr_if(u32 offset) {
> > +   return readl(ipipeif_base_addr + offset); }
> > +
> > +static inline void regw_if(u32 val, u32 offset) {
> > +   writel(val, ipipeif_base_addr + offset); }
> > +
> > +void ipipeif_set_enable(char en, unsigned int mode) {
> > +   regw_if(1, IPIPEIF_ENABLE);
> > +}
> > +
> > +u32 ipipeif_get_enable(void)
> > +{
> > +   return regr_if(IPIPEIF_ENABLE);
> > +}
> > +
> > +int ipipeif_set_address(struct ipipeif *params, unsigned int address)
> > +{
>
> If address is a value for a register you should use u32.
Okay.
>
> > +   unsigned int val1;
> > +   unsigned int val;
> > +
> > +   if (params->source != 0) {
> > +           val = ((params->adofs >> 5) & IPIPEIF_ADOFS_LSB_MASK);
> > +           regw_if(val, IPIPEIF_ADOFS);
>
> You may do without val as well.
>
> > +           /* lower sixteen bit */
> > +           val = ((address >> IPIPEIF_ADDRL_SHIFT) & IPIPEIF_ADDRL_MASK);
> > +           regw_if(val, IPIPEIF_ADDRL);
> > +
> > +           /* upper next seven bit */
> > +           val1 =
> > +               ((address >> IPIPEIF_ADDRU_SHIFT) & IPIPEIF_ADDRU_MASK);
> > +           regw_if(val1, IPIPEIF_ADDRU);
> > +   } else
> > +           return -1;
>
> What's -1? If this is an error, Exxxxx codes should be used.
>
> The error check should become first and the rest of the function may be unindented by one tab stop.
Okay.
>
> > +   return 0;
> > +}
> > +
> > +static void ipipeif_config_dpc(struct ipipeif_dpc *dpc) {
> > +   u32 val;
> > +
> > +   if (dpc->en) {
> > +           val = ((dpc->en & 1) << IPIPEIF_DPC2_EN_SHIFT);
> > +           val |= (dpc->thr & IPIPEIF_DPC2_THR_MASK);
> > +   } else
> > +           val = 0;
> > +
> > +   regw_if(val, IPIPEIF_DPC2);
> > +}
> > +
> > +/* This function sets up IPIPEIF and is called from
> > + * ipipe_hw_setup()
> > + */
> > +int ipipeif_hw_setup(struct ipipeif *params) {
> > +   enum v4l2_mbus_pixelcode isif_port_if;
> > +   unsigned int val1 = 0x7;
>
> 7 looks like a magic number.
Will fix.
>
> > +   unsigned int val;
> > +
> > +   if (NULL == params)
> > +           return -1;
>
> Same here, and I can also see elsewhere.
Will fix.
>
> > +   /* Enable clock to IPIPEIF and IPIPE */
> > +   if (device_type == DM365)
> > +           vpss_enable_clock(VPSS_IPIPEIF_CLOCK, 1);
> > +
> > +   /* Combine all the fields to make CFG1 register of IPIPEIF */
> > +   val = params->mode << ONESHOT_SHIFT;
> > +   val |= params->source << INPSRC_SHIFT;
> > +   val |= params->clock_select << CLKSEL_SHIFT;
> > +   val |= params->avg_filter << AVGFILT_SHIFT;
> > +   val |= params->decimation << DECIM_SHIFT;
> > +
> > +   if (device_type == DM355) {
> > +           val |= params->var.if_base.ialaw << IALAW_SHIFT;
> > +           val |= params->var.if_base.pack_mode << PACK8IN_SHIFT;
> > +           val |= params->var.if_base.clk_div << CLKDIV_SHIFT;
> > +           val |= params->var.if_base.data_shift << DATASFT_SHIFT;
> > +   } else {
> > +           /* DM365 IPIPE 5.1 */
> > +           val |= params->var.if_5_1.pack_mode << PACK8IN_SHIFT;
> > +           val |= params->var.if_5_1.source1 << INPSRC1_SHIFT;
> > +           if (params->source != SDRAM_YUV)
> > +                   val |= params->var.if_5_1.data_shift << DATASFT_SHIFT;
> > +           else
> > +                   val &= (~(val1 << DATASFT_SHIFT));
> > +   }
> > +   regw_if(val, IPIPEIF_GFG1);
> > +
> > +   switch (params->source) {
> > +   case CCDC:
> > +           {
> > +                   regw_if(params->gain, IPIPEIF_GAIN);
> > +                   break;
> > +           }
>
> Braces aren't needed here.
Okay.
>
> > +   case SDRAM_RAW:
> > +   case CCDC_DARKFM:
> > +           {
> > +                   regw_if(params->gain, IPIPEIF_GAIN);
> > +                   /* fall through */
> > +           }
>
> Ditto.
>
> > +   case SDRAM_YUV:
> > +           {
> > +                   val |= params->var.if_5_1.data_shift << DATASFT_SHIFT;
> > +                   regw_if(params->glob_hor_size, IPIPEIF_PPLN);
> > +                   regw_if(params->glob_ver_size, IPIPEIF_LPFR);
> > +                   regw_if(params->hnum, IPIPEIF_HNUM);
> > +                   regw_if(params->vnum, IPIPEIF_VNUM);
> > +
> > +                   break;
> > +           }
> > +   default:
> > +           /* Do nothing */
> > +           ;
>
> Is this not an error?
Yes. It is. Will fix.
>
> > +   }
> > +
> > +   /*check if decimation is enable or not */
> > +   if (params->decimation)
> > +           regw_if(params->rsz, IPIPEIF_RSZ);
> > +
> > +   if (device_type == DM365) {
>
> You can do an opposite check and then return if it's true. By removing the brackes from cases you can unindent this by two tab stops. The function is also very long.
>
> > +           /* Setup sync alignment and initial rsz position */
> > +           val = params->var.if_5_1.align_sync & 1;
> > +           val <<= IPIPEIF_INIRSZ_ALNSYNC_SHIFT;
> > +           val |= (params->var.if_5_1.rsz_start & IPIPEIF_INIRSZ_MASK);
> > +           regw_if(val, IPIPEIF_INIRSZ);
> > +
> > +           /* Enable DPCM decompression */
> > +           switch (params->source) {
> > +           case SDRAM_RAW:
> > +                   {
> > +                           val = 0;
> > +                           if (params->var.if_5_1.dpcm.en) {
> > +                                   val = params->var.if_5_1.dpcm.en & 1;
> > +                                   val |= (params->var.if_5_1.dpcm.type
> > +                                             & 1)
> > +                                       << IPIPEIF_DPCM_BITS_SHIFT;
> > +                                   val |=
> > +                                       (params->var.if_5_1.dpcm.pred & 1)
> > +                                       << IPIPEIF_DPCM_PRED_SHIFT;
> > +                           }
> > +                           regw_if(val, IPIPEIF_DPCM);
> > +
> > +                           /* set DPC */
> > +                           ipipeif_config_dpc(&params->var.if_5_1.dpc);
> > +
> > +                           regw_if(params->var.if_5_1.clip, IPIPEIF_OCLIP);
> > +                           /* fall through for SDRAM YUV mode */
> > +                           isif_port_if =
> > +                               params->var.if_5_1.isif_port.if_type;
> > +                           /* configure CFG2 */
> > +                           switch (isif_port_if) {
> > +                           case V4L2_MBUS_FMT_YUYV8_1X16:
> > +                                   val |=
> > +                                       (0 <<
> > +                                         IPIPEIF_CFG2_YUV8_SHIFT);
>
> This has no effect.
Will fix.

>
> > +                                   val |=
> > +                                       (1 <<
> > +                                         IPIPEIF_CFG2_YUV16_SHIFT);
> > +                                   regw_if(val, IPIPEIF_CFG2);
> > +                                   break;
> > +                           default:
> > +                                   val |=
> > +                                       (0 <<
> > +                                         IPIPEIF_CFG2_YUV8_SHIFT);
> > +                                   val |=
> > +                                       (0 <<
> > +                                         IPIPEIF_CFG2_YUV16_SHIFT);
>
> Neither do the above two statements.
>
Yes.
> > +                                   regw_if(val, IPIPEIF_CFG2);
> > +                                   break;
> > +                           }
> > +                   }
> > +           case SDRAM_YUV:
> > +                   {
> > +                           /* Set clock divider */
> > +                           if (params->clock_select == SDRAM_CLK) {
> > +                                   val |=
> > +                                       ((params->var.if_5_1.clk_div.m - 1)
> > +                                        << IPIPEIF_CLKDIV_M_SHIFT);
> > +                                   val |=
> > +                                       (params->var.if_5_1.clk_div.n - 1);
> > +                                   regw_if(val, IPIPEIF_CLKDIV);
> > +                           }
> > +
> > +                           break;
> > +                   }
> > +           case CCDC:
> > +           case CCDC_DARKFM:
> > +                   {
> > +                           /* set DPC */
> > +                           ipipeif_config_dpc(&params->var.if_5_1.dpc);
> > +
> > +                           /* Set DF gain & threshold control */
> > +                           val = 0;
> > +                           if (params->var.if_5_1.df_gain_en) {
> > +                                   val = (params->var.if_5_1.df_gain_thr
> > +                                            & IPIPEIF_DF_GAIN_THR_MASK);
> > +                                   regw_if(val, IPIPEIF_DFSGTH);
> > +                                   val = ((params->var.if_5_1.df_gain_en
> > +                                             & 1)
> > +                                            << IPIPEIF_DF_GAIN_EN_SHIFT);
> > +                                   val |= (params->var.if_5_1.df_gain
> > +                                             & IPIPEIF_DF_GAIN_MASK);
> > +                           }
> > +                           regw_if(val, IPIPEIF_DFSGVL);
> > +                           isif_port_if =
> > +                               params->var.if_5_1.isif_port.if_type;
>
> Indentation.
Okay.
>
> > +
> > +                           /* configure CFG2 */
> > +                           val =
> > +                               params->var.if_5_1.isif_port.hdpol
> > +                               << IPIPEIF_CFG2_HDPOL_SHIFT;
> > +                           val |=
> > +                               params->var.if_5_1.isif_port.vdpol
> > +                               << IPIPEIF_CFG2_VDPOL_SHIFT;
> > +                           switch (isif_port_if) {
> > +                           case V4L2_MBUS_FMT_YUYV8_1X16:
> > +                           case V4L2_MBUS_FMT_YUYV10_1X20:
> > +                                   {
> > +                                           val |=
> > +                                               (0 <<
> > +                                                IPIPEIF_CFG2_YUV8_SHIFT);
> > +                                           val |=
> > +                                               (1 <<
> > +                                                IPIPEIF_CFG2_YUV16_SHIFT);
>
> It might make sense to use #defines with descriptive names rather than zeros and ones.
Will do.
>
> > +                                           break;
> > +                                   }
> > +                           case V4L2_MBUS_FMT_YUYV8_2X8:
> > +                           case V4L2_MBUS_FMT_Y8_1X8:
> > +                           case V4L2_MBUS_FMT_YUYV10_2X10:
> > +                                   {
> > +                                           val |=
> > +                                               (1 <<
> > +                                                IPIPEIF_CFG2_YUV8_SHIFT);
> > +                                           val |=
> > +                                               (1 <<
> > +                                                IPIPEIF_CFG2_YUV16_SHIFT);
> > +                                           val |=
> > +                                               ((params->var.if_5_1.
> > +                                                 pix_order)
> > +                                                <<
> > +                                                IPIPEIF_CFG2_YUV8P_SHIFT);
> > +                                           break;
> > +                                   }
> > +                           default:
> > +                                   {
> > +                                           /* Bayer */
> > +                                           regw_if(params->var.if_5_1.clip,
> > +                                                   IPIPEIF_OCLIP);
> > +                                           val |=
> > +                                               (0 <<
> > +                                                IPIPEIF_CFG2_YUV16_SHIFT);
> > +                                   }
> > +                           }
> > +                           regw_if(val, IPIPEIF_CFG2);
> > +                           break;
> > +                   }
> > +           default:
> > +                   /* do nothing */
> > +                   ;
> > +           }
> > +   }
> > +   return 0;
> > +}
> > +
> > +static int __devinit dm3xx_ipipeif_probe(struct platform_device
> > +*pdev) {
> > +   static resource_size_t  res_len;
> > +   struct resource *res;
> > +   int status;
> > +
> > +   if (NULL != pdev->dev.platform_data)
>
> Lvalue would be better right for readability.
Okay.
>
> > +           device_type = DM365;
> > +
> > +   res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +   if (!res)
> > +           return -ENOENT;
> > +
> > +   res_len = res->end - res->start + 1;
> > +
> > +   res = request_mem_region(res->start, res_len, res->name);
> > +   if (!res)
> > +           return -EBUSY;
> > +
> > +   ipipeif_base_addr = ioremap_nocache(res->start, res_len);
> > +   if (!ipipeif_base_addr) {
> > +           status = -EBUSY;
> > +           goto fail;
> > +   }
> > +   return 0;
> > +
> > +fail:
> > +   release_mem_region(res->start, res_len);
> > +
> > +   return status;
> > +}
> > +
> > +static int dm3xx_ipipeif_remove(struct platform_device *pdev) {
> > +   struct resource *res;
> > +
> > +   iounmap(ipipeif_base_addr);
> > +   res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +   if (res)
> > +           release_mem_region(res->start, res->end - res->start + 1);
> > +   return 0;
> > +}
> > +
> > +static struct platform_driver dm3xx_ipipeif_driver = {
> > +   .driver = {
> > +           .name   = "dm3xx_ipipeif",
> > +           .owner = THIS_MODULE,
> > +   },
> > +   .remove = __devexit_p(dm3xx_ipipeif_remove),
> > +   .probe = dm3xx_ipipeif_probe,
> > +};
> > +
> > +static int dm3xx_ipipeif_init(void)
> > +{
> > +   return platform_driver_register(&dm3xx_ipipeif_driver);
> > +}
> > +
> > +static void dm3xx_ipipeif_exit(void)
> > +{
> > +   platform_driver_unregister(&dm3xx_ipipeif_driver);
> > +}
> > +
> > +module_init(dm3xx_ipipeif_init);
> > +module_exit(dm3xx_ipipeif_exit);
> > +
> > +MODULE_LICENSE("GPL2");
> > diff --git a/include/media/davinci/dm3xx_ipipeif.h
> > b/include/media/davinci/dm3xx_ipipeif.h
> > new file mode 100644
> > index 0000000..87389ff
> > --- /dev/null
> > +++ b/include/media/davinci/dm3xx_ipipeif.h
> > @@ -0,0 +1,292 @@
> > +/*
> > +* Copyright (C) 2011 Texas Instruments Inc
> > +*
> > +* This program is free software; you can redistribute it and/or
> > +* modify it under the terms of the GNU General Public License as
> > +* published by the Free Software Foundation version 2.
> > +*
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +* GNU General Public License for more details.
> > +*
> > +* You should have received a copy of the GNU General Public License
> > +* along with this program; if not, write to the Free Software
> > +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> > +02111-1307 USA */
> > +
> > +#ifndef _DM3XX_IPIPEIF_H
> > +#define _DM3XX_IPIPEIF_H
> > +/* Used to shift input image data based on the data lines connected
> > + * to parallel port
> > + */
> > +/* IPIPE base specific types */
> > +enum ipipeif_data_shift {
> > +   IPIPEIF_BITS15_2,
> > +   IPIPEIF_BITS14_1,
> > +   IPIPEIF_BITS13_0,
> > +   IPIPEIF_BITS12_0,
> > +   IPIPEIF_BITS11_0,
> > +   IPIPEIF_BITS10_0,
> > +   IPIPEIF_BITS9_0
> > +};
> > +
> > +enum ipipeif_clkdiv {
> > +   IPIPEIF_DIVIDE_HALF,
> > +   IPIPEIF_DIVIDE_THIRD,
> > +   IPIPEIF_DIVIDE_FOURTH,
> > +   IPIPEIF_DIVIDE_FIFTH,
> > +   IPIPEIF_DIVIDE_SIXTH,
> > +   IPIPEIF_DIVIDE_EIGHTH,
> > +   IPIPEIF_DIVIDE_SIXTEENTH,
> > +   IPIPEIF_DIVIDE_THIRTY
> > +};
> > +
> > +/* IPIPE 5.1 interface types */
> > +/* dpcm predicator for IPIPE 5.1 */
> > +enum ipipeif_dpcm_pred {
> > +   DPCM_SIMPLE_PRED,
> > +   DPCM_ADV_PRED
> > +};
> > +/* data shift for IPIPE 5.1 */
> > +enum ipipeif_5_1_data_shift {
> > +   IPIPEIF_5_1_BITS11_0,
> > +   IPIPEIF_5_1_BITS10_0,
> > +   IPIPEIF_5_1_BITS9_0,
> > +   IPIPEIF_5_1_BITS8_0,
> > +   IPIPEIF_5_1_BITS7_0,
> > +   IPIPEIF_5_1_BITS15_4,
> > +};
> > +
> > +/* clockdiv for IPIPE 5.1 */
> > +struct ipipeif_5_1_clkdiv {
> > +   unsigned char m;
> > +   unsigned char n;
> > +};
> > +
> > +/* DPC at the if for IPIPE 5.1 */
> > +struct ipipeif_dpc {
> > +   /* 0 - disable, 1 - enable */
> > +   unsigned char en;
> > +   /* threshold */
> > +   unsigned short thr;
> > +};
> > +
> > +enum ipipeif_decimation {
> > +   IPIPEIF_DECIMATION_OFF,
> > +   IPIPEIF_DECIMATION_ON
> > +};
>
> If these are used as register values they should be explicitly defined.
>
> > +enum       ipipeif_pixel_order {
> > +   IPIPEIF_CBCR_Y,
> > +   IPIPEIF_Y_CBCR
> > +};
> > +
> > +#ifdef __KERNEL__
>
> This file is under include/media which isn't included by user space --- user space headers belong under include/linux. Interface and internal definitions should be in a separate header file.
The entire file is used in kernel. Will change.
>
> > +#include <linux/kernel.h>
> > +#include <mach/hardware.h>
> > +#include <linux/io.h>
> > +#include <media/davinci/vpss.h>
> > +#include <media/davinci/vpfe_types.h>
> > +
> > +enum ipipeif_clock {
> > +   PIXCEL_CLK,
> > +   SDRAM_CLK
>
> IPIPEIF prefix here?
Sure.
>
> > +};
> > +
> > +enum ipipeif_pack_mode  {
> > +   IPIPEIF_PACK_16_BIT,
> > +   IPIPEIF_PACK_8_BIT
> > +};
> > +
> > +enum ipipe_oper_mode {
> > +   CONTINUOUS,
> > +   ONE_SHOT
> > +};
> > +
> > +enum ipipeif_5_1_pack_mode  {
> > +   IPIPEIF_5_1_PACK_16_BIT,
> > +   IPIPEIF_5_1_PACK_8_BIT,
> > +   IPIPEIF_5_1_PACK_8_BIT_A_LAW,
> > +   IPIPEIF_5_1_PACK_12_BIT
> > +};
> > +
> > +enum  ipipeif_avg_filter {
> > +   AVG_OFF,
> > +   AVG_ON
> > +};
> > +
> > +enum  ipipeif_input_source {
> > +   CCDC,
> > +   SDRAM_RAW,
> > +   CCDC_DARKFM,
> > +   SDRAM_YUV
> > +};
> > +
> > +enum ipipeif_ialaw {
> > +   ALAW_OFF,
> > +   ALAW_ON
> > +};
> > +
> > +struct ipipeif_base {
> > +   enum ipipeif_ialaw ialaw;
> > +   enum ipipeif_pack_mode pack_mode;
> > +   enum ipipeif_data_shift data_shift;
> > +   enum ipipeif_clkdiv clk_div;
> > +};
> > +
> > +enum  ipipeif_input_src1 {
> > +   SRC1_PARALLEL_PORT,
> > +   SRC1_SDRAM_RAW,
> > +   SRC1_ISIF_DARKFM,
> > +   SRC1_SDRAM_YUV
> > +};
> > +
> > +enum ipipeif_dpcm_type {
> > +   DPCM_8BIT_10BIT,
> > +   DPCM_8BIT_12BIT
> > +};
> > +
> > +struct ipipeif_dpcm_decomp {
> > +   unsigned char en;
> > +   enum ipipeif_dpcm_type type;
> > +   enum ipipeif_dpcm_pred pred;
> > +};
> > +
> > +enum ipipeif_dfs_dir {
> > +   IPIPEIF_PORT_MINUS_SDRAM,
> > +   IPIPEIF_SDRAM_MINUS_PORT
> > +};
> > +
> > +struct ipipeif_5_1 {
> > +   enum ipipeif_5_1_pack_mode pack_mode;
> > +   enum ipipeif_5_1_data_shift data_shift;
> > +   enum ipipeif_input_src1 source1;
> > +   struct ipipeif_5_1_clkdiv clk_div;
> > +   /* Defect pixel correction */
> > +   struct ipipeif_dpc dpc;
> > +   /* DPCM decompression */
> > +   struct ipipeif_dpcm_decomp dpcm;
> > +   /* ISIF port pixel order */
> > +   enum ipipeif_pixel_order pix_order;
> > +   /* interface parameters from isif */
> > +   struct vpfe_hw_if_param isif_port;
> > +   /* clipped to this value */
> > +   unsigned short clip;
> > +   /* Align HSync and VSync to rsz_start */
> > +   unsigned char align_sync;
> > +   /* resizer start position */
> > +   unsigned int rsz_start;
> > +   /* DF gain enable */
> > +   unsigned char df_gain_en;
> > +   /* DF gain value */
> > +   unsigned short df_gain;
> > +   /* DF gain threshold value */
> > +   unsigned short df_gain_thr;
> > +};
> > +
> > +/* ipipeif structures common to DM350 and DM365 used by ipipeif API
> > +*/ struct ipipeif {
> > +   enum ipipe_oper_mode mode;
> > +   enum ipipeif_input_source source;
> > +   enum ipipeif_clock clock_select;
> > +   unsigned int glob_hor_size;
> > +   unsigned int glob_ver_size;
> > +   unsigned int hnum;
> > +   unsigned int vnum;
> > +   unsigned int adofs;
> > +   unsigned char rsz;
> > +   enum ipipeif_decimation decimation;
> > +   enum ipipeif_avg_filter avg_filter;
> > +   unsigned short gain;
> > +   /* IPIPE 5.1 */
> > +   union var_part {
> > +           struct ipipeif_base if_base;
> > +           struct ipipeif_5_1  if_5_1;
> > +   } var;
> > +};
> > +
> > +/* IPIPEIF Register Offsets from the base address */
> > +#define IPIPEIF_ENABLE                     (0x00)
> > +#define IPIPEIF_GFG1                       (0x04)
> > +#define IPIPEIF_PPLN                       (0x08)
> > +#define IPIPEIF_LPFR                       (0x0C)
> > +#define IPIPEIF_HNUM                       (0x10)
> > +#define IPIPEIF_VNUM                       (0x14)
> > +#define IPIPEIF_ADDRU                      (0x18)
> > +#define IPIPEIF_ADDRL                      (0x1C)
> > +#define IPIPEIF_ADOFS                      (0x20)
> > +#define IPIPEIF_RSZ                        (0x24)
> > +#define IPIPEIF_GAIN                       (0x28)
> > +
> > +/* Below registers are available only on IPIPE 5.1 */
> > +#define IPIPEIF_DPCM                       (0x2C)
> > +#define IPIPEIF_CFG2                       (0x30)
> > +#define IPIPEIF_INIRSZ                     (0x34)
> > +#define IPIPEIF_OCLIP                      (0x38)
> > +#define IPIPEIF_DTUDF                      (0x3C)
> > +#define IPIPEIF_CLKDIV                     (0x40)
> > +#define IPIPEIF_DPC1                       (0x44)
> > +#define IPIPEIF_DPC2                       (0x48)
> > +#define IPIPEIF_DFSGVL                     (0x4C)
> > +#define IPIPEIF_DFSGTH                     (0x50)
> > +#define IPIPEIF_RSZ3A                      (0x54)
> > +#define IPIPEIF_INIRSZ3A           (0x58)
> > +#define IPIPEIF_RSZ_MIN                    (16)
> > +#define IPIPEIF_RSZ_MAX                    (112)
> > +#define IPIPEIF_RSZ_CONST          (16)
> > +#define SETBIT(reg, bit)   (reg = ((reg) | ((0x00000001)<<(bit))))
> > +#define RESETBIT(reg, bit) (reg = ((reg) & (~(0x00000001<<(bit)))))
> > +
> > +#define IPIPEIF_ADOFS_LSB_MASK             (0x1FF)
> > +#define IPIPEIF_ADOFS_LSB_SHIFT            (5)
> > +#define IPIPEIF_ADOFS_MSB_MASK             (0x200)
> > +#define IPIPEIF_ADDRU_MASK         (0x7FF)
> > +#define IPIPEIF_ADDRL_SHIFT                (5)
> > +#define IPIPEIF_ADDRL_MASK         (0xFFFF)
> > +#define IPIPEIF_ADDRU_SHIFT                (21)
> > +#define IPIPEIF_ADDRMSB_SHIFT              (31)
> > +#define IPIPEIF_ADDRMSB_LEFT_SHIFT (10)
> > +
> > +/* CFG1 Masks and shifts */
> > +#define ONESHOT_SHIFT                      (0)
> > +#define DECIM_SHIFT                        (1)
> > +#define INPSRC_SHIFT                       (2)
> > +#define CLKDIV_SHIFT                       (4)
> > +#define AVGFILT_SHIFT                      (7)
> > +#define PACK8IN_SHIFT                      (8)
> > +#define IALAW_SHIFT                        (9)
> > +#define CLKSEL_SHIFT                       (10)
> > +#define DATASFT_SHIFT                      (11)
> > +#define INPSRC1_SHIFT                      (14)
>
> IPIPEIF prefix. Are these related to a particular register or a set of registers?
One register. Will need to add the IPIPEIF prefix.
>
> > +/* DPC2 */
> > +#define IPIPEIF_DPC2_EN_SHIFT              (12)
> > +#define IPIPEIF_DPC2_THR_MASK              (0xFFF)
> > +#define IPIPEIF_DF_GAIN_EN_SHIFT   (10)
> > +#define IPIPEIF_DF_GAIN_MASK               (0x3FF)
> > +#define IPIPEIF_DF_GAIN_THR_MASK   (0xFFF)
> > +/* DPCM */
> > +#define IPIPEIF_DPCM_BITS_SHIFT            (2)
> > +#define IPIPEIF_DPCM_PRED_SHIFT            (1)
> > +/* CFG2 */
> > +#define IPIPEIF_CFG2_HDPOL_SHIFT   (1)
> > +#define IPIPEIF_CFG2_VDPOL_SHIFT   (2)
> > +#define IPIPEIF_CFG2_YUV8_SHIFT            (6)
> > +#define    IPIPEIF_CFG2_YUV16_SHIFT        (3)
> > +#define    IPIPEIF_CFG2_YUV8P_SHIFT        (7)
> > +
> > +/* INIRSZ */
> > +#define IPIPEIF_INIRSZ_ALNSYNC_SHIFT       (13)
> > +#define IPIPEIF_INIRSZ_MASK                (0x1FFF)
> > +
> > +/* CLKDIV */
> > +#define IPIPEIF_CLKDIV_M_SHIFT             8
> > +
> > +int ipipeif_set_address(struct ipipeif *if_params, unsigned int
> > +address); void ipipeif_set_enable(char en, unsigned int mode); int
> > +ipipeif_hw_setup(struct ipipeif *if_params);
> > +u32 ipipeif_get_enable(void);
> > +
> > +#endif
> > +#endif
> > --
> > 1.6.2.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
>

