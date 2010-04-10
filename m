Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36785 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0DJBL7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 21:11:59 -0400
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
From: Andy Walls <awalls@radix.net>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@redhat.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20100408230440.14453.36936.stgit@localhost.localdomain>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
	 <20100408230440.14453.36936.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 21:12:08 -0400
Message-Id: <1270861928.3038.153.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-09 at 01:04 +0200, David Härdeman wrote:
> This patch adds an RC6 decoder (modes 0 and 6A) to ir-core.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

David,

Overall, a nice job of implementing RC6 decoder logic.  I have a few
comments below (along with some of me reasoning to myself out loud).


> ---
>  drivers/media/IR/Kconfig          |    9 +
>  drivers/media/IR/Makefile         |    1 
>  drivers/media/IR/ir-core-priv.h   |    7 +
>  drivers/media/IR/ir-raw-event.c   |    1 
>  drivers/media/IR/ir-rc6-decoder.c |  412 +++++++++++++++++++++++++++++++++++++
>  drivers/media/IR/ir-sysfs.c       |    2 
>  include/media/rc-map.h            |    1 
>  7 files changed, 433 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/IR/ir-rc6-decoder.c
> 
> diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
> index ba81bda..28d336d 100644
> --- a/drivers/media/IR/Kconfig
> +++ b/drivers/media/IR/Kconfig
> @@ -27,3 +27,12 @@ config IR_RC5_DECODER
>  	---help---
>  	   Enable this option if you have IR with RC-5 protocol, and
>  	   if the IR is decoded in software
> +
> +config IR_RC6_DECODER
> +	tristate "Enable IR raw decoder for the RC6 protocol"
> +	depends on IR_CORE
> +	default y
> +
> +	---help---
> +	   Enable this option if you have an infrared remote control which
> +	   uses the RC6 protocol, and you need software decoding support.
> diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
> index 62e12d5..792d9ca 100644
> --- a/drivers/media/IR/Makefile
> +++ b/drivers/media/IR/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_IR_CORE) += ir-core.o
>  obj-$(CONFIG_VIDEO_IR) += ir-common.o
>  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
>  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
> +obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
> diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> index ab785bc..853ec80 100644
> --- a/drivers/media/IR/ir-core-priv.h
> +++ b/drivers/media/IR/ir-core-priv.h
> @@ -109,4 +109,11 @@ void ir_raw_init(void);
>  #define load_rc5_decode()	0
>  #endif
>  
> +/* from ir-rc6-decoder.c */
> +#ifdef CONFIG_IR_RC5_DECODER_MODULE
> +#define load_rc6_decode()	request_module("ir-rc6-decoder")
> +#else
> +#define load_rc6_decode()	0
> +#endif
> +
>  #endif /* _IR_RAW_EVENT */
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index 2efc051..ef0f231 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -224,6 +224,7 @@ static void init_decoders(struct work_struct *work)
>  
>  	load_nec_decode();
>  	load_rc5_decode();
> +	load_rc6_decode();
>  
>  	/* If needed, we may later add some init code. In this case,
>  	   it is needed to change the CONFIG_MODULE test at ir-core.h
> diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
> new file mode 100644
> index 0000000..ccc5be2
> --- /dev/null
> +++ b/drivers/media/IR/ir-rc6-decoder.c
> @@ -0,0 +1,412 @@
> +/* ir-rc6-decoder.c - A decoder for the RC6 IR protocol
> + *
> + * Copyright (C) 2010 by David Härdeman <david@hardeman.nu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "ir-core-priv.h"
> +
> +/*
> + * This decoder currently supports:
> + * RC6-0-16	(standard toggle bit in header)
> + * RC6-6A-24	(no toggle bit)
> + * RC6-6A-32	(MCE version with toggle bit in body)
> + */

Just for reference for review:

http://slycontrol.ru/scr/kb/rc6.htm
http://www.picbasic.nl/info_rc6_uk.htm


RC6 Mode 0:

prefix mark:  111111
prefix space: 00
start bit:    10           (biphase encoding of '1')
mode bits:    010101       (biphase encoding of '000')
toggle bits:  0011 or 1100 (double duration biphase coding of '0' or '1')
system byte:  xxxxxxxxxxxxxxxx (biphase encoding of 8 bits)
command byte: yyyyyyyyyyyyyyyy (biphase encoding of 8 bits)

RC6 Mode 6A:

prefix mark:   111111
prefix space:  00
start bit:     10           (biphase encoding of '1')
mode bits:     101001       (biphase encoding of '110' for '6') 
trailer bits:  0011         (double duration biphase encoding of '0' for 'A')
customer len:  01 or 10     (biphase encoding of '0' for 7 bits or '1' for 15 bits)
customer bits: xxxxxxxxxxxxxx (biphase encoding of 7 bits for a short customer code)
		or
               xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (biphase encoding of 15 bits for a long customer code)
system byte:   yyyyyyyyyyyyyyyy (biphase encoding of 8 bits)
command byte:  zzzzzzzzzzzzzzzz (biphase encoding of 8 bits)


> +#define RC6_UNIT		444444	/* us */
> +#define RC6_HEADER_NBITS	4	/* not including toggle bit */
> +#define RC6_0_NBITS		16
> +#define RC6_6A_SMALL_NBITS	24
> +#define RC6_6A_LARGE_NBITS	32

According to the slycontrol.ru website, the data length is, in theory
OEM dependent for Mode 6A, limited to a max of 24 bits (3 bytes) after a
short customer code and 128 bits (16 bytes) after a long customer code.

I don't know what the reality is for existing remotes.

Would it be better to look for the signal free time of 6 RC6_UNITs to
declare the end of reception, instead of a bit count?


> +#define RC6_PREFIX_PULSE	PULSE(6)
> +#define RC6_PREFIX_SPACE	SPACE(2)
> +#define RC6_MODE_MASK		0x07	/* for the header bits */
> +#define RC6_STARTBIT_MASK	0x08	/* for the header bits */
> +#define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */

That's an OEM specific toggle bit.  It is likely more properly named
RC6_6A_MS_TOGGLE_MASK.  See slide 6 of:

http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWEN05007_WinHEC05.ppt

(Although in reality, every remote that wants to work with stock MS
drivers will use it.)

> +
> +/* Used to register rc6_decoder clients */
> +static LIST_HEAD(decoder_list);
> +static DEFINE_SPINLOCK(decoder_lock);
> +
> +enum rc6_mode {
> +	RC6_MODE_0,
> +	RC6_MODE_6A,
> +	RC6_MODE_UNKNOWN,
> +};
> +
> +enum rc6_state {
> +	STATE_INACTIVE,
> +	STATE_PREFIX_SPACE,
> +	STATE_HEADER_BIT_START,
> +	STATE_HEADER_BIT_END,
> +	STATE_TOGGLE_START,
> +	STATE_TOGGLE_END,
> +	STATE_BODY_BIT_START,
> +	STATE_BODY_BIT_END,
> +	STATE_FINISHED,
> +};
> +
> +struct decoder_data {
> +	struct list_head	list;
> +	struct ir_input_dev	*ir_dev;
> +	int			enabled:1;
> +
> +	/* State machine control */
> +	enum rc6_state		state;
> +	u8			header;
> +	u32			body;
> +	int			last_unit;
> +	bool			toggle;
> +	unsigned		count;
> +	unsigned		wanted_bits;
> +};
> +
> +
> +/**
> + * get_decoder_data()	- gets decoder data
> + * @input_dev:	input device
> + *
> + * Returns the struct decoder_data that corresponds to a device
> + */
> +static struct decoder_data *get_decoder_data(struct  ir_input_dev *ir_dev)
> +{
> +	struct decoder_data *data = NULL;
> +
> +	spin_lock(&decoder_lock);
> +	list_for_each_entry(data, &decoder_list, list) {
> +		if (data->ir_dev == ir_dev)
> +			break;
> +	}
> +	spin_unlock(&decoder_lock);
> +	return data;
> +}
> +
> +static ssize_t store_enabled(struct device *d,
> +			     struct device_attribute *mattr,
> +			     const char *buf,
> +			     size_t len)
> +{
> +	unsigned long value;
> +	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
> +	struct decoder_data *data = get_decoder_data(ir_dev);
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	if (strict_strtoul(buf, 10, &value) || value > 1)
> +		return -EINVAL;
> +
> +	data->enabled = value;
> +
> +	return len;
> +}
> +
> +static ssize_t show_enabled(struct device *d,
> +			     struct device_attribute *mattr, char *buf)
> +{
> +	struct ir_input_dev *ir_dev = dev_get_drvdata(d);
> +	struct decoder_data *data = get_decoder_data(ir_dev);
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	if (data->enabled)
> +		return sprintf(buf, "1\n");
> +	else
> +	return sprintf(buf, "0\n");
> +}
> +
> +static DEVICE_ATTR(enabled, S_IRUGO | S_IWUSR, show_enabled, store_enabled);
> +
> +static struct attribute *decoder_attributes[] = {
> +	&dev_attr_enabled.attr,
> +	NULL
> +};
> +
> +static struct attribute_group decoder_attribute_group = {
> +	.name	= "rc6_decoder",
> +	.attrs	= decoder_attributes,
> +};
> +
> +static enum rc6_mode rc6_mode(struct decoder_data *data) {
> +	switch (data->header & RC6_MODE_MASK) {
> +	case 0:
> +		return RC6_MODE_0;
> +	case 6:
> +		if (!data->toggle)
> +			return RC6_MODE_6A;
> +		/* fall through */
> +	default:
> +		return RC6_MODE_UNKNOWN;
> +	}
> +}
> +
> +/**
> + * ir_rc6_decode() - Decode one RC6 pulse or space
> + * @input_dev:	the struct input_dev descriptor of the device
> + * @duration:	duration of pulse/space in ns
> + *
> + * This function returns -EINVAL if the pulse violates the state machine
> + */
> +static int ir_rc6_decode(struct input_dev *input_dev, s64 duration)
> +{
> +	struct decoder_data *data;
> +	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> +	u32 scancode;
> +	u8 toggle;
> +	int u;
> +
> +	data = get_decoder_data(ir_dev);
> +	if (!data)
> +		return -EINVAL;
> +
> +	if (!data->enabled)
> +		return 0;
> +
> +	if (IS_RESET(duration)) {
> +		data->state = STATE_INACTIVE;
> +		return 0;
> +	}
> +
> +	u =  TO_UNITS(duration, RC6_UNIT);
> +	if (DURATION(u) == 0)
> +		goto out;
> +
> +again:
> +	IR_dprintk(2, "RC6 decode started at state %i (%i units, %ius)\n",
> +		   data->state, u, TO_US(duration));
> +
> +	if (DURATION(u) == 0 && data->state != STATE_FINISHED)
> +		return 0;

Isn't there a better way to structure the logic to break up two adjacent
pulse units than with goto's out of the switch back up to here?

A do {} while() loop would have been much clearer.



> +	switch (data->state) {
> +
> +	case STATE_INACTIVE:
> +		if (u >= RC6_PREFIX_PULSE - 1 && u <= RC6_PREFIX_PULSE + 1) {
> +			data->state = STATE_PREFIX_SPACE;
> +			data->count = 0;
> +			return 0;
> +		}
> +		break;
> +
> +	case STATE_PREFIX_SPACE:
> +		if (u == RC6_PREFIX_SPACE) {
> +			data->state = STATE_HEADER_BIT_START;
> +			return 0;
> +		}
> +		break;
> +
> +	case STATE_HEADER_BIT_START:
> +		if (DURATION(u) == 1) {
> +			data->header <<= 1;
> +			if (IS_PULSE(u))
> +				data->header |= 1;
> +			data->count++;
> +			data->last_unit = u;
> +			data->state = STATE_HEADER_BIT_END;
> +			return 0;
> +		}
> +		break;
> +
> +	case STATE_HEADER_BIT_END:
> +		if (IS_TRANSITION(u, data->last_unit)) {
> +			if (data->count == RC6_HEADER_NBITS)
> +				data->state = STATE_TOGGLE_START;
> +			else
> +				data->state = STATE_HEADER_BIT_START;
> +
> +			DECREASE_DURATION(u, 1);
> +			goto again;
> +		}
> +		break;
> +
> +	case STATE_TOGGLE_START:
> +		if (DURATION(u) == 2) {
> +			data->toggle = IS_PULSE(u);
> +			data->last_unit = u;
> +			data->state = STATE_TOGGLE_END;
> +			return 0;
> +		}
> +		break;
> +
> +	case STATE_TOGGLE_END:
> +		if (IS_TRANSITION(u, data->last_unit) && DURATION(u) >= 2) {
> +			data->state = STATE_BODY_BIT_START;
> +			data->last_unit = u;
> +			DECREASE_DURATION(u, 2);
> +			data->count = 0;
> +
> +			if (!(data->header & RC6_STARTBIT_MASK)) {
> +				IR_dprintk(1, "RC6 invalid start bit\n");
> +				break;
> +			}
> +
> +			switch (rc6_mode(data)) {
> +			case RC6_MODE_0:
> +				data->wanted_bits = RC6_0_NBITS;
> +				break;
> +			case RC6_MODE_6A:
> +				/* This might look weird, but we basically
> +				   check the value of the first body bit to
> +				   determine the number of bits in mode 6A */

This bit basically only tells you the length of the customer code: 7 or
15 bits.  


> +				if ((DURATION(u) == 0 && IS_SPACE(data->last_unit)) || DURATION(u) > 0)
> +					data->wanted_bits = RC6_6A_LARGE_NBITS;
> +				else
> +					data->wanted_bits = RC6_6A_SMALL_NBITS;
> +				break;
> +			default:
> +				IR_dprintk(1, "RC6 unknown mode\n");
> +				goto out;
> +			}
> +			goto again;
> +		}
> +		break;
> +
> +	case STATE_BODY_BIT_START:
> +		if (DURATION(u) == 1) {
> +			data->body <<= 1;
> +			if (IS_PULSE(u))
> +				data->body |= 1;
> +			data->count++;
> +			data->last_unit = u;
> +
> +			/*
> +			 * If the last bit is one, a space will merge
> +			 * with the silence after the command.
> +			 */
> +			if (IS_PULSE(u) && data->count == data->wanted_bits) {
> +				data->state = STATE_FINISHED;
> +				goto again;
> +			}
> +
> +			data->state = STATE_BODY_BIT_END;
> +			return 0;
> +		}
> +		break;
> +
> +	case STATE_BODY_BIT_END:
> +		if (IS_TRANSITION(u, data->last_unit)) {
> +			if (data->count == data->wanted_bits)
> +				data->state = STATE_FINISHED;
> +			else
> +				data->state = STATE_BODY_BIT_START;
> +
> +			DECREASE_DURATION(u, 1);
> +			goto again;
> +		}
> +		break;
> +
> +	case STATE_FINISHED:
> +		switch (rc6_mode(data)) {
> +		case RC6_MODE_0:
> +			scancode = data->body & 0xffff;
> +			toggle = data->toggle;
> +			IR_dprintk(1, "RC6(0) scancode 0x%04x (toggle: %u)\n",
> +				   scancode, toggle);
> +			break;
> +		case RC6_MODE_6A:
> +			if (data->wanted_bits == RC6_6A_LARGE_NBITS) {
> +				toggle = data->body & RC6_6A_MCE_TOGGLE_MASK ? 1 : 0;
> +				scancode = data->body & ~RC6_6A_MCE_TOGGLE_MASK;

Technically this depends on the OEM.  In reality, every RC6 Mode 6A
remote that wants to work with Microsoft stock drivers will likely use
this bit as a toggle.

Regards,
Andy

> +			} else {
> +				toggle = 0;
> +				scancode = data->body & 0xffffff;
> +			}
> +
> +			IR_dprintk(1, "RC6(6A) scancode 0x%08x (toggle: %u)\n",
> +				   scancode, toggle);
> +			break;
> +		default:
> +			IR_dprintk(1, "RC6 unknown mode\n");
> +			goto out;
> +		}
> +
> +		ir_keydown(input_dev, scancode, toggle);
> +		data->state = STATE_INACTIVE;
> +		return 0;
> +	}
> +
> +out:
> +	IR_dprintk(1, "RC6 decode failed at state %i (%i units, %ius)\n",
> +		   data->state, u, TO_US(duration));
> +	data->state = STATE_INACTIVE;
> +	return -EINVAL;
> +}
> +
> +static int ir_rc6_register(struct input_dev *input_dev)
> +{
> +	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> +	struct decoder_data *data;
> +	int rc;
> +
> +	rc = sysfs_create_group(&ir_dev->dev.kobj, &decoder_attribute_group);
> +	if (rc < 0)
> +		return rc;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
> +		return -ENOMEM;
> +	}
> +
> +	data->ir_dev = ir_dev;
> +	data->enabled = 1;
> +
> +	spin_lock(&decoder_lock);
> +	list_add_tail(&data->list, &decoder_list);
> +	spin_unlock(&decoder_lock);
> +
> +	return 0;
> +}
> +
> +static int ir_rc6_unregister(struct input_dev *input_dev)
> +{
> +	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> +	static struct decoder_data *data;
> +
> +	data = get_decoder_data(ir_dev);
> +	if (!data)
> +		return 0;
> +
> +	sysfs_remove_group(&ir_dev->dev.kobj, &decoder_attribute_group);
> +
> +	spin_lock(&decoder_lock);
> +	list_del(&data->list);
> +	spin_unlock(&decoder_lock);
> +
> +	return 0;
> +}
> +
> +static struct ir_raw_handler rc6_handler = {
> +	.decode		= ir_rc6_decode,
> +	.raw_register	= ir_rc6_register,
> +	.raw_unregister	= ir_rc6_unregister,
> +};
> +
> +static int __init ir_rc6_decode_init(void)
> +{
> +	ir_raw_handler_register(&rc6_handler);
> +
> +	printk(KERN_INFO "IR RC6 protocol handler initialized\n");
> +	return 0;
> +}
> +
> +static void __exit ir_rc6_decode_exit(void)
> +{
> +	ir_raw_handler_unregister(&rc6_handler);
> +}
> +
> +module_init(ir_rc6_decode_init);
> +module_exit(ir_rc6_decode_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("David Härdeman <david@hardeman.nu>");
> +MODULE_DESCRIPTION("RC6 IR protocol decoder");
> diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
> index a222d4f..d7ec973 100644
> --- a/drivers/media/IR/ir-sysfs.c
> +++ b/drivers/media/IR/ir-sysfs.c
> @@ -60,6 +60,8 @@ static ssize_t show_protocol(struct device *d,
>  		s = "pulse-distance";
>  	else if (ir_type == IR_TYPE_NEC)
>  		s = "nec";
> +	else if (ir_type == IR_TYPE_RC6)
> +		s = "rc6";
>  	else
>  		s = "other";
>  
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 3b7fe5a..11f6618 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -15,6 +15,7 @@
>  #define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
>  #define IR_TYPE_PD	(1  << 1)	/* Pulse distance encoded IR */
>  #define IR_TYPE_NEC	(1  << 2)
> +#define IR_TYPE_RC6	(1  << 3)	/* Philips RC6 protocol */
>  #define IR_TYPE_OTHER	(1u << 31)
>  
>  struct ir_scancode {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

