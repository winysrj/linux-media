Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42636 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbAEL7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 06:59:43 -0500
Received: by mail-pd0-f174.google.com with SMTP id fp1so27949126pdb.19
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 03:59:43 -0800 (PST)
Message-ID: <54AA7CAA.2070203@gmail.com>
Date: Mon, 05 Jan 2015 20:59:38 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, tskd08@gmail.com
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com> <20141230111051.7aeff58a@concha.lan>
In-Reply-To: <20141230111051.7aeff58a@concha.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thank you for the comment.
I understood the naming conventions you mentioned,
and I'll update them in the next version.

>> diff --git a/drivers/media/dvb-core/dvb_i2c.c b/drivers/media/dvb-core/dvb_i2c.c
>> new file mode 100644
>> index 0000000..4ea4e5e
>> --- /dev/null
>> +++ b/drivers/media/dvb-core/dvb_i2c.c
....
>> +static struct i2c_client *
>> +dvb_i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info *info,
>> +		   const unsigned short *probe_addrs)
>> +{
>> +	struct i2c_client *cl;
>> +
>> +	request_module(I2C_MODULE_PREFIX "%s", info->type);
>> +	/* Create the i2c client */
>> +	if (info->addr == 0 && probe_addrs)
>> +		cl = i2c_new_probed_device(adap, info, probe_addrs, NULL);
>> +	else
>> +		cl = i2c_new_device(adap, info);
>> +	if (!cl || !cl->dev.driver)
>> +		return NULL;
>> +	return cl;
> 
> The best would be to also register the device with the media controller,
> if CONFIG_MEDIA_CONTROLLER is defined, just like v4l2_i2c_subdev_init()
> does.

I'll comment to your patch on this.

> I would also try to use similar names for the function calls to the ones
> that the v4l subsystem uses for subdevices.

So the name should be dvb_i2c_new_subdev()?
I am a bit worried that it would be rather confusing because
this func is different from v4l2_i2c_new_subdev() in that
it does not return "struct dvb_frontend *", requires info.platform_data parameter,
and is a static/internal function.

One more thing that I'm wondering about is whether we should add fe->demod_i2c_bus
to support tuner devices on a (dedicated) i2c bus hosted on a demod device.
I guess that this structure is pretty common (to reduce noise),
and this removes i2c_adapter from "out" structure and
confines the usage of "out" structure to just device-specific ones.

--
akihiro 

