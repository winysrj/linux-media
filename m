Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:15059 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaHOQRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 12:17:31 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAC00MPVVX6LU20@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Aug 2014 12:17:30 -0400 (EDT)
Date: Fri, 15 Aug 2014 13:17:25 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 4/4] pt3: add support for Earthsoft PT3 ISDB-S/T receiver
 card
Message-id: <20140815131725.6451cbf9.m.chehab@samsung.com>
In-reply-to: <1405352627-22677-5-git-send-email-tskd08@gmail.com>
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com>
 <1405352627-22677-2-git-send-email-tskd08@gmail.com>
 <1405352627-22677-3-git-send-email-tskd08@gmail.com>
 <1405352627-22677-4-git-send-email-tskd08@gmail.com>
 <1405352627-22677-5-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jul 2014 00:43:47 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> This patch adds support for PT3 PCIe cards.
> PT3 has an FPGA PCIe bridge chip, a TC90522 demod chip and
> a VA4M6JC2103 tuner module which contains two QM1D1C0042 chips for ISDB-S
> and two MxL301RF's for ISDB-T.
> It can receive and deliver 4 (2x ISDB-S, 2x ISDB-T) streams simultaneously.
> 
> As an antenna input for each delivery system is split in the tuner module
> and shared between the corresponding two tuner chips,
> LNB/LNA controls that the FPGA chip provides are (naturally) shared as well.
> The tuner chips also share the power line in the tuner module,
> which is controlled on/off by a GPIO pin of the demod chip.
> 
> As with the demod chip and the ISDB-T tuner chip,
> the init sequences/register settings for those chips are not disclosed
> and stored in a private memory of the FPGA,
> PT3 driver executes the init of those chips on behalf of their drivers.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  drivers/media/pci/Kconfig       |   1 +
>  drivers/media/pci/Makefile      |   1 +
>  drivers/media/pci/pt3/Kconfig   |  10 +
>  drivers/media/pci/pt3/Makefile  |   8 +
>  drivers/media/pci/pt3/pt3.c     | 750 ++++++++++++++++++++++++++++++++++++++++
>  drivers/media/pci/pt3/pt3.h     | 179 ++++++++++
>  drivers/media/pci/pt3/pt3_dma.c | 225 ++++++++++++
>  drivers/media/pci/pt3/pt3_i2c.c | 239 +++++++++++++
>  8 files changed, 1413 insertions(+)
>  create mode 100644 drivers/media/pci/pt3/Kconfig
>  create mode 100644 drivers/media/pci/pt3/Makefile
>  create mode 100644 drivers/media/pci/pt3/pt3.c
>  create mode 100644 drivers/media/pci/pt3/pt3.h
>  create mode 100644 drivers/media/pci/pt3/pt3_dma.c
>  create mode 100644 drivers/media/pci/pt3/pt3_i2c.c
> 
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 53196f1..9a1173c 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -40,6 +40,7 @@ source "drivers/media/pci/b2c2/Kconfig"
>  source "drivers/media/pci/pluto2/Kconfig"
>  source "drivers/media/pci/dm1105/Kconfig"
>  source "drivers/media/pci/pt1/Kconfig"
> +source "drivers/media/pci/pt3/Kconfig"
>  source "drivers/media/pci/mantis/Kconfig"
>  source "drivers/media/pci/ngene/Kconfig"
>  source "drivers/media/pci/ddbridge/Kconfig"
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index 35cc578..f7be6bc 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -7,6 +7,7 @@ obj-y        +=	ttpci/		\
>  		pluto2/		\
>  		dm1105/		\
>  		pt1/		\
> +		pt3/		\
>  		mantis/		\
>  		ngene/		\
>  		ddbridge/	\
> diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
> new file mode 100644
> index 0000000..69a8d12
> --- /dev/null
> +++ b/drivers/media/pci/pt3/Kconfig
> @@ -0,0 +1,10 @@
> +config DVB_PT3
> +	tristate "DVB Support for Earthsoft PT3 cards"
> +	depends on DVB_CORE && PCI && I2C
> +	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
> +	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Support for Earthsoft PT3 PCIe cards.
> +
> +	  Say Y or M if you own such a device and want to use it.
> diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
> new file mode 100644
> index 0000000..396f146
> --- /dev/null
> +++ b/drivers/media/pci/pt3/Makefile
> @@ -0,0 +1,8 @@
> +
> +earth-pt3-objs += pt3.o pt3_i2c.o pt3_dma.o
> +
> +obj-$(CONFIG_DVB_PT3) += earth-pt3.o
> +
> +ccflags-y += -Idrivers/media/dvb-core
> +ccflags-y += -Idrivers/media/dvb-frontends
> +ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
> new file mode 100644
> index 0000000..cada24b
> --- /dev/null
> +++ b/drivers/media/pci/pt3/pt3.c
> @@ -0,0 +1,750 @@
> +/*
> + * Earthsoft PT3 driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/freezer.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/string.h>
> +
> +#include "dmxdev.h"
> +#include "dvbdev.h"
> +#include "dvb_demux.h"
> +#include "dvb_frontend.h"
> +
> +#include "pt3.h"
> +
> +DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> +
> +static bool one_adapter;
> +module_param(one_adapter, bool, 0444);
> +MODULE_PARM_DESC(one_adapter, "Place FE's together under one adapter.");
> +
> +static int num_bufs = 4;
> +module_param(num_bufs, int, 0444);
> +MODULE_PARM_DESC(num_bufs, "Number of DMA buffer (188KiB) per FE.");
> +
> +
> +static const struct i2c_algorithm pt3_i2c_algo = {
> +	.master_xfer   = &pt3_i2c_master_xfer,
> +	.functionality = &pt3_i2c_functionality,
> +};
> +
> +static const struct pt3_adap_config adap_conf[PT3_NUM_FE] = {
> +	{
> +		.demod_cfg = {
> +			.addr = 0x11,
> +		},
> +		.tuner_cfg.qm1d1c0042 = {
> +			.addr = 0x63,
> +			.freq_offset = -300,
> +			.lpf = 1,
> +		}
> +	},
> +	{
> +		.demod_cfg = {
> +			.addr = 0x10,
> +		},
> +		.tuner_cfg.mxl301rf = {
> +			.addr = 0x62,
> +			.init_freq = 515142857,
> +		}
> +	},
> +	{
> +		.demod_cfg = {
> +			.addr = 0x13,
> +		},
> +		.tuner_cfg.qm1d1c0042 = {
> +			.addr = 0x60,
> +			.freq_offset = 300,
> +			.lpf = 1,
> +		}
> +	},
> +	{
> +		.demod_cfg = {
> +			.addr = 0x12,
> +		},
> +		.tuner_cfg.mxl301rf = {
> +			.addr = 0x61,
> +			.init_freq = 521142857,
> +		}
> +	},
> +};
> +
> +struct reg_val {
> +	u8 reg;
> +	u8 val;
> +};
> +
> +
> +static int
> +pt3_demod_write(struct pt3_adapter *adap, const struct reg_val *data, int num)
> +{
> +	struct pt3_board *pt3;
> +	struct i2c_msg msg;
> +	u8 wbuf[2];
> +	int i, ret;
> +
> +	ret = 0;
> +	pt3 = adap->dvb_adap.priv;
> +	msg.addr = adap_conf[adap->adap_idx].demod_cfg.addr;
> +	msg.flags = 0;
> +	msg.buf = wbuf;
> +	msg.len = 2;
> +	for (i = 0; i < num; i++) {
> +		wbuf[0] = data[i].reg;
> +		wbuf[1] = data[i].val;
> +		ret = i2c_transfer(&pt3->i2c_adap, &msg, 1);
> +		if (ret < 0)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static inline void pt3_lnb_ctrl(struct pt3_board *pt3, bool on)
> +{
> +	iowrite32((on ? 0x0f : 0x0c), pt3->regs[0] + REG_SYSTEM_W);
> +}
> +
> +static inline struct pt3_adapter *pt3_find_adapter(struct dvb_frontend *fe)
> +{
> +	struct pt3_board *pt3;
> +	int i;
> +
> +	if (one_adapter) {
> +		pt3 = fe->dvb->priv;
> +		for (i = 0; i < PT3_NUM_FE; i++)
> +			if (pt3->adaps[i]->fe == fe)
> +				return pt3->adaps[i];
> +	}
> +	return container_of(fe->dvb, struct pt3_adapter, dvb_adap);
> +}
> +
> +/*
> + * all 4 tuners in PT3 are packaged in a can module (Sharp VA4M6JC2103).
> + * it seems that they share the power lines and Amp power line and
> + * adaps[3] controls those powers.
> + */
> +static int
> +pt3_set_tuner_power(struct pt3_board *pt3, bool tuner_on, bool amp_on)
> +{
> +	struct reg_val reg = { 0x1e, 0x99 };
> +
> +	if (tuner_on)
> +		reg.val |= 0x40;
> +	if (amp_on)
> +		reg.val |= 0x04;
> +	return pt3_demod_write(pt3->adaps[PT3_NUM_FE - 1], &reg, 1);
> +}
> +
> +
> +static int pt3_fe_callback_s(void *priv, int component, int cmd, int arg);
> +static int pt3_fe_callback_t(void *priv, int component, int cmd, int arg);
> +
> +/*
> + * pt3_fe_init: initialize demod sub modules and ISDB-T tuners all at once.
> + *
> + * As for demod IC (TC90522) and ISDB-T tuners (MxL301RF),
> + * the i2c sequences for init'ing them are not public and hidden in a ROM,
> + * and include the board specific configurations as well.
> + * They are stored in a lump and cannot be taken out / accessed separately,
> + * thus cannot be moved to the FE/tuner driver.
> + */
> +static int pt3_fe_init(struct pt3_board *pt3)
> +{
> +	static const struct reg_val init0_sat[] = {
> +		{ 0x03, 0x01 },
> +		{ 0x1e, 0x10 },
> +	};
> +	static const struct reg_val init0_ter[] = {
> +		{ 0x01, 0x40 },
> +		{ 0x1c, 0x10 },
> +	};
> +	static const struct reg_val cfg_sat[] = {
> +		{ 0x1c, 0x15 },
> +		{ 0x1f, 0x04 },
> +	};
> +	static const struct reg_val cfg_ter[] = {
> +		{ 0x1d, 0x01 },
> +	};
> +	int i, ret;
> +	struct dvb_frontend *fe;
> +
> +	pt3_i2c_reset(pt3);
> +	ret = pt3_init_all_demods(pt3);
> +	if (ret < 0)
> +		goto failed;
> +
> +	/* additional config? */
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		fe = pt3->adaps[i]->fe;
> +		/* temporary disable the callback */
> +		fe->callback = NULL;
> +
> +		if (pt3->adaps[i]->fe->ops.delsys[0] == SYS_ISDBS)
> +			ret = pt3_demod_write(pt3->adaps[i], init0_sat,
> +						ARRAY_SIZE(init0_sat));
> +		else
> +			ret = pt3_demod_write(pt3->adaps[i], init0_ter,
> +						ARRAY_SIZE(init0_ter));
> +		if (ret < 0)
> +			goto failed;
> +		fe->ops.init(fe);
> +	}
> +
> +	usleep_range(2000, 4000);
> +	ret = pt3_set_tuner_power(pt3, true, false);
> +	if (ret < 0)
> +		goto failed;
> +
> +	/* output pin configuration */
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		fe = pt3->adaps[i]->fe;
> +		if (pt3->adaps[i]->fe->ops.delsys[0] == SYS_ISDBS)
> +			ret = pt3_demod_write(pt3->adaps[i], cfg_sat,
> +						ARRAY_SIZE(cfg_sat));
> +		else
> +			ret = pt3_demod_write(pt3->adaps[i], cfg_ter,
> +						ARRAY_SIZE(cfg_ter));
> +		if (ret < 0)
> +			goto failed;
> +	}
> +	usleep_range(4000, 6000);
> +
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		fe = pt3->adaps[i]->fe;
> +		if (fe->ops.delsys[0] != SYS_ISDBS)
> +			continue;
> +		/* init and wake-up ISDB-S tuners */
> +		/* no initial tuning here */
> +		ret = fe->ops.tuner_ops.init(fe);
> +		if (ret < 0)
> +			goto failed;
> +	}
> +	ret = pt3_init_all_mxl301rf(pt3);
> +	if (ret < 0)
> +		goto failed;
> +
> +	ret = pt3_set_tuner_power(pt3, true, true);
> +	if (ret < 0)
> +		goto failed;
> +
> +	/* Wake up all tuners and/or make an initial tuning,
> +	 * in order to avoid interference among the tuners in the module,
> +	 * according to the doc from the manufacturer.
> +	 */
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		fe = pt3->adaps[i]->fe;
> +		if (fe->ops.delsys[0] == SYS_ISDBS) {
> +			fe->dtv_property_cache.frequency = 1049480 +
> +				adap_conf[i].tuner_cfg.qm1d1c0042.freq_offset;
> +			ret = fe->ops.tuner_ops.set_params(fe);
> +		} else
> +			ret = fe->ops.tuner_ops.init(fe);
> +		if (ret < 0)
> +			goto failed;
> +	}
> +
> +	/* and sleep again, waiting to be opened by users. */
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		fe = pt3->adaps[i]->fe;
> +		if (fe->ops.tuner_ops.sleep)
> +			ret = fe->ops.tuner_ops.sleep(fe);
> +		if (ret < 0)
> +			goto failed;
> +		if (fe->ops.sleep)
> +			ret = fe->ops.sleep(fe);
> +		if (ret < 0)
> +			goto failed;
> +		fe->callback = (fe->ops.delsys[0] == SYS_ISDBS) ?
> +				pt3_fe_callback_s : pt3_fe_callback_t;
> +	}
> +	return ret;
> +
> +failed:
> +	dev_warn(&pt3->pdev->dev, "Failed to init the tuner module.\n");
> +	return ret;
> +}
> +
> +/*  callback functions to control the shared resources:
> + *      LNB, tuner CAN module's power and LNA.
> + */
> +static int pt3_fe_callback_t(void *priv, int component, int cmd, int arg)
> +{
> +	struct pt3_adapter *adap;
> +	struct pt3_board *pt3;
> +	int ret;
> +
> +	adap = pt3_find_adapter(priv);
> +	switch (component) {
> +	case DVB_FRONTEND_COMPONENT_DEMOD:
> +		switch (cmd) {
> +		case TC90522T_CMD_SET_LNA:
> +			/* LNA is shared btw. 2 TERR-tuners */
> +			pt3 = adap->dvb_adap.priv;
> +			if (mutex_lock_interruptible(&pt3->lock))
> +				return -ERESTARTSYS;
> +			if (arg)
> +				pt3->lna_on_cnt++;
> +			else
> +				pt3->lna_on_cnt--;
> +
> +			if (arg && pt3->lna_on_cnt <= 1) {
> +				pt3->lna_on_cnt = 1;
> +				ret = pt3_set_tuner_power(pt3, true, true);
> +			} else if (!arg && pt3->lna_on_cnt <= 0) {
> +				pt3->lna_on_cnt = 0;
> +				ret = pt3_set_tuner_power(pt3, true, false);
> +			} else
> +				ret = 0;
> +			mutex_unlock(&pt3->lock);
> +			return ret;
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int pt3_fe_callback_s(void *priv, int component, int cmd, int arg)
> +{
> +	struct pt3_adapter *adap;
> +	struct pt3_board *pt3;
> +	bool on;
> +
> +	adap = pt3_find_adapter(priv);
> +	switch (component) {
> +	case DVB_FRONTEND_COMPONENT_DEMOD:
> +		switch (cmd) {
> +		case TC90522S_CMD_SET_LNB:
> +			/* LNB power is shared btw. 2 SAT-tuners */
> +			on = (arg != SEC_VOLTAGE_OFF);
> +			if (on == adap->cur_lnb)
> +				return 0;
> +			adap->cur_lnb = on;
> +			pt3 = adap->dvb_adap.priv;
> +			if (mutex_lock_interruptible(&pt3->lock))
> +				return -ERESTARTSYS;
> +			if (on)
> +				pt3->lnb_on_cnt++;
> +			else
> +				pt3->lnb_on_cnt--;
> +
> +			if (on && pt3->lnb_on_cnt <= 1) {
> +				pt3->lnb_on_cnt = 1;
> +				pt3_lnb_ctrl(pt3, 1);
> +			} else if (!on && pt3->lnb_on_cnt <= 0) {
> +				pt3->lnb_on_cnt = 0;
> +				pt3_lnb_ctrl(pt3, 0);
> +			}
> +			mutex_unlock(&pt3->lock);
> +			return 0;
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
> +
> +static int pt3_attach_fe(struct pt3_board *pt3, struct i2c_adapter *i2c, int i)
> +{
> +	struct dvb_frontend *fe;
> +	struct i2c_adapter *tuner_i2c;
> +	struct dvb_adapter *dvb_adap;
> +	void *ret;
> +
> +	fe = dvb_attach(tc90522_attach, &adap_conf[i].demod_cfg, i2c);
> +	if (!fe)
> +		return -ENOMEM;
> +	pt3->adaps[i]->fe = fe;
> +
> +	tuner_i2c = tc90522_get_tuner_i2c(fe);
> +	if (TC90522_IS_ISDBS(adap_conf[i].demod_cfg.addr)) {
> +		fe->callback = &pt3_fe_callback_s;
> +		ret = dvb_attach(qm1d1c0042_attach, fe, tuner_i2c,
> +				&adap_conf[i].tuner_cfg.qm1d1c0042);
> +	} else {
> +		fe->callback = &pt3_fe_callback_t;
> +		ret = dvb_attach(mxl301rf_attach, fe, tuner_i2c,
> +				&adap_conf[i].tuner_cfg.mxl301rf);
> +	}
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
> +	return dvb_register_frontend(dvb_adap, fe);
> +}
> +
> +
> +static int pt3_fetch_thread(void *data)
> +{
> +	struct pt3_adapter *adap = data;
> +
> +#define PT3_FETCH_DELAY (10 * 1000)
> +#define PT3_INITIAL_DISCARD_BUFS 4
> +
> +	pt3_init_dmabuf(adap);
> +	adap->num_discard = PT3_INITIAL_DISCARD_BUFS;
> +
> +	dev_dbg(adap->dvb_adap.device,
> +		"PT3: [%s] started.\n", adap->thread->comm);
> +	while (!kthread_should_stop()) {
> +		pt3_proc_dma(adap);
> +		usleep_range(PT3_FETCH_DELAY, PT3_FETCH_DELAY + 2000);
> +	}
> +	dev_dbg(adap->dvb_adap.device,
> +		"PT3: [%s] exited.\n", adap->thread->comm);
> +	adap->thread = NULL;
> +	return 0;
> +}

Why do you need a thread here? Having a thread requires some special
care, as you need to delete it before suspend, restore at resume
(if active) and be sure that it was killed at device removal.

I'm not seeing any of those things on this driver.

> +
> +static int pt3_start_streaming(struct pt3_adapter *adap)
> +{
> +	struct task_struct *thread;
> +
> +	/* start fetching thread */
> +	thread = kthread_run(pt3_fetch_thread, adap, "pt3-ad%i-dmx%i",
> +				adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> +	if (IS_ERR(thread)) {
> +		int ret = PTR_ERR(thread);
> +
> +		dev_warn(adap->dvb_adap.device,
> +			"PT3 (adap:%d, dmx:%d): failed to start kthread.\n",
> +			adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> +		return ret;
> +	}
> +	adap->thread = thread;
> +
> +	return pt3_start_dma(adap);
> +}
> +
> +static int pt3_stop_streaming(struct pt3_adapter *adap)
> +{
> +	int ret;
> +
> +	ret = pt3_stop_dma(adap);
> +	if (ret)
> +		dev_warn(adap->dvb_adap.device,
> +			"PT3: failed to stop streaming of adap:%d/FE:%d\n",
> +			adap->dvb_adap.num, adap->fe->id);
> +
> +	/* kill the fetching thread */
> +	ret = kthread_stop(adap->thread);
> +	/* paranoia check in case a signal arrived */
> +	if (adap->thread)
> +		dev_warn(adap->dvb_adap.device,
> +			"PT3(%s): thread %s won't exit\n",
> +			__func__, adap->thread->comm);
> +	return ret;
> +}
> +
> +static int pt3_start_feed(struct dvb_demux_feed *feed)
> +{
> +	struct pt3_adapter *adap;
> +
> +	if (signal_pending(current))
> +		return -EINTR;
> +
> +	adap = container_of(feed->demux, struct pt3_adapter, demux);
> +	adap->num_feeds++;
> +	if (adap->thread)
> +		return 0;
> +	if (adap->num_feeds != 1) {
> +		dev_warn(adap->dvb_adap.device,
> +			"%s: unmatched start/stop_feed in adap:%i/dmx:%i.\n",
> +			__func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> +		adap->num_feeds = 1;
> +	}
> +
> +	return pt3_start_streaming(adap);
> +
> +}
> +
> +static int pt3_stop_feed(struct dvb_demux_feed *feed)
> +{
> +	struct pt3_adapter *adap;
> +
> +	adap = container_of(feed->demux, struct pt3_adapter, demux);
> +
> +	adap->num_feeds--;
> +	if (adap->num_feeds > 0 || !adap->thread)
> +		return 0;
> +	adap->num_feeds = 0;
> +
> +	return pt3_stop_streaming(adap);
> +}
> +
> +
> +static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
> +{
> +	int ret;
> +	struct pt3_adapter *adap;
> +	struct dvb_adapter *da;
> +
> +	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
> +	if (!adap) {
> +		dev_err(&pt3->pdev->dev, "(%s) Out of memory.\n", __func__);
> +		return -ENOMEM;
> +	}
> +	pt3->adaps[index] = adap;
> +	adap->adap_idx = index;
> +
> +	if (index == 0 || !one_adapter) {
> +		ret = dvb_register_adapter(&adap->dvb_adap, "PT3 DVB",
> +				THIS_MODULE, &pt3->pdev->dev, adapter_nr);
> +		if (ret < 0) {
> +			dev_err(&pt3->pdev->dev,
> +				"failed to register adapter dev.\n");
> +			goto err_mem;
> +		}
> +		da = &adap->dvb_adap;
> +	} else
> +		da = &pt3->adaps[0]->dvb_adap;
> +
> +	adap->dvb_adap.priv = pt3;
> +	adap->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
> +	adap->demux.priv = adap;
> +	adap->demux.feednum = 256;
> +	adap->demux.filternum = 256;
> +	adap->demux.start_feed = pt3_start_feed;
> +	adap->demux.stop_feed = pt3_stop_feed;
> +	ret = dvb_dmx_init(&adap->demux);
> +	if (ret < 0) {
> +		dev_err(&pt3->pdev->dev, "failed to init dmx dev.\n");
> +		goto err_adap;
> +	}
> +
> +	adap->dmxdev.filternum = 256;
> +	adap->dmxdev.demux = &adap->demux.dmx;
> +	ret = dvb_dmxdev_init(&adap->dmxdev, da);
> +	if (ret < 0) {
> +		dev_err(&pt3->pdev->dev, "failed to init dmxdev.\n");
> +		goto err_demux;
> +	}
> +
> +	ret = pt3_alloc_dmabuf(adap);
> +	if (ret) {
> +		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers.\n");
> +		goto err_dmabuf;
> +	}
> +
> +	return 0;
> +
> +err_dmabuf:
> +	pt3_free_dmabuf(adap);
> +	dvb_dmxdev_release(&adap->dmxdev);
> +err_demux:
> +	dvb_dmx_release(&adap->demux);
> +err_adap:
> +	if (index == 0 || !one_adapter)
> +		dvb_unregister_adapter(da);
> +err_mem:
> +	kfree(adap);
> +	pt3->adaps[index] = NULL;
> +	return ret;
> +}
> +
> +static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
> +{
> +	struct pt3_adapter *adap;
> +	struct dmx_demux *dmx;
> +
> +	adap = pt3->adaps[index];
> +	if (adap == NULL)
> +		return;
> +
> +	/* stop demux kthread */
> +
> +	dmx = &adap->demux.dmx;
> +	dmx->close(dmx);
> +	if (adap->fe) {
> +		adap->fe->callback = NULL;
> +		if (adap->fe->frontend_priv)
> +			dvb_unregister_frontend(adap->fe);
> +		dvb_frontend_detach(adap->fe);
> +	}
> +	pt3_free_dmabuf(adap);
> +	dvb_dmxdev_release(&adap->dmxdev);
> +	dvb_dmx_release(&adap->demux);
> +	if (index == 0 || !one_adapter)
> +		dvb_unregister_adapter(&adap->dvb_adap);
> +	kfree(adap);
> +	pt3->adaps[index] = NULL;
> +}
> +
> +static void pt3_remove(struct pci_dev *pdev)
> +{
> +	struct pt3_board *pt3;
> +	int i;
> +
> +	pt3 = pci_get_drvdata(pdev);
> +	for (i = PT3_NUM_FE - 1; i >= 0; i--)
> +		pt3_cleanup_adapter(pt3, i);
> +	i2c_del_adapter(&pt3->i2c_adap);
> +	kfree(pt3->i2c_buf);
> +	pci_iounmap(pt3->pdev, pt3->regs[0]);
> +	pci_iounmap(pt3->pdev, pt3->regs[1]);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	kfree(pt3);
> +}
> +
> +static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	u8 rev;
> +	u32 ver;
> +	int i, ret;
> +	struct pt3_board *pt3;
> +	struct i2c_adapter *i2c;
> +
> +	if (pci_read_config_byte(pdev, PCI_REVISION_ID, &rev) || rev != 1)
> +		return -ENODEV;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret < 0)
> +		return -ENODEV;
> +	pci_set_master(pdev);
> +
> +	ret = pci_request_regions(pdev, DRV_NAME);
> +	if (ret < 0)
> +		goto err_disable_device;
> +
> +	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret == 0)
> +		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
> +	else {
> +		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +		if (ret == 0)
> +			dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +		else {
> +			dev_err(&pdev->dev, "Failed to set DMA mask.\n");
> +			goto err_release_regions;
> +		}
> +		dev_info(&pdev->dev, "Use 32bit DMA.\n");
> +	}
> +
> +	pt3 = kzalloc(sizeof(*pt3), GFP_KERNEL);
> +	if (!pt3) {
> +		dev_err(&pdev->dev, "(%s): Out of Memory.\n", __func__);
> +		ret = -ENOMEM;
> +		goto err_release_regions;
> +	}
> +	pci_set_drvdata(pdev, pt3);
> +	pt3->pdev = pdev;
> +	mutex_init(&pt3->lock);
> +	pt3->regs[0] = pci_ioremap_bar(pdev, 0);
> +	pt3->regs[1] = pci_ioremap_bar(pdev, 2);
> +	if (pt3->regs[0] == NULL || pt3->regs[1] == NULL) {
> +		dev_err(&pdev->dev, "Failed to ioremap.\n");
> +		ret = -ENOMEM;
> +		goto err_kfree;
> +	}
> +
> +	ver = ioread32(pt3->regs[0] + REG_VERSION);
> +	if ((ver >> 16) != 0x0301) {
> +		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported",
> +			ver >> 24, (ver & 0x00ff0000) >> 16);
> +		ret = -ENODEV;
> +		goto err_iounmap;
> +	}
> +
> +	pt3->num_bufs = clamp_val(num_bufs, MIN_DATA_BUFS, MAX_DATA_BUFS);
> +
> +	pt3->i2c_buf = kmalloc(sizeof(*pt3->i2c_buf), GFP_KERNEL);
> +	if (pt3->i2c_buf == NULL) {
> +		dev_err(&pdev->dev, "(%s): Out of Memory.\n", __func__);
> +		ret = -ENOMEM;
> +		goto err_iounmap;
> +	}
> +	i2c = &pt3->i2c_adap;
> +	i2c->owner = THIS_MODULE;
> +	i2c->algo = &pt3_i2c_algo;
> +	i2c->algo_data = NULL;
> +	i2c->dev.parent = &pdev->dev;
> +	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
> +	i2c_set_adapdata(i2c, pt3);
> +	ret = i2c_add_adapter(i2c);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to add i2c adapter.\n");
> +		goto err_i2cbuf;
> +	}
> +
> +	for (i = 0; i < PT3_NUM_FE; i++) {
> +		ret = pt3_alloc_adapter(pt3, i);
> +		if (ret < 0)
> +			break;
> +
> +		ret = pt3_attach_fe(pt3, i2c, i);
> +		if (ret < 0)
> +			break;
> +	}
> +	if (i < PT3_NUM_FE) {
> +		dev_err(&pdev->dev, "Failed to create FE%d.\n", i);
> +		goto err_cleanup_adapters;
> +	}
> +
> +	ret = pt3_fe_init(pt3);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to init frontends.\n");
> +		i = PT3_NUM_FE - 1;
> +		goto err_cleanup_adapters;
> +	}
> +
> +	dev_info(&pdev->dev,
> +		"successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x).\n",
> +		ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
> +	return 0;
> +
> +err_cleanup_adapters:
> +	while (i)
> +		pt3_cleanup_adapter(pt3, i--);
> +	i2c_del_adapter(i2c);
> +err_i2cbuf:
> +	kfree(pt3->i2c_buf);
> +err_iounmap:
> +	if (pt3->regs[0])
> +		pci_iounmap(pdev, pt3->regs[0]);
> +	if (pt3->regs[1])
> +		pci_iounmap(pdev, pt3->regs[1]);
> +err_kfree:
> +	kfree(pt3);
> +err_release_regions:
> +	pci_release_regions(pdev);
> +err_disable_device:
> +	pci_disable_device(pdev);
> +	return ret;
> +
> +}
> +
> +static const struct pci_device_id pt3_id_table[] = {
> +	{ PCI_DEVICE_SUB(0x1172, 0x4c15, 0xee8d, 0x0368) },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(pci, pt3_id_table);
> +
> +static struct pci_driver pt3_driver = {
> +	.name		= DRV_NAME,
> +	.probe		= pt3_probe,
> +	.remove	= pt3_remove,
> +	.id_table	= pt3_id_table,
> +};
> +
> +module_pci_driver(pt3_driver);
> +
> +MODULE_DESCRIPTION("Earthsoft PT3 Driver");
> +MODULE_AUTHOR("Akihiro TSUKADA");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
> new file mode 100644
> index 0000000..cd7821d
> --- /dev/null
> +++ b/drivers/media/pci/pt3/pt3.h
> @@ -0,0 +1,179 @@
> +/*
> + * Earthsoft PT3 driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef PT3_H
> +#define PT3_H
> +
> +#include <linux/atomic.h>
> +#include <linux/types.h>
> +
> +#include "dvb_demux.h"
> +#include "dvb_frontend.h"
> +#include "dmxdev.h"
> +
> +#include "tc90522.h"
> +#include "mxl301rf.h"
> +#include "qm1d1c0042.h"
> +
> +#define DRV_NAME KBUILD_MODNAME
> +
> +#define PT3_NUM_FE 4
> +
> +/*
> + * register index of the FPGA chip
> + */
> +#define REG_VERSION	0x00
> +#define REG_BUS		0x04
> +#define REG_SYSTEM_W	0x08
> +#define REG_SYSTEM_R	0x0c
> +#define REG_I2C_W	0x10
> +#define REG_I2C_R	0x14
> +#define REG_RAM_W	0x18
> +#define REG_RAM_R	0x1c
> +#define REG_DMA_BASE	0x40	/* regs for FE[i] = REG_DMA_BASE + 0x18 * i */
> +#define OFST_DMA_DESC_L	0x00
> +#define OFST_DMA_DESC_H	0x04
> +#define OFST_DMA_CTL	0x08
> +#define OFST_TS_CTL	0x0c
> +#define OFST_STATUS	0x10
> +#define OFST_TS_ERR	0x14
> +
> +/*
> + * internal buffer for I2C
> + */
> +#define PT3_I2C_MAX 4091
> +struct pt3_i2cbuf {
> +	u8  data[PT3_I2C_MAX];
> +	u8  tmp;
> +	u32 num_cmds;
> +};
> +
> +/*
> + * DMA things
> + */
> +#define TS_PACKET_SZ  188
> +/* DMA transfers must not cross 4GiB, so use one page / transfer */
> +#define DATA_XFER_SZ   4096
> +#define DATA_BUF_XFERS 47
> +/* (num_bufs * DATA_BUF_SZ) % TS_PACKET_SZ must be 0 */
> +#define DATA_BUF_SZ    (DATA_BUF_XFERS * DATA_XFER_SZ)
> +#define MAX_DATA_BUFS  16
> +#define MIN_DATA_BUFS   2
> +
> +#define DESCS_IN_PAGE (PAGE_SIZE / sizeof(struct xfer_desc))
> +#define MAX_NUM_XFERS (MAX_DATA_BUFS * DATA_BUF_XFERS)
> +#define MAX_DESC_BUFS DIV_ROUND_UP(MAX_NUM_XFERS, DESCS_IN_PAGE)
> +
> +/* DMA transfer description.
> + * device is passed a pointer to this struct, dma-reads it,
> + * and gets the DMA buffer ring for storing TS data.
> + */
> +struct xfer_desc {
> +	u32 addr_l; /* bus address of target data buffer */
> +	u32 addr_h;
> +	u32 size;
> +	u32 next_l; /* bus adddress of the next xfer_desc */
> +	u32 next_h;
> +};
> +
> +/* A DMA mapping of a page containing xfer_desc's */
> +struct xfer_desc_buffer {
> +	dma_addr_t b_addr;
> +	struct xfer_desc *descs; /* PAGE_SIZE (xfer_desc[DESCS_IN_PAGE]) */
> +};
> +
> +/* A DMA mapping of a data buffer */
> +struct dma_data_buffer {
> +	dma_addr_t b_addr;
> +	u8 *data; /* size: u8[PAGE_SIZE] */
> +};
> +
> +/*
> + * device things
> + */
> +struct pt3_adap_config {
> +	struct tc90522_config demod_cfg;
> +	union tuner_config {
> +		struct qm1d1c0042_config qm1d1c0042;
> +		struct mxl301rf_config   mxl301rf;
> +	} tuner_cfg;
> +};
> +
> +struct pt3_adapter {
> +	struct dvb_adapter  dvb_adap;  /* dvb_adap.priv => struct pt3_board */
> +	int adap_idx;
> +
> +	struct dvb_demux    demux;
> +	struct dmxdev       dmxdev;
> +	struct dvb_frontend *fe;
> +
> +	/* data fetch thread */
> +	struct task_struct *thread;
> +	int num_feeds;
> +
> +	bool cur_lnb; /* current LNB power status (on/off) */
> +
> +	/* items below are for DMA */
> +	struct dma_data_buffer buffer[MAX_DATA_BUFS];
> +	int buf_idx;
> +	int buf_ofs;
> +	int num_bufs;  /* == pt3_board->num_bufs */
> +	int num_discard; /* how many access units to discard initially */
> +
> +	struct xfer_desc_buffer desc_buf[MAX_DESC_BUFS];
> +	int num_desc_bufs;  /* == num_bufs * DATA_BUF_XFERS / DESCS_IN_PAGE */
> +};
> +
> +
> +struct pt3_board {
> +	struct pci_dev *pdev;
> +	void __iomem *regs[2];
> +	/* regs[0]: registers, regs[1]: internal memory, used for I2C */
> +
> +	struct mutex lock;
> +
> +	/* LNB power shared among sat-FEs */
> +	int lnb_on_cnt; /* LNB power on count */
> +
> +	/* LNA shared among terr-FEs */
> +	int lna_on_cnt; /* booster enabled count */
> +
> +	int num_bufs;  /* number of DMA buffers allocated/mapped per FE */
> +
> +	struct i2c_adapter i2c_adap;
> +	struct pt3_i2cbuf *i2c_buf;
> +
> +	struct pt3_adapter *adaps[PT3_NUM_FE];
> +};
> +
> +
> +/*
> + * prototypes
> + */
> +extern int  pt3_alloc_dmabuf(struct pt3_adapter *adap);
> +extern void pt3_init_dmabuf(struct pt3_adapter *adap);
> +extern void pt3_free_dmabuf(struct pt3_adapter *adap);
> +extern int  pt3_start_dma(struct pt3_adapter *adap);
> +extern int  pt3_stop_dma(struct pt3_adapter *adap);
> +extern int  pt3_proc_dma(struct pt3_adapter *adap);
> +
> +extern int  pt3_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
> +	int num);
> +extern u32  pt3_i2c_functionality(struct i2c_adapter *adap);
> +extern void pt3_i2c_reset(struct pt3_board *pt3);
> +extern int  pt3_init_all_demods(struct pt3_board *pt3);
> +extern int  pt3_init_all_mxl301rf(struct pt3_board *pt3);
> +#endif /* PT3_H */
> diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
> new file mode 100644
> index 0000000..f0ce904
> --- /dev/null
> +++ b/drivers/media/pci/pt3/pt3_dma.c
> @@ -0,0 +1,225 @@
> +/*
> + * Earthsoft PT3 driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +
> +#include "pt3.h"
> +
> +#define PT3_ACCESS_UNIT (TS_PACKET_SZ * 128)
> +#define PT3_BUF_CANARY  (0x74)
> +
> +static u32 get_dma_base(int idx)
> +{
> +	int i;
> +
> +	i = (idx == 1 || idx == 2) ? 3 - idx : idx;
> +	return REG_DMA_BASE + 0x18 * i;
> +}
> +
> +int pt3_stop_dma(struct pt3_adapter *adap)
> +{
> +	struct pt3_board *pt3 = adap->dvb_adap.priv;
> +	u32 base;
> +	u32 stat;
> +	int retry;
> +
> +	base = get_dma_base(adap->adap_idx);
> +	stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
> +	if (!(stat & 0x01))
> +		return 0;
> +
> +	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
> +	for (retry = 0; retry < 5; retry++) {
> +		stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
> +		if (!(stat & 0x01))
> +			return 0;
> +		msleep(50);
> +	}
> +	return -EIO;
> +}
> +
> +int pt3_start_dma(struct pt3_adapter *adap)
> +{
> +	struct pt3_board *pt3 = adap->dvb_adap.priv;
> +	u32 base = get_dma_base(adap->adap_idx);
> +
> +	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
> +	iowrite32(lower_32_bits(adap->desc_buf[0].b_addr),
> +			pt3->regs[0] + base + OFST_DMA_DESC_L);
> +	iowrite32(upper_32_bits(adap->desc_buf[0].b_addr),
> +			pt3->regs[0] + base + OFST_DMA_DESC_H);
> +	iowrite32(0x01, pt3->regs[0] + base + OFST_DMA_CTL);
> +	return 0;
> +}
> +
> +
> +static u8 *next_unit(struct pt3_adapter *adap, int *idx, int *ofs)
> +{
> +	*ofs += PT3_ACCESS_UNIT;
> +	if (*ofs >= DATA_BUF_SZ) {
> +		*ofs -= DATA_BUF_SZ;
> +		(*idx)++;
> +		if (*idx == adap->num_bufs)
> +			*idx = 0;
> +	}
> +	return &adap->buffer[*idx].data[*ofs];
> +}
> +
> +int pt3_proc_dma(struct pt3_adapter *adap)
> +{
> +	int idx, ofs;
> +
> +	idx = adap->buf_idx;
> +	ofs = adap->buf_ofs;
> +
> +	if (adap->buffer[idx].data[ofs] == PT3_BUF_CANARY)
> +		return 0;
> +
> +	while (*next_unit(adap, &idx, &ofs) != PT3_BUF_CANARY) {
> +		u8 *p;
> +
> +		p = &adap->buffer[adap->buf_idx].data[adap->buf_ofs];
> +		if (adap->num_discard > 0)
> +			adap->num_discard--;
> +		else if (adap->buf_ofs + PT3_ACCESS_UNIT > DATA_BUF_SZ) {
> +			dvb_dmx_swfilter_packets(&adap->demux, p,
> +				(DATA_BUF_SZ - adap->buf_ofs) / TS_PACKET_SZ);
> +			dvb_dmx_swfilter_packets(&adap->demux,
> +				adap->buffer[idx].data, ofs / TS_PACKET_SZ);
> +		} else
> +			dvb_dmx_swfilter_packets(&adap->demux, p,
> +				PT3_ACCESS_UNIT / TS_PACKET_SZ);
> +
> +		*p = PT3_BUF_CANARY;
> +		adap->buf_idx = idx;
> +		adap->buf_ofs = ofs;
> +	}
> +	return 0;
> +}
> +
> +void pt3_init_dmabuf(struct pt3_adapter *adap)
> +{
> +	int idx, ofs;
> +	u8 *p;
> +
> +	idx = 0;
> +	ofs = 0;
> +	p = adap->buffer[0].data;
> +	/* mark the whole buffers as "not written yet" */
> +	while (idx < adap->num_bufs) {
> +		p[ofs] = PT3_BUF_CANARY;
> +		ofs += PT3_ACCESS_UNIT;
> +		if (ofs >= DATA_BUF_SZ) {
> +			ofs -= DATA_BUF_SZ;
> +			idx++;
> +			p = adap->buffer[idx].data;
> +		}
> +	}
> +	adap->buf_idx = 0;
> +	adap->buf_ofs = 0;
> +}
> +
> +void pt3_free_dmabuf(struct pt3_adapter *adap)
> +{
> +	struct pt3_board *pt3;
> +	int i;
> +
> +	pt3 = adap->dvb_adap.priv;
> +	for (i = 0; i < adap->num_bufs; i++)
> +		dma_free_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
> +			adap->buffer[i].data, adap->buffer[i].b_addr);
> +	adap->num_bufs = 0;
> +
> +	for (i = 0; i < adap->num_desc_bufs; i++)
> +		dma_free_coherent(&pt3->pdev->dev, PAGE_SIZE,
> +			adap->desc_buf[i].descs, adap->desc_buf[i].b_addr);
> +	adap->num_desc_bufs = 0;
> +}
> +
> +
> +int pt3_alloc_dmabuf(struct pt3_adapter *adap)
> +{
> +	struct pt3_board *pt3;
> +	void *p;
> +	int i, j;
> +	int idx, ofs;
> +	int num_desc_bufs;
> +	dma_addr_t data_addr, desc_addr;
> +	struct xfer_desc *d;
> +
> +	pt3 = adap->dvb_adap.priv;
> +	adap->num_bufs = 0;
> +	adap->num_desc_bufs = 0;
> +	for (i = 0; i < pt3->num_bufs; i++) {
> +		p = dma_alloc_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
> +					&adap->buffer[i].b_addr, GFP_KERNEL);
> +		if (p == NULL)
> +			goto failed;
> +		adap->buffer[i].data = p;
> +		adap->num_bufs++;
> +	}
> +	pt3_init_dmabuf(adap);
> +
> +	/* build circular-linked pointers (xfer_desc) to the data buffers*/
> +	idx = 0;
> +	ofs = 0;
> +	num_desc_bufs =
> +		DIV_ROUND_UP(adap->num_bufs * DATA_BUF_XFERS, DESCS_IN_PAGE);
> +	for (i = 0; i < num_desc_bufs; i++) {
> +		p = dma_alloc_coherent(&pt3->pdev->dev, PAGE_SIZE,
> +					&desc_addr, GFP_KERNEL);
> +		if (p == NULL)
> +			goto failed;
> +		adap->num_desc_bufs++;
> +		adap->desc_buf[i].descs = p;
> +		adap->desc_buf[i].b_addr = desc_addr;
> +
> +		if (i > 0) {
> +			d = &adap->desc_buf[i - 1].descs[DESCS_IN_PAGE - 1];
> +			d->next_l = lower_32_bits(desc_addr);
> +			d->next_h = upper_32_bits(desc_addr);
> +		}
> +		for (j = 0; j < DESCS_IN_PAGE; j++) {
> +			data_addr = adap->buffer[idx].b_addr + ofs;
> +			d = &adap->desc_buf[i].descs[j];
> +			d->addr_l = lower_32_bits(data_addr);
> +			d->addr_h = upper_32_bits(data_addr);
> +			d->size = DATA_XFER_SZ;
> +
> +			desc_addr += sizeof(struct xfer_desc);
> +			d->next_l = lower_32_bits(desc_addr);
> +			d->next_h = upper_32_bits(desc_addr);
> +
> +			ofs += DATA_XFER_SZ;
> +			if (ofs >= DATA_BUF_SZ) {
> +				ofs -= DATA_BUF_SZ;
> +				idx++;
> +				if (idx >= adap->num_bufs) {
> +					desc_addr = adap->desc_buf[0].b_addr;
> +					d->next_l = lower_32_bits(desc_addr);
> +					d->next_h = upper_32_bits(desc_addr);
> +					return 0;
> +				}
> +			}
> +		}
> +	}
> +	return 0;
> +
> +failed:
> +	pt3_free_dmabuf(adap);
> +	return -ENOMEM;
> +}
> diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
> new file mode 100644
> index 0000000..c66ddef
> --- /dev/null
> +++ b/drivers/media/pci/pt3/pt3_i2c.c
> @@ -0,0 +1,239 @@
> +/*
> + * Earthsoft PT3 driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/i2c.h>
> +#include <linux/io.h>
> +#include <linux/pci.h>
> +
> +#include "pt3.h"
> +
> +#define PT3_I2C_BASE  2048
> +#define PT3_CMD_ADDR_NORMAL 0
> +#define PT3_CMD_ADDR_INIT_DEMOD  4096
> +#define PT3_CMD_ADDR_INIT_TUNER  (4096 + 2042)
> +
> +/* masks for I2C status register */
> +#define STAT_SEQ_RUNNING 0x1
> +#define STAT_SEQ_ERROR   0x6
> +#define STAT_NO_SEQ      0x8
> +
> +#define PT3_I2C_RUN   (1 << 16)
> +#define PT3_I2C_RESET (1 << 17)
> +
> +enum ctl_cmd {
> +	I_END,
> +	I_ADDRESS,
> +	I_CLOCK_L,
> +	I_CLOCK_H,
> +	I_DATA_L,
> +	I_DATA_H,
> +	I_RESET,
> +	I_SLEEP,
> +	I_DATA_L_NOP  = 0x08,
> +	I_DATA_H_NOP  = 0x0c,
> +	I_DATA_H_READ = 0x0d,
> +	I_DATA_H_ACK0 = 0x0e,
> +	I_DATA_H_ACK1 = 0x0f,
> +};
> +
> +
> +static void cmdbuf_add(struct pt3_i2cbuf *cbuf, enum ctl_cmd cmd)
> +{
> +	int buf_idx;
> +
> +	if ((cbuf->num_cmds % 2) == 0)
> +		cbuf->tmp = cmd;
> +	else {
> +		cbuf->tmp |= cmd << 4;
> +		buf_idx = cbuf->num_cmds / 2;
> +		if (buf_idx < ARRAY_SIZE(cbuf->data))
> +			cbuf->data[buf_idx] = cbuf->tmp;
> +	}
> +	cbuf->num_cmds++;
> +}
> +
> +static void put_end(struct pt3_i2cbuf *cbuf)
> +{
> +	cmdbuf_add(cbuf, I_END);
> +	if (cbuf->num_cmds % 2)
> +		cmdbuf_add(cbuf, I_END);
> +}
> +
> +static void put_start(struct pt3_i2cbuf *cbuf)
> +{
> +	cmdbuf_add(cbuf, I_DATA_H);
> +	cmdbuf_add(cbuf, I_CLOCK_H);
> +	cmdbuf_add(cbuf, I_DATA_L);
> +	cmdbuf_add(cbuf, I_CLOCK_L);
> +}
> +
> +static void put_byte_write(struct pt3_i2cbuf *cbuf, u8 val)
> +{
> +	u8 mask;
> +
> +	mask = 0x80;
> +	for (mask = 0x80; mask > 0; mask >>= 1)
> +		cmdbuf_add(cbuf, (val & mask) ? I_DATA_H_NOP : I_DATA_L_NOP);
> +	cmdbuf_add(cbuf, I_DATA_H_ACK0);
> +}
> +
> +static void put_byte_read(struct pt3_i2cbuf *cbuf, u32 size)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < size; i++) {
> +		for (j = 0; j < 8; j++)
> +			cmdbuf_add(cbuf, I_DATA_H_READ);
> +		cmdbuf_add(cbuf, (i == size - 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
> +	}
> +}
> +
> +static void put_stop(struct pt3_i2cbuf *cbuf)
> +{
> +	cmdbuf_add(cbuf, I_DATA_L);
> +	cmdbuf_add(cbuf, I_CLOCK_H);
> +	cmdbuf_add(cbuf, I_DATA_H);
> +}
> +
> +
> +/* translates msgs to internal commands for bit-banging */
> +static void translate(struct pt3_i2cbuf *cbuf, struct i2c_msg *msgs, int num)
> +{
> +	int i, j;
> +	bool rd;
> +
> +	cbuf->num_cmds = 0;
> +	for (i = 0; i < num; i++) {
> +		rd = !!(msgs[i].flags & I2C_M_RD);
> +		put_start(cbuf);
> +		put_byte_write(cbuf, msgs[i].addr << 1 | rd);
> +		if (rd)
> +			put_byte_read(cbuf, msgs[i].len);
> +		else
> +			for (j = 0; j < msgs[i].len; j++)
> +				put_byte_write(cbuf, msgs[i].buf[j]);
> +	}
> +	if (num > 0)
> +		put_stop(cbuf);
> +	put_end(cbuf);
> +}
> +
> +static int wait_i2c_result(struct pt3_board *pt3, u32 *result, int max_wait)
> +{
> +	int i;
> +	u32 v;
> +
> +	for (i = 0; i < max_wait; i++) {
> +		v = ioread32(pt3->regs[0] + REG_I2C_R);
> +		if (!(v & STAT_SEQ_RUNNING))
> +			break;
> +		usleep_range(500, 750);
> +	}
> +	if (i >= max_wait)
> +		return -EIO;
> +	if (result)
> +		*result = v;
> +	return 0;
> +}
> +
> +/* send [pre-]translated i2c msgs stored at addr */
> +static int send_i2c_cmd(struct pt3_board *pt3, u32 addr)
> +{
> +	u32 ret;
> +
> +	/* make sure that previous transactions had finished */
> +	if (wait_i2c_result(pt3, NULL, 50)) {
> +		dev_warn(&pt3->pdev->dev, "(%s) prev. transaction stalled\n",
> +				__func__);
> +		return -EIO;
> +	}
> +
> +	iowrite32(PT3_I2C_RUN | addr, pt3->regs[0] + REG_I2C_W);
> +	usleep_range(200, 300);
> +	/* wait for the current transaction to finish */
> +	if (wait_i2c_result(pt3, &ret, 500) || (ret & STAT_SEQ_ERROR)) {
> +		dev_warn(&pt3->pdev->dev, "(%s) failed.\n", __func__);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +
> +/* init commands for each demod are combined into one transaction
> + *  and hidden in ROM with the address PT3_CMD_ADDR_INIT_DEMOD.
> + */
> +int  pt3_init_all_demods(struct pt3_board *pt3)
> +{
> +	ioread32(pt3->regs[0] + REG_I2C_R);
> +	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_DEMOD);
> +}
> +
> +/* init commands for two ISDB-T tuners are hidden in ROM. */
> +int  pt3_init_all_mxl301rf(struct pt3_board *pt3)
> +{
> +	usleep_range(1000, 2000);
> +	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_TUNER);
> +}
> +
> +void pt3_i2c_reset(struct pt3_board *pt3)
> +{
> +	iowrite32(PT3_I2C_RESET, pt3->regs[0] + REG_I2C_W);
> +}
> +
> +/*
> + * I2C algorithm
> + */
> +int
> +pt3_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> +{
> +	struct pt3_board *pt3;
> +	struct pt3_i2cbuf *cbuf;
> +	int i;
> +	void __iomem *p;
> +
> +	pt3 = i2c_get_adapdata(adap);
> +	cbuf = pt3->i2c_buf;
> +
> +	for (i = 0; i < num; i++)
> +		if (msgs[i].flags & I2C_M_RECV_LEN) {
> +			dev_warn(&pt3->pdev->dev,
> +				"(%s) I2C_M_RECV_LEN not supported.\n",
> +				__func__);
> +			return -EINVAL;
> +		}
> +
> +	translate(cbuf, msgs, num);
> +	memcpy_toio(pt3->regs[1] + PT3_I2C_BASE + PT3_CMD_ADDR_NORMAL / 2,
> +			cbuf->data, cbuf->num_cmds);
> +
> +	if (send_i2c_cmd(pt3, PT3_CMD_ADDR_NORMAL) < 0)
> +		return -EIO;
> +
> +	p = pt3->regs[1] + PT3_I2C_BASE;
> +	for (i = 0; i < num; i++)
> +		if ((msgs[i].flags & I2C_M_RD) && msgs[i].len > 0) {
> +			memcpy_fromio(msgs[i].buf, p, msgs[i].len);
> +			p += msgs[i].len;
> +		}
> +
> +	return 0;
> +}
> +
> +u32 pt3_i2c_functionality(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C;
> +}
