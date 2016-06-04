Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33549 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbcFDTzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2016 15:55:04 -0400
Received: by mail-wm0-f65.google.com with SMTP id a136so6957495wme.0
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2016 12:55:02 -0700 (PDT)
Subject: Re: [PATCH] [media]: Driver for Toshiba et8ek8 5MP sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
 <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160525214544.GL26360@valkosipuli.retiisi.org.uk>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57533212.3020406@gmail.com>
Date: Sat, 4 Jun 2016 22:54:58 +0300
MIME-Version: 1.0
In-Reply-To: <20160525214544.GL26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26.05.2016 00:45, Sakari Ailus wrote:
> Hi Ivaylo,
>
> I've got some comments here but I haven't reviewed everything yet. What's
> missing is
>
> - the user space interface for selecting the sensor configuration "mode",
>
> - passing information on the sensor configuration to the user space.
>
> I'll try to take a look at those some time in the near future.
>

ok

>
> I very much appreciate your work towards finally upstreaming this! :-)
>
> On Tue, May 03, 2016 at 05:50:04PM +0300, Ivaylo Dimitrov wrote:
>> The sensor is found in Nokia N900 main camera
>>
>> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>> ---
>>   .../bindings/media/i2c/toshiba,et8ek8.txt          |   53 +
>>   drivers/media/i2c/Kconfig                          |    1 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/et8ek8/Kconfig                   |    6 +
>>   drivers/media/i2c/et8ek8/Makefile                  |    2 +
>>   drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1711 ++++++++++++++++++++
>>   drivers/media/i2c/et8ek8/et8ek8_mode.c             |  591 +++++++
>>   drivers/media/i2c/et8ek8/et8ek8_reg.h              |  100 ++
>>   include/uapi/linux/v4l2-controls.h                 |    5 +
>>   9 files changed, 2470 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>>   create mode 100644 drivers/media/i2c/et8ek8/Kconfig
>>   create mode 100644 drivers/media/i2c/et8ek8/Makefile
>>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
>>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
>>   create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>> new file mode 100644
>> index 0000000..55f712c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>> @@ -0,0 +1,53 @@
>> +Toshiba et8ek8 5MP sensor
>> +
>> +Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
>> +
>> +More detailed documentation can be found in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt .
>> +
>> +
>> +Mandatory properties
>> +--------------------
>> +
>> +- compatible: "toshiba,et8ek8"
>> +- reg: I2C address (0x3e, or an alternative address)
>> +- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
>> +  dependent).
>
> As these are bindings for a particular sensor, 2,8 volts it is.
>
> The sensor has also a digital voltage supply but it might be controlled by
> the same GPIO which controls the CCP2 switch. Ugly stuff. Perhaps we could
> just omit that here.
>

ok

>> +- clocks: External clock to the sensor
>> +- clock-frequency: Frequency of the external clock to the sensor
>> +
>> +
>> +Optional properties
>> +-------------------
>> +
>> +- reset-gpios: XSHUTDOWN GPIO
>
> I guess this should be mandatory.
>

yeah. Also, I will change xxx-lanes to optional

>> +
>> +
>> +Endpoint node mandatory properties
>> +----------------------------------
>> +
>> +- clock-lanes: <0>
>> +- data-lanes: <1..n>
>> +- remote-endpoint: A phandle to the bus receiver's endpoint node.
>> +
>> +
>> +Example
>> +-------
>> +
>> +&i2c3 {
>> +	clock-frequency = <400000>;
>> +
>> +	cam1: camera@3e {
>> +		compatible = "toshiba,et8ek8";
>> +		reg = <0x3e>;
>> +		vana-supply = <&vaux4>;
>> +		clocks = <&isp 0>;
>> +		clock-frequency = <9600000>;
>> +		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
>> +		port {
>> +			csi_cam1: endpoint {
>> +				remote-endpoint = <&csi_out1>;
>> +			};
>> +		};
>> +	};
>> +};
>
> Please split the DT documentation from the driver.
>

Split it how? Send as series [patch 1] - driver, [patch 2] - doc?

> I remember having discussed showing the module in DT with Sebastian but I
> couldn't find the patches anywhere. We currently consider the lens and
> sensor entirely separate, the module has not been shown in software as
> there's been nothing to control it.
>

Not sure what am I supposed to do with that comment :)

> Sebastian: do you still have those patches around somewhere?
>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 993dc50..e964787 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -629,6 +629,7 @@ config VIDEO_S5K5BAF
>>   	  camera sensor with an embedded SoC image signal processor.
>>
>>   source "drivers/media/i2c/smiapp/Kconfig"
>> +source "drivers/media/i2c/et8ek8/Kconfig"
>>
>>   config VIDEO_S5C73M3
>>   	tristate "Samsung S5C73M3 sensor support"
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 94f2c99..907b180 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -2,6 +2,7 @@ msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
>>   obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
>>
>>   obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
>> +obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
>>   obj-$(CONFIG_VIDEO_CX25840) += cx25840/
>>   obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
>>   obj-y				+= soc_camera/
>> diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/Kconfig
>> new file mode 100644
>> index 0000000..1439936
>> --- /dev/null
>> +++ b/drivers/media/i2c/et8ek8/Kconfig
>> @@ -0,0 +1,6 @@
>> +config VIDEO_ET8EK8
>> +	tristate "ET8EK8 camera sensor support"
>> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +	---help---
>> +	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
>> +	  It is used for example in Nokia N900 (RX-51).
>> diff --git a/drivers/media/i2c/et8ek8/Makefile b/drivers/media/i2c/et8ek8/Makefile
>> new file mode 100644
>> index 0000000..66d1b7d
>> --- /dev/null
>> +++ b/drivers/media/i2c/et8ek8/Makefile
>> @@ -0,0 +1,2 @@
>> +et8ek8-objs			+= et8ek8_mode.o et8ek8_driver.o
>> +obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8.o
>> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
>> new file mode 100644
>> index 0000000..1eaef78
>> --- /dev/null
>> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
>> @@ -0,0 +1,1711 @@
>> +/*
>> + * et8ek8_driver.c
>> + *
>> + * Copyright (C) 2008 Nokia Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
>> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
>
> tuukkat76@gmail.com
>

ok

>> + *
>> + * Based on code from Toni Leinonen <toni.leinonen@offcode.fi>.
>> + *
>> + * This driver is based on the Micron MT9T012 camera imager driver
>> + * (C) Texas Instruments.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/i2c.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/gpio/consumer.h>
>
> Alphabetical order, please.
>

ok

>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +#include <linux/sort.h>
>> +#include <linux/version.h>
>
> Is linux/version.h needed?
>

no, will remove it

>> +#include <linux/v4l2-mediabus.h>
>> +
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#include "et8ek8_reg.h"
>> +
>> +#define ET8EK8_NAME		"et8ek8"
>> +#define ET8EK8_PRIV_MEM_SIZE	128
>> +
>> +#define ET8EK8_CID_USER_FRAME_WIDTH	(V4L2_CID_USER_ET8EK8_BASE + 1)
>> +#define ET8EK8_CID_USER_FRAME_HEIGHT	(V4L2_CID_USER_ET8EK8_BASE + 2)
>> +#define ET8EK8_CID_USER_VISIBLE_WIDTH	(V4L2_CID_USER_ET8EK8_BASE + 3)
>> +#define ET8EK8_CID_USER_VISIBLE_HEIGHT	(V4L2_CID_USER_ET8EK8_BASE + 4)
>> +#define ET8EK8_CID_USER_SENSITIVITY	(V4L2_CID_USER_ET8EK8_BASE + 5)
>
> If you have custom controls,
>

hmm?

>> +
>> +struct et8ek8_sensor {
>> +	struct v4l2_subdev subdev;
>> +	struct media_pad pad;
>> +	struct v4l2_mbus_framefmt format;
>> +	struct gpio_desc *reset;
>> +	struct regulator *vana;
>> +	struct clk *ext_clk;
>> +	u32 xclk_freq;
>> +
>> +	u16 version;
>> +
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	struct v4l2_ctrl *exposure;
>> +	struct v4l2_ctrl *pixel_rate;
>> +	struct et8ek8_reglist *current_reglist;
>> +
>> +	u8 priv_mem[ET8EK8_PRIV_MEM_SIZE];
>> +
>> +	struct mutex power_lock;
>> +	int power_count;
>> +};
>> +
>> +#define to_et8ek8_sensor(sd)	container_of(sd, struct et8ek8_sensor, subdev)
>> +
>> +enum et8ek8_versions {
>> +	ET8EK8_REV_1 = 0x0001,
>> +	ET8EK8_REV_2,
>> +};
>> +
>> +/*
>> + * This table describes what should be written to the sensor register
>> + * for each gain value. The gain(index in the table) is in terms of
>> + * 0.1EV, i.e. 10 indexes in the table give 2 time more gain [0] in
>> + * the *analog gain, [1] in the digital gain
>> + *
>> + * Analog gain [dB] = 20*log10(regvalue/32); 0x20..0x100
>> + */
>> +static struct et8ek8_gain {
>> +	u16 analog;
>> +	u16 digital;
>> +} const et8ek8_gain_table[] = {
>> +	{ 32,    0},  /* x1 */
>> +	{ 34,    0},
>> +	{ 37,    0},
>> +	{ 39,    0},
>> +	{ 42,    0},
>> +	{ 45,    0},
>> +	{ 49,    0},
>> +	{ 52,    0},
>> +	{ 56,    0},
>> +	{ 60,    0},
>> +	{ 64,    0},  /* x2 */
>> +	{ 69,    0},
>> +	{ 74,    0},
>> +	{ 79,    0},
>> +	{ 84,    0},
>> +	{ 91,    0},
>> +	{ 97,    0},
>> +	{104,    0},
>> +	{111,    0},
>> +	{119,    0},
>> +	{128,    0},  /* x4 */
>> +	{137,    0},
>> +	{147,    0},
>> +	{158,    0},
>> +	{169,    0},
>> +	{181,    0},
>> +	{194,    0},
>> +	{208,    0},
>> +	{223,    0},
>> +	{239,    0},
>> +	{256,    0},  /* x8 */
>> +	{256,   73},
>> +	{256,  152},
>> +	{256,  236},
>> +	{256,  327},
>> +	{256,  424},
>> +	{256,  528},
>> +	{256,  639},
>> +	{256,  758},
>> +	{256,  886},
>> +	{256, 1023},  /* x16 */
>> +};
>> +
>> +/* Register definitions */
>> +#define REG_REVISION_NUMBER_L	0x1200
>> +#define REG_REVISION_NUMBER_H	0x1201
>> +
>> +#define PRIV_MEM_START_REG	0x0008
>> +#define PRIV_MEM_WIN_SIZE	8
>> +
>> +#define ET8EK8_I2C_DELAY	3	/* msec delay b/w accesses */
>> +
>> +#define USE_CRC			1
>> +
>> +/*
>> + *
>> + * Register access helpers
>> + *
>> + */
>> +
>> +/*
>> + * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
>> + * Returns zero if successful, or non-zero otherwise.
>> + */
>> +static int et8ek8_i2c_read_reg(struct i2c_client *client, u16 data_length,
>> +			       u16 reg, u32 *val)
>> +{
>> +	int r;
>> +	struct i2c_msg msg[1];
>> +	unsigned char data[4];
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +	if (data_length != ET8EK8_REG_8BIT && data_length != ET8EK8_REG_16BIT)
>> +		return -EINVAL;
>> +
>> +	msg->addr = client->addr;
>> +	msg->flags = 0;
>> +	msg->len = 2;
>> +	msg->buf = data;
>> +
>> +	/* high byte goes out first */
>> +	data[0] = (u8) (reg >> 8);
>> +	data[1] = (u8) (reg & 0xff);
>> +	r = i2c_transfer(client->adapter, msg, 1);
>> +	if (r < 0)
>> +		goto err;
>> +
>> +	msg->len = data_length;
>> +	msg->flags = I2C_M_RD;
>> +	r = i2c_transfer(client->adapter, msg, 1);
>> +	if (r < 0)
>> +		goto err;
>> +
>> +	*val = 0;
>> +	/* high byte comes first */
>> +	if (data_length == ET8EK8_REG_8BIT)
>> +		*val = data[0];
>> +	else
>> +		*val = (data[0] << 8) + data[1];
>> +
>> +	return 0;
>> +
>> +err:
>> +	dev_err(&client->dev, "read from offset 0x%x error %d\n", reg, r);
>> +
>> +	return r;
>> +}
>> +
>> +static void et8ek8_i2c_create_msg(struct i2c_client *client, u16 len, u16 reg,
>> +				  u32 val, struct i2c_msg *msg,
>> +				  unsigned char *buf)
>> +{
>> +	msg->addr = client->addr;
>> +	msg->flags = 0; /* Write */
>> +	msg->len = 2 + len;
>> +	msg->buf = buf;
>> +
>> +	/* high byte goes out first */
>> +	buf[0] = (u8) (reg >> 8);
>> +	buf[1] = (u8) (reg & 0xff);
>> +
>> +	switch (len) {
>> +	case ET8EK8_REG_8BIT:
>> +		buf[2] = (u8) (val) & 0xff;
>> +		break;
>> +	case ET8EK8_REG_16BIT:
>> +		buf[2] = (u8) (val >> 8) & 0xff;
>> +		buf[3] = (u8) (val & 0xff);
>> +		break;
>> +	case ET8EK8_REG_32BIT:
>> +		buf[2] = (u8) (val >> 24) & 0xff;
>> +		buf[3] = (u8) (val >> 16) & 0xff;
>> +		buf[4] = (u8) (val >> 8) & 0xff;
>> +		buf[5] = (u8) (val & 0xff);
>> +		break;
>> +	default:
>> +		BUG();
>> +	}
>> +}
>> +
>> +/*
>> + * A buffered write method that puts the wanted register write
>> + * commands in a message list and passes the list to the i2c framework
>> + */
>> +static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
>> +					  const struct et8ek8_reg *wnext,
>> +					  int cnt)
>> +{
>> +	/* FIXME: check how big cnt is */
>> +	struct i2c_msg msg[cnt];
>> +	unsigned char data[cnt][6];
>> +	int wcnt = 0;
>> +	u16 reg, data_length;
>> +	u32 val;
>> +
>> +	/* Create new write messages for all writes */
>> +	while (wcnt < cnt) {
>> +		data_length = wnext->type;
>> +		reg = wnext->reg;
>> +		val = wnext->val;
>> +		wnext++;
>> +
>> +		et8ek8_i2c_create_msg(client, data_length, reg,
>> +				    val, &msg[wcnt], &data[wcnt][0]);
>> +
>> +		/* Update write count */
>> +		wcnt++;
>> +	}
>> +
>> +	/* Now we send everything ... */
>> +	return i2c_transfer(client->adapter, msg, wcnt);
>> +}
>> +
>> +/*
>> + * Write a list of registers to i2c device.
>> + *
>> + * The list of registers is terminated by ET8EK8_REG_TERM.
>> + * Returns zero if successful, or non-zero otherwise.
>> + */
>> +static int et8ek8_i2c_write_regs(struct i2c_client *client,
>> +				 const struct et8ek8_reg reglist[])
>> +{
>> +	int r, cnt = 0;
>> +	const struct et8ek8_reg *next, *wnext;
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +
>> +	if (reglist == NULL)
>> +		return -EINVAL;
>> +
>> +	/* Initialize list pointers to the start of the list */
>> +	next = wnext = reglist;
>> +
>> +	do {
>> +		/*
>> +		 * We have to go through the list to figure out how
>> +		 * many regular writes we have in a row
>> +		 */
>> +		while (next->type != ET8EK8_REG_TERM
>> +		       && next->type != ET8EK8_REG_DELAY) {
>> +			/*
>> +			 * Here we check that the actual length fields
>> +			 * are valid
>> +			 */
>> +			if (next->type != ET8EK8_REG_8BIT
>> +			    &&  next->type != ET8EK8_REG_16BIT) {
>> +				dev_err(&client->dev,
>> +					"Invalid value on entry %d 0x%x\n",
>> +					cnt, next->type);
>> +				return -EINVAL;
>> +			}
>> +
>> +			/*
>> +			 * Increment count of successive writes and
>> +			 * read pointer
>> +			 */
>> +			cnt++;
>> +			next++;
>> +		}
>> +
>> +		/* Now we start writing ... */
>> +		r = et8ek8_i2c_buffered_write_regs(client, wnext, cnt);
>> +
>> +		/* ... and then check that everything was OK */
>> +		if (r < 0) {
>> +			dev_err(&client->dev, "i2c transfer error !!!\n");
>> +			return r;
>> +		}
>> +
>> +		/*
>> +		 * If we ran into a sleep statement when going through
>> +		 * the list, this is where we snooze for the required time
>> +		 */
>> +		if (next->type == ET8EK8_REG_DELAY) {
>> +			set_current_state(TASK_UNINTERRUPTIBLE);
>> +			schedule_timeout(msecs_to_jiffies(next->val));
>> +			/*
>> +			 * ZZZ ...
>> +			 * Update list pointers and cnt and start over ...
>> +			 */
>> +			next++;
>> +			wnext = next;
>> +			cnt = 0;
>> +		}
>> +	} while (next->type != ET8EK8_REG_TERM);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Write to a 8/16-bit register.
>> + * Returns zero if successful, or non-zero otherwise.
>> + */
>> +static int et8ek8_i2c_write_reg(struct i2c_client *client, u16 data_length,
>> +				u16 reg, u32 val)
>> +{
>> +	int r;
>> +	struct i2c_msg msg[1];
>> +	unsigned char data[6];
>> +
>> +	if (!client->adapter)
>> +		return -ENODEV;
>> +	if (data_length != ET8EK8_REG_8BIT && data_length != ET8EK8_REG_16BIT)
>> +		return -EINVAL;
>> +
>> +	et8ek8_i2c_create_msg(client, data_length, reg, val, msg, data);
>> +
>> +	r = i2c_transfer(client->adapter, msg, 1);
>> +	if (r < 0)
>> +		dev_err(&client->dev,
>> +			"wrote 0x%x to offset 0x%x error %d\n", val, reg, r);
>> +	else
>> +		r = 0; /* on success i2c_transfer() return messages trasfered */
>> +
>> +	return r;
>> +}
>> +
>> +static struct et8ek8_reglist *et8ek8_reglist_find_type(
>> +		struct et8ek8_meta_reglist *meta,
>> +		u16 type)
>> +{
>> +	struct et8ek8_reglist **next = &meta->reglist[0].ptr;
>> +
>> +	while (*next) {
>> +		if ((*next)->type == type)
>> +			return *next;
>> +
>> +		next++;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int et8ek8_i2c_reglist_find_write(struct i2c_client *client,
>> +					 struct et8ek8_meta_reglist *meta,
>> +					 u16 type)
>> +{
>> +	struct et8ek8_reglist *reglist;
>> +
>> +	reglist = et8ek8_reglist_find_type(meta, type);
>> +	if (IS_ERR(reglist))
>> +		return PTR_ERR(reglist);
>> +
>> +	return et8ek8_i2c_write_regs(client, reglist->regs);
>> +}
>> +
>> +static struct et8ek8_reglist **et8ek8_reglist_first(
>> +		struct et8ek8_meta_reglist *meta)
>> +{
>> +	return &meta->reglist[0].ptr;
>> +}
>> +
>> +static void et8ek8_reglist_to_mbus(const struct et8ek8_reglist *reglist,
>> +				   struct v4l2_mbus_framefmt *fmt)
>> +{
>> +	fmt->width = reglist->mode.window_width;
>> +	fmt->height = reglist->mode.window_height;
>> +
>> +	if (reglist->mode.pixel_format == V4L2_PIX_FMT_SGRBG10DPCM8)
>> +		fmt->code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
>> +	else
>> +		fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
>> +}
>> +
>> +static struct et8ek8_reglist *et8ek8_reglist_find_mode_fmt(
>> +		struct et8ek8_meta_reglist *meta,
>> +		struct v4l2_mbus_framefmt *fmt)
>> +{
>> +	struct et8ek8_reglist **list = et8ek8_reglist_first(meta);
>> +	struct et8ek8_reglist *best_match = NULL;
>> +	struct et8ek8_reglist *best_other = NULL;
>> +	struct v4l2_mbus_framefmt format;
>> +	unsigned int max_dist_match = (unsigned int)-1;
>> +	unsigned int max_dist_other = (unsigned int)-1;
>> +
>> +	/* Find the mode with the closest image size. The distance between
>> +	 * image sizes is the size in pixels of the non-overlapping regions
>> +	 * between the requested size and the frame-specified size.
>> +	 *
>> +	 * Store both the closest mode that matches the requested format, and
>> +	 * the closest mode for all other formats. The best match is returned
>> +	 * if found, otherwise the best mode with a non-matching format is
>> +	 * returned.
>> +	 */
>> +	for (; *list; list++) {
>> +		unsigned int dist;
>> +
>> +		if ((*list)->type != ET8EK8_REGLIST_MODE)
>> +			continue;
>> +
>> +		et8ek8_reglist_to_mbus(*list, &format);
>> +
>> +		dist = min(fmt->width, format.width)
>> +		     * min(fmt->height, format.height);
>> +		dist = format.width * format.height
>> +		     + fmt->width * fmt->height - 2 * dist;
>> +
>> +
>> +		if (fmt->code == format.code) {
>> +			if (dist < max_dist_match || best_match == NULL) {
>> +				best_match = *list;
>> +				max_dist_match = dist;
>> +			}
>> +		} else {
>> +			if (dist < max_dist_other || best_other == NULL) {
>> +				best_other = *list;
>> +				max_dist_other = dist;
>> +			}
>> +		}
>> +	}
>> +
>> +	return best_match ? best_match : best_other;
>> +}
>> +
>> +#define TIMEPERFRAME_AVG_FPS(t)						\
>> +	(((t).denominator + ((t).numerator >> 1)) / (t).numerator)
>> +
>> +static struct et8ek8_reglist *et8ek8_reglist_find_mode_ival(
>> +		struct et8ek8_meta_reglist *meta,
>> +		struct et8ek8_reglist *current_reglist,
>> +		struct v4l2_fract *timeperframe)
>> +{
>> +	int fps = TIMEPERFRAME_AVG_FPS(*timeperframe);
>> +	struct et8ek8_reglist **list = et8ek8_reglist_first(meta);
>> +	struct et8ek8_mode *current_mode = &current_reglist->mode;
>> +
>> +	for (; *list; list++) {
>> +		struct et8ek8_mode *mode = &(*list)->mode;
>> +
>> +		if ((*list)->type != ET8EK8_REGLIST_MODE)
>> +			continue;
>> +
>> +		if (mode->window_width != current_mode->window_width
>> +		    || mode->window_height != current_mode->window_height)
>> +			continue;
>> +
>> +		if (TIMEPERFRAME_AVG_FPS(mode->timeperframe) == fps)
>> +			return *list;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int et8ek8_reglist_cmp(const void *a, const void *b)
>> +{
>> +	const struct et8ek8_reglist **list1 = (const struct et8ek8_reglist **)a,
>> +		**list2 = (const struct et8ek8_reglist **)b;
>> +
>> +	/* Put real modes in the beginning. */
>> +	if ((*list1)->type == ET8EK8_REGLIST_MODE &&
>> +	    (*list2)->type != ET8EK8_REGLIST_MODE)
>> +		return -1;
>> +	if ((*list1)->type != ET8EK8_REGLIST_MODE &&
>> +	    (*list2)->type == ET8EK8_REGLIST_MODE)
>> +		return 1;
>> +
>> +	/* Descending width. */
>> +	if ((*list1)->mode.window_width > (*list2)->mode.window_width)
>> +		return -1;
>> +	if ((*list1)->mode.window_width < (*list2)->mode.window_width)
>> +		return 1;
>> +
>> +	if ((*list1)->mode.window_height > (*list2)->mode.window_height)
>> +		return -1;
>> +	if ((*list1)->mode.window_height < (*list2)->mode.window_height)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_reglist_import(struct i2c_client *client,
>> +				 struct et8ek8_meta_reglist *meta)
>> +{
>> +	uintptr_t nlists = 0;
>> +
>> +	if (meta->magic != ET8EK8_MAGIC) {
>
> No need to check this anymore.
>

ok. will remove the struct member as well.

>> +		dev_err(&client->dev,
>> +			"invalid camera sensor firmware (0x%08X)\n",
>> +			meta->magic);
>> +		return -EILSEQ;
>> +	}
>> +
>> +	dev_info(&client->dev, "meta_reglist version %s\n", meta->version);
>> +
>> +	while (meta->reglist[nlists].ptr != NULL)
>> +		nlists++;
>> +
>> +	if (!nlists)
>> +		return -EINVAL;
>> +
>> +	sort(&meta->reglist[0].ptr, nlists, sizeof(meta->reglist[0].ptr),
>> +	     et8ek8_reglist_cmp, NULL);
>> +
>> +	nlists = 0;
>> +	while (meta->reglist[nlists].ptr != NULL) {
>
> I guess you could just loop over nlists. You just counted the entries above.
>

Yeah. Also, I wonder why is nlists uintptr_t. Will fix it.

>> +		struct et8ek8_reglist *list;
>> +
>> +		list = meta->reglist[nlists].ptr;
>> +
>> +		dev_dbg(&client->dev,
>> +		       "%s: type %d\tw %d\th %d\tfmt %x\tival %d/%d\tptr %p\n",
>> +		       __func__,
>> +		       list->type,
>> +		       list->mode.window_width, list->mode.window_height,
>> +		       list->mode.pixel_format,
>> +		       list->mode.timeperframe.numerator,
>> +		       list->mode.timeperframe.denominator,
>> +		       (void *)meta->reglist[nlists].ptr);
>> +
>> +		nlists++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Return time of one row in microseconds, .8 fixed point format.
>> + * If the sensor is not set to any mode, return zero.
>> + */
>> +static int et8ek8_get_row_time(struct et8ek8_sensor *sensor)
>> +{
>> +	unsigned int clock;	/* Pixel clock in Hz>>10 fixed point */
>> +	unsigned int rt;	/* Row time in .8 fixed point */
>> +
>> +	if (!sensor->current_reglist)
>> +		return 0;
>> +
>> +	clock = sensor->current_reglist->mode.pixel_clock;
>> +	clock = (clock + (1 << 9)) >> 10;
>> +	rt = sensor->current_reglist->mode.width * (1000000 >> 2);
>> +	rt = (rt + (clock >> 1)) / clock;
>> +
>> +	return rt;
>> +}
>> +
>> +/*
>> + * Convert exposure time `us' to rows. Modify `us' to make it to
>> + * correspond to the actual exposure time.
>> + */
>> +static int et8ek8_exposure_us_to_rows(struct et8ek8_sensor *sensor, u32 *us)
>> +{
>> +	unsigned int rows;	/* Exposure value as written to HW (ie. rows) */
>> +	unsigned int rt;	/* Row time in .8 fixed point */
>> +
>> +	/* Assume that the maximum exposure time is at most ~8 s,
>> +	 * and the maximum width (with blanking) ~8000 pixels.
>> +	 * The formula here is in principle as simple as
>> +	 *    rows = exptime / 1e6 / width * pixel_clock
>> +	 * but to get accurate results while coping with value ranges,
>> +	 * have to do some fixed point math.
>> +	 */
>> +
>> +	rt = et8ek8_get_row_time(sensor);
>> +	rows = ((*us << 8) + (rt >> 1)) / rt;
>> +
>> +	if (rows > sensor->current_reglist->mode.max_exp)
>> +		rows = sensor->current_reglist->mode.max_exp;
>> +
>> +	/* Set the exposure time to the rounded value */
>> +	*us = (rt * rows + (1 << 7)) >> 8;
>> +
>> +	return rows;
>> +}
>> +
>> +/*
>> + * Convert exposure time in rows to microseconds
>> + */
>> +static int et8ek8_exposure_rows_to_us(struct et8ek8_sensor *sensor, int rows)
>> +{
>> +	return (et8ek8_get_row_time(sensor) * rows + (1 << 7)) >> 8;
>> +}
>> +
>> +/* Called to change the V4L2 gain control value. This function
>> + * rounds and clamps the given value and updates the V4L2 control value.
>> + * If power is on, also updates the sensor analog and digital gains.
>> + * gain is in 0.1 EV (exposure value) units.
>> + */
>> +static int et8ek8_set_gain(struct et8ek8_sensor *sensor, s32 gain)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +	struct et8ek8_gain new;
>> +	int r;
>> +
>> +	new = et8ek8_gain_table[gain];
>> +
>> +	/* FIXME: optimise I2C writes! */
>> +	r = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT,
>> +				0x124a, new.analog >> 8);
>> +	if (r)
>> +		return r;
>> +	r = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT,
>> +				0x1249, new.analog & 0xff);
>> +	if (r)
>> +		return r;
>> +
>> +	r = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT,
>> +				0x124d, new.digital >> 8);
>> +	if (r)
>> +		return r;
>> +	r = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT,
>> +				0x124c, new.digital & 0xff);
>> +
>> +	return r;
>> +}
>> +
>> +static int et8ek8_set_test_pattern(struct et8ek8_sensor *sensor, s32 mode)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +	int cbh_mode, cbv_mode, tp_mode, din_sw, r1420, rval;
>> +
>> +	/* Values for normal mode */
>> +	cbh_mode = 0;
>> +	cbv_mode = 0;
>> +	tp_mode  = 0;
>> +	din_sw   = 0x00;
>> +	r1420    = 0xF0;
>> +
>> +	if (mode != 0) {
>> +		/* Test pattern mode */
>> +		if (mode < 5) {
>> +			cbh_mode = 1;
>> +			cbv_mode = 1;
>> +			tp_mode  = mode + 3;
>> +		} else {
>> +			cbh_mode = 0;
>> +			cbv_mode = 0;
>> +			tp_mode  = mode - 4 + 3;
>> +		}
>> +		din_sw   = 0x01;
>> +		r1420    = 0xE0;
>> +	}
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x111B,
>> +				    tp_mode << 4);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1121,
>> +				    cbh_mode << 7);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1124,
>> +				    cbv_mode << 7);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x112C, din_sw);
>> +	if (rval)
>> +		goto out;
>> +
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1420, r1420);
>> +	if (rval)
>> +		goto out;
>> +
>> +out:
>> +	return rval;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * V4L2 controls
>> + */
>> +
>> +static int et8ek8_get_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct et8ek8_sensor *sensor =
>> +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
>> +	const struct et8ek8_mode *mode = &sensor->current_reglist->mode;
>> +
>> +	switch (ctrl->id) {
>> +	case ET8EK8_CID_USER_FRAME_WIDTH:
>> +		ctrl->cur.val = mode->width;
>> +		break;
>> +	case ET8EK8_CID_USER_FRAME_HEIGHT:
>> +		ctrl->cur.val = mode->height;
>> +		break;
>> +	case ET8EK8_CID_USER_VISIBLE_WIDTH:
>> +		ctrl->cur.val = mode->window_width;
>> +		break;
>> +	case ET8EK8_CID_USER_VISIBLE_HEIGHT:
>> +		ctrl->cur.val = mode->window_height;
>> +		break;
>> +	case ET8EK8_CID_USER_SENSITIVITY:
>> +		ctrl->cur.val = mode->sensitivity;
>
> All the values use for this control are 65536. Thus it provides no
> information to the user space nor it controls anything. Please drop it.
>

ok

>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_set_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct et8ek8_sensor *sensor =
>> +		container_of(ctrl->handler, struct et8ek8_sensor, ctrl_handler);
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +	int uninitialized_var(rows);
>> +
>> +	if (ctrl->id == V4L2_CID_EXPOSURE)
>> +		rows = et8ek8_exposure_us_to_rows(sensor, (u32 *)&ctrl->val);
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_GAIN:
>> +		return et8ek8_set_gain(sensor, ctrl->val);
>> +
>> +	case V4L2_CID_EXPOSURE:
>> +		return et8ek8_i2c_write_reg(client, ET8EK8_REG_16BIT, 0x1243,
>> +					    swab16(rows));
>> +
>> +	case V4L2_CID_TEST_PATTERN:
>> +		return et8ek8_set_test_pattern(sensor, ctrl->val);
>> +
>> +	case V4L2_CID_PIXEL_RATE:
>> +		/* For v4l2_ctrl_s_ctrl_int64() used internally. */
>> +		return 0;
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static const struct v4l2_ctrl_ops et8ek8_ctrl_ops = {
>> +	.g_volatile_ctrl = et8ek8_get_ctrl,
>> +	.s_ctrl = et8ek8_set_ctrl,
>> +};
>> +
>> +static const char * const et8ek8_test_pattern_menu[] = {
>> +	"Normal",
>> +	"Vertical colorbar",
>> +	"Horizontal colorbar",
>> +	"Scale",
>> +	"Ramp",
>> +	"Small vertical colorbar",
>> +	"Small horizontal colorbar",
>> +	"Small scale",
>> +	"Small ramp",
>> +};
>> +
>> +static const struct v4l2_ctrl_config et8ek8_ctrls[] = {
>> +	{
>> +		.id		= V4L2_CID_USER_ET8EK8_BASE,
>> +		.type		= V4L2_CTRL_TYPE_CTRL_CLASS,
>> +		.name		= "et8ek8 driver controls",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_WRITE_ONLY,
>> +	},
>> +	{
>> +		.ops		= &et8ek8_ctrl_ops,
>> +		.id		= ET8EK8_CID_USER_FRAME_WIDTH,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Frame width",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_VOLATILE,
>> +	},
>> +	{
>> +		.ops		= &et8ek8_ctrl_ops,
>> +		.id		= ET8EK8_CID_USER_FRAME_HEIGHT,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Frame height",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_VOLATILE,
>> +	},
>> +	{
>> +		.ops		= &et8ek8_ctrl_ops,
>> +		.id		= ET8EK8_CID_USER_VISIBLE_WIDTH,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Visible width",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_VOLATILE,
>> +	},
>> +	{
>> +		.ops		= &et8ek8_ctrl_ops,
>> +		.id		= ET8EK8_CID_USER_VISIBLE_HEIGHT,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Visible height",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_VOLATILE,
>> +	},
>> +	{
>> +		.ops		= &et8ek8_ctrl_ops,
>> +		.id		= ET8EK8_CID_USER_SENSITIVITY,
>> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>> +		.name		= "Sensitivity",
>> +		.min		= 0,
>> +		.max		= 0,
>> +		.step		= 1,
>> +		.def		= 0,
>> +		.flags		= V4L2_CTRL_FLAG_READ_ONLY |
>> +				  V4L2_CTRL_FLAG_VOLATILE,
>> +	},
>> +};
>> +
>> +static int et8ek8_init_controls(struct et8ek8_sensor *sensor)
>> +{
>> +	unsigned int i;
>> +	u32 min, max;
>> +
>> +	v4l2_ctrl_handler_init(&sensor->ctrl_handler,
>> +			       ARRAY_SIZE(et8ek8_ctrls) + 2);
>> +
>> +	/* V4L2_CID_GAIN */
>> +	v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
>> +			  V4L2_CID_GAIN, 0, ARRAY_SIZE(et8ek8_gain_table) - 1,
>> +			  1, 0);
>> +
>> +	/* V4L2_CID_EXPOSURE */
>> +	min = et8ek8_exposure_rows_to_us(sensor, 1);
>> +	max = et8ek8_exposure_rows_to_us(sensor,
>> +				sensor->current_reglist->mode.max_exp);
>> +	sensor->exposure =
>> +		v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
>> +				  V4L2_CID_EXPOSURE, min, max, min, max);
>> +
>> +	/* V4L2_CID_PIXEL_RATE */
>> +	sensor->pixel_rate =
>> +		v4l2_ctrl_new_std(&sensor->ctrl_handler, &et8ek8_ctrl_ops,
>> +		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
>> +
>> +	/* V4L2_CID_TEST_PATTERN */
>> +	v4l2_ctrl_new_std_menu_items(&sensor->ctrl_handler,
>> +				     &et8ek8_ctrl_ops, V4L2_CID_TEST_PATTERN,
>> +				     ARRAY_SIZE(et8ek8_test_pattern_menu) - 1,
>> +				     0, 0, et8ek8_test_pattern_menu);
>> +
>> +	/* V4L2_CID_USER_ET8EK8_BASE */
>> +	for (i = 0; i < ARRAY_SIZE(et8ek8_ctrls); ++i)
>> +		v4l2_ctrl_new_custom(&sensor->ctrl_handler, &et8ek8_ctrls[i],
>> +				     NULL);
>> +
>> +	if (sensor->ctrl_handler.error)
>> +		return sensor->ctrl_handler.error;
>> +
>> +	sensor->subdev.ctrl_handler = &sensor->ctrl_handler;
>> +	return 0;
>> +}
>> +
>> +static void et8ek8_update_controls(struct et8ek8_sensor *sensor)
>> +{
>> +	struct v4l2_ctrl *ctrl = sensor->exposure;
>> +	struct et8ek8_mode *mode = &sensor->current_reglist->mode;
>> +	u32 min, max, pixel_rate;
>> +	static const int S = 8;
>> +
>> +	min = et8ek8_exposure_rows_to_us(sensor, 1);
>> +	max = et8ek8_exposure_rows_to_us(sensor, mode->max_exp);
>> +
>> +	/*
>> +	 * Calculate average pixel clock per line. Assume buffers can spread
>> +	 * the data over horizontal blanking time. Rounding upwards.
>> +	 * Formula taken from stock Nokia N900 kernel
>> +	 */
>> +	pixel_rate = ((mode->pixel_clock + (1 << S) - 1) >> S) + mode->width;
>> +	pixel_rate = mode->window_width * (pixel_rate - 1) / mode->width;
>> +
>> +	v4l2_ctrl_lock(ctrl);
>> +	ctrl->minimum = min;
>> +	ctrl->maximum = max;
>> +	ctrl->step = min;
>> +	ctrl->default_value = max;
>> +	ctrl->val = max;
>> +	ctrl->cur.val = max;
>> +	__v4l2_ctrl_s_ctrl_int64(sensor->pixel_rate, pixel_rate << S);
>> +	v4l2_ctrl_unlock(ctrl);
>> +}
>> +
>> +static int et8ek8_configure(struct et8ek8_sensor *sensor)
>> +{
>> +	struct v4l2_subdev *subdev = &sensor->subdev;
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	int rval;
>> +
>> +	rval = et8ek8_i2c_write_regs(client, sensor->current_reglist->regs);
>> +	if (rval)
>> +		goto fail;
>> +
>> +	/* Controls set while the power to the sensor is turned off are saved
>> +	 * but not applied to the hardware. Now that we're about to start
>> +	 * streaming apply all the current values to the hardware.
>> +	 */
>> +	rval = v4l2_ctrl_handler_setup(&sensor->ctrl_handler);
>> +	if (rval)
>> +		goto fail;
>> +
>> +	return 0;
>> +
>> +fail:
>> +	dev_err(&client->dev, "sensor configuration failed\n");
>> +	return rval;
>> +}
>> +
>> +static int et8ek8_stream_on(struct et8ek8_sensor *sensor)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +
>> +	return et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1252, 0xb0);
>> +}
>> +
>> +static int et8ek8_stream_off(struct et8ek8_sensor *sensor)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>> +
>> +	return et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1252, 0x30);
>> +}
>> +
>> +static int et8ek8_s_stream(struct v4l2_subdev *subdev, int streaming)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	int ret;
>> +
>> +	if (!streaming)
>> +		return et8ek8_stream_off(sensor);
>> +
>> +	ret = et8ek8_configure(sensor);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return et8ek8_stream_on(sensor);
>> +}
>> +
>> +/* --------------------------------------------------------------------------
>> + * V4L2 subdev operations
>> + */
>> +
>> +static int et8ek8_power_off(struct et8ek8_sensor *sensor)
>> +{
>> +	int rval;
>> +
>> +	gpiod_set_value(sensor->reset, 0);
>> +	udelay(1);
>> +
>> +	clk_disable_unprepare(sensor->ext_clk);
>> +
>> +	rval = regulator_disable(sensor->vana);
>> +	return rval;
>> +}
>> +
>> +static int et8ek8_power_on(struct et8ek8_sensor *sensor)
>> +{
>> +	struct v4l2_subdev *subdev = &sensor->subdev;
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	unsigned int xclk_freq;
>> +	int val, rval;
>> +
>> +	rval = regulator_enable(sensor->vana);
>> +	if (rval) {
>> +		dev_err(&client->dev, "failed to enable vana regulator\n");
>> +		return rval;
>> +	}
>> +
>> +	if (sensor->current_reglist)
>> +		xclk_freq = sensor->current_reglist->mode.ext_clock;
>> +	else
>> +		xclk_freq = sensor->xclk_freq;
>> +
>> +	rval = clk_set_rate(sensor->ext_clk, xclk_freq);
>> +	if (rval < 0) {
>> +		dev_err(&client->dev, "unable to set extclk clock freq to %u\n",
>> +			xclk_freq);
>> +		goto out;
>> +	}
>> +	rval = clk_prepare_enable(sensor->ext_clk);
>> +	if (rval < 0) {
>> +		dev_err(&client->dev, "failed to enable extclk\n");
>> +		goto out;
>> +	}
>> +
>> +	if (rval)
>> +		goto out;
>> +
>> +	udelay(10); /* I wish this is a good value */
>> +
>> +	gpiod_set_value(sensor->reset, 1);
>> +
>> +	msleep(5000 * 1000 / xclk_freq + 1); /* Wait 5000 cycles */
>> +
>> +	rval = et8ek8_i2c_reglist_find_write(client, &meta_reglist,
>> +					     ET8EK8_REGLIST_POWERON);
>> +	if (rval)
>> +		goto out;
>> +
>> +#ifdef USE_CRC
>> +	rval = et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT, 0x1263, &val);
>> +	if (rval)
>> +		goto out;
>> +#if USE_CRC /* TODO get crc setting from DT */
>> +	val |= BIT(4);
>> +#else
>> +	val &= ~BIT(4);
>> +#endif
>> +	rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x1263, val);
>> +	if (rval)
>> +		goto out;
>> +#endif
>> +
>> +out:
>> +	if (rval)
>> +		et8ek8_power_off(sensor);
>> +
>> +	return rval;
>> +}
>> +
>> +/* --------------------------------------------------------------------------
>> + * V4L2 subdev video operations
>> + */
>> +#define MAX_FMTS 4
>> +static int et8ek8_enum_mbus_code(struct v4l2_subdev *subdev,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	struct et8ek8_reglist **list =
>> +			et8ek8_reglist_first(&meta_reglist);
>> +	u32 pixelformat[MAX_FMTS];
>> +	int npixelformat = 0;
>> +
>> +	if (code->index >= MAX_FMTS)
>> +		return -EINVAL;
>> +
>> +	for (; *list; list++) {
>> +		struct et8ek8_mode *mode = &(*list)->mode;
>> +		int i;
>> +
>> +		if ((*list)->type != ET8EK8_REGLIST_MODE)
>> +			continue;
>> +
>> +		for (i = 0; i < npixelformat; i++) {
>> +			if (pixelformat[i] == mode->pixel_format)
>> +				break;
>> +		}
>> +		if (i != npixelformat)
>> +			continue;
>> +
>> +		if (code->index == npixelformat) {
>> +			if (mode->pixel_format == V4L2_PIX_FMT_SGRBG10DPCM8)
>> +				code->code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8;
>> +			else
>> +				code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
>> +			return 0;
>> +		}
>> +
>> +		pixelformat[npixelformat] = mode->pixel_format;
>> +		npixelformat++;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int et8ek8_enum_frame_size(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_size_enum *fse)
>> +{
>> +	struct et8ek8_reglist **list =
>> +			et8ek8_reglist_first(&meta_reglist);
>> +	struct v4l2_mbus_framefmt format;
>> +	int cmp_width = INT_MAX;
>> +	int cmp_height = INT_MAX;
>> +	int index = fse->index;
>> +
>> +	for (; *list; list++) {
>> +		if ((*list)->type != ET8EK8_REGLIST_MODE)
>> +			continue;
>> +
>> +		et8ek8_reglist_to_mbus(*list, &format);
>> +		if (fse->code != format.code)
>> +			continue;
>> +
>> +		/* Assume that the modes are grouped by frame size. */
>> +		if (format.width == cmp_width && format.height == cmp_height)
>> +			continue;
>> +
>> +		cmp_width = format.width;
>> +		cmp_height = format.height;
>> +
>> +		if (index-- == 0) {
>> +			fse->min_width = format.width;
>> +			fse->min_height = format.height;
>> +			fse->max_width = format.width;
>> +			fse->max_height = format.height;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int et8ek8_enum_frame_ival(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_interval_enum *fie)
>> +{
>> +	struct et8ek8_reglist **list =
>> +			et8ek8_reglist_first(&meta_reglist);
>> +	struct v4l2_mbus_framefmt format;
>> +	int index = fie->index;
>> +
>> +	for (; *list; list++) {
>> +		struct et8ek8_mode *mode = &(*list)->mode;
>> +
>> +		if ((*list)->type != ET8EK8_REGLIST_MODE)
>> +			continue;
>> +
>> +		et8ek8_reglist_to_mbus(*list, &format);
>> +		if (fie->code != format.code)
>> +			continue;
>> +
>> +		if (fie->width != format.width || fie->height != format.height)
>> +			continue;
>> +
>> +		if (index-- == 0) {
>> +			fie->interval = mode->timeperframe;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static struct v4l2_mbus_framefmt *
>> +__et8ek8_get_pad_format(struct et8ek8_sensor *sensor,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			unsigned int pad, enum v4l2_subdev_format_whence which)
>> +{
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_format(&sensor->subdev, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &sensor->format;
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static int et8ek8_get_pad_format(struct v4l2_subdev *subdev,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_format *fmt)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct v4l2_mbus_framefmt *format;
>> +
>> +	format = __et8ek8_get_pad_format(sensor, cfg, fmt->pad, fmt->which);
>> +	if (format == NULL)
>> +		return -EINVAL;
>> +
>> +	fmt->format = *format;
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_set_pad_format(struct v4l2_subdev *subdev,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_format *fmt)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct v4l2_mbus_framefmt *format;
>> +	struct et8ek8_reglist *reglist;
>> +
>> +	format = __et8ek8_get_pad_format(sensor, cfg, fmt->pad, fmt->which);
>> +	if (format == NULL)
>> +		return -EINVAL;
>> +
>> +	reglist = et8ek8_reglist_find_mode_fmt(&meta_reglist,
>> +					     &fmt->format);
>> +	et8ek8_reglist_to_mbus(reglist, &fmt->format);
>> +	*format = fmt->format;
>> +
>> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +		sensor->current_reglist = reglist;
>> +		et8ek8_update_controls(sensor);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_get_frame_interval(struct v4l2_subdev *subdev,
>> +				     struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +
>> +	memset(fi, 0, sizeof(*fi));
>> +	fi->interval = sensor->current_reglist->mode.timeperframe;
>> +
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_set_frame_interval(struct v4l2_subdev *subdev,
>> +				     struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct et8ek8_reglist *reglist;
>> +
>> +	reglist = et8ek8_reglist_find_mode_ival(&meta_reglist,
>> +					      sensor->current_reglist,
>> +					      &fi->interval);
>> +
>> +	if (!reglist)
>> +		return -EINVAL;
>> +
>> +	if (sensor->current_reglist->mode.ext_clock != reglist->mode.ext_clock)
>> +		return -EINVAL;
>> +
>> +	sensor->current_reglist = reglist;
>> +	et8ek8_update_controls(sensor);
>> +
>> +	return 0;
>> +}
>> +
>> +static int et8ek8_g_priv_mem(struct v4l2_subdev *subdev)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	unsigned int length = ET8EK8_PRIV_MEM_SIZE;
>> +	unsigned int offset = 0;
>> +	u8 *ptr  = sensor->priv_mem;
>> +	int rval = 0;
>> +
>> +	/* Read the EEPROM window-by-window, each window 8 bytes */
>> +	do {
>> +		u8 buffer[PRIV_MEM_WIN_SIZE];
>> +		struct i2c_msg msg;
>> +		int bytes, i;
>> +		int ofs;
>> +
>> +		/* Set the current window */
>> +		rval = et8ek8_i2c_write_reg(client, ET8EK8_REG_8BIT, 0x0001,
>> +					    0xe0 | (offset >> 3));
>> +		if (rval < 0)
>> +			goto out;
>> +
>> +		/* Wait for status bit */
>> +		for (i = 0; i < 1000; ++i) {
>> +			u32 status;
>> +
>> +			rval = et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT,
>> +						   0x0003, &status);
>> +			if (rval < 0)
>> +				goto out;
>> +			if ((status & 0x08) == 0)
>> +				break;
>> +			usleep_range(1000, 2000);
>> +		};
>> +
>> +		if (i == 1000) {
>> +			rval = -EIO;
>> +			goto out;
>> +		}
>> +
>> +		/* Read window, 8 bytes at once, and copy to user space */
>> +		ofs = offset & 0x07;	/* Offset within this window */
>> +		bytes = length + ofs > 8 ? 8-ofs : length;
>> +		msg.addr = client->addr;
>> +		msg.flags = 0;
>> +		msg.len = 2;
>> +		msg.buf = buffer;
>> +		ofs += PRIV_MEM_START_REG;
>> +		buffer[0] = (u8)(ofs >> 8);
>> +		buffer[1] = (u8)(ofs & 0xFF);
>> +		rval = i2c_transfer(client->adapter, &msg, 1);
>> +		if (rval < 0)
>> +			goto out;
>> +		mdelay(ET8EK8_I2C_DELAY);
>> +		msg.addr = client->addr;
>> +		msg.len = bytes;
>> +		msg.flags = I2C_M_RD;
>> +		msg.buf = buffer;
>> +		memset(buffer, 0, sizeof(buffer));
>> +		rval = i2c_transfer(client->adapter, &msg, 1);
>> +		if (rval < 0)
>> +			goto out;
>> +		rval = 0;
>> +		memcpy(ptr, buffer, bytes);
>> +
>> +		length -= bytes;
>> +		offset += bytes;
>> +		ptr    += bytes;
>> +	} while (length > 0);
>> +
>> +out:
>> +	return rval;
>> +}
>> +
>> +static int et8ek8_dev_init(struct v4l2_subdev *subdev)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	int rval, rev_l, rev_h;
>> +
>> +	rval = et8ek8_power_on(sensor);
>> +	if (rval) {
>> +		dev_err(&client->dev, "could not power on\n");
>> +		return rval;
>> +	}
>> +
>> +	if (et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT,
>> +				REG_REVISION_NUMBER_L, &rev_l) != 0
>> +	    || et8ek8_i2c_read_reg(client, ET8EK8_REG_8BIT,
>> +				   REG_REVISION_NUMBER_H, &rev_h) != 0) {
>> +		dev_err(&client->dev,
>> +			"no et8ek8 sensor detected\n");
>> +		rval = -ENODEV;
>> +		goto out_poweroff;
>> +	}
>> +	sensor->version = (rev_h << 8) + rev_l;
>> +	if (sensor->version != ET8EK8_REV_1
>> +	    && sensor->version != ET8EK8_REV_2)
>> +		dev_info(&client->dev,
>> +			 "unknown version 0x%x detected, continuing anyway\n",
>> +			 sensor->version);
>> +
>> +	rval = et8ek8_reglist_import(client, &meta_reglist);
>> +	if (rval) {
>> +		dev_err(&client->dev,
>> +			"invalid register list %s, import failed\n",
>> +			ET8EK8_NAME);
>> +		goto out_poweroff;
>> +	}
>> +
>> +	sensor->current_reglist =
>> +		et8ek8_reglist_find_type(&meta_reglist,
>> +				       ET8EK8_REGLIST_MODE);
>> +	if (!sensor->current_reglist) {
>> +		dev_err(&client->dev,
>> +			"invalid register list %s, no mode found\n",
>> +			ET8EK8_NAME);
>> +		rval = -ENODEV;
>> +		goto out_poweroff;
>> +	}
>> +
>> +	et8ek8_reglist_to_mbus(sensor->current_reglist, &sensor->format);
>> +
>> +	rval = et8ek8_i2c_reglist_find_write(client,
>> +					   &meta_reglist,
>> +					   ET8EK8_REGLIST_POWERON);
>> +	if (rval) {
>> +		dev_err(&client->dev,
>> +			"invalid register list %s, no POWERON mode found\n",
>> +			ET8EK8_NAME);
>> +		goto out_poweroff;
>> +	}
>> +	rval = et8ek8_stream_on(sensor); /* Needed to be able to read EEPROM */
>> +	if (rval)
>> +		goto out_poweroff;
>> +	rval = et8ek8_g_priv_mem(subdev);
>> +	if (rval)
>> +		dev_warn(&client->dev,
>> +			"can not read OTP (EEPROM) memory from sensor\n");
>> +	rval = et8ek8_stream_off(sensor);
>> +	if (rval)
>> +		goto out_poweroff;
>> +
>> +	rval = et8ek8_power_off(sensor);
>> +	if (rval)
>> +		goto out_poweroff;
>> +
>> +	return 0;
>> +
>> +out_poweroff:
>> +	et8ek8_power_off(sensor);
>> +
>> +	return rval;
>> +}
>> +
>> +/* --------------------------------------------------------------------------
>> + * sysfs attributes
>> + */
>> +static ssize_t
>> +et8ek8_priv_mem_read(struct device *dev, struct device_attribute *attr,
>> +		     char *buf)
>> +{
>> +	struct v4l2_subdev *subdev = i2c_get_clientdata(to_i2c_client(dev));
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +
>> +#if PAGE_SIZE < ET8EK8_PRIV_MEM_SIZE
>> +#error PAGE_SIZE too small!
>> +#endif
>> +
>> +	memcpy(buf, sensor->priv_mem, ET8EK8_PRIV_MEM_SIZE);
>> +
>> +	return ET8EK8_PRIV_MEM_SIZE;
>> +}
>> +static DEVICE_ATTR(priv_mem, S_IRUGO, et8ek8_priv_mem_read, NULL);
>> +
>> +/* --------------------------------------------------------------------------
>> + * V4L2 subdev core operations
>> + */
>> +
>> +static int
>> +et8ek8_registered(struct v4l2_subdev *subdev)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	struct v4l2_mbus_framefmt *format;
>> +	int rval;
>> +
>> +	dev_dbg(&client->dev, "registered!");
>> +
>> +	if (device_create_file(&client->dev, &dev_attr_priv_mem) != 0) {
>> +		dev_err(&client->dev, "could not register sysfs entry\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	rval = et8ek8_dev_init(subdev);
>> +	if (rval)
>> +		return rval;
>> +
>> +	rval = et8ek8_init_controls(sensor);
>> +	if (rval) {
>> +		dev_err(&client->dev, "controls initialization failed\n");
>> +		return rval;
>> +	}
>> +
>> +	format = __et8ek8_get_pad_format(sensor, NULL, 0,
>> +					 V4L2_SUBDEV_FORMAT_ACTIVE);
>> +	return 0;
>> +}
>> +
>> +static int __et8ek8_set_power(struct et8ek8_sensor *sensor, bool on)
>> +{
>> +	return on ? et8ek8_power_on(sensor) : et8ek8_power_off(sensor);
>> +}
>> +
>> +static int et8ek8_set_power(struct v4l2_subdev *subdev, int on)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&sensor->power_lock);
>> +
>> +	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +	 * update the power state.
>> +	 */
>> +	if (sensor->power_count == !on) {
>> +		ret = __et8ek8_set_power(sensor, !!on);
>> +		if (ret < 0)
>> +			goto done;
>> +	}
>> +
>> +	/* Update the power count. */
>> +	sensor->power_count += on ? 1 : -1;
>> +	WARN_ON(sensor->power_count < 0);
>> +
>> +done:
>> +	mutex_unlock(&sensor->power_lock);
>> +	return ret;
>> +}
>> +
>> +static int et8ek8_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(sd);
>> +	struct v4l2_mbus_framefmt *format;
>> +	struct et8ek8_reglist *reglist;
>> +
>> +	reglist = et8ek8_reglist_find_type(&meta_reglist, ET8EK8_REGLIST_MODE);
>> +	format = __et8ek8_get_pad_format(sensor, fh->pad, 0,
>> +					 V4L2_SUBDEV_FORMAT_TRY);
>> +	et8ek8_reglist_to_mbus(reglist, format);
>> +
>> +	return et8ek8_set_power(sd, true);
>> +}
>> +
>> +static int et8ek8_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	return et8ek8_set_power(sd, false);
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops et8ek8_video_ops = {
>> +	.s_stream = et8ek8_s_stream,
>> +	.g_frame_interval = et8ek8_get_frame_interval,
>> +	.s_frame_interval = et8ek8_set_frame_interval,
>> +};
>> +
>> +static const struct v4l2_subdev_core_ops et8ek8_core_ops = {
>> +	.s_power = et8ek8_set_power,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops et8ek8_pad_ops = {
>> +	.enum_mbus_code = et8ek8_enum_mbus_code,
>> +	.enum_frame_size = et8ek8_enum_frame_size,
>> +	.enum_frame_interval = et8ek8_enum_frame_ival,
>> +	.get_fmt = et8ek8_get_pad_format,
>> +	.set_fmt = et8ek8_set_pad_format,
>> +};
>> +
>> +static const struct v4l2_subdev_ops et8ek8_ops = {
>> +	.core = &et8ek8_core_ops,
>> +	.video = &et8ek8_video_ops,
>> +	.pad = &et8ek8_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops et8ek8_internal_ops = {
>> +	.registered = et8ek8_registered,
>> +	.open = et8ek8_open,
>> +	.close = et8ek8_close,
>> +};
>> +
>> +/* --------------------------------------------------------------------------
>> + * I2C driver
>> + */
>> +#ifdef CONFIG_PM
>> +
>> +static int et8ek8_suspend(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +
>> +	if (!sensor->power_count)
>> +		return 0;
>> +
>> +	return __et8ek8_set_power(sensor, false);
>> +}
>> +
>> +static int et8ek8_resume(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +
>> +	if (!sensor->power_count)
>> +		return 0;
>> +
>> +	return __et8ek8_set_power(sensor, true);
>> +}
>> +
>> +static const struct dev_pm_ops et8ek8_pm_ops = {
>> +	.suspend	= et8ek8_suspend,
>> +	.resume		= et8ek8_resume,
>> +};
>> +
>> +#else
>> +
>> +#define et8ek8_pm_ops	NULL
>> +
>> +#endif /* CONFIG_PM */
>> +
>> +static int et8ek8_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *devid)
>> +{
>> +	struct et8ek8_sensor *sensor;
>> +	struct device *dev = &client->dev;
>> +	int ret;
>> +
>> +	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
>> +	if (!sensor)
>> +		return -ENOMEM;
>> +
>> +	sensor->reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(sensor->reset)) {
>> +		dev_dbg(&client->dev, "could not request reset gpio\n");
>> +		return PTR_ERR(sensor->reset);
>> +	}
>> +
>> +	sensor->vana = devm_regulator_get(dev, "vana");
>> +	if (IS_ERR(sensor->vana)) {
>> +		dev_err(&client->dev, "could not get regulator for vana\n");
>> +		return PTR_ERR(sensor->vana);
>> +	}
>> +
>> +	sensor->ext_clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(sensor->ext_clk)) {
>> +		dev_err(&client->dev, "could not get clock\n");
>> +		return PTR_ERR(sensor->ext_clk);
>> +	}
>> +
>> +	ret = of_property_read_u32(dev->of_node, "clock-frequency",
>> +				   &sensor->xclk_freq);
>> +	if (ret) {
>> +		dev_warn(dev, "can't get clock-frequency\n");
>> +		return ret;
>> +	}
>> +
>> +	mutex_init(&sensor->power_lock);
>> +
>> +	v4l2_i2c_subdev_init(&sensor->subdev, client, &et8ek8_ops);
>> +	sensor->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	sensor->subdev.internal_ops = &et8ek8_internal_ops;
>> +
>> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	ret = media_entity_pads_init(&sensor->subdev.entity, 1, &sensor->pad);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "media entity init failed!\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = v4l2_async_register_subdev(&sensor->subdev);
>> +	if (ret < 0) {
>> +		media_entity_cleanup(&sensor->subdev.entity);
>> +		return ret;
>> +	}
>> +
>> +	dev_dbg(dev, "initialized!\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int __exit et8ek8_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>> +	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
>> +
>> +	if (sensor->power_count) {
>> +		gpiod_set_value(sensor->reset, 0);
>> +		clk_disable_unprepare(sensor->ext_clk);
>> +		sensor->power_count = 0;
>> +	}
>> +
>> +	v4l2_device_unregister_subdev(&sensor->subdev);
>> +	device_remove_file(&client->dev, &dev_attr_priv_mem);
>> +	v4l2_ctrl_handler_free(&sensor->ctrl_handler);
>> +	media_entity_cleanup(&sensor->subdev.entity);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id et8ek8_of_table[] = {
>> +	{ .compatible = "toshiba,et8ek8" },
>> +	{ },
>> +};
>> +
>> +static const struct i2c_device_id et8ek8_id_table[] = {
>> +	{ ET8EK8_NAME, 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, et8ek8_id_table);
>> +
>> +static struct i2c_driver et8ek8_i2c_driver = {
>> +	.driver		= {
>> +		.name	= ET8EK8_NAME,
>> +		.pm	= &et8ek8_pm_ops,
>> +		.of_match_table	= et8ek8_of_table,
>> +	},
>> +	.probe		= et8ek8_probe,
>> +	.remove		= __exit_p(et8ek8_remove),
>> +	.id_table	= et8ek8_id_table,
>> +};
>> +
>> +module_i2c_driver(et8ek8_i2c_driver);
>> +
>> +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>");
>> +MODULE_DESCRIPTION("Toshiba ET8EK8 camera sensor driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/media/i2c/et8ek8/et8ek8_mode.c b/drivers/media/i2c/et8ek8/et8ek8_mode.c
>> new file mode 100644
>> index 0000000..e5c367b
>> --- /dev/null
>> +++ b/drivers/media/i2c/et8ek8/et8ek8_mode.c
>> @@ -0,0 +1,591 @@
>> +/*
>> + * et8ek8_mode.c
>> + *
>> + * Copyright (C) 2008 Nokia Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
>> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include "et8ek8_reg.h"
>> +
>> +/*
>> + *
>> + * Stingray sensor mode settings for Scooby
>> + *
>> + *
>> + */
>> +
>> +/* Mode1_poweron_Mode2_16VGA_2592x1968_12.07fps */
>> +static struct et8ek8_reglist mode1_poweron_mode2_16vga_2592x1968_12_07fps = {
>> +/* (without the +1)
>> + * SPCK       = 80 MHz
>> + * CCP2       = 640 MHz
>> + * VCO        = 640 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 137 (3288)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 200
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_POWERON,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3288,
>> +		.height = 2016,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 2592,
>> +		.window_height = 1968,
>> +		.pixel_clock = 80000000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 1207
>> +		},
>> +		.max_exp = 2012,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		/* Need to set firstly */
>> +		{ ET8EK8_REG_8BIT, 0x126C, 0xCC },
>> +		/* Strobe and Data of CCP2 delay are minimized. */
>> +		{ ET8EK8_REG_8BIT, 0x1269, 0x00 },
>> +		/* Refined value of Min H_COUNT  */
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
>> +		/* Frequency of SPCK setting (SPCK=MRCK) */
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
>> +		{ ET8EK8_REG_8BIT, 0x1241, 0x94 },
>> +		{ ET8EK8_REG_8BIT, 0x1242, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x124B, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1255, 0xFF },
>> +		{ ET8EK8_REG_8BIT, 0x1256, 0x9F },
>> +		{ ET8EK8_REG_8BIT, 0x1258, 0x00 },
>> +		/* From parallel out to serial out */
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 },
>> +		/* From w/ embeded data to w/o embeded data */
>> +		{ ET8EK8_REG_8BIT, 0x125E, 0xC0 },
>> +		/* CCP2 out is from STOP to ACTIVE */
>> +		{ ET8EK8_REG_8BIT, 0x1263, 0x98 },
>> +		{ ET8EK8_REG_8BIT, 0x1268, 0xC6 },
>> +		{ ET8EK8_REG_8BIT, 0x1434, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1163, 0x44 },
>> +		{ ET8EK8_REG_8BIT, 0x1166, 0x29 },
>> +		{ ET8EK8_REG_8BIT, 0x1140, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x1011, 0x24 },
>> +		{ ET8EK8_REG_8BIT, 0x1151, 0x80 },
>> +		{ ET8EK8_REG_8BIT, 0x1152, 0x23 },
>> +		/* Initial setting for improvement2 of lower frequency noise */
>> +		{ ET8EK8_REG_8BIT, 0x1014, 0x05 },
>> +		{ ET8EK8_REG_8BIT, 0x1033, 0x06 },
>> +		{ ET8EK8_REG_8BIT, 0x1034, 0x79 },
>> +		{ ET8EK8_REG_8BIT, 0x1423, 0x3F },
>> +		{ ET8EK8_REG_8BIT, 0x1424, 0x3F },
>> +		{ ET8EK8_REG_8BIT, 0x1426, 0x00 },
>> +		/* Switch of Preset-White-balance (0d:disable / 1d:enable) */
>> +		{ ET8EK8_REG_8BIT, 0x1439, 0x00 },
>> +		/* Switch of blemish correction (0d:disable / 1d:enable) */
>> +		{ ET8EK8_REG_8BIT, 0x161F, 0x60 },
>> +		/* Switch of auto noise correction (0d:disable / 1d:enable) */
>> +		{ ET8EK8_REG_8BIT, 0x1634, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1646, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1648, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x113E, 0x01 },
>> +		{ ET8EK8_REG_8BIT, 0x113F, 0x22 },
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode1_16VGA_2592x1968_13.12fps_DPCM10-8 */
>> +static struct et8ek8_reglist mode1_16vga_2592x1968_13_12fps_dpcm10_8 = {
>> +/* (without the +1)
>> + * SPCK       = 80 MHz
>> + * CCP2       = 560 MHz
>> + * VCO        = 560 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 128 (3072)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 175
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 6
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3072,
>> +		.height = 2016,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 2592,
>> +		.window_height = 1968,
>> +		.pixel_clock = 80000000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 1292
>> +		},
>> +		.max_exp = 2012,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x57 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x82 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x06 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x80 }, /* <-changed to v14 7E->80 */
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode3_4VGA_1296x984_29.99fps_DPCM10-8 */
>> +static struct et8ek8_reglist mode3_4vga_1296x984_29_99fps_dpcm10_8 = {
>> +/* (without the +1)
>> + * SPCK       = 96.5333333333333 MHz
>> + * CCP2       = 579.2 MHz
>> + * VCO        = 579.2 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 133 (3192)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 181
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 5
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3192,
>> +		.height = 1008,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 1296,
>> +		.window_height = 984,
>> +		.pixel_clock = 96533333,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 3000
>> +		},
>> +		.max_exp = 1004,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x5A },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x82 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x05 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x85 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode4_SVGA_864x656_29.88fps */
>> +static struct et8ek8_reglist mode4_svga_864x656_29_88fps = {
>> +/* (without the +1)
>> + * SPCK       = 80 MHz
>> + * CCP2       = 320 MHz
>> + * VCO        = 640 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 166 (3984)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 200
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 1
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3984,
>> +		.height = 672,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 864,
>> +		.window_height = 656,
>> +		.pixel_clock = 80000000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 2988
>> +		},
>> +		.max_exp = 668,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x71 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x62 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x62 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0xA6 },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode5_VGA_648x492_29.93fps */
>> +static struct et8ek8_reglist mode5_vga_648x492_29_93fps = {
>> +/* (without the +1)
>> + * SPCK       = 80 MHz
>> + * CCP2       = 320 MHz
>> + * VCO        = 640 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 221 (5304)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 200
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 1
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 5304,
>> +		.height = 504,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 648,
>> +		.window_height = 492,
>> +		.pixel_clock = 80000000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 2993
>> +		},
>> +		.max_exp = 500,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x71 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x61 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x61 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0xDD },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode2_16VGA_2592x1968_3.99fps */
>> +static struct et8ek8_reglist mode2_16vga_2592x1968_3_99fps = {
>> +/* (without the +1)
>> + * SPCK       = 80 MHz
>> + * CCP2       = 640 MHz
>> + * VCO        = 640 MHz
>> + * VCOUNT     = 254 (6096)
>> + * HCOUNT     = 137 (3288)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 200
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3288,
>> +		.height = 6096,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 2592,
>> +		.window_height = 1968,
>> +		.pixel_clock = 80000000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 399
>> +		},
>> +		.max_exp = 6092,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x07 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0xFE },
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode_648x492_5fps */
>> +static struct et8ek8_reglist mode_648x492_5fps = {
>> +/* (without the +1)
>> + * SPCK       = 13.3333333333333 MHz
>> + * CCP2       = 53.3333333333333 MHz
>> + * VCO        = 640 MHz
>> + * VCOUNT     = 84 (2016)
>> + * HCOUNT     = 221 (5304)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 200
>> + * VCO_DIV    = 5
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 1
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 5304,
>> +		.height = 504,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 648,
>> +		.window_height = 492,
>> +		.pixel_clock = 13333333,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 499
>> +		},
>> +		.max_exp = 500,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x64 },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x71 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x57 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x61 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x61 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0xDD },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x54 },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode3_4VGA_1296x984_5fps */
>> +static struct et8ek8_reglist mode3_4vga_1296x984_5fps = {
>> +/* (without the +1)
>> + * SPCK       = 49.4 MHz
>> + * CCP2       = 395.2 MHz
>> + * VCO        = 790.4 MHz
>> + * VCOUNT     = 250 (6000)
>> + * HCOUNT     = 137 (3288)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 247
>> + * VCO_DIV    = 1
>> + * SPCK_DIV   = 7
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3288,
>> +		.height = 3000,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 1296,
>> +		.window_height = 984,
>> +		.pixel_clock = 49400000,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 501
>> +		},
>> +		.max_exp = 2996,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x7B },
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x82 },
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x17 },
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x89 },
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0xFA },
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x88 }, /* CCP_LVDS_MODE/  */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +/* Mode_4VGA_1296x984_25fps_DPCM10-8 */
>> +static struct et8ek8_reglist mode_4vga_1296x984_25fps_dpcm10_8 = {
>> +/* (without the +1)
>> + * SPCK       = 84.2666666666667 MHz
>> + * CCP2       = 505.6 MHz
>> + * VCO        = 505.6 MHz
>> + * VCOUNT     = 88 (2112)
>> + * HCOUNT     = 133 (3192)
>> + * CKREF_DIV  = 2
>> + * CKVAR_DIV  = 158
>> + * VCO_DIV    = 0
>> + * SPCK_DIV   = 5
>> + * MRCK_DIV   = 7
>> + * LVDSCK_DIV = 0
>> + */
>> +	.type = ET8EK8_REGLIST_MODE,
>> +	.mode = {
>> +		.sensor_width = 2592,
>> +		.sensor_height = 1968,
>> +		.sensor_window_origin_x = 0,
>> +		.sensor_window_origin_y = 0,
>> +		.sensor_window_width = 2592,
>> +		.sensor_window_height = 1968,
>> +		.width = 3192,
>> +		.height = 1056,
>> +		.window_origin_x = 0,
>> +		.window_origin_y = 0,
>> +		.window_width = 1296,
>> +		.window_height = 984,
>> +		.pixel_clock = 84266667,
>> +		.ext_clock = 9600000,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 2500
>> +		},
>> +		.max_exp = 1052,
>> +		/* .max_gain = 0, */
>> +		.pixel_format = V4L2_PIX_FMT_SGRBG10DPCM8,
>> +		.sensitivity = 65536
>> +	},
>> +	.regs = {
>> +		{ ET8EK8_REG_8BIT, 0x1239, 0x4F },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x123A, 0x05 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x1220, 0x85 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x1222, 0x58 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },	/*        */
>> +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 },	/*        */
>> +		{ ET8EK8_REG_TERM, 0, 0}
>> +	}
>> +};
>> +
>> +struct et8ek8_meta_reglist meta_reglist = {
>> +	.magic   = ET8EK8_MAGIC,
>> +	.version = "V14 03-June-2008",
>> +	.reglist = {
>> +		{ .ptr = &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
>> +		{ .ptr = &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
>> +		{ .ptr = &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
>> +		{ .ptr = &mode4_svga_864x656_29_88fps },
>> +		{ .ptr = &mode5_vga_648x492_29_93fps },
>> +		{ .ptr = &mode2_16vga_2592x1968_3_99fps },
>> +		{ .ptr = &mode_648x492_5fps },
>> +		{ .ptr = &mode3_4vga_1296x984_5fps },
>> +		{ .ptr = &mode_4vga_1296x984_25fps_dpcm10_8 },
>> +		{ .ptr = 0 }
>> +	}
>> +};
>> diff --git a/drivers/media/i2c/et8ek8/et8ek8_reg.h b/drivers/media/i2c/et8ek8/et8ek8_reg.h
>> new file mode 100644
>> index 0000000..1f138b0
>> --- /dev/null
>> +++ b/drivers/media/i2c/et8ek8/et8ek8_reg.h
>> @@ -0,0 +1,100 @@
>> +/*
>> + * et8ek8.h
>> + *
>> + * Copyright (C) 2008 Nokia Corporation
>> + *
>> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
>> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
>
> tuukkat76@gmail.com
>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#ifndef ET8EK8REGS_H
>> +#define ET8EK8REGS_H
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/types.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/v4l2-subdev.h>
>> +
>> +struct v4l2_mbus_framefmt;
>> +struct v4l2_subdev_pad_mbus_code_enum;
>> +
>> +#define ET8EK8_MAGIC			0x531A0002
>> +
>> +struct et8ek8_mode {
>> +	/* Physical sensor resolution and current image window */
>> +	__u16 sensor_width;
>> +	__u16 sensor_height;
>> +	__u16 sensor_window_origin_x;
>> +	__u16 sensor_window_origin_y;
>> +	__u16 sensor_window_width;
>> +	__u16 sensor_window_height;
>> +
>> +	/* Image data coming from sensor (after scaling) */
>> +	__u16 width;
>> +	__u16 height;
>> +	__u16 window_origin_x;
>> +	__u16 window_origin_y;
>> +	__u16 window_width;
>> +	__u16 window_height;
>> +
>> +	__u32 pixel_clock;		/* in Hz */
>> +	__u32 ext_clock;		/* in Hz */
>> +	struct v4l2_fract timeperframe;
>> +	__u32 max_exp;			/* Maximum exposure value */
>> +	__u32 pixel_format;		/* V4L2_PIX_FMT_xxx */
>> +	__u32 sensitivity;		/* 16.16 fixed point */
>> +};
>> +
>> +#define ET8EK8_REG_8BIT			1
>> +#define ET8EK8_REG_16BIT		2
>> +#define ET8EK8_REG_32BIT		4
>> +#define ET8EK8_REG_DELAY		100
>> +#define ET8EK8_REG_TERM			0xff
>> +struct et8ek8_reg {
>> +	u16 type;
>> +	u16 reg;			/* 16-bit offset */
>> +	u32 val;			/* 8/16/32-bit value */
>> +};
>> +
>> +/* Possible struct smia_reglist types. */
>> +#define ET8EK8_REGLIST_STANDBY		0
>> +#define ET8EK8_REGLIST_POWERON		1
>> +#define ET8EK8_REGLIST_RESUME		2
>> +#define ET8EK8_REGLIST_STREAMON		3
>> +#define ET8EK8_REGLIST_STREAMOFF	4
>> +#define ET8EK8_REGLIST_DISABLED		5
>> +
>> +#define ET8EK8_REGLIST_MODE		10
>> +
>> +#define ET8EK8_REGLIST_LSC_ENABLE	100
>> +#define ET8EK8_REGLIST_LSC_DISABLE	101
>> +#define ET8EK8_REGLIST_ANR_ENABLE	102
>> +#define ET8EK8_REGLIST_ANR_DISABLE	103
>> +
>> +struct et8ek8_reglist {
>> +	u32 type;
>> +	struct et8ek8_mode mode;
>> +	struct et8ek8_reg regs[];
>> +};
>> +
>> +#define ET8EK8_MAX_LEN			32
>> +struct et8ek8_meta_reglist {
>> +	u32 magic;
>
> The field is useless as is ET8EK8_MAGIC. It was there to avoid loading
> garbage by accident by using request_firmware(). Please remove.
>

ok

>> +	char version[ET8EK8_MAX_LEN];
>> +	union {
>> +		struct et8ek8_reglist *ptr;
>> +	} reglist[];
>> +};
>> +
>> +extern struct et8ek8_meta_reglist meta_reglist;
>> +
>> +#endif /* ET8EK8REGS */
>> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
>> index b6a357a..97a08d8 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -180,6 +180,11 @@ enum v4l2_colorfx {
>>    * We reserve 16 controls for this driver. */
>>   #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
>>
>> +/* The base for the et8ek8 driver controls.
>> + * We reserve 16 controls for this driver.
>> + */
>> +#define V4L2_CID_USER_ET8EK8_BASE		(V4L2_CID_USER_BASE + 0x1090)
>> +
>>   /* MPEG-class control IDs */
>>   /* The MPEG controls are applicable to all codec controls
>>    * and the 'MPEG' part of the define is historical */
>

Please elaborate on "If you have custom controls,", see above, so I will 
be able to fix it and send a new version.

Thanks,
Ivo
