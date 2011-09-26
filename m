Return-path: <linux-media-owner@vger.kernel.org>
Received: from moh2-ve1.go2.pl ([193.17.41.186]:47723 "EHLO moh2-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1IZVhK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 17:37:10 -0400
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
	by moh2-ve1.go2.pl (Postfix) with ESMTP id A433D44E3C1
	for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 23:37:08 +0200 (CEST)
Received: from unknown (unknown [10.0.0.142])
	by moh2-ve1.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 23:37:08 +0200 (CEST)
Message-ID: <4E80F080.7030500@o2.pl>
Date: Mon, 26 Sep 2011 23:37:04 +0200
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Martin Wilks <m.wilks@technisat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Arnaud Lacombe <lacombar@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sven Barth <pascaldragon@googlemail.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH]Medion 95700 analog video support
References: <4E63C8A0.7030702@o2.pl>  <CAOcJUbzXKVoOsfLA+YewyfDKmxuX0PgB8mWdfG49ArdS1fpyfA@mail.gmail.com>  <4E7CDEB1.9090901@infradead.org>  <CAOcJUby0dK_sjhTB3HEfdxkc9rsWU9KkZ=2B4O=Tcn4E90AE2w@mail.gmail.com>  <c651371a-b2c4-4e95-bbb3-5b97a8b7281e@email.android.com>  <4E7CF707.7060800@o2.pl> <1316895712.12899.84.camel@palomino.walls.org>
In-Reply-To: <1316895712.12899.84.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 24.09.2011 22:21, Andy Walls pisze:
> Hi Maciej,
> 
> I'll try and comment on the specific areas below, but overall the
> problem is this:
> 
> 1. The default setup and behavior of the cx25840 module was written
> around hardware designs supported by the ivtv driver: i.e. interfacing
> to a CX23416 MPEG encoder.
> 
> 2. The ivtv and pvrusb2 drivers rely on that default setup and behavior
> of the cx25840 module.
> 
> 3. The PVR-150 and PVR-500 are very popular cards supported by ivtv that
> use a CX25843 and CX23416.  Many MythTV users still have these cards in
> service.
> 
> 4. The ivtv driver also supports other hardware designs that use
> different encoders, so trying fix ivtv to match new changes in the
> cx25840 will ripples along to other analog video decoder drivers.  This
> would result in a lot of time to perform regression testing with as many
> different ivtv supported capture cards as possible. 
> 
> 
> What I recommend is that you rework your changes so that the cx25840
> module is provided information by the bridge driver as to the board
> model, and then have the cx25840 module behave appropriately based on
> the board information passed in by the bridge driver.
> 
> 1. Add whatever data fields you think you need to the "struct
> cx25840_platform_data" structure in include/media/cx25840.h.  Maybe
> something as simple as "bool is_medion95700"
> 
> 2. In cxusb-analog.c you instantiate the cx25840 sub-device with
> v4l2_i2c_new_subdev_board() with the cx25840 platform data filled in as
> needed for the Medion 95700.  Look at
> drivers/media/video/ivtv/ivtv-i2c.c:ivtv_i2c_register() for an example
> of how this is done for the cx25840 module.
> 
> 3. Modify the cx25840 module to behave as you need it if the platform
> data indicates a Medion 95700; otherwise, leave the default cx25840
> setup and behavior.
> 

Hi Andy,

Thanks for you detailed explanation, I did not know that ivtv boards are that
quirky with regard to VBI capture.
I will do as you wrote above, make my changes to cx25840 driver conditional, 
so ivtv won't be affected.

> Any specific comments I have are in-line below:
> 
>> @@ -18,6 +18,9 @@
>>   * CX2388[578] IRQ handling, IO Pin mux configuration and other small fixes are
>>   * Copyright (C) 2010 Andy Walls <awalls@md.metrocast.net>
>>   *
>> + * CX2384x pin to pad mapping and output format configuration support are
>       ^^^^^^^
> CX2584x?
>>  	if ((fmt->width * 16 < Hsrc) || (Hsrc < fmt->width) ||
>>  			(Vlines * 8 < Vsrc) || (Vsrc < Vlines)) {
>> @@ -1403,6 +1695,112 @@ static void log_audio_status(struct i2c_client *client)
>>  	}
>>  }
>>  
>> +#define CX25480_VCONFIG_OPTION(option_mask) \
>            ^^^^^^
> CX25840?
> 
>> +	if (config_in & option_mask) { \
>> +		state->vid_config &= ~(option_mask); \
>> +		state->vid_config |= config_in & option_mask; \
>> +	} \
>> +
>> +#define CX25480_VCONFIG_SET_BIT(optionmask, reg, bit, oneval) \
>            ^^^^^^
> CX25840?
> 

You mean here that it should be named consistently either as CX2584x or CX25840?

>>  	return set_input(client, input, state->aud_input);
>>  }
>>  
>> @@ -1877,7 +2278,7 @@ static int cx25840_probe(struct i2c_client *client,
>>  	u16 device_id;
>>  
>>  	/* Check if the adapter supports the needed features */
>> -	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
>>  		return -EIO;
> 
> On the surface, this change doesn't appear to adversely affect the ivtv,
> pvrusb2, cx23885, and cx231xx bridge drivers.  
> 
> I would need to take a hard look at the CX2584[0123], CX2583[67],
> CX2388[578], and CX2310[12] datasheets to see why, and if, all the Mako
> core variants require I2C_FUNC_SMBUS_BYTE_DATA.
> 
> However, if the cxusb bridge has a full I2C master, shouldn't the cxusb
> driver be specifying (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL) as its
> functionality?  See Documentation/i2c/functionality.

Adding I2C_FUNC_SMBUS_EMUL flag to cxusb i2c host seems to be a right thing to do for now,
but I would be very surprised if any of Conexant video decoders actually used SMBus instead
of plain I2C.

Best regards,
Maciej Szmigiero


