Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:42502 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbZFKXar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 19:30:47 -0400
Received: by an-out-0708.google.com with SMTP id d40so3479420and.1
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 16:30:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244739649-27466-11-git-send-email-m-karicheri2@ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-3-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-4-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-5-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-6-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-7-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-9-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-10-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-11-git-send-email-m-karicheri2@ti.com>
Date: Fri, 12 Jun 2009 03:23:53 +0400
Message-ID: <208cbae30906111623s3cf1939emb552ef465fed4cea@mail.gmail.com>
Subject: Re: [PATCH 10/10 - v2] common vpss module for video drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thu, Jun 11, 2009 at 9:00 PM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> common voss module for video drivers
>
> This is a new module added for vpss library functions that are
> used for configuring vpss system module. All video drivers will
> include vpss.h header file and call functions defined in this
> module to configure vpss system module.
>
>
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
>  drivers/media/video/davinci/vpss.c |  290 ++++++++++++++++++++++++++++++++++++
>  include/media/davinci/vpss.h       |   69 +++++++++
>  2 files changed, 359 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpss.c
>  create mode 100644 include/media/davinci/vpss.h
>
> diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
> new file mode 100644
> index 0000000..def021e
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpss.c
> @@ -0,0 +1,290 @@
> +/*
> + * Copyright (C) 2009 Texas Instruments.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * common vpss driver for all video drivers.
> + */
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/compiler.h>
> +#include <linux/io.h>
> +#include <mach/hardware.h>
> +#include <media/davinci/vpss.h>
> +
> +/* DM644x defines */
> +#define DM644X_SBL_PCR_VPSS            (4)
> +
> +/* vpss BL register offsets */
> +#define DM355_VPSSBL_CCDCMUX           0x1c
> +/* vpss CLK register offsets */
> +#define DM355_VPSSCLK_CLKCTRL          0x04
> +/* masks and shifts */
> +#define VPSS_HSSISEL_SHIFT             4
> +
> +/*
> + * vpss operations. Depends on platform. Not all functions are available
> + * on all platforms. The api, first check if a functio is available before
> + * invoking it. In the probe, the function ptrs are intialized based on
> + * vpss name. vpss name can be "dm355_vpss", "dm644x_vpss" etc.
> + */
> +struct vpss_hw_ops {
> +       /* enable clock */
> +       int (*enable_clock)(enum vpss_clock_sel clock_sel, int en);
> +       /* select input to ccdc */
> +       void (*select_ccdc_source)(enum vpss_ccdc_source_sel src_sel);
> +       /* clear wbl overlflow bit */
> +       int (*clear_wbl_overflow)(enum vpss_wbl_sel wbl_sel);
> +};
> +
> +/* vpss configuration */
> +struct vpss_oper_config {
> +       __iomem void *vpss_bl_regs_base;
> +       __iomem void *vpss_regs_base;
> +       struct resource         *r1;
> +       resource_size_t         len1;
> +       struct resource         *r2;
> +       resource_size_t         len2;
> +       char vpss_name[32];
> +       spinlock_t vpss_lock;
> +       struct vpss_hw_ops hw_ops;
> +};
> +
> +static struct vpss_oper_config oper_cfg;
> +
> +/* register access routines */
> +static inline u32 bl_regr(u32 offset)
> +{
> +       return __raw_readl(oper_cfg.vpss_bl_regs_base + offset);
> +}
> +
> +static inline void bl_regw(u32 val, u32 offset)
> +{
> +       __raw_writel(val, oper_cfg.vpss_bl_regs_base + offset);
> +}
> +
> +static inline u32 vpss_regr(u32 offset)
> +{
> +       return __raw_readl(oper_cfg.vpss_regs_base + offset);
> +}
> +
> +static inline void vpss_regw(u32 val, u32 offset)
> +{
> +       __raw_writel(val, oper_cfg.vpss_regs_base + offset);
> +}
> +
> +static void dm355_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
> +{
> +       bl_regw(src_sel << VPSS_HSSISEL_SHIFT, DM355_VPSSBL_CCDCMUX);
> +}
> +
> +int vpss_select_ccdc_source(enum vpss_ccdc_source_sel src_sel)
> +{
> +       if (!oper_cfg.hw_ops.select_ccdc_source)
> +               return -1;
> +
> +       dm355_select_ccdc_source(src_sel);
> +       return 0;
> +}
> +EXPORT_SYMBOL(vpss_select_ccdc_source);
> +
> +static int dm644x_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
> +{
> +       u32 mask = 1, val;
> +
> +       if (wbl_sel < VPSS_PCR_AEW_WBL_0 ||
> +           wbl_sel > VPSS_PCR_CCDC_WBL_O)
> +               return -1;
> +
> +       /* writing a 0 clear the overflow */
> +       mask = ~(mask << wbl_sel);
> +       val = bl_regr(DM644X_SBL_PCR_VPSS) & mask;
> +       bl_regw(val, DM644X_SBL_PCR_VPSS);
> +       return 0;
> +}
> +
> +int vpss_clear_wbl_overflow(enum vpss_wbl_sel wbl_sel)
> +{
> +       if (!oper_cfg.hw_ops.clear_wbl_overflow)
> +               return -1;
> +
> +       return oper_cfg.hw_ops.clear_wbl_overflow(wbl_sel);
> +}
> +EXPORT_SYMBOL(vpss_clear_wbl_overflow);
> +
> +/*
> + *  dm355_enable_clock - Enable VPSS Clock
> + *  @clock_sel: CLock to be enabled/disabled
> + *  @en: enable/disable flag
> + *
> + *  This is called to enable or disable a vpss clock
> + */
> +static int dm355_enable_clock(enum vpss_clock_sel clock_sel, int en)
> +{
> +       unsigned long flags;
> +       u32 utemp, mask = 0x1, shift = 0;
> +
> +       switch (clock_sel) {
> +       case VPSS_VPBE_CLOCK:
> +               /* nothing since lsb */
> +               break;
> +       case VPSS_VENC_CLOCK_SEL:
> +               shift = 2;
> +               break;
> +       case VPSS_CFALD_CLOCK:
> +               shift = 3;
> +               break;
> +       case VPSS_H3A_CLOCK:
> +               shift = 4;
> +               break;
> +       case VPSS_IPIPE_CLOCK:
> +               shift = 5;
> +               break;
> +       case VPSS_CCDC_CLOCK:
> +               shift = 6;
> +               break;
> +       default:
> +               printk(KERN_ERR "dm355_enable_clock:"
> +                               " Invalid selector: %d\n", clock_sel);
> +               return -1;
> +       }
> +
> +       spin_lock_irqsave(&oper_cfg.vpss_lock, flags);
> +       utemp = vpss_regr(DM355_VPSSCLK_CLKCTRL);
> +       if (!en)
> +               utemp &= ~(mask << shift);
> +       else
> +               utemp |= (mask << shift);
> +
> +       vpss_regw(utemp, DM355_VPSSCLK_CLKCTRL);
> +       spin_unlock_irqrestore(&oper_cfg.vpss_lock, flags);
> +       return 0;
> +}
> +
> +int vpss_enable_clock(enum vpss_clock_sel clock_sel, int en)
> +{
> +       if (!oper_cfg.hw_ops.enable_clock)
> +               return -1;
> +
> +       return oper_cfg.hw_ops.enable_clock(clock_sel, en);
> +}
> +EXPORT_SYMBOL(vpss_enable_clock);
> +
> +static int __init vpss_probe(struct platform_device *pdev)
> +{
> +       int                     status;
> +
> +       if (!pdev->dev.platform_data) {
> +               dev_err(&pdev->dev, "vpss, no platform data\n");
> +               return -ENOENT;
> +       }
> +
> +       strcpy(oper_cfg.vpss_name, pdev->dev.platform_data);
> +       dev_info(&pdev->dev, "%s vpss probed\n", oper_cfg.vpss_name);
> +       oper_cfg.r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!oper_cfg.r1)
> +               return -ENOENT;
> +
> +       oper_cfg.len1 = oper_cfg.r1->end - oper_cfg.r1->start + 1;
> +
> +       oper_cfg.r1 = request_mem_region(oper_cfg.r1->start, oper_cfg.len1,
> +                                        oper_cfg.r1->name);
> +       if (!oper_cfg.r1)
> +               return -EBUSY;
> +
> +       oper_cfg.vpss_bl_regs_base = ioremap(oper_cfg.r1->start, oper_cfg.len1);
> +       if (!oper_cfg.vpss_bl_regs_base) {
> +               status = -EBUSY;
> +               goto fail1;
> +       }
> +
> +       if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
> +               oper_cfg.r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +               if (!oper_cfg.r2) {
> +                       status = -ENOENT;
> +                       goto fail2;
> +               }
> +               oper_cfg.len2 = oper_cfg.r2->end - oper_cfg.r2->start + 1;
> +               oper_cfg.r2 = request_mem_region(oper_cfg.r2->start,
> +                                                oper_cfg.len2,
> +                                                oper_cfg.r2->name);
> +               if (!oper_cfg.r2) {
> +                       status = -EBUSY;
> +                       goto fail2;
> +               }
> +
> +               oper_cfg.vpss_regs_base = ioremap(oper_cfg.r2->start,
> +                                                 oper_cfg.len2);
> +               if (!oper_cfg.vpss_regs_base) {
> +                       status = -EBUSY;
> +                       goto fail3;
> +               }
> +       }
> +
> +       if (!strcmp(oper_cfg.vpss_name, "dm355_vpss")) {
> +               oper_cfg.hw_ops.enable_clock = dm355_enable_clock;
> +               oper_cfg.hw_ops.select_ccdc_source = dm355_select_ccdc_source;
> +       } else if (!strcmp(oper_cfg.vpss_name, "dm644x_vpss"))
> +               oper_cfg.hw_ops.clear_wbl_overflow = dm644x_clear_wbl_overflow;
> +       else
> +               return -ENODEV;

Do you need clean up procedure if you return error here? I mean -
calls to release_mem_region, release_mem_region, etc

> +       spin_lock_init(&oper_cfg.vpss_lock);
> +       dev_info(&pdev->dev, "%s vpss probe success\n", oper_cfg.vpss_name);
> +       return 0;
> +fail3:
> +       release_mem_region(oper_cfg.r2->start, oper_cfg.len2);
> +fail2:
> +       iounmap(oper_cfg.vpss_bl_regs_base);
> +fail1:
> +       release_mem_region(oper_cfg.r1->start, oper_cfg.len1);
> +       return status;
> +}


-- 
Best regards, Klimov Alexey
