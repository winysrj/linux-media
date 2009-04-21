Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4600 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZDUJ3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 05:29:04 -0400
Message-ID: <19335.62.70.2.252.1240306140.squirrel@webmail.xs4all.nl>
Date: Tue, 21 Apr 2009 11:29:00 +0200 (CEST)
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tue, 21 Apr 2009, Hans Verkuil wrote:
>
>>
>> > Video (sub)devices, connecting to SoCs over generic i2c busses cannot
>> > provide a pointer to struct v4l2_device in i2c-adapter driver_data,
>> and
>> > provide their own i2c_board_info data, including a platform_data
>> field.
>> > Add a v4l2_i2c_new_dev_subdev() API function that does exactly the
>> same as
>> > v4l2_i2c_new_subdev() but uses different parameters, and make
>> > v4l2_i2c_new_subdev() a wrapper around it.
>>
>> Huh? Against what repository are you compiling? The v4l2_device pointer
>> has already been added!
>
> Ok, have to rebase then. I guess, it still would be better to do the way I
> propose in this patch - to add a new function, with i2c_board_info as a
> parameter and convert v4l2_i2c_new_subdev() to a wrapper around it, than
> to convert all existing users, agree? Do you also agree with the name?

I like the idea of passing in a board_info struct instead of an
addr/client_type. Just make sure when preparing a patch for the v4l-dvb
repo that this new function is for kernels >= 2.6.26 only.

I prefer a name like v4l2_i2c_subdev_board(). I will probably at some
stage remove that '_new' part of the existing functions anyway as that
doesn't add anything to the name.

Regards,

       Hans

>
> Thanks
> Guennadi
>
>>
>> Regards,
>>
>>          Hans
>>
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> > diff --git a/drivers/media/video/v4l2-common.c
>> > b/drivers/media/video/v4l2-common.c
>> > index 1da8cb8..c55fc99 100644
>> > --- a/drivers/media/video/v4l2-common.c
>> > +++ b/drivers/media/video/v4l2-common.c
>> > @@ -783,8 +783,6 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd,
>> > struct i2c_client *client,
>> >  }
>> >  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
>> >
>> > -
>> > -
>> >  /* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
>> >     returns the v4l2_device and that i2c_get_clientdata(client)
>> >     returns the v4l2_subdev. */
>> > @@ -792,23 +790,34 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct
>> > i2c_adapter *adapter,
>> >  		const char *module_name, const char *client_type, u8 addr)
>> >  {
>> >  	struct v4l2_device *dev = i2c_get_adapdata(adapter);
>> > -	struct v4l2_subdev *sd = NULL;
>> > -	struct i2c_client *client;
>> >  	struct i2c_board_info info;
>> >
>> > -	BUG_ON(!dev);
>> > -
>> > -	if (module_name)
>> > -		request_module(module_name);
>> > -
>> >  	/* Setup the i2c board info with the device type and
>> >  	   the device address. */
>> >  	memset(&info, 0, sizeof(info));
>> >  	strlcpy(info.type, client_type, sizeof(info.type));
>> >  	info.addr = addr;
>> >
>> > +	return v4l2_i2c_new_dev_subdev(adapter, module_name, &info, dev);
>> > +}
>> > +EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
>> > +
>> > +/* Load an i2c sub-device. It assumes that i2c_get_clientdata(client)
>> > +   returns the v4l2_subdev. */
>> > +struct v4l2_subdev *v4l2_i2c_new_dev_subdev(struct i2c_adapter
>> *adapter,
>> > +		const char *module_name, const struct i2c_board_info *info,
>> > +		struct v4l2_device *dev)
>> > +{
>> > +	struct v4l2_subdev *sd = NULL;
>> > +	struct i2c_client *client;
>> > +
>> > +	BUG_ON(!dev);
>> > +
>> > +	if (module_name)
>> > +		request_module(module_name);
>> > +
>> >  	/* Create the i2c client */
>> > -	client = i2c_new_device(adapter, &info);
>> > +	client = i2c_new_device(adapter, info);
>> >  	/* Note: it is possible in the future that
>> >  	   c->driver is NULL if the driver is still being loaded.
>> >  	   We need better support from the kernel so that we
>> > @@ -835,7 +844,7 @@ error:
>> >  		i2c_unregister_device(client);
>> >  	return sd;
>> >  }
>> > -EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
>> > +EXPORT_SYMBOL_GPL(v4l2_i2c_new_dev_subdev);
>> >
>> >  /* Probe and load an i2c sub-device. It assumes that
>> > i2c_get_adapdata(adapter)
>> >     returns the v4l2_device and that i2c_get_clientdata(client)
>> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>> > index 3a69056..0722b00 100644
>> > --- a/include/media/v4l2-common.h
>> > +++ b/include/media/v4l2-common.h
>> > @@ -131,6 +131,7 @@ struct i2c_driver;
>> >  struct i2c_adapter;
>> >  struct i2c_client;
>> >  struct i2c_device_id;
>> > +struct i2c_board_info;
>> >  struct v4l2_device;
>> >  struct v4l2_subdev;
>> >  struct v4l2_subdev_ops;
>> > @@ -144,6 +145,10 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter,
>> int
>> > address, struct i2c_driver
>> >     The client_type argument is the name of the chip that's on the
>> > adapter. */
>> >  struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
>> >  		const char *module_name, const char *client_type, u8 addr);
>> > +/* Same as above but uses user-provided v4l2_device and
>> i2c_board_info */
>> > +struct v4l2_subdev *v4l2_i2c_new_dev_subdev(struct i2c_adapter
>> *adapter,
>> > +		const char *module_name, const struct i2c_board_info *info,
>> > +		struct v4l2_device *dev);
>> >  /* Probe and load an i2c module and return an initialized v4l2_subdev
>> > struct.
>> >     Only call request_module if module_name != NULL.
>> >     The client_type argument is the name of the chip that's on the
>> > adapter. */
>> >
>>
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

