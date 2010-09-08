Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:46548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0IHUTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 16:19:21 -0400
Message-ID: <4C87EFCB.2060906@infradead.org>
Date: Wed, 08 Sep 2010 17:19:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: raja_mani@ti.com
CC: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	matti.j.aaltonen@nokia.com, Pramodh AG <pramodh_ag@ti.com>
Subject: Re: [RFC/PATCH 3/8] drivers:staging:ti-st: Sources for FM TX
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com> <1283443080-30644-2-git-send-email-raja_mani@ti.com> <1283443080-30644-3-git-send-email-raja_mani@ti.com> <1283443080-30644-4-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-4-git-send-email-raja_mani@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 02-09-2010 12:57, raja_mani@ti.com escreveu:
> From: Raja Mani <raja_mani@ti.com>
> 
> This has implementation of FM TX functionality (for Wl127x and WL128x
> chip) which are listed below,
> 
> 1) frequency set.
> 2) stereo/nono mode selection.
> 3) RDS config.
> 4) mute/unmute mode config.
> 5) power level config.
> 6) preemphasis filter config, etc.
> 
> This will work on top of TI Shared Transport driver. It communicates with
> TI FM V4L2 module and TI FM Common module to perform the actual FM TX operation.
> 
> Signed-off-by: Raja Mani <raja_mani@ti.com>
> Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
> ---
>  drivers/staging/ti-st/fmdrv_tx.c |  391 ++++++++++++++++++++++++++++++++++++++
>  drivers/staging/ti-st/fmdrv_tx.h |   37 ++++
>  2 files changed, 428 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.c
>  create mode 100644 drivers/staging/ti-st/fmdrv_tx.h
> 
> diff --git a/drivers/staging/ti-st/fmdrv_tx.c b/drivers/staging/ti-st/fmdrv_tx.c
> new file mode 100644
> index 0000000..55bf89a
> --- /dev/null
> +++ b/drivers/staging/ti-st/fmdrv_tx.c
> @@ -0,0 +1,391 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *  This sub-module of FM driver implements FM TX functionality.
> + *
> + *  Copyright (C) 2010 Texas Instruments
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include "fmdrv.h"
> +#include "fmdrv_common.h"
> +#include "fmdrv_tx.h"

Where are those headers? Please send your patch series on an order that helps the
reviewers to understand the logic, sending first things first.

I'm not seeing the patches that are adding those include files, making hard to
understand the remaining patches of this series.

> +
> +int fm_tx_set_stereo_mono(struct fmdrv_ops *fmdev, unsigned short mode)
> +{
> +	unsigned short payload;
> +	int ret = 0;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX) {
> +		ret = -EPERM;
> +		goto exit;
> +	}
> +	if (fmdev->tx_data.aud_mode == mode)
> +		goto exit;
> +
> +	pr_debug("stereo mode: %d", (int)mode);
> +
> +	/* Set Stereo/Mono mode */
> +	FM_STORE_LE16_TO_BE16(payload, (1 - mode));
> +	ret = fmc_send_cmd(fmdev, MONO_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	fmdev->tx_data.aud_mode = mode;
> +exit:
> +	return ret;
> +}
> +
> +static int __set_rds_text(struct fmdrv_ops *fmdev, unsigned char *rds_text)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	ret = fmc_send_cmd(fmdev, RDS_DATA_SET, rds_text, strlen(rds_text),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* Scroll mode */
> +	FM_STORE_LE16_TO_BE16(payload, (unsigned short)0x1);
> +	ret = fmc_send_cmd(fmdev, DISPLAY_MODE_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	return 0;
> +}
> +
> +static int __set_rds_data_mode(struct fmdrv_ops *fmdev, unsigned char mode)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	/* Setting unique PI TODO: how unique? */
> +	FM_STORE_LE16_TO_BE16(payload, (unsigned short)0xcafe);
> +	ret = fmc_send_cmd(fmdev, PI_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* Set decoder id */
> +	FM_STORE_LE16_TO_BE16(payload, (unsigned short)0xa);
> +	ret = fmc_send_cmd(fmdev, DI_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* TODO: RDS_MODE_GET? */
> +	return 0;
> +}
> +
> +static int __set_rds_len(struct fmdrv_ops *fmdev, unsigned char type,
> +				unsigned short len)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	len |= type << 8;
> +	FM_STORE_LE16_TO_BE16(payload, len);
> +	ret = fmc_send_cmd(fmdev, LENGHT_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* TODO: LENGHT_GET? */
> +	return 0;
> +}
> +
> +int fm_tx_set_rds_mode(struct fmdrv_ops *fmdev, unsigned char rds_en_dis)
> +{
> +	unsigned short payload;
> +	int ret;
> +	unsigned char rds_text[] = "Zoom2\n";
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +
> +	pr_debug("rds_en_dis:%d(E:%d, D:%d)", rds_en_dis,
> +		   FM_RDS_ENABLE, FM_RDS_DISABLE);
> +
> +	if (rds_en_dis == FM_RDS_ENABLE) {
> +		/* Set RDS length */
> +		__set_rds_len(fmdev, 0, strlen(rds_text));
> +		/* Set RDS text */
> +		__set_rds_text(fmdev, rds_text);
> +		/* Set RDS mode */
> +		__set_rds_data_mode(fmdev, 0x0);
> +	}
> +
> +	/* Send command to enable RDS */
> +	if (rds_en_dis == FM_RDS_ENABLE)
> +		FM_STORE_LE16_TO_BE16(payload, 0x01);
> +	else
> +		FM_STORE_LE16_TO_BE16(payload, 0x00);
> +
> +	ret = fmc_send_cmd(fmdev, RDS_DATA_ENB, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	if (rds_en_dis == FM_RDS_ENABLE) {
> +		/* Set RDS length */
> +		__set_rds_len(fmdev, 0, strlen(rds_text));
> +		/* Set RDS text */
> +		__set_rds_text(fmdev, rds_text);
> +	}
> +	fmdev->tx_data.rds.flag = rds_en_dis;
> +
> +	return 0;
> +}
> +
> +int fm_tx_set_radio_text(struct fmdrv_ops *fmdev,
> +				unsigned char *rds_text,
> +				unsigned char rds_type)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +
> +	fm_tx_set_rds_mode(fmdev, 0);
> +	/* Set RDS length */
> +	__set_rds_len(fmdev, rds_type, strlen(rds_text));
> +	/* Set RDS text */
> +	__set_rds_text(fmdev, rds_text);
> +	/* Set RDS mode */
> +	__set_rds_data_mode(fmdev, 0x0);
> +
> +	FM_STORE_LE16_TO_BE16(payload, 1);
> +	ret = fmc_send_cmd(fmdev, RDS_DATA_ENB, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	return 0;
> +}
> +
> +int fm_tx_set_af(struct fmdrv_ops *fmdev, unsigned int af)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +	pr_debug("AF: %d", af);
> +
> +	af = (af - 87500) / 100;
> +	FM_STORE_LE16_TO_BE16(payload, (unsigned short)af);
> +	ret = fmc_send_cmd(fmdev, TA_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +	return 0;
> +}
> +
> +int fm_tx_set_region(struct fmdrv_ops *fmdev,
> +				unsigned char region_to_set)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	if (region_to_set != FM_BAND_EUROPE_US &&
> +	    region_to_set != FM_BAND_JAPAN) {
> +		pr_err("Invalid band\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Send command to set the band */
> +	FM_STORE_LE16_TO_BE16(payload, (unsigned short)region_to_set);
> +	ret = fmc_send_cmd(fmdev, TX_BAND_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	return 0;
> +}
> +
> +int fm_tx_set_mute_mode(struct fmdrv_ops *fmdev,
> +				unsigned char mute_mode_toset)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +	pr_debug("tx: mute mode %ld", (unsigned long)mute_mode_toset);
> +
> +	FM_STORE_LE16_TO_BE16(payload, mute_mode_toset);
> +	ret = fmc_send_cmd(fmdev, MUTE, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	return 0;
> +}
> +
> +/* Set TX Audio I/O */
> +static int __set_audio_io(struct fmdrv_ops *fmdev)
> +{
> +	struct fmtx_data *tx = &fmdev->tx_data;
> +	unsigned short payload;
> +	int ret;
> +
> +	/* Set Audio I/O Enable */
> +	FM_STORE_LE16_TO_BE16(payload, tx->audio_io);
> +	ret = fmc_send_cmd(fmdev, AUDIO_IO_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* TODO: is audio set? */
> +	return 0;
> +}
> +
> +/* Start TX Transmission */
> +static int __enable_xmit(struct fmdrv_ops *fmdev, unsigned char new_xmit_state)
> +{
> +	struct fmtx_data *tx = &fmdev->tx_data;
> +	unsigned short payload;
> +	unsigned long timeleft;
> +	int ret;
> +
> +	/* Enable POWER_ENB interrupts */
> +	FM_STORE_LE16_TO_BE16(payload, FM_POW_ENB_EVENT);
> +	ret = fmc_send_cmd(fmdev, INT_MASK_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +
> +	/* Set Power Enable */
> +	FM_STORE_LE16_TO_BE16(payload, new_xmit_state);
> +	ret = fmc_send_cmd(fmdev, POWER_ENB_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* Wait for Power Enabled */
> +	init_completion(&fmdev->maintask_completion);
> +	timeleft = wait_for_completion_timeout(&fmdev->maintask_completion,
> +					       FM_DRV_TX_TIMEOUT);
> +	if (!timeleft) {
> +		pr_err("Timeout(%d sec),didn't get tune ended interrupt",
> +			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
> +		return -ETIMEDOUT;
> +	}
> +
> +	set_bit(FM_CORE_TX_XMITING, &fmdev->flag);
> +	tx->xmit_state = new_xmit_state;
> +
> +	return 0;
> +}
> +
> +/* Set TX power level */
> +int fm_tx_set_pwr_lvl(struct fmdrv_ops *fmdev, unsigned char new_pwr_lvl)
> +{
> +	unsigned short payload;
> +	struct fmtx_data *tx = &fmdev->tx_data;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +	pr_debug("tx: pwr_level_to_set %ld ", (long int)new_pwr_lvl);
> +
> +	/* If the core isn't ready update global variable */
> +	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
> +		tx->pwr_lvl = new_pwr_lvl;
> +		return 0;
> +	}
> +
> +	/* Set power level */
> +	FM_STORE_LE16_TO_BE16(payload, new_pwr_lvl);
> +	ret = fmc_send_cmd(fmdev, POWER_LEL_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	/* TODO: is the power level set? */
> +	tx->pwr_lvl = new_pwr_lvl;
> +
> +	return 0;
> +}
> +
> +/* Sets FM TX pre-emphasis filter value (OFF, 50us, or 75us)
> + * Convert V4L2 specified filter values to chip specific filter values.
> + */
> +int fm_tx_set_preemph_filter(struct fmdrv_ops *fmdev, unsigned int filter)
> +{
> +	struct fmtx_data *tx = &fmdev->tx_data;
> +	unsigned short payload;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +
> +	FM_STORE_LE16_TO_BE16(payload, filter);
> +	ret = fmc_send_cmd(fmdev, PREMPH_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	tx->preemph = filter;
> +	return ret;
> +}
> +
> +/* Sets FM TX antenna impedence value */
> +int fm_tx_set_ant_imp(struct fmdrv_ops *fmdev, unsigned char imp)
> +{
> +	unsigned short payload;
> +	int ret;
> +
> +	if (fmdev->curr_fmmode != FM_MODE_TX)
> +		return -EPERM;
> +
> +	FM_STORE_LE16_TO_BE16(payload, imp);
> +	ret = fmc_send_cmd(fmdev, IMP_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	return ret;
> +}
> +
> +/* Set TX Frequency */
> +int fm_tx_set_frequency(struct fmdrv_ops *fmdev, unsigned int freq_to_set)
> +{
> +	struct fmtx_data *tx = &fmdev->tx_data;
> +	unsigned short payload, chanl_index;
> +	int ret;
> +
> +	if (test_bit(FM_CORE_TX_XMITING, &fmdev->flag)) {
> +		__enable_xmit(fmdev, 0);
> +		clear_bit(FM_CORE_TX_XMITING, &fmdev->flag);
> +	}
> +
> +	/* Enable FR, BL interrupts */
> +	FM_STORE_LE16_TO_BE16(payload, (FM_FR_EVENT | FM_BL_EVENT));
> +	ret = fmc_send_cmd(fmdev, INT_MASK_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +
> +	tx->tx_frq = (unsigned long)freq_to_set;
> +	pr_debug("tx: freq_to_set %ld ", (long int)tx->tx_frq);
> +
> +	chanl_index = freq_to_set / 10;
> +	/* Set current tuner channel */
> +	FM_STORE_LE16_TO_BE16(payload, chanl_index);
> +	ret = fmc_send_cmd(fmdev, CHANL_SET, &payload, sizeof(payload),
> +				&fmdev->maintask_completion, NULL, NULL);
> +	FM_CHECK_SEND_CMD_STATUS(ret);
> +
> +	fm_tx_set_pwr_lvl(fmdev, tx->pwr_lvl);
> +	fm_tx_set_preemph_filter(fmdev, tx->preemph);
> +
> +	tx->audio_io = 0x01;	/* I2S */
> +	__set_audio_io(fmdev);
> +
> +	__enable_xmit(fmdev, 0x01);	/* Enable transmission */
> +
> +	tx->aud_mode = FM_STEREO_MODE;
> +	tx->rds.flag = FM_RDS_DISABLE;
> +
> +	return 0;
> +}
> +
> diff --git a/drivers/staging/ti-st/fmdrv_tx.h b/drivers/staging/ti-st/fmdrv_tx.h
> new file mode 100644
> index 0000000..f61dace
> --- /dev/null
> +++ b/drivers/staging/ti-st/fmdrv_tx.h
> @@ -0,0 +1,37 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *  FM TX module header.
> + *
> + *  Copyright (C) 2010 Texas Instruments
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#ifndef _FMDRV_TX_H
> +#define _FMDRV_TX_H
> +
> +int fm_tx_set_frequency(struct fmdrv_ops*, unsigned int);
> +int fm_tx_set_pwr_lvl(struct fmdrv_ops*, unsigned char);
> +int fm_tx_set_region(struct fmdrv_ops*, unsigned char);
> +int fm_tx_set_mute_mode(struct fmdrv_ops*, unsigned char);
> +int fm_tx_set_stereo_mono(struct fmdrv_ops*, unsigned short);
> +int fm_tx_set_rds_mode(struct fmdrv_ops*, unsigned char);
> +int fm_tx_set_radio_text(struct fmdrv_ops*, unsigned char*, unsigned char);
> +int fm_tx_set_af(struct fmdrv_ops*, unsigned int);
> +int fm_tx_set_preemph_filter(struct fmdrv_ops*, unsigned int);
> +int fm_tx_set_ant_imp(struct fmdrv_ops*, unsigned char);
> +
> +#endif
> +

