Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35575 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbbENQGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 12:06:33 -0400
Date: Thu, 14 May 2015 13:06:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Dirk Nehring <dnehring@gmx.net>, linux-media@vger.kernel.org,
	Max Nibble <nibble.max@gmail.com>
Subject: Re: [PATCH 1/1] SMI PCIe driver for DVBSky cards
Message-ID: <20150514130627.1e420ff2@recife.lan>
In-Reply-To: <1426201763-10397-1-git-send-email-dnehring@gmx.net>
References: <1426201763-10397-1-git-send-email-dnehring@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Mar 2015 00:09:23 +0100
Dirk Nehring <dnehring@gmx.net> escreveu:

> ported from the manufacturer's source tree, available from
> http://dvbsky.net/download/linux/media_build-bst-150211.tar.gz

The better would be if the author of the remote controller support
to send us the patch or to reply us with his SOB.

Max,

Could you please take care of it?

Thanks!
Mauro

> 
> Signed-off-by: Dirk Nehring <dnehring@gmx.net>
> ---
>  drivers/media/pci/smipcie/Kconfig                  |   1 +
>  drivers/media/pci/smipcie/Makefile                 |   3 +
>  drivers/media/pci/smipcie/smipcie-ir.c             | 233 +++++++++++++++++++++
>  .../pci/smipcie/{smipcie.c => smipcie-main.c}      |  14 +-
>  drivers/media/pci/smipcie/smipcie.h                |  19 ++
>  5 files changed, 269 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/smipcie/smipcie-ir.c
>  rename drivers/media/pci/smipcie/{smipcie.c => smipcie-main.c} (99%)
> 
> diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
> index c8de53f..c24641e 100644
> --- a/drivers/media/pci/smipcie/Kconfig
> +++ b/drivers/media/pci/smipcie/Kconfig
> @@ -7,6 +7,7 @@ config DVB_SMIPCIE
>  	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
>  	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
> +	depends on RC_CORE
>  	help
>  	  Support for cards with SMI PCIe bridge:
>  	  - DVBSky S950 V3
> diff --git a/drivers/media/pci/smipcie/Makefile b/drivers/media/pci/smipcie/Makefile
> index be55481..013bc3f 100644
> --- a/drivers/media/pci/smipcie/Makefile
> +++ b/drivers/media/pci/smipcie/Makefile
> @@ -1,3 +1,6 @@
> +
> +smipcie-objs	:= smipcie-main.o smipcie-ir.o
> +
>  obj-$(CONFIG_DVB_SMIPCIE) += smipcie.o
>  
>  ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
> new file mode 100644
> index 0000000..2a32746
> --- /dev/null
> +++ b/drivers/media/pci/smipcie/smipcie-ir.c
> @@ -0,0 +1,233 @@
> +/*
> + * SMI PCIe driver for DVBSky cards.
> + *
> + * Copyright (C) 2014 Max nibble <nibble.max@gmail.com>
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + */
> +
> +#include "smipcie.h"
> +
> +static void smi_ir_enableInterrupt(struct smi_rc *ir)
> +{
> +	struct smi_dev *dev = ir->dev;
> +
> +	smi_write(MSI_INT_ENA_SET, IR_X_INT);
> +}
> +
> +static void smi_ir_disableInterrupt(struct smi_rc *ir)
> +{
> +	struct smi_dev *dev = ir->dev;
> +
> +	smi_write(MSI_INT_ENA_CLR, IR_X_INT);
> +}
> +
> +static void smi_ir_clearInterrupt(struct smi_rc *ir)
> +{
> +	struct smi_dev *dev = ir->dev;
> +
> +	smi_write(MSI_INT_STATUS_CLR, IR_X_INT);
> +}
> +
> +static void smi_ir_stop(struct smi_rc *ir)
> +{
> +	struct smi_dev *dev = ir->dev;
> +
> +	smi_ir_disableInterrupt(ir);
> +	smi_clear(IR_Init_Reg, 0x80);
> +}
> +
> +#define BITS_PER_COMMAND 14
> +#define GROUPS_PER_BIT	 2
> +#define IR_RC5_MIN_BIT	36
> +#define IR_RC5_MAX_BIT	52
> +static u32 smi_decode_rc5(u8 *pData, u8 size)
> +{
> +	u8 index, current_bit, bit_count;
> +	u8 group_array[BITS_PER_COMMAND * GROUPS_PER_BIT + 4];
> +	u8 group_index = 0;
> +	u32 command = 0xFFFFFFFF;
> +
> +	group_array[group_index++] = 1;
> +
> +	for (index = 0; index < size; index++) {
> +
> +		current_bit = (pData[index] & 0x80) ? 1 : 0;
> +		bit_count = pData[index] & 0x7f;
> +
> +		if ((current_bit == 1) && (bit_count >= 2*IR_RC5_MAX_BIT + 1)) {
> +			goto process_code;
> +		} else if ((bit_count >= IR_RC5_MIN_BIT) &&
> +			   (bit_count <= IR_RC5_MAX_BIT)) {
> +				group_array[group_index++] = current_bit;
> +		} else if ((bit_count > IR_RC5_MAX_BIT) &&
> +			   (bit_count <= 2*IR_RC5_MAX_BIT)) {
> +				group_array[group_index++] = current_bit;
> +				group_array[group_index++] = current_bit;
> +		} else {
> +			goto invalid_timing;
> +		}
> +		if (group_index >= BITS_PER_COMMAND*GROUPS_PER_BIT)
> +			goto process_code;
> +
> +		 if ((group_index == BITS_PER_COMMAND*GROUPS_PER_BIT - 1)
> +			&& (group_array[group_index-1] == 0)) {
> +			group_array[group_index++] = 1;
> +			goto process_code;
> +		}
> +	}
> +
> +process_code:
> +	if (group_index == (BITS_PER_COMMAND*GROUPS_PER_BIT-1))
> +		group_array[group_index++] = 1;
> +
> +	if (group_index == BITS_PER_COMMAND*GROUPS_PER_BIT) {
> +		command = 0;
> +		for (index = 0; index < (BITS_PER_COMMAND*GROUPS_PER_BIT);
> +		     index = index + 2) {
> +			if ((group_array[index] == 1) &&
> +			    (group_array[index+1] == 0)) {
> +				command |= (1 << (BITS_PER_COMMAND -
> +						   (index/2) - 1));
> +			} else if ((group_array[index] == 0) &&
> +				   (group_array[index+1] == 1)) {
> +				/* */
> +
> +			} else {
> +				command = 0xFFFFFFFF;
> +				goto invalid_timing;
> +			}
> +		}
> +	}
> +
> +invalid_timing:
> +	return command;
> +}
> +
> +static void smi_ir_decode(struct work_struct *work)
> +{
> +	struct smi_rc *ir = container_of(work, struct smi_rc, work);
> +	struct smi_dev *dev = ir->dev;
> +	struct rc_dev *rc_dev = ir->rc_dev;
> +	u32 dwIRControl, dwIRData, dwIRCode, scancode;
> +	u8 index, ucIRCount, readLoop, rc5_command, rc5_system, toggle;
> +
> +	dwIRControl = smi_read(IR_Init_Reg);
> +	if (dwIRControl & rbIRVld) {
> +		ucIRCount = (u8) smi_read(IR_Data_Cnt);
> +
> +		if (ucIRCount < 4)
> +			goto end_ir_decode;
> +
> +		readLoop = ucIRCount/4;
> +		if (ucIRCount % 4)
> +			readLoop += 1;
> +		for (index = 0; index < readLoop; index++) {
> +			dwIRData = smi_read(IR_DATA_BUFFER_BASE + (index*4));
> +
> +			ir->irData[index*4 + 0] = (u8)(dwIRData);
> +			ir->irData[index*4 + 1] = (u8)(dwIRData >> 8);
> +			ir->irData[index*4 + 2] = (u8)(dwIRData >> 16);
> +			ir->irData[index*4 + 3] = (u8)(dwIRData >> 24);
> +		}
> +		dwIRCode = smi_decode_rc5(ir->irData, ucIRCount);
> +
> +		if (dwIRCode != 0xFFFFFFFF) {
> +			rc5_command = dwIRCode & 0x3F;
> +			rc5_system = (dwIRCode & 0x7C0) >> 6;
> +			toggle = (dwIRCode & 0x800) ? 1 : 0;
> +			scancode = rc5_system << 8 | rc5_command;
> +			rc_keydown(rc_dev, RC_TYPE_RC5, scancode, toggle);
> +		}
> +	}
> +end_ir_decode:
> +	smi_set(IR_Init_Reg, 0x04);
> +	smi_ir_enableInterrupt(ir);
> +}
> +
> +/* ir functions call by main driver.*/
> +int smi_ir_irq(struct smi_rc *ir, u32 int_status)
> +{
> +	int handled = 0;
> +
> +	if (int_status & IR_X_INT) {
> +		smi_ir_disableInterrupt(ir);
> +		smi_ir_clearInterrupt(ir);
> +		schedule_work(&ir->work);
> +		handled = 1;
> +	}
> +	return handled;
> +}
> +
> +void smi_ir_start(struct smi_rc *ir)
> +{
> +	struct smi_dev *dev = ir->dev;
> +
> +	smi_write(IR_Idle_Cnt_Low, 0x00140070);
> +	msleep(20);
> +	smi_set(IR_Init_Reg, 0x90);
> +
> +	smi_ir_enableInterrupt(ir);
> +}
> +
> +int smi_ir_init(struct smi_dev *dev)
> +{
> +	int ret;
> +	struct rc_dev *rc_dev;
> +	struct smi_rc *ir = &dev->ir;
> +
> +	rc_dev = rc_allocate_device();
> +	if (!rc_dev)
> +		return -ENOMEM;
> +
> +	/* init input device */
> +	snprintf(ir->input_name, sizeof(ir->input_name), "IR (%s)",
> +		 dev->info->name);
> +	snprintf(ir->input_phys, sizeof(ir->input_phys), "pci-%s/ir0",
> +		 pci_name(dev->pci_dev));
> +
> +	rc_dev->driver_name = "SMI_PCIe";
> +	rc_dev->input_phys = ir->input_phys;
> +	rc_dev->input_name = ir->input_name;
> +	rc_dev->input_id.bustype = BUS_PCI;
> +	rc_dev->input_id.version = 1;
> +	rc_dev->input_id.vendor = dev->pci_dev->subsystem_vendor;
> +	rc_dev->input_id.product = dev->pci_dev->subsystem_device;
> +	rc_dev->dev.parent = &dev->pci_dev->dev;
> +
> +	rc_dev->driver_type = RC_DRIVER_SCANCODE;
> +	rc_dev->map_name = RC_MAP_DVBSKY;
> +
> +	ir->rc_dev = rc_dev;
> +	ir->dev = dev;
> +
> +	INIT_WORK(&ir->work, smi_ir_decode);
> +	smi_ir_disableInterrupt(ir);
> +
> +	ret = rc_register_device(rc_dev);
> +	if (ret)
> +		goto ir_err;
> +
> +	return 0;
> +ir_err:
> +	rc_free_device(rc_dev);
> +	return ret;
> +}
> +
> +void smi_ir_exit(struct smi_dev *dev)
> +{
> +	struct smi_rc *ir = &dev->ir;
> +	struct rc_dev *rc_dev = ir->rc_dev;
> +
> +	smi_ir_stop(ir);
> +	rc_unregister_device(rc_dev);
> +	ir->rc_dev = NULL;
> +}
> diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie-main.c
> similarity index 99%
> rename from drivers/media/pci/smipcie/smipcie.c
> rename to drivers/media/pci/smipcie/smipcie-main.c
> index 36c8ed7..88f3268 100644
> --- a/drivers/media/pci/smipcie/smipcie.c
> +++ b/drivers/media/pci/smipcie/smipcie-main.c
> @@ -472,6 +472,7 @@ static irqreturn_t smi_irq_handler(int irq, void *dev_id)
>  
>  	u32 intr_status = smi_read(MSI_INT_STATUS);
>  
> +	struct smi_rc *ir = &dev->ir;
>  	/* ts0 interrupt.*/
>  	if (dev->info->ts_0)
>  		handled += smi_port_irq(port0, intr_status);
> @@ -484,6 +485,9 @@ static irqreturn_t smi_irq_handler(int irq, void *dev_id)
>  }
>  
>  static struct i2c_client *smi_add_i2c_client(struct i2c_adapter *adapter,
> +	/* ir interrupt.*/
> +	handled += smi_ir_irq(ir, intr_status);
> +
>  			struct i2c_board_info *info)
>  {
>  	struct i2c_client *client;
> @@ -994,6 +998,10 @@ static int smi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  			goto err_del_port0_attach;
>  	}
>  
> +	ret = smi_ir_init(dev);
> +	if (ret < 0)
> +		goto err_del_port1_attach;
> +
>  #ifdef CONFIG_PCI_MSI /* to do msi interrupt.???*/
>  	if (pci_msi_enabled())
>  		ret = pci_enable_msi(dev->pci_dev);
> @@ -1004,10 +1012,13 @@ static int smi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	ret = request_irq(dev->pci_dev->irq, smi_irq_handler,
>  			   IRQF_SHARED, "SMI_PCIE", dev);
>  	if (ret < 0)
> -		goto err_del_port1_attach;
> +		goto err_del_ir;
>  
> +	smi_ir_start(&dev->ir);
>  	return 0;
>  
> +err_del_ir:
> +	smi_ir_exit(dev);
>  err_del_port1_attach:
>  	if (dev->info->ts_1)
>  		smi_port_detach(&dev->ts_port[1]);
> @@ -1016,6 +1027,7 @@ err_del_port0_attach:
>  		smi_port_detach(&dev->ts_port[0]);
>  err_del_i2c_adaptor:
>  	smi_i2c_exit(dev);
> +	smi_ir_exit(dev);
>  err_pci_iounmap:
>  	iounmap(dev->lmmio);
>  err_kfree:
> diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
> index 10cdf20..68cdda2 100644
> --- a/drivers/media/pci/smipcie/smipcie.h
> +++ b/drivers/media/pci/smipcie/smipcie.h
> @@ -234,6 +234,17 @@ struct smi_cfg_info {
>  	int fe_1;
>  };
>  
> +struct smi_rc {
> +	struct smi_dev *dev;
> +	struct rc_dev *rc_dev;
> +	char input_phys[64];
> +	char input_name[64];
> +	struct work_struct work;
> +	u8 irData[256];
> +
> +	int users;
> +};
> +
>  struct smi_port {
>  	struct smi_dev *dev;
>  	int idx;
> @@ -284,6 +295,9 @@ struct smi_dev {
>  	/* i2c */
>  	struct i2c_adapter i2c_bus[2];
>  	struct i2c_algo_bit_data i2c_bit[2];
> +
> +	/* ir */
> +	struct smi_rc ir;
>  };
>  
>  #define smi_read(reg)             readl(dev->lmmio + ((reg)>>2))
> @@ -296,4 +310,9 @@ struct smi_dev {
>  #define smi_set(reg, bit)          smi_andor((reg), (bit), (bit))
>  #define smi_clear(reg, bit)        smi_andor((reg), (bit), 0)
>  
> +int smi_ir_irq(struct smi_rc *ir, u32 int_status);
> +void smi_ir_start(struct smi_rc *ir);
> +void smi_ir_exit(struct smi_dev *dev);
> +int smi_ir_init(struct smi_dev *dev);
> +
>  #endif /* #ifndef _SMI_PCIE_H_ */
