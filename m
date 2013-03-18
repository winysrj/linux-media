Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42498 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CRWsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 18:48:32 -0400
Message-ID: <514799BB.3040407@gmail.com>
Date: Mon, 18 Mar 2013 23:48:27 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 3/7] media: soc-camera: switch I2C subdevice drivers
 to use v4l2-clk
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de> <201303180847.20708.hverkuil@xs4all.nl> <Pine.LNX.4.64.1303181044550.30957@axis700.grange> <201303181123.10606.hverkuil@xs4all.nl>
In-Reply-To: <201303181123.10606.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2013 11:23 AM, Hans Verkuil wrote:
> On Mon March 18 2013 11:08:16 Guennadi Liakhovetski wrote:
>> On Mon, 18 Mar 2013, Hans Verkuil wrote:
>>> On Fri March 15 2013 22:27:49 Guennadi Liakhovetski wrote:
[...]
>>>> @@ -431,6 +434,7 @@ static int imx074_probe(struct i2c_client *client,
>>>>   	struct imx074 *priv;
>>>>   	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>>>>   	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>>>> +	int ret;
>>>>
>>>>   	if (!ssdd) {
>>>>   		dev_err(&client->dev, "IMX074: missing platform data!\n");
>>>> @@ -451,13 +455,23 @@ static int imx074_probe(struct i2c_client *client,
>>>>
>>>>   	priv->fmt	=&imx074_colour_fmts[0];
>>>>
>>>> -	return imx074_video_probe(client);
>>>> +	priv->clk = v4l2_clk_get(&priv->subdev, "mclk");
>>>> +	if (IS_ERR(priv->clk))
>>>> +		return PTR_ERR(priv->clk);
>>>> +
>>>> +	ret = imx074_video_probe(client);
>>>> +	if (ret<  0)
>>>> +		v4l2_clk_put(priv->clk);
>>>> +
>>>
>>> I feel uneasy about this. It's not the clock part as such but the fact that
>>> assumptions are made about the usage of this sensor driver. It basically
>>> comes down to the fact that these drivers are *still* tied to the soc-camera
>>> framework. I think I am going to work on this in a few weeks time to cut
>>> these drivers loose from soc-camera. We discussed how to do that in the past.
>>
>> Sorry, not sure I understand. This is a generic (V4L2) clock, it has
>> nothing specific to soc-camera.
>
> The assumption that there is a clock that needs to be set up is soc_camera
> specific IMHO.

I don't think this is really soc-camera specific. This is specific to most
SoC camera subsystems, also those not using soc-camera framework (even 
though
there might be not that many of them ;)).

>>> The whole point of the subdev API is to make drivers independent of bridge
>>> drivers, and these soc-camera subdev drivers are the big exception and they
>>> stick out like a sore thumb.
>>
>> We are moving towards complete driver independency from the soc-camera
>> framework, and, afaics, there's not much left. Simply noone is interested
>> enough to do the work or to pay for it, noone has a really burning
>> use-case. And without one it's not very easy to implement things with no
>> test case. But sure, you're most welcome to work on this :)
>
> I'll see what I can do since I am interested in doing this :-)
>
>>> Anyway, w.r.t. the clock use: what happens if these drivers are used in e.g.
>>> a USB webcam driver? In that case there probably won't be a clock involved
>>> (well, there is one, but that is likely to be setup by the firmware/hardware
>>> itself).
>>
>> Well, from the sensor driver PoV if the sensor needs a clock it seems
>> logical for the driver to request it and to fail if it's not available.
>> USB cameras could provide a dummy clock, or we could implement one
>> centrally, however, this will lead to an undesirable result, that everyone
>> will just use that dummy clock... If we make clock support optional the
>> same thing will happen - noone will implement them. BTW, you're looking at
>> an intermediate patch in this series, which only adds clock support. In a
>> later patch the return error code for missing clock will be replaced with
>> -EPROBE_DEFER which serves as a sign, that no bridge driver is available
>> yes and _is_ required to support asynchronous probing.
>
> Creating a dummy clock in a USB device would work, I agree.
>
> Forget my other remarks: I hadn't realized that the global list of clocks
> (clk_list) is unique per device (i2c adapter-i2c addr), so you can add
> multiple clocks with the same name (mclk) and still match them to the correct
> device.
>
> That makes it all work as it should.
>
> Regards,
>
> 	Hans
>
>>> Wouldn't it be better if the clock name is passed on through the platform data
>>> (or device tree)? And if no clock name was specified, then there is no need to
>>> get a clock either and the driver can assume that it will always have a clock.
>>> That would solve this problem when this sensor driver is no longer soc-camera
>>> dependent.
>>
>> No. Yes, this has been discussed many times - in the context of the
>> generic clock API. I also proposed a patch, that did such a thing and was
>> "kindly" explained, why that wasn't a good idea :-) Clock names are names
>> of clock _inputs_ on the consumer. I.e. a sensor driver should request a
>> clock according to its datasheet. For the clock provider it's different,
>> say, a bridge driver cannot know what sensor will be connected to it and
>> clock it will be expecting. That's why we have clock lookup tables, that
>> connect physical clock objects (providers) with consumer clock names in
>> platform data (perhaps, a similar thing is done in DT, haven't looked
>> yet). I think, we could accept a compromise by using a common name for all
>> clocks with the same function. I'm using "mclk" as an abbreviation for
>> "master clock."

I guess using a common "mclk" name would work. It's easy to specify this
in the device tree. In the clock consumer device's node an exact clock
name, according to the DT binding, can be specified in the 'clock-names'
property. Then a corresponding entry of the 'clocks' property contains
a clock specifier, pointing to a relevant clock on the list of clocks of
the clock provider. Similarly we could associate a platform clock with
a consumer clock id by using clkdev_add_alias in non-dt cases. But this
would require CCF support.

--

Regards,
Sylwester
