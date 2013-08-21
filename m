Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64128 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3HUVmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 17:42:42 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so397021bkb.13
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 14:42:40 -0700 (PDT)
Message-ID: <5215344E.2070002@gmail.com>
Date: Wed, 21 Aug 2013 23:42:38 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com> <1904390.nVVGcVBrVP@avalon> <52139A9B.1030400@googlemail.com> <52152578.2060201@googlemail.com>
In-Reply-To: <52152578.2060201@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On 08/21/2013 10:39 PM, Frank Sch�fer wrote:
> Am 20.08.2013 18:34, schrieb Frank Sch�fer:
>> Am 20.08.2013 15:38, schrieb Laurent Pinchart:
>>> Hi Mauro,
>>>
>>> On Sunday 18 August 2013 12:20:08 Mauro Carvalho Chehab wrote:
>>>> Em Sun, 18 Aug 2013 13:40:25 +0200 Frank Sch�fer escreveu:
>>>>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
>>>>>> Hi Frank,
>>>>>> As I mentioned on the list, I'm currently on a holiday, so, replying
>>>>>> briefly.
>>>>> Sorry, I missed that (can't read all mails on the list).
>>>>>
>>>>>> Since em28xx is a USB device, I conclude, that it's supplying clock to
>>>>>> its components including the ov2640 sensor. So, yes, I think the driver
>>>>>> should export a V4L2 clock.
>>>>> Ok, so it's mandatory on purpose ?
>>>>> I'll take a deeper into the v4l2-clk code and the
>>>>> em28xx/ov2640/soc-camera interaction this week.
>>>>> Have a nice holiday !
>>>> commit 9aea470b399d797e88be08985c489855759c6c60
>>>> Author: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>>> Date:   Fri Dec 21 13:01:55 2012 -0300
>>>>
>>>>      [media] soc-camera: switch I2C subdevice drivers to use v4l2-clk
>>>>
>>>>      Instead of centrally enabling and disabling subdevice master clocks in
>>>>      soc-camera core, let subdevice drivers do that themselves, using the
>>>>      V4L2 clock API and soc-camera convenience wrappers.
>>>>
>>>>      Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>>>      Acked-by: Hans Verkuil<hans.verkuil@cisco.com>
>>>>      Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>>>      Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>>>
>>>> (c/c the ones that acked with this broken changeset)
>>>>
>>>> We need to fix it ASAP or to revert the ov2640 changes, as some em28xx
>>>> cameras are currently broken on 3.10.
>>>>
>>>> I'll also reject other ports to the async API if the drivers are
>>>> used outside an embedded driver, as no PC driver currently defines
>>>> any clock source. The same applies to regulators.
>>>>
>>>> Guennadi,
>>>>
>>>> Next time, please check if the i2c drivers are used outside soc_camera
>>>> and apply the fixes where needed, as no regressions are allowed.
>>> We definitely need to check all users of our sensor drivers when making such a
>>> change. Mistakes happen, so let's fix them.
>>>
>>> Guennadi is on holidays until the end of this week. Would that be too late to
>>> fix the issue (given that 3.10 is already broken) ? The fix shouldn't be too
>>> complex, registering a dummy V4L2 clock in the em28xx driver should be enough.
>> I would prefer either a) making the clock optional in the senor
>> driver(s) or b) implementing a real V4L2 clock.
>>
>> Reading the soc-camera code, it looks like NULL-pointers for struct
>> v4l2_clk are handled correctly. so a) should be pretty simple:
>>
>>      priv->clk = v4l2_clk_get(&client->dev, "mclk");
>> -   if (IS_ERR(priv->clk)) {
>> -       ret = PTR_ERR(priv->clk);
>> -       goto eclkget;
>> -   }
>> +   if (IS_ERR(priv->clk))
>> +       priv->clk = NULL;
>>
>> Some additional NULL-pointer checks might be necessary, e.g. before
>> calling v4l2_clk_put().
>
> Tested and that works.
> Patch follows.

That patch breaks subdevs registration through the v4l2-async. See commit

ef6672ea35b5bb64ab42e18c1a1ffc717c31588a
[media] V4L2: mt9m111: switch to asynchronous subdevice probing

Sensor probe() callback must return EPROBE_DEFER when the clock is not
found. This cause the sensor's probe() callback to be called again by
the driver core after some other driver has probed, e.g. the one that
registers v4l2_clk. If specific error code is not returned from probe()
the whole registration process breaks.

>> Concerning b): I'm not yet sure if it is really needed/makes sense...
>> Who is supposed to configure/enable/disable the clock in a constellation
>> like em28xx+ov2640 ?
>> For UXGA for example, the clock needs to be switched to 12MHz, while
>> 24MHz is used for smaller reolutions.
>> But I'm not sure if it is a good idea to let the sensor driver do the
>> switch (to define fixed bindings between resoultions and clock frequencies).
>> Btw, what if a frequency is requested which isn't supported ? Set the
>> clock to the next nearest supported frequency ?
>>
>> Regards,
>> Frank
>
> I tried to implement a v4l2_clk for the em28xx driver (not yet beeing
> sure if it really makes sense) and I noticed the following problem:
> The ov2640 driver (as well as all other sensor drivers) seems to have
> specific expectations for the names of the clock.
> The name must me "mclk" and dev_name must be the device name of the i2c
> client device.
> Is "mclk" supposed to be a clock type ? Wouldn't an enum be a better
> choice in this case ?

This is made similar to the common clock API, a string is an identifier
of a clock for the device. I can't see anything unusual in that, it will
also make it easier to phase out the v4l2-clk API and replace it with
the common clock API once that is more widely available.

The name is supposed to come from the datasheet and usually be different
for each sensor, but since we mostly deal with just one clock a common
"mclk" name was chosen for simplicity.

> Anyway, the sensor subdevices are registered using
> v4l2_i2c_new_subdev_board(), which sets up an i2c client, loads the
> module and returns v4l2_subdev.
> The v4l2_clock needs to be registered before (otherwise no clock is
> found during sensor probing), but at this point the device name of the
> i2c_client isn't known yet...

Look how soc-camera registers the clock:

  snprintf(clk_name, sizeof(clk_name), "%d-%04x",
	 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);

  icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
  if (IS_ERR(icd->clk)) {
  	 ret = PTR_ERR(icd->clk);
  	 goto eclkreg;
  }

Other bridge drivers need to do something similar. All you need to know is
the I2C adapter id and the sensor's I2C slave address. For em28xx it might
be something along the lines of:

	...
	struct i2c_board_info ov2640_info = {
		.type = "ov2640",
		.flags = I2C_CLIENT_SCCB,
		.addr = dev->i2c_client[dev->def_i2c_bus].addr,
		.platform_data = &camlink,
	};
	...

	//////////////////////////////////////////////////////
	char clk_name[16];
	struct v4l2_clk *clk;

	static const struct v4l2_clk_ops em28xx_sensor_clk_ops = {
		/* empty ops */
	};


	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
		 dev->i2c_adap[dev->def_i2c_bus].nr, ov2640_info.addr);

	clk = v4l2_clk_register(&em28xx_sensor_clk_ops, clk_name, "mclk", icd);
	if (IS_ERR(icd->clk)) {
		...
	}
	//////////////////////////////////////////////////////

	subdev =
	     v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
				       &dev->i2c_adap[dev->def_i2c_bus],
				       &ov2640_info, NULL);
	...

Alternatively all sensors modified by changeset 9aea470b399d797e88be
"[media] soc-camera: switch I2C subdevice drivers to use v4l2-clk" could
receive a platform data flag that would be set for drivers like em28xx,
and which would be indicating if the clock should be used or not. It
probably should has been done originally if it wasn't clear which bridge
drivers use that modified sensors and that regressions were possible.

--
Regards,
Sylwester
