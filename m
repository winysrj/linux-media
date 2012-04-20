Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab2DTRIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 13:08:35 -0400
Message-ID: <4F91980F.7020604@redhat.com>
Date: Fri, 20 Apr 2012 14:08:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] m88ds3103, dvbsky dvb-s2 usb box.
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353240317150@gmail.com> <201204201608550936479@gmail.com>
In-Reply-To: <201204201608550936479@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-04-2012 05:08, nibble.max escreveu:
> 2012-04-20 16:02:41 nibble.max@gmail.com
>> Em 15-04-2012 12:53, nibble.max escreveu:
>>> +static struct dvb_usb_device_properties US6830_properties = {
>>> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
>>> +	.usb_ctrl = DEVICE_SPECIFIC,
>>> +	.size_of_priv = sizeof(struct su3000_state),
>>> +	.power_ctrl = su3000_power_ctrl,
>>> +	.num_adapters = 1,
>>> +	.identify_state	= su3000_identify_state,
>>> +	.i2c_algo = &su3000_i2c_algo,
>>> +
>>> +	.rc.legacy = {
>>> +		.rc_map_table = rc_map_su3000_table,
>>> +		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
>>> +		.rc_interval = 150,
>>> +		.rc_query = dw2102_rc_query,
>>> +	},
>>
>>
>> New drivers should use .rc.core instead. For a simple example on how to use,
>> please take a look at the az6007 driver.
>>
> It is strange to me that I need write two keymaps for one remote controller, one for USB box, the other for pcie cards.
> rc.core will save my time to keep one keymap for all. :)
> 

One remote controller just needs one keymap file. If the same IR requires two different
tables, then something is wrong at the get_key function (or, for drivers where only the
lower 8bits are returned - the IR mask is not properly set).

Regards,
Mauro
