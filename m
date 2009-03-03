Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:39383 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbZCCMHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 07:07:12 -0500
Subject: Re: [PATCH 4/9] omap3isp: Add ISP frontend (CCDC)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	saaguirre@ti.com, tuukka.o.toivonen@nokia.com,
	dongsoo.kim@gmail.com
In-Reply-To: <1236074816-30018-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
	 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236074816-30018-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 15:07:39 +0300
Message-Id: <1236082059.10927.25.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-03 at 12:06 +0200, Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/isp/ispccdc.c | 1568 +++++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/ispccdc.h |  203 +++++
>  2 files changed, 1771 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/isp/ispccdc.c
>  create mode 100644 drivers/media/video/isp/ispccdc.h
> 
> diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
> new file mode 100644
> index 0000000..80ab762
> --- /dev/null
> +++ b/drivers/media/video/isp/ispccdc.c
> @@ -0,0 +1,1568 @@
> +/*
> + * ispccdc.c
> + *
> + * Driver Library for CCDC module in TI's OMAP3 Camera ISP
> + *
> + * Copyright (C) 2009 Texas Instruments, Inc.
> + *
> + * Contributors:
> + *	Senthilvadivu Guruswamy <svadivu@ti.com>
> + *	Pallavi Kulkarni <p-kulkarni@ti.com>
> + *	Sergio Aguirre <saaguirre@ti.com>
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +
> +#include "isp.h"
> +#include "ispreg.h"
> +#include "ispccdc.h"
> +#include "ispmmu.h"
> +
> +#define LSC_TABLE_INIT_SIZE	50052
> +
> +static u32 *fpc_table_add;
> +static unsigned long fpc_table_add_m;
> +
> +/**
> + * struct isp_ccdc - Structure for the CCDC module to store its own information
> + * @ccdc_inuse: Flag to determine if CCDC has been reserved or not (0 or 1).
> + * @ccdcout_w: CCDC output width.
> + * @ccdcout_h: CCDC output height.
> + * @ccdcin_w: CCDC input width.
> + * @ccdcin_h: CCDC input height.
> + * @ccdcin_woffset: CCDC input horizontal offset.
> + * @ccdcin_hoffset: CCDC input vertical offset.
> + * @crop_w: Crop width.
> + * @crop_h: Crop weight.
> + * @ccdc_inpfmt: CCDC input format.
> + * @ccdc_outfmt: CCDC output format.
> + * @vpout_en: Video port output enable.
> + * @wen: Data write enable.
> + * @exwen: External data write enable.
> + * @refmt_en: Reformatter enable.
> + * @ccdcslave: CCDC slave mode enable.
> + * @syncif_ipmod: Image
> + * @obclamp_en: Data input format.
> + * @mutexlock: Mutex used to get access to the CCDC.
> + */
> +static struct isp_ccdc {
> +	u8 ccdc_inuse;
> +	u32 ccdcout_w;
> +	u32 ccdcout_h;
> +	u32 ccdcin_w;
> +	u32 ccdcin_h;
> +	u32 ccdcin_woffset;
> +	u32 ccdcin_hoffset;
> +	u32 crop_w;
> +	u32 crop_h;
> +	u8 ccdc_inpfmt;
> +	u8 ccdc_outfmt;
> +	u8 vpout_en;
> +	u8 wen;
> +	u8 exwen;
> +	u8 refmt_en;
> +	u8 ccdcslave;
> +	u8 syncif_ipmod;
> +	u8 obclamp_en;
> +	u8 lsc_en;
> +	struct mutex mutexlock; /* For checking/modifying ccdc_inuse */
> +	u32 wenlog;
> +} ispccdc_obj;
> +
> +static struct ispccdc_lsc_config lsc_config;
> +static u8 *lsc_gain_table;
> +static unsigned long lsc_ispmmu_addr;
> +static int lsc_initialized;
> +static u8 ccdc_use_lsc;
> +static u8 *lsc_gain_table_tmp;
> +
> +/* Structure for saving/restoring CCDC module registers*/
> +static struct isp_reg ispccdc_reg_list[] = {
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HD_VD_WID, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PIX_LINES, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CULLING, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HSIZE_OFF, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDR_ADDR, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CLAMP, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_DCSUB, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_COLPTN, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_BLKCMP, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC_ADDR, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_ALAW, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR0, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR1, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR2, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR3, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR4, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR5, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR6, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_ADDR7, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGEVEN0, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGEVEN1, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGODD0, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PRGODD1, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_INITIAL, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_TABLE_BASE, 0},
> +	{OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_TABLE_OFFSET, 0},
> +	{0, ISP_TOK_TERM, 0}
> +};
> +
> +/**
> + * omap34xx_isp_ccdc_config - Sets CCDC configuration from userspace
> + * @userspace_add: Structure containing CCDC configuration sent from userspace.
> + *
> + * Returns 0 if successful, -EINVAL if the pointer to the configuration
> + * structure is null, or the copy_from_user function fails to copy user space
> + * memory to kernel space memory.
> + **/
> +int omap34xx_isp_ccdc_config(void *userspace_add)
> +{
> +	struct ispccdc_bclamp bclamp_t;
> +	struct ispccdc_blcomp blcomp_t;
> +	struct ispccdc_fpc fpc_t;
> +	struct ispccdc_culling cull_t;
> +	struct ispccdc_update_config *ccdc_struct;
> +
> +	if (userspace_add == NULL)
> +		return -EINVAL;
> +
> +	ccdc_struct = userspace_add;
> +
> +	if (ISP_ABS_CCDC_ALAW & ccdc_struct->flag) {
> +		if (ISP_ABS_CCDC_ALAW & ccdc_struct->update)
> +			ispccdc_config_alaw(ccdc_struct->alawip);
> +		ispccdc_enable_alaw(1);
> +	} else if (ISP_ABS_CCDC_ALAW & ccdc_struct->update)
> +		ispccdc_enable_alaw(0);
> +
> +	if (ISP_ABS_CCDC_LPF & ccdc_struct->flag)
> +		ispccdc_enable_lpf(1);
> +	else
> +		ispccdc_enable_lpf(0);
> +
> +	if (ISP_ABS_CCDC_BLCLAMP & ccdc_struct->flag) {
> +		if (ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) {
> +			if (copy_from_user(&bclamp_t, (struct ispccdc_bclamp *)
> +						(ccdc_struct->bclamp),
> +						sizeof(struct ispccdc_bclamp)))
> +				goto copy_from_user_err;
> +
> +			ispccdc_enable_black_clamp(1);
> +			ispccdc_config_black_clamp(bclamp_t);
> +		} else
> +			ispccdc_enable_black_clamp(1);
> +	} else {
> +		if (ISP_ABS_CCDC_BLCLAMP & ccdc_struct->update) {
> +			if (copy_from_user(&bclamp_t, (struct ispccdc_bclamp *)
> +						(ccdc_struct->bclamp),
> +						sizeof(struct ispccdc_bclamp)))
> +				goto copy_from_user_err;
> +
> +			ispccdc_enable_black_clamp(0);
> +			ispccdc_config_black_clamp(bclamp_t);
> +		}
> +	}
> +
> +	if (ISP_ABS_CCDC_BCOMP & ccdc_struct->update) {
> +		if (copy_from_user(&blcomp_t, (struct ispccdc_blcomp *)
> +							(ccdc_struct->blcomp),
> +							sizeof(blcomp_t)))
> +			goto copy_from_user_err;
> +
> +		ispccdc_config_black_comp(blcomp_t);
> +	}
> +
> +	if (ISP_ABS_CCDC_FPC & ccdc_struct->flag) {
> +		if (ISP_ABS_CCDC_FPC & ccdc_struct->update) {
> +			if (copy_from_user(&fpc_t, (struct ispccdc_fpc *)
> +							(ccdc_struct->fpc),
> +							sizeof(fpc_t)))
> +				goto copy_from_user_err;
> +			fpc_table_add = kmalloc((64 + (fpc_t.fpnum * 4)),
> +							GFP_KERNEL | GFP_DMA);
> +			if (!fpc_table_add) {
> +				printk(KERN_ERR "Cannot allocate memory for"
> +								" FPC table");
> +				return -ENOMEM;
> +			}
> +			while (((int)fpc_table_add & 0xFFFFFFC0) !=
> +							(int)fpc_table_add)
> +				fpc_table_add++;
> +
> +			fpc_table_add_m = ispmmu_kmap(virt_to_phys
> +							(fpc_table_add),
> +							(fpc_t.fpnum) * 4);
> +
> +			if (copy_from_user(fpc_table_add, (u32 *)fpc_t.fpcaddr,
> +							fpc_t.fpnum * 4))
> +				goto copy_from_user_err;
> +
> +			fpc_t.fpcaddr = fpc_table_add_m;
> +			ispccdc_config_fpc(fpc_t);
> +		}
> +		ispccdc_enable_fpc(1);
> +	} else if (ISP_ABS_CCDC_FPC & ccdc_struct->update)
> +			ispccdc_enable_fpc(0);
> +
> +	if (ISP_ABS_CCDC_CULL & ccdc_struct->update) {
> +		if (copy_from_user(&cull_t, (struct ispccdc_culling *)
> +							(ccdc_struct->cull),
> +							sizeof(cull_t)))
> +			goto copy_from_user_err;
> +		ispccdc_config_culling(cull_t);
> +	}
> +
> +	if (is_isplsc_activated()) {
> +		if (ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->flag) {
> +			if (ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) {
> +				if (copy_from_user(&lsc_config,
> +						(struct ispccdc_lsc_config *)
> +						(ccdc_struct->lsc_cfg),
> +						sizeof(struct
> +						ispccdc_lsc_config)))
> +					goto copy_from_user_err;
> +				ispccdc_config_lsc(&lsc_config);
> +			}
> +			ccdc_use_lsc = 1;
> +		} else if (ISP_ABS_CCDC_CONFIG_LSC & ccdc_struct->update) {
> +				ispccdc_enable_lsc(0);
> +				ccdc_use_lsc = 0;
> +		}
> +		if (ISP_ABS_TBL_LSC & ccdc_struct->update) {
> +			if (copy_from_user(lsc_gain_table,
> +				(ccdc_struct->lsc), lsc_config.size))
> +				goto copy_from_user_err;
> +			ispccdc_load_lsc(lsc_gain_table, lsc_config.size);
> +		}
> +	}
> +
> +	if (ISP_ABS_CCDC_COLPTN & ccdc_struct->update)
> +		ispccdc_config_imgattr(ccdc_struct->colptn);
> +
> +	return 0;
> +
> +copy_from_user_err:
> +	printk(KERN_ERR "CCDC Config:Copy From User Error");

"\n" is missed, right ?
Please, see below with the same. It's better to check all messages..

> +	return -EINVAL ;
> +}
> +EXPORT_SYMBOL(omap34xx_isp_ccdc_config);
> +
> +/**
> + * Set the value to be used for CCDC_CFG.WENLOG.
> + *  w - Value of wenlog.
> + */
> +void ispccdc_set_wenlog(u32 wenlog)
> +{
> +	ispccdc_obj.wenlog = wenlog;
> +}
> +EXPORT_SYMBOL(ispccdc_set_wenlog);
> +
> +/**
> + * ispccdc_request - Reserves the CCDC module.
> + *
> + * Reserves the CCDC module and assures that is used only once at a time.
> + *
> + * Returns 0 if successful, or -EBUSY if CCDC module is busy.
> + **/
> +int ispccdc_request(void)
> +{
> +	mutex_lock(&ispccdc_obj.mutexlock);
> +	if (ispccdc_obj.ccdc_inuse) {
> +		mutex_unlock(&ispccdc_obj.mutexlock);
> +		DPRINTK_ISPCCDC("ISP_ERR : CCDC Module Busy");

"\n" ?

> +		return -EBUSY;
> +	}
> +
> +	ispccdc_obj.ccdc_inuse = 1;
> +	mutex_unlock(&ispccdc_obj.mutexlock);
> +	isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, ISPCTRL_CCDC_RAM_EN |
> +							ISPCTRL_CCDC_CLK_EN |
> +							ISPCTRL_SBL_WR1_RAM_EN);
> +	isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_VDLC);
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_request);
> +
> +/**
> + * ispccdc_free - Frees the CCDC module.
> + *
> + * Frees the CCDC module so it can be used by another process.
> + *
> + * Returns 0 if successful, or -EINVAL if module has been already freed.
> + **/
> +int ispccdc_free(void)
> +{
> +	mutex_lock(&ispccdc_obj.mutexlock);
> +	if (!ispccdc_obj.ccdc_inuse) {
> +		mutex_unlock(&ispccdc_obj.mutexlock);
> +		DPRINTK_ISPCCDC("ISP_ERR: CCDC Module already freed\n");
> +		return -EINVAL;
> +	}
> +
> +	ispccdc_obj.ccdc_inuse = 0;
> +	mutex_unlock(&ispccdc_obj.mutexlock);
> +	isp_reg_and(OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> +			~(ISPCTRL_CCDC_CLK_EN |
> +			ISPCTRL_CCDC_RAM_EN |
> +			ISPCTRL_SBL_WR1_RAM_EN));
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_free);
> +
> +/**
> + * ispccdc_free_lsc - Frees Lens Shading Compensation table
> + *
> + * Always returns 0.
> + **/
> +static int ispccdc_free_lsc(void)
> +{
> +	if (!lsc_ispmmu_addr)
> +		return 0;
> +
> +	ispccdc_enable_lsc(0);
> +	lsc_initialized = 0;
> +	isp_reg_writel(0, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_TABLE_BASE);
> +	ispmmu_kunmap(lsc_ispmmu_addr);
> +	kfree(lsc_gain_table);
> +	return 0;
> +}
> +
> +/**
> + * ispccdc_allocate_lsc - Allocate space for Lens Shading Compensation table
> + * @table_size: LSC gain table size.
> + *
> + * Returns 0 if successful, -ENOMEM of its no memory available, or -EINVAL if
> + * table_size is zero.
> + **/
> +static int ispccdc_allocate_lsc(u32 table_size)
> +{
> +	if (table_size == 0)
> +		return -EINVAL;
> +
> +	if ((lsc_config.size >= table_size) && lsc_gain_table)
> +		return 0;
> +
> +	ispccdc_free_lsc();
> +
> +	lsc_gain_table = kmalloc(table_size, GFP_KERNEL | GFP_DMA);
> +
> +	if (!lsc_gain_table) {
> +		printk(KERN_ERR "Cannot allocate memory for gain tables \n");
> +		return -ENOMEM;
> +	}
> +
> +	lsc_ispmmu_addr = ispmmu_kmap(virt_to_phys(lsc_gain_table), table_size);
> +	if (lsc_ispmmu_addr <= 0) {
> +		printk(KERN_ERR "Cannot map memory for gain tables \n");
> +		kfree(lsc_gain_table);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ispccdc_program_lsc - Program Lens Shading Compensation table.
> + * @table_size: LSC gain table size.
> + *
> + * Returns 0 if successful, or -EINVAL if there's no mapped address for the
> + * table yet.
> + **/
> +static int ispccdc_program_lsc(void)
> +{
> +	if (!lsc_ispmmu_addr)
> +		return -EINVAL;
> +
> +	if (lsc_initialized)
> +		return 0;
> +
> +	isp_reg_writel(lsc_ispmmu_addr, OMAP3_ISP_IOMEM_CCDC,
> +						ISPCCDC_LSC_TABLE_BASE);
> +	lsc_initialized = 1;
> +	return 0;
> +}
> +
> +/**
> + * ispccdc_load_lsc - Load Lens Shading Compensation table.
> + * @table_addr: LSC gain table MMU Mapped address.
> + * @table_size: LSC gain table size.
> + *
> + * Returns 0 if successful, -ENOMEM of its no memory available, or -EINVAL if
> + * table_size is zero.
> + **/
> +int ispccdc_load_lsc(u8 *table_addr, u32 table_size)
> +{
> +	int ret;
> +
> +	if (!is_isplsc_activated())
> +		return 0;
> +
> +	if (!table_addr)
> +		return -EINVAL;
> +
> +	ret = ispccdc_allocate_lsc(table_size);
> +	if (ret)
> +		return ret;
> +
> +	if (table_addr != lsc_gain_table)
> +		memcpy(lsc_gain_table, table_addr, table_size);
> +	ret = ispccdc_program_lsc();
> +	if (ret)
> +		return ret;
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_load_lsc);
> +
> +/**
> + * ispccdc_config_lsc - Configures the lens shading compensation module
> + * @lsc_cfg: LSC configuration structure
> + **/
> +void ispccdc_config_lsc(struct ispccdc_lsc_config *lsc_cfg)
> +{
> +	int reg;
> +
> +	if (!is_isplsc_activated())
> +		return;
> +
> +	ispccdc_enable_lsc(0);
> +	isp_reg_writel(lsc_cfg->offset, OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_LSC_TABLE_OFFSET);
> +
> +	reg = 0;
> +	reg |= (lsc_cfg->gain_mode_n << ISPCCDC_LSC_GAIN_MODE_N_SHIFT);
> +	reg |= (lsc_cfg->gain_mode_m << ISPCCDC_LSC_GAIN_MODE_M_SHIFT);
> +	reg |= (lsc_cfg->gain_format << ISPCCDC_LSC_GAIN_FORMAT_SHIFT);
> +	isp_reg_writel(reg, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG);
> +
> +	reg = 0;
> +	reg &= ~ISPCCDC_LSC_INITIAL_X_MASK;
> +	reg |= (lsc_cfg->initial_x << ISPCCDC_LSC_INITIAL_X_SHIFT);
> +	reg &= ~ISPCCDC_LSC_INITIAL_Y_MASK;
> +	reg |= (lsc_cfg->initial_y << ISPCCDC_LSC_INITIAL_Y_SHIFT);
> +	isp_reg_writel(reg, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_INITIAL);
> +}
> +EXPORT_SYMBOL(ispccdc_config_lsc);
> +
> +/**
> + * ispccdc_enable_lsc - Enables/Disables the Lens Shading Compensation module.
> + * @enable: 0 Disables LSC, 1 Enables LSC.
> + **/
> +void ispccdc_enable_lsc(u8 enable)
> +{
> +	if (!is_isplsc_activated())
> +		return;
> +
> +	if (enable) {
> +		isp_reg_or(OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> +			ISPCTRL_SBL_SHARED_RPORTB | ISPCTRL_SBL_RD_RAM_EN);
> +
> +		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG, 0x1);
> +
> +		ispccdc_obj.lsc_en = 1;
> +	} else {
> +		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG, 0xFFFE);
> +		ispccdc_obj.lsc_en = 0;
> +	}
> +}
> +EXPORT_SYMBOL(ispccdc_enable_lsc);
> +
> +
> +/**
> + * ispccdc_config_crop - Configures crop parameters for the ISP CCDC.
> + * @left: Left offset of the crop area.
> + * @top: Top offset of the crop area.
> + * @height: Height of the crop area.
> + * @width: Width of the crop area.
> + *
> + * The following restrictions are applied for the crop settings. If incoming
> + * values do not follow these restrictions then we map the settings to the
> + * closest acceptable crop value.
> + * 1) Left offset is always odd. This can be avoided if we enable byte swap
> + *    option for incoming data into CCDC.
> + * 2) Top offset is always even.
> + * 3) Crop height is always even.
> + * 4) Crop width is always a multiple of 16 pixels
> + **/
> +void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width)
> +{
> +	ispccdc_obj.ccdcin_woffset = left + (left % 2);
> +	ispccdc_obj.ccdcin_hoffset = top + (top % 2);
> +
> +	ispccdc_obj.crop_w = width - (width % 16);
> +	ispccdc_obj.crop_h = height + (height % 2);
> +
> +	DPRINTK_ISPCCDC("\n\tOffsets L %d T %d W %d H %d\n",
> +						ispccdc_obj.ccdcin_woffset,
> +						ispccdc_obj.ccdcin_hoffset,
> +						ispccdc_obj.crop_w,
> +						ispccdc_obj.crop_h);
> +}
> +
> +/**
> + * ispccdc_config_datapath - Specifies the input and output modules for CCDC.
> + * @input: Indicates the module that inputs the image to the CCDC.
> + * @output: Indicates the module to which the CCDC outputs the image.
> + *
> + * Configures the default configuration for the CCDC to work with.
> + *
> + * The valid values for the input are CCDC_RAW (0), CCDC_YUV_SYNC (1),
> + * CCDC_YUV_BT (2), and CCDC_OTHERS (3).
> + *
> + * The valid values for the output are CCDC_YUV_RSZ (0), CCDC_YUV_MEM_RSZ (1),
> + * CCDC_OTHERS_VP (2), CCDC_OTHERS_MEM (3), CCDC_OTHERS_VP_MEM (4).
> + *
> + * Returns 0 if successful, or -EINVAL if wrong I/O combination or wrong input
> + * or output values.
> + **/
> +int ispccdc_config_datapath(enum ccdc_input input, enum ccdc_output output)
> +{
> +	u32 syn_mode = 0;
> +	struct ispccdc_vp vpcfg;
> +	struct ispccdc_syncif syncif;
> +	struct ispccdc_bclamp blkcfg;
> +
> +	u32 colptn = (ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC0_SHIFT) |
> +		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC1_SHIFT) |
> +		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC2_SHIFT) |
> +		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP0PLC3_SHIFT) |
> +		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC0_SHIFT) |
> +		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC1_SHIFT) |
> +		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP1PLC2_SHIFT) |
> +		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP1PLC3_SHIFT) |
> +		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC0_SHIFT) |
> +		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC1_SHIFT) |
> +		(ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC2_SHIFT) |
> +		(ISPCCDC_COLPTN_R_Ye << ISPCCDC_COLPTN_CP2PLC3_SHIFT) |
> +		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC0_SHIFT) |
> +		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC1_SHIFT) |
> +		(ISPCCDC_COLPTN_B_Mg << ISPCCDC_COLPTN_CP3PLC2_SHIFT) |
> +		(ISPCCDC_COLPTN_Gb_G << ISPCCDC_COLPTN_CP3PLC3_SHIFT);
> +
> +	/* CCDC does not convert the image format */
> +	if (((input == CCDC_RAW) || (input == CCDC_OTHERS)) &&
> +						(output == CCDC_YUV_RSZ)) {
> +		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC I/O Combination\n");
> +		return -EINVAL;
> +	}
> +
> +	syn_mode = isp_reg_readl(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> +
> +	switch (output) {
> +	case CCDC_YUV_RSZ:
> +		syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
> +		break;
> +
> +	case CCDC_YUV_MEM_RSZ:
> +		syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
> +		ispccdc_obj.wen = 1;
> +		syn_mode |= ISPCCDC_SYN_MODE_WEN;
> +		break;
> +
> +	case CCDC_OTHERS_VP:
> +		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
> +		vpcfg.bitshift_sel = BIT9_0;
> +		vpcfg.freq_sel = PIXCLKBY2;
> +		ispccdc_config_vp(vpcfg);
> +		ispccdc_enable_vp(1);
> +		break;
> +
> +	case CCDC_OTHERS_MEM:
> +		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
> +		syn_mode |= ISPCCDC_SYN_MODE_WEN;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_EXWEN;
> +		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
> +							~ISPCCDC_CFG_WENLOG);
> +		vpcfg.bitshift_sel = BIT11_2;
> +		vpcfg.freq_sel = PIXCLKBY2;
> +		ispccdc_config_vp(vpcfg);
> +		ispccdc_enable_vp(0);
> +		break;
> +
> +	case CCDC_OTHERS_VP_MEM:
> +		syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
> +		syn_mode |= ISPCCDC_SYN_MODE_WEN;
> +		syn_mode &= ~ISPCCDC_SYN_MODE_EXWEN;
> +
> +		isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
> +							~ISPCCDC_CFG_WENLOG,
> +							ispccdc_obj.wenlog);
> +		vpcfg.bitshift_sel = BIT9_0;
> +		vpcfg.freq_sel = PIXCLKBY2;
> +		ispccdc_config_vp(vpcfg);
> +		ispccdc_enable_vp(1);
> +		break;
> +	default:
> +		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Output");
> +		return -EINVAL;
> +	};
> +
> +	isp_reg_writel(syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> +
> +	switch (input) {
> +	case CCDC_RAW:
> +		syncif.ccdc_mastermode = 0;
> +		syncif.datapol = 0;
> +		syncif.datsz = DAT10;
> +		syncif.fldmode = 0;
> +		syncif.fldout = 0;
> +		syncif.fldpol = 0;
> +		syncif.fldstat = 0;
> +		syncif.hdpol = 0;
> +		syncif.ipmod = RAW;
> +		syncif.vdpol = 0;
> +		ispccdc_config_sync_if(syncif);
> +		ispccdc_config_imgattr(colptn);
> +		blkcfg.dcsubval = 64;
> +		ispccdc_config_black_clamp(blkcfg);
> +		if (is_isplsc_activated()) {
> +			ispccdc_config_lsc(&lsc_config);
> +			ispccdc_load_lsc(lsc_gain_table_tmp,
> +							LSC_TABLE_INIT_SIZE);
> +		}
> +
> +		break;
> +	case CCDC_YUV_SYNC:
> +		syncif.ccdc_mastermode = 0;
> +		syncif.datapol = 0;
> +		syncif.datsz = DAT8;
> +		syncif.fldmode = 0;
> +		syncif.fldout = 0;
> +		syncif.fldpol = 0;
> +		syncif.fldstat = 0;
> +		syncif.hdpol = 0;
> +		syncif.ipmod = YUV16;
> +		syncif.vdpol = 1;
> +		ispccdc_config_imgattr(0);
> +		ispccdc_config_sync_if(syncif);
> +		blkcfg.dcsubval = 0;
> +		ispccdc_config_black_clamp(blkcfg);
> +		break;
> +	case CCDC_YUV_BT:
> +		break;
> +	case CCDC_OTHERS:
> +		break;
> +	default:
> +		DPRINTK_ISPCCDC("ISP_ERR: Wrong CCDC Input");
> +		return -EINVAL;
> +	}
> +
> +	ispccdc_obj.ccdc_inpfmt = input;
> +	ispccdc_obj.ccdc_outfmt = output;
> +	ispccdc_print_status();
> +	isp_print_status();
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_config_datapath);
> +
> +/**
> + * ispccdc_config_sync_if - Sets the sync i/f params between sensor and CCDC.
> + * @syncif: Structure containing the sync parameters like field state, CCDC in
> + *          master/slave mode, raw/yuv data, polarity of data, field, hs, vs
> + *          signals.
> + **/
> +void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
> +{
> +	u32 syn_mode = isp_reg_readl(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> +
> +	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
> +
> +	if (syncif.fldstat)
> +		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
> +
> +	syn_mode &= ISPCCDC_SYN_MODE_INPMOD_MASK;
> +	ispccdc_obj.syncif_ipmod = syncif.ipmod;
> +
> +	switch (syncif.ipmod) {
> +	case RAW:
> +		break;
> +	case YUV16:
> +		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR16;
> +		break;
> +	case YUV8:
> +		syn_mode |= ISPCCDC_SYN_MODE_INPMOD_YCBCR8;
> +		break;
> +	};
> +
> +	syn_mode &= ISPCCDC_SYN_MODE_DATSIZ_MASK;
> +	switch (syncif.datsz) {
> +	case DAT8:
> +		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
> +		break;
> +	case DAT10:
> +		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
> +		break;
> +	case DAT11:
> +		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_11;
> +		break;
> +	case DAT12:
> +		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
> +		break;
> +	};
> +
> +	if (syncif.fldmode)
> +		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
> +
> +	if (syncif.datapol)
> +		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
> +
> +	if (syncif.fldpol)
> +		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
> +
> +	if (syncif.hdpol)
> +		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
> +
> +	if (syncif.vdpol)
> +		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
> +	else
> +		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
> +
> +	if (syncif.ccdc_mastermode) {
> +		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
> +		isp_reg_writel((syncif.hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT)
> +						| (syncif.vs_width <<
> +						ISPCCDC_HD_VD_WID_VDW_SHIFT),
> +						OMAP3_ISP_IOMEM_CCDC,
> +						ISPCCDC_HD_VD_WID);
> +
> +		isp_reg_writel(syncif.ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
> +			| syncif.hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
> +			OMAP3_ISP_IOMEM_CCDC,
> +			ISPCCDC_PIX_LINES);
> +	} else
> +		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
> +						ISPCCDC_SYN_MODE_VDHDOUT);
> +
> +	isp_reg_writel(syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
> +
> +	if (!(syncif.bt_r656_en)) {
> +		isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
> +						~ISPCCDC_REC656IF_R656ON);
> +	}
> +}
> +EXPORT_SYMBOL(ispccdc_config_sync_if);
> +
> +/**
> + * ispccdc_config_black_clamp - Configures the clamp parameters in CCDC.
> + * @bclamp: Structure containing the optical black average gain, optical black
> + *          sample length, sample lines, and the start pixel position of the
> + *          samples w.r.t the HS pulse.
> + * Configures the clamp parameters in CCDC. Either if its being used the
> + * optical black clamp, or the digital clamp. If its a digital clamp, then
> + * assures to put a valid DC substraction level.
> + *
> + * Returns always 0 when completed.
> + **/
> +int ispccdc_config_black_clamp(struct ispccdc_bclamp bclamp)
> +{
> +	u32 bclamp_val = 0;
> +
> +	if (ispccdc_obj.obclamp_en) {
> +		bclamp_val |= bclamp.obgain << ISPCCDC_CLAMP_OBGAIN_SHIFT;
> +		bclamp_val |= bclamp.oblen << ISPCCDC_CLAMP_OBSLEN_SHIFT;
> +		bclamp_val |= bclamp.oblines << ISPCCDC_CLAMP_OBSLN_SHIFT;
> +		bclamp_val |= bclamp.obstpixel << ISPCCDC_CLAMP_OBST_SHIFT;
> +		isp_reg_writel(bclamp_val, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_CLAMP);
> +	} else {
> +		if (omap_rev() < OMAP3430_REV_ES2_0)
> +			if ((ispccdc_obj.syncif_ipmod == YUV16) ||
> +					(ispccdc_obj.syncif_ipmod == YUV8) ||
> +					(isp_reg_readl(OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_REC656IF) &
> +					ISPCCDC_REC656IF_R656ON))
> +				bclamp.dcsubval = 0;
> +		isp_reg_writel(bclamp.dcsubval, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_DCSUB);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_config_black_clamp);
> +
> +/**
> + * ispccdc_enable_black_clamp - Enables/Disables the optical black clamp.
> + * @enable: 0 Disables optical black clamp, 1 Enables optical black clamp.
> + *
> + * Enables or disables the optical black clamp. When disabled, the digital
> + * clamp operates.
> + **/
> +void ispccdc_enable_black_clamp(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CLAMP,
> +					~ISPCCDC_CLAMP_CLAMPEN,
> +					enable ? ISPCCDC_CLAMP_CLAMPEN : 0);
> +	ispccdc_obj.obclamp_en = enable;
> +}
> +EXPORT_SYMBOL(ispccdc_enable_black_clamp);
> +
> +/**
> + * ispccdc_config_fpc - Configures the Faulty Pixel Correction parameters.
> + * @fpc: Structure containing the number of faulty pixels corrected in the
> + *       frame, address of the FPC table.
> + *
> + * Returns 0 if successful, or -EINVAL if FPC Address is not on the 64 byte
> + * boundary.
> + **/
> +int ispccdc_config_fpc(struct ispccdc_fpc fpc)
> +{
> +	u32 fpc_val = 0;
> +
> +	fpc_val = isp_reg_readl(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
> +
> +	if ((fpc.fpcaddr & 0xFFFFFFC0) == fpc.fpcaddr) {
> +		isp_reg_writel(fpc_val & (~ISPCCDC_FPC_FPCEN),
> +					OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
> +		isp_reg_writel(fpc.fpcaddr,
> +				OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC_ADDR);
> +	} else {
> +		DPRINTK_ISPCCDC("FPC Address should be on 64byte boundary\n");
> +		return -EINVAL;
> +	}
> +	isp_reg_writel(fpc_val | (fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_config_fpc);
> +
> +/**
> + * ispccdc_enable_fpc - Enables the Faulty Pixel Correction.
> + * @enable: 0 Disables FPC, 1 Enables FPC.
> + **/
> +void ispccdc_enable_fpc(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC,
> +					~ISPCCDC_FPC_FPCEN,
> +					enable ? ISPCCDC_FPC_FPCEN : 0);
> +}
> +EXPORT_SYMBOL(ispccdc_enable_fpc);
> +
> +/**
> + * ispccdc_config_black_comp - Configures Black Level Compensation parameters.
> + * @blcomp: Structure containing the black level compensation value for RGrGbB
> + *          pixels. in 2's complement.
> + **/
> +void ispccdc_config_black_comp(struct ispccdc_blcomp blcomp)
> +{
> +	u32 blcomp_val = 0;
> +
> +	blcomp_val |= blcomp.b_mg << ISPCCDC_BLKCMP_B_MG_SHIFT;
> +	blcomp_val |= blcomp.gb_g << ISPCCDC_BLKCMP_GB_G_SHIFT;
> +	blcomp_val |= blcomp.gr_cy << ISPCCDC_BLKCMP_GR_CY_SHIFT;
> +	blcomp_val |= blcomp.r_ye << ISPCCDC_BLKCMP_R_YE_SHIFT;
> +
> +	isp_reg_writel(blcomp_val, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_BLKCMP);
> +}
> +EXPORT_SYMBOL(ispccdc_config_black_comp);
> +
> +/**
> + * ispccdc_config_vp - Configures the Video Port Configuration parameters.
> + * @vpcfg: Structure containing the Video Port input frequency, and the 10 bit
> + *         format.
> + **/
> +void ispccdc_config_vp(struct ispccdc_vp vpcfg)
> +{
> +	u32 fmtcfg_vp = isp_reg_readl(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
> +
> +	fmtcfg_vp &= ISPCCDC_FMTCFG_VPIN_MASK & ISPCCDC_FMTCF_VPIF_FRQ_MASK;
> +
> +	switch (vpcfg.bitshift_sel) {
> +	case BIT9_0:
> +		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
> +		break;
> +	case BIT10_1:
> +		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_10_1;
> +		break;
> +	case BIT11_2:
> +		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_11_2;
> +		break;
> +	case BIT12_3:
> +		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
> +		break;
> +	};
> +	switch (vpcfg.freq_sel) {
> +	case PIXCLKBY2:
> +		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY2;
> +		break;
> +	case PIXCLKBY3_5:
> +		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY3;
> +		break;
> +	case PIXCLKBY4_5:
> +		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY4;
> +		break;
> +	case PIXCLKBY5_5:
> +		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY5;
> +		break;
> +	case PIXCLKBY6_5:
> +		fmtcfg_vp |= ISPCCDC_FMTCF_VPIF_FRQ_BY6;
> +		break;
> +	};
> +	isp_reg_writel(fmtcfg_vp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
> +}
> +EXPORT_SYMBOL(ispccdc_config_vp);
> +
> +/**
> + * ispccdc_enable_vp - Enables the Video Port.
> + * @enable: 0 Disables VP, 1 Enables VP
> + **/
> +void ispccdc_enable_vp(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG,
> +					~ISPCCDC_FMTCFG_VPEN,
> +					enable ? ISPCCDC_FMTCFG_VPEN : 0);
> +}
> +EXPORT_SYMBOL(ispccdc_enable_vp);
> +
> +/**
> + * ispccdc_config_reformatter - Configures the Reformatter.
> + * @refmt: Structure containing the memory address to format and the bit fields
> + *         for the reformatter registers.
> + *
> + * Configures the Reformatter register values if line alternating is disabled.
> + * Else, just enabling line alternating is enough.
> + **/
> +void ispccdc_config_reformatter(struct ispccdc_refmt refmt)
> +{
> +	u32 fmtcfg_val = 0;
> +
> +	fmtcfg_val = isp_reg_readl(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
> +
> +	if (refmt.lnalt)
> +		fmtcfg_val |= ISPCCDC_FMTCFG_LNALT;
> +	else {
> +		fmtcfg_val &= ~ISPCCDC_FMTCFG_LNALT;
> +		fmtcfg_val &= 0xFFFFF003;
> +		fmtcfg_val |= refmt.lnum << ISPCCDC_FMTCFG_LNUM_SHIFT;
> +		fmtcfg_val |= refmt.plen_even <<
> +						ISPCCDC_FMTCFG_PLEN_EVEN_SHIFT;
> +		fmtcfg_val |= refmt.plen_odd << ISPCCDC_FMTCFG_PLEN_ODD_SHIFT;
> +
> +		isp_reg_writel(refmt.prgeven0, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_PRGEVEN0);
> +		isp_reg_writel(refmt.prgeven1, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_PRGEVEN1);
> +		isp_reg_writel(refmt.prgodd0, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_PRGODD0);
> +		isp_reg_writel(refmt.prgodd1, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_PRGODD1);
> +		isp_reg_writel(refmt.fmtaddr0, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR0);
> +		isp_reg_writel(refmt.fmtaddr1, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR1);
> +		isp_reg_writel(refmt.fmtaddr2, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR2);
> +		isp_reg_writel(refmt.fmtaddr3, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR3);
> +		isp_reg_writel(refmt.fmtaddr4, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR4);
> +		isp_reg_writel(refmt.fmtaddr5, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR5);
> +		isp_reg_writel(refmt.fmtaddr6, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR6);
> +		isp_reg_writel(refmt.fmtaddr7, OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_FMT_ADDR7);
> +	}
> +	isp_reg_writel(fmtcfg_val, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
> +}
> +EXPORT_SYMBOL(ispccdc_config_reformatter);
> +
> +/**
> + * ispccdc_enable_reformatter - Enables the Reformatter.
> + * @enable: 0 Disables Reformatter, 1- Enables Data Reformatter
> + **/
> +void ispccdc_enable_reformatter(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG,
> +					~ISPCCDC_FMTCFG_FMTEN,
> +					enable ? ISPCCDC_FMTCFG_FMTEN : 0);
> +	ispccdc_obj.refmt_en = enable;
> +}
> +EXPORT_SYMBOL(ispccdc_enable_reformatter);
> +
> +/**
> + * ispccdc_config_culling - Configures the culling parameters.
> + * @cull: Structure containing the vertical culling pattern, and horizontal
> + *        culling pattern for odd and even lines.
> + **/
> +void ispccdc_config_culling(struct ispccdc_culling cull)
> +{
> +	u32 culling_val = 0;
> +
> +	culling_val |= cull.v_pattern << ISPCCDC_CULLING_CULV_SHIFT;
> +	culling_val |= cull.h_even << ISPCCDC_CULLING_CULHEVN_SHIFT;
> +	culling_val |= cull.h_odd << ISPCCDC_CULLING_CULHODD_SHIFT;
> +
> +	isp_reg_writel(culling_val, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CULLING);
> +}
> +EXPORT_SYMBOL(ispccdc_config_culling);
> +
> +/**
> + * ispccdc_enable_lpf - Enables the Low-Pass Filter (LPF).
> + * @enable: 0 Disables LPF, 1 Enables LPF
> + **/
> +void ispccdc_enable_lpf(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE,
> +					~ISPCCDC_SYN_MODE_LPF,
> +					enable ? ISPCCDC_SYN_MODE_LPF : 0);
> +}
> +EXPORT_SYMBOL(ispccdc_enable_lpf);
> +
> +/**
> + * ispccdc_config_alaw - Configures the input width for A-law.
> + * @ipwidth: Input width for A-law
> + **/
> +void ispccdc_config_alaw(enum alaw_ipwidth ipwidth)
> +{
> +	isp_reg_writel(ipwidth << ISPCCDC_ALAW_GWDI_SHIFT,
> +					OMAP3_ISP_IOMEM_CCDC, ISPCCDC_ALAW);
> +}
> +EXPORT_SYMBOL(ispccdc_config_alaw);
> +
> +/**
> + * ispccdc_enable_alaw - Enables the A-law compression.
> + * @enable: 0 - Disables A-law, 1 - Enables A-law
> + **/
> +void ispccdc_enable_alaw(u8 enable)
> +{
> +	isp_reg_and_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_ALAW,
> +					~ISPCCDC_ALAW_CCDTBL,
> +					enable ? ISPCCDC_ALAW_CCDTBL : 0);
> +}
> +EXPORT_SYMBOL(ispccdc_enable_alaw);
> +
> +/**
> + * ispccdc_config_imgattr - Configures the sensor image specific attributes.
> + * @colptn: Color pattern of the sensor.
> + **/
> +void ispccdc_config_imgattr(u32 colptn)
> +{
> +	isp_reg_writel(colptn, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_COLPTN);
> +}
> +EXPORT_SYMBOL(ispccdc_config_imgattr);
> +
> +/**
> + * ispccdc_config_shadow_registers - Programs the shadow registers for CCDC.
> + * Currently nothing to program in shadow, but kept for future use.
> + **/
> +void ispccdc_config_shadow_registers(void)
> +{
> +	return;
> +}
> +EXPORT_SYMBOL(ispccdc_config_shadow_registers);
> +
> +/**
> + * ispccdc_try_size - Checks if requested Input/output dimensions are valid
> + * @input_w: input width for the CCDC in number of pixels per line
> + * @input_h: input height for the CCDC in number of lines
> + * @output_w: output width from the CCDC in number of pixels per line
> + * @output_h: output height for the CCDC in number of lines
> + *
> + * Calculates the number of pixels cropped if the reformater is disabled,
> + * Fills up the output width and height variables in the isp_ccdc structure.
> + *
> + * Returns 0 if successful, or -EINVAL if the input width is less than 2 pixels
> + **/
> +int ispccdc_try_size(u32 input_w, u32 input_h, u32 *output_w, u32 *output_h)
> +{
> +	if (input_w < 32 || input_h < 32) {
> +		DPRINTK_ISPCCDC("ISP_ERR: CCDC cannot handle input width less"
> +				" than 32 pixels or height less than 32\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ispccdc_obj.crop_w)
> +		*output_w = ispccdc_obj.crop_w;
> +	else
> +		*output_w = input_w;
> +
> +	if (ispccdc_obj.crop_h)
> +		*output_h = ispccdc_obj.crop_h;
> +	else
> +		*output_h = input_h;
> +
> +	if ((!ispccdc_obj.refmt_en) && ((ispccdc_obj.ccdc_outfmt !=
> +		CCDC_OTHERS_MEM) && ispccdc_obj.ccdc_outfmt !=
> +					CCDC_OTHERS_VP_MEM))
> +		*output_h -= 1;
> +
> +	if ((ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) ||
> +						(ispccdc_obj.ccdc_outfmt ==
> +						CCDC_OTHERS_VP_MEM)) {
> +		if (*output_w % 16) {
> +			*output_w -= (*output_w % 16);
> +			*output_w += 16;
> +		}
> +	}
> +
> +	ispccdc_obj.ccdcout_w = *output_w;
> +	ispccdc_obj.ccdcout_h = *output_h;
> +	ispccdc_obj.ccdcin_w = input_w;
> +	ispccdc_obj.ccdcin_h = input_h;
> +
> +	DPRINTK_ISPCCDC("try size: ccdcin_w=%u,ccdcin_h=%u,ccdcout_w=%u,"
> +							" ccdcout_h=%u\n",
> +							ispccdc_obj.ccdcin_w,
> +							ispccdc_obj.ccdcin_h,
> +							ispccdc_obj.ccdcout_w,
> +							ispccdc_obj.ccdcout_h);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_try_size);
> +
> +/**
> + * ispccdc_config_size - Configure the dimensions of the CCDC input/output
> + * @input_w: input width for the CCDC in number of pixels per line
> + * @input_h: input height for the CCDC in number of lines
> + * @output_w: output width from the CCDC in number of pixels per line
> + * @output_h: output height for the CCDC in number of lines
> + *
> + * Configures the appropriate values stored in the isp_ccdc structure to
> + * HORZ/VERT_INFO registers and the VP_OUT depending on whether the image
> + * is stored in memory or given to the another module in the ISP pipeline.
> + *
> + * Returns 0 if successful, or -EINVAL if try_size was not called before to
> + * validate the requested dimensions.
> + **/
> +int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
> +{
> +	DPRINTK_ISPCCDC("config size: input_w=%u, input_h=%u, output_w=%u,"
> +							" output_h=%u\n",
> +							input_w, input_h,
> +							output_w, output_h);
> +	if ((output_w != ispccdc_obj.ccdcout_w) || (output_h !=
> +						ispccdc_obj.ccdcout_h)) {
> +		DPRINTK_ISPCCDC("ISP_ERR : ispccdc_try_size should"
> +					" be called before config size\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP) {
> +		isp_reg_writel((ispccdc_obj.ccdcin_woffset <<
> +					ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
> +					(ispccdc_obj.ccdcin_w <<
> +					ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_FMT_HORZ);
> +		isp_reg_writel((ispccdc_obj.ccdcin_hoffset <<
> +					ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
> +					(ispccdc_obj.ccdcin_h <<
> +					ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_FMT_VERT);
> +		isp_reg_writel((ispccdc_obj.ccdcout_w <<
> +					ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
> +					(ispccdc_obj.ccdcout_h - 1) <<
> +					ISPCCDC_VP_OUT_VERT_NUM_SHIFT,
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VP_OUT);
> +		isp_reg_writel((((ispccdc_obj.ccdcout_h - 25) &
> +					ISPCCDC_VDINT_0_MASK) <<
> +					ISPCCDC_VDINT_0_SHIFT) |
> +					((50 & ISPCCDC_VDINT_1_MASK) <<
> +					ISPCCDC_VDINT_1_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VDINT);
> +
> +	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_MEM) {
> +		isp_reg_writel(0, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
> +		if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
> +			isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
> +					| ((ispccdc_obj.ccdcout_w - 1)
> +					<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_HORZ_INFO);
> +		} else {
> +			isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
> +					| ((ispccdc_obj.ccdcout_w - 1)
> +					<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_HORZ_INFO);
> +		}
> +		isp_reg_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
> +							OMAP3_ISP_IOMEM_CCDC,
> +							ISPCCDC_VERT_START);
> +		isp_reg_writel((ispccdc_obj.ccdcout_h - 1) <<
> +						ISPCCDC_VERT_LINES_NLV_SHIFT,
> +						OMAP3_ISP_IOMEM_CCDC,
> +						ISPCCDC_VERT_LINES);
> +
> +		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
> +		isp_reg_writel((((ispccdc_obj.ccdcout_h - 2) &
> +					ISPCCDC_VDINT_0_MASK) <<
> +					ISPCCDC_VDINT_0_SHIFT) |
> +					((100 & ISPCCDC_VDINT_1_MASK) <<
> +					ISPCCDC_VDINT_1_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VDINT);
> +	} else if (ispccdc_obj.ccdc_outfmt == CCDC_OTHERS_VP_MEM) {
> +		isp_reg_writel((0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
> +					(ispccdc_obj.ccdcin_w <<
> +					ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_FMT_HORZ);
> +		isp_reg_writel((0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
> +					((ispccdc_obj.ccdcin_h) <<
> +					ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_FMT_VERT);
> +		isp_reg_writel((ispccdc_obj.ccdcout_w
> +					<< ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
> +					((ispccdc_obj.ccdcout_h - 1) <<
> +					ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VP_OUT);
> +		isp_reg_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
> +					((ispccdc_obj.ccdcout_w - 1) <<
> +					ISPCCDC_HORZ_INFO_NPH_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_HORZ_INFO);
> +		isp_reg_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VERT_START);
> +		isp_reg_writel((ispccdc_obj.ccdcout_h - 1) <<
> +					ISPCCDC_VERT_LINES_NLV_SHIFT,
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VERT_LINES);
> +		ispccdc_config_outlineoffset(ispccdc_obj.ccdcout_w * 2, 0, 0);
> +		isp_reg_writel((((ispccdc_obj.ccdcout_h - 2) &
> +					ISPCCDC_VDINT_0_MASK) <<
> +					ISPCCDC_VDINT_0_SHIFT) |
> +					((100 & ISPCCDC_VDINT_1_MASK) <<
> +					ISPCCDC_VDINT_1_SHIFT),
> +					OMAP3_ISP_IOMEM_CCDC,
> +					ISPCCDC_VDINT);
> +	}
> +
> +	if (is_isplsc_activated()) {
> +		if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
> +			ispccdc_config_lsc(&lsc_config);
> +			ispccdc_load_lsc(lsc_gain_table, lsc_config.size);
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_config_size);
> +
> +/**
> + * ispccdc_config_outlineoffset - Configures the output line offset
> + * @offset: Must be twice the Output width and aligned on 32 byte boundary
> + * @oddeven: Specifies the odd/even line pattern to be chosen to store the
> + *           output.
> + * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
> + *
> + * - Configures the output line offset when stored in memory
> + * - Sets the odd/even line pattern to store the output
> + *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
> + * - Configures the number of even and odd line fields in case of rearranging
> + * the lines.
> + *
> + * Returns 0 if successful, or -EINVAL if the offset is not in 32 byte
> + * boundary.
> + **/
> +int ispccdc_config_outlineoffset(u32 offset, u8 oddeven, u8 numlines)
> +{
> +	if ((offset & ISP_32B_BOUNDARY_OFFSET) == offset) {
> +		isp_reg_writel((offset & 0xFFFF), OMAP3_ISP_IOMEM_CCDC,
> +						ISPCCDC_HSIZE_OFF);
> +	} else {
> +		DPRINTK_ISPCCDC("ISP_ERR : Offset should be in 32 byte"
> +								" boundary");

"\n" ?

> +		return -EINVAL;
> +	}
> +
> +	isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +						~ISPCCDC_SDOFST_FINV);
> +
> +	isp_reg_and(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +						~ISPCCDC_SDOFST_FOFST_4L);
> +
> +	switch (oddeven) {
> +	case EVENEVEN:
> +		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +			(numlines & 0x7) << ISPCCDC_SDOFST_LOFST0_SHIFT);
> +		break;
> +	case ODDEVEN:
> +		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +			(numlines & 0x7) << ISPCCDC_SDOFST_LOFST1_SHIFT);
> +		break;
> +	case EVENODD:
> +		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +			(numlines & 0x7) << ISPCCDC_SDOFST_LOFST2_SHIFT);
> +		break;
> +	case ODDODD:
> +		isp_reg_or(OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> +			(numlines & 0x7) << ISPCCDC_SDOFST_LOFST3_SHIFT);
> +		break;
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(ispccdc_config_outlineoffset);
> +
> +/**
> + * ispccdc_set_outaddr - Sets the memory address where the output will be saved
> + * @addr: 32-bit memory address aligned on 32 byte boundary.
> + *
> + * Sets the memory address where the output will be saved.
> + *
> + * Returns 0 if successful, or -EINVAL if the address is not in the 32 byte
> + * boundary.
> + **/
> +int ispccdc_set_outaddr(u32 addr)
> +{
> +	if ((addr & ISP_32B_BOUNDARY_BUF) == addr) {
> +		isp_reg_writel(addr, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDR_ADDR);
> +		return 0;
> +	} else {
> +		DPRINTK_ISPCCDC("ISP_ERR : Address should be in 32 byte"
> +								" boundary");

"\n" ?


<snip>

> 
> Best regards, Klimov Alexey

