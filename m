Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34839 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaHGQ2l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Aug 2014 12:28:41 -0400
Message-ID: <53E3A937.8000907@iki.fi>
Date: Thu, 07 Aug 2014 19:28:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] sp2: Add I2C driver for CIMaX SP2 common interface
 module
References: <1407308704-4120-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407308704-4120-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/06/2014 10:05 AM, Olli Salonen wrote:
> Driver for the CIMaX SP2 common interface chip. It is very much based on
> the existing cimax2 driver for cx23885, but should be more reusable. The
> product has been sold with name Atmel T90FJR as well and the data sheets
> for that chip seem to be publicly available.
>
> It seems that the USB device that I have and the cx23885 based devices will
> need to interact differently with the chip for the CAM operations. Thus
> there is one callback function that is passed on to the sp2 driver
> (see function sp2_ci_op_cam for that one).
>
> IRQ functionality is not included currently (not needed by USB devices
> and I don't have a PCIe device for development).
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/Makefile   |   1 +
>   drivers/media/dvb-frontends/sp2.c      | 411 +++++++++++++++++++++++++++++++++
>   drivers/media/dvb-frontends/sp2.h      |  54 +++++
>   drivers/media/dvb-frontends/sp2_priv.h |  49 ++++
>   4 files changed, 515 insertions(+)
>   create mode 100644 drivers/media/dvb-frontends/sp2.c
>   create mode 100644 drivers/media/dvb-frontends/sp2.h
>   create mode 100644 drivers/media/dvb-frontends/sp2_priv.h
>
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index edf103d..3498b95 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -107,6 +107,7 @@ obj-$(CONFIG_DVB_DRXK) += drxk.o
>   obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
>   obj-$(CONFIG_DVB_SI2165) += si2165.o
>   obj-$(CONFIG_DVB_A8293) += a8293.o
> +obj-$(CONFIG_DVB_SP2) += sp2.o
>   obj-$(CONFIG_DVB_TDA10071) += tda10071.o
>   obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>   obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
> diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
> new file mode 100644
> index 0000000..c1b4d7e
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/sp2.c
> @@ -0,0 +1,411 @@
> +/*
> + * CIMaX SP2/SP2HF (Atmel T90FJR) CI driver
> + *
> + * Copyright (C) 2014 Olli Salonen <olli.salonen@iki.fi>
> + *
> + * Heavily based on CIMax2(R) SP2 driver in conjunction with NetUp Dual
> + * DVB-S2 CI card (cimax2) with following copyrights:
> + *
> + *  Copyright (C) 2009 NetUP Inc.
> + *  Copyright (C) 2009 Igor M. Liplianin <liplianin@netup.ru>
> + *  Copyright (C) 2009 Abylay Ospan <aospan@netup.ru>
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
> +#include "sp2_priv.h"
> +
> +static int sp2_read_i2c(struct sp2 *s, u8 reg, u8 *buf, int len)
> +{
> +	int ret;
> +	struct i2c_client *client = s->client;
> +	struct i2c_adapter *adap = client->adapter;
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = client->addr,
> +			.flags = 0,
> +			.buf = &reg,
> +			.len = 1
> +		}, {
> +			.addr = client->addr,
> +			.flags	= I2C_M_RD,
> +			.buf = buf,
> +			.len = len
> +		}
> +	};
> +
> +	ret = i2c_transfer(adap, msg, 2);
> +
> +	if (ret != 2) {
> +		dev_err(&client->dev, "i2c read error, reg = 0x%02x, status = %d\n",
> +				reg, ret);
> +		return -1;
> +	}

Could you define error code here? I know a lot of old drivers were using 
just -1, but for new driver we could try do better. Return possible 
error from i2c_transfer() and if it returns wrong amount of messages (0 
or 1 in that case) then change -EIO.

I looked from I2C documentation and I think -EIO fits best

Documentation/i2c/fault-codes

EIO
	This rather vague error means something went wrong when
	performing an I/O operation.  Use a more specific fault
	code when you can.


> +
> +	dev_dbg(&s->client->dev, "addr=0x%04x, reg = 0x%02x, data = %02x\n",
> +				client->addr, reg, buf[0]);
> +
> +	return 0;
> +}
> +
> +static int sp2_write_i2c(struct sp2 *s, u8 reg, u8 *buf, int len)
> +{
> +	int ret;
> +	u8 buffer[35];
> +	struct i2c_client *client = s->client;
> +	struct i2c_adapter *adap = client->adapter;
> +	struct i2c_msg msg = {
> +		.addr = client->addr,
> +		.flags = 0,
> +		.buf = &buffer[0],
> +		.len = len + 1
> +	};
> +
> +	if ((len + 1) > sizeof(buffer)) {
> +		dev_err(&client->dev, "i2c wr reg=%02x: len=%d is too big!\n",
> +				reg, len);
> +		return -EINVAL;
> +	}
> +
> +	buffer[0] = reg;
> +	memcpy(&buffer[1], buf, len);
> +
> +	ret = i2c_transfer(adap, &msg, 1);
> +
> +	if (ret != 1) {
> +		dev_err(&client->dev, "i2c write error, reg = 0x%02x, status = %d\n",
> +				reg, ret);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sp2_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot, u8 acs,
> +			u8 read, int addr, u8 data)
> +{
> +	struct sp2 *s = en50221->data;
> +	u8 store;
> +	int mem, ret;
> +	int (*ci_op_cam)(void*, u8, int, u8, int*) = s->ci_control;
> +
> +	dev_dbg(&s->client->dev, "slot=%d, acs=0x%02x, addr=0x%04x, data = 0x%02x",
> +			slot, acs, addr, data);
> +
> +	if (slot != 0)
> +		return -EINVAL;
> +
> +	/* change module access type between IO space and attribute memory
> +	   when needed */

See Documentation/CodingStyle Chapter 8: Commenting.

/*
  * change module access type between IO space and attribute memory
  * when needed
  */

checkpatch.pl ?

> +	if (s->module_access_type != acs) {
> +		ret = sp2_read_i2c(s, 0x00, &store, 1);
> +
> +		if (ret)
> +			return ret;
> +
> +		store &= ~(SP2_MOD_CTL_ACS1 | SP2_MOD_CTL_ACS0);
> +		store |= acs;
> +
> +		ret = sp2_write_i2c(s, 0x00, &store, 1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	s->module_access_type = acs;
> +
> +	/* implementation of ci_op_cam is device specific */
> +	if (ci_op_cam) {
> +		ret = ci_op_cam(s->priv, read, addr, data, &mem);
> +	} else {
> +		dev_err(&s->client->dev, "callback not defined");
> +		return -EINVAL;
> +	}
> +
> +	if (ret)
> +		return -EREMOTEIO;

Maybe it could be good idea to return original error code from the 
bridge driver here too. EREMOTEIO is USB specific error.

> +
> +	if (read) {
> +		dev_dbg(&s->client->dev, "cam read, addr=0x%04x, data = 0x%04x",
> +				addr, mem);
> +		return mem;
> +	} else {
> +		return 0;
> +	}
> +}
> +
> +int sp2_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
> +				int slot, int addr)
> +{
> +	return sp2_ci_op_cam(en50221, slot, SP2_CI_ATTR_ACS,
> +			SP2_CI_RD, addr, 0);
> +}
> +
> +int sp2_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
> +				int slot, int addr, u8 data)
> +{
> +	return sp2_ci_op_cam(en50221, slot, SP2_CI_ATTR_ACS,
> +			SP2_CI_WR, addr, data);
> +}
> +
> +int sp2_ci_read_cam_control(struct dvb_ca_en50221 *en50221,
> +				int slot, u8 addr)
> +{
> +	return sp2_ci_op_cam(en50221, slot, SP2_CI_IO_ACS,
> +			SP2_CI_RD, addr, 0);
> +}
> +
> +int sp2_ci_write_cam_control(struct dvb_ca_en50221 *en50221,
> +				int slot, u8 addr, u8 data)
> +{
> +	return sp2_ci_op_cam(en50221, slot, SP2_CI_IO_ACS,
> +			SP2_CI_WR, addr, data);
> +}
> +
> +int sp2_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	struct sp2 *s = en50221->data;
> +	u8 buf;
> +	int ret;
> +
> +	if (slot != 0)
> +		return -EINVAL;
> +
> +	usleep_range(500, 600);

That sleep has no idea. It is there likely workaround some other bug. 
You should not need never wait before I/O like that - but likely after 
in order to wait hw ready. Underlying adapter is I2C here and adapter 
should be ready without a waiting.

> +
> +	/* RST on */
> +	buf = SP2_MOD_CTL_RST;
> +	ret = sp2_write_i2c(s, 0x00, &buf, 1);
> +
> +	if (ret)
> +		return ret;
> +
> +	usleep_range(500, 600);
> +
> +	/* RST off */
> +	buf = 0x00;
> +	ret = sp2_write_i2c(s, 0x00, &buf, 1);
> +
> +	msleep(1000);
> +
> +	return 0;

return value from previous I2C op is discarded mistakenly?

> +}
> +
> +int sp2_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	/* not implemented */
> +	return 0;
> +}
> +
> +int sp2_ci_slot_ts_enable(struct dvb_ca_en50221 *en50221, int slot)
> +{
> +	struct sp2 *s = en50221->data;
> +	u8 buf;
> +
> +	if (slot != 0)
> +		return -EINVAL;
> +
> +	sp2_read_i2c(s, 0x00, &buf, 1);
> +
> +	/* disable bypass and enable TS */
> +	buf |= (SP2_MOD_CTL_TSOEN | SP2_MOD_CTL_TSIEN);
> +	return sp2_write_i2c(s, 0, &buf, 1);
> +}
> +
> +int sp2_ci_poll_slot_status(struct dvb_ca_en50221 *en50221,
> +				int slot, int open)
> +{
> +	struct sp2 *s = en50221->data;
> +	u8 buf[2];
> +	int ret;
> +
> +	/* CAM module INSERT/REMOVE processing. slow operation because of i2c
> +	 * transfers */

multiline comment style

> +	if (time_after(jiffies, s->next_status_checked_time)) {
> +		ret = sp2_read_i2c(s, 0x00, buf, 1);
> +		s->next_status_checked_time = jiffies +	msecs_to_jiffies(1000);
> +
> +		if (ret)
> +			return 0;
> +
> +		if (buf[0] & SP2_MOD_CTL_DET)
> +			s->status = DVB_CA_EN50221_POLL_CAM_PRESENT |
> +					DVB_CA_EN50221_POLL_CAM_READY;
> +		else
> +			s->status = 0;
> +	}

Adds one sec throttle for CAM polling, which is imho good. I have never 
understood why it is polled so rapidly...

> +
> +	return s->status;
> +}
> +
> +int sp2_init(struct sp2 *s)
> +{
> +	int ret = 0;
> +	u8 buf;
> +	u8 cimax_init[34] = {
> +		0x00, /* module A control*/
> +		0x00, /* auto select mask high A */
> +		0x00, /* auto select mask low A */
> +		0x00, /* auto select pattern high A */
> +		0x00, /* auto select pattern low A */
> +		0x44, /* memory access time A, 600 ns */
> +		0x00, /* invert input A */
> +		0x00, /* RFU */
> +		0x00, /* RFU */
> +		0x00, /* module B control*/
> +		0x00, /* auto select mask high B */
> +		0x00, /* auto select mask low B */
> +		0x00, /* auto select pattern high B */
> +		0x00, /* auto select pattern low B */
> +		0x44, /* memory access time B, 600 ns */
> +		0x00, /* invert input B */
> +		0x00, /* RFU */
> +		0x00, /* RFU */
> +		0x00, /* auto select mask high Ext */
> +		0x00, /* auto select mask low Ext */
> +		0x00, /* auto select pattern high Ext */
> +		0x00, /* auto select pattern low Ext */
> +		0x00, /* RFU */
> +		0x02, /* destination - module A */
> +		0x01, /* power control reg, VCC power on */
> +		0x00, /* RFU */
> +		0x00, /* int status read only */
> +		0x00, /* Interrupt Mask Register */
> +		0x05, /* EXTINT=active-high, INT=push-pull */
> +		0x00, /* USCG1 */
> +		0x04, /* ack active low */
> +		0x00, /* LOCK = 0 */
> +		0x22, /* unknown */
> +		0x00, /* synchronization? */
> +	};
> +
> +	s->ca.owner = THIS_MODULE;
> +	s->ca.read_attribute_mem = sp2_ci_read_attribute_mem;
> +	s->ca.write_attribute_mem = sp2_ci_write_attribute_mem;
> +	s->ca.read_cam_control = sp2_ci_read_cam_control;
> +	s->ca.write_cam_control = sp2_ci_write_cam_control;
> +	s->ca.slot_reset = sp2_ci_slot_reset;
> +	s->ca.slot_shutdown = sp2_ci_slot_shutdown;
> +	s->ca.slot_ts_enable = sp2_ci_slot_ts_enable;
> +	s->ca.poll_slot_status = sp2_ci_poll_slot_status;
> +	s->ca.data = s;
> +	s->module_access_type = 0;
> +
> +	/* initialize all regs */
> +	ret = sp2_write_i2c(s, 0x00, &cimax_init[0], 34);
> +	if (ret)
> +		goto err;
> +
> +	/* lock registers */
> +	buf = 1;
> +	ret = sp2_write_i2c(s, 0x1f, &buf, 1);
> +	if (ret)
> +		goto err;
> +
> +	/* power on slots */
> +	ret = sp2_write_i2c(s, 0x18, &buf, 1);
> +	if (ret)
> +		goto err;
> +
> +	ret = dvb_ca_en50221_init(s->dvb_adap, &s->ca, 0, 1);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	dev_dbg(&s->client->dev, "init failed=%d\n", ret);
> +	return ret;
> +}
> +
> +int sp2_exit(struct i2c_client *client)
> +{
> +	struct sp2 *s;
> +
> +	if (client == NULL)
> +		return 0;
> +
> +	s = i2c_get_clientdata(client);
> +	if (s == NULL)
> +		return 0;
> +
> +	if (s->ca.data == NULL)
> +		return 0;
> +
> +	dvb_ca_en50221_release(&s->ca);
> +
> +	return 0;
> +}
> +
> +static int sp2_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	struct sp2_config *cfg = client->dev.platform_data;
> +	struct sp2 *s;
> +	int ret;
> +
> +	s = kzalloc(sizeof(struct sp2), GFP_KERNEL);
> +	if (!s) {
> +		ret = -ENOMEM;
> +		dev_err(&client->dev, "kzalloc() failed\n");
> +		goto err;
> +	}
> +
> +	s->client = client;
> +	s->dvb_adap = cfg->dvb_adap;
> +	s->priv = cfg->priv;
> +	s->ci_control = cfg->ci_control;
> +
> +	i2c_set_clientdata(client, s);
> +
> +	ret = sp2_init(s);
> +	if (ret)
> +		goto err;
> +
> +	dev_info(&s->client->dev, "CIMaX SP2 successfully attached\n");
> +	return 0;
> +err:
> +	dev_dbg(&client->dev, "init failed=%d\n", ret);
> +	kfree(s);
> +
> +	return ret;
> +}
> +
> +static int sp2_remove(struct i2c_client *client)
> +{
> +	struct si2157 *s = i2c_get_clientdata(client);
> +
> +	sp2_exit(client);
> +	kfree(s);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id sp2_id[] = {
> +	{"sp2", 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, sp2_id);
> +
> +static struct i2c_driver sp2_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "sp2",
> +	},
> +	.probe		= sp2_probe,
> +	.remove		= sp2_remove,
> +	.id_table	= sp2_id,
> +};
> +
> +module_i2c_driver(sp2_driver);
> +
> +MODULE_DESCRIPTION("CIMaX SP2/HF CI driver");
> +MODULE_AUTHOR("Olli Salonen <olli.salonen@iki.fi>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/sp2.h b/drivers/media/dvb-frontends/sp2.h
> new file mode 100644
> index 0000000..31ba6ba
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/sp2.h
> @@ -0,0 +1,54 @@
> +/*
> + * CIMaX SP2/HF CI driver
> + *
> + * Copyright (C) 2014 Olli Salonen <olli.salonen@iki.fi>
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
> +#ifndef SP2_H
> +#define SP2_H
> +
> +#include <linux/kconfig.h>
> +#include "dvb_frontend.h"

Maybe that include is not needed? There is no direct frontend relation?

> +#include "dvb_ca_en50221.h"
> +
> +/*
> + * I2C address
> + * 0x40 (port 0)
> + * 0x41 (port 1)
> + */
> +struct sp2_config {
> +	/* dvb_adapter to attach the ci to */
> +	struct dvb_adapter *dvb_adap;
> +
> +	/* function ci_control handles the device specific ci ops */
> +	void *ci_control;
> +
> +	/* priv is passed back to function ci_control */
> +	void *priv;
> +};
> +
> +extern int sp2_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
> +					int slot, int addr);
> +extern int sp2_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
> +					int slot, int addr, u8 data);
> +extern int sp2_ci_read_cam_control(struct dvb_ca_en50221 *en50221,
> +					int slot, u8 addr);
> +extern int sp2_ci_write_cam_control(struct dvb_ca_en50221 *en50221,
> +					int slot, u8 addr, u8 data);
> +extern int sp2_ci_slot_reset(struct dvb_ca_en50221 *en50221, int slot);
> +extern int sp2_ci_slot_shutdown(struct dvb_ca_en50221 *en50221, int slot);
> +extern int sp2_ci_slot_ts_enable(struct dvb_ca_en50221 *en50221, int slot);
> +extern int sp2_ci_poll_slot_status(struct dvb_ca_en50221 *en50221,
> +					int slot, int open);
> +
> +#endif
> diff --git a/drivers/media/dvb-frontends/sp2_priv.h b/drivers/media/dvb-frontends/sp2_priv.h
> new file mode 100644
> index 0000000..7099fb9
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/sp2_priv.h
> @@ -0,0 +1,49 @@
> +/*
> + * CIMaX SP2/HF CI driver
> + *
> + * Copyright (C) 2014 Olli Salonen <olli.salonen@iki.fi>
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
> +#ifndef SP2_PRIV_H
> +#define SP2_PRIV_H
> +
> +#include "sp2.h"
> +
> +/* state struct */
> +struct sp2 {
> +	int status;
> +	struct i2c_client *client;
> +	struct dvb_adapter *dvb_adap;
> +	struct dvb_ca_en50221 ca;
> +	int module_access_type;
> +	unsigned long next_status_checked_time;
> +	void *priv;
> +	void *ci_control;
> +};
> +
> +#define SP2_CI_ATTR_ACS		0x00
> +#define SP2_CI_IO_ACS		0x04
> +#define SP2_CI_WR		0
> +#define SP2_CI_RD		1
> +
> +/* Module control register (0x00 module A, 0x09 module B) bits */
> +#define SP2_MOD_CTL_DET		0x01
> +#define SP2_MOD_CTL_AUTO	0x02
> +#define SP2_MOD_CTL_ACS0	0x04
> +#define SP2_MOD_CTL_ACS1	0x08
> +#define SP2_MOD_CTL_HAD		0x10
> +#define SP2_MOD_CTL_TSIEN	0x20
> +#define SP2_MOD_CTL_TSOEN	0x40
> +#define SP2_MOD_CTL_RST		0x80
> +
> +#endif
>


Reviewed-by: Antti Palosaari <crope@iki.fi>

None of those findings are critical. However I hope you double check and 
fix if there is any relevant enough.

regards
Antti

-- 
http://palosaari.fi/
