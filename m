Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43935 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362Ab2JaXJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 19:09:15 -0400
Message-ID: <5091AF97.7010804@gmail.com>
Date: Thu, 01 Nov 2012 00:09:11 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <Pine.LNX.4.64.1210200007580.28993@axis700.grange> <Pine.LNX.4.64.1210241548300.2683@axis700.grange> <508D4F79.2000204@gmail.com> <Pine.LNX.4.64.1210290841200.17869@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210290841200.17869@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10/29/2012 08:52 AM, Guennadi Liakhovetski wrote:
>>>> +/*
>>>> + * Typically this function will be called during bridge driver probing. It
>>>> + * installs bus notifiers to handle asynchronously probing subdevice drivers.
>>>> + * Once the bridge driver probing completes, subdevice drivers, waiting in
>>>> + * EPROBE_DEFER state are re-probed, at which point they get their platform
>>>> + * data, which allows them to complete probing.
>>>> + */
>>>> +int v4l2_async_group_probe(struct v4l2_async_group *group)
>>>> +{
>>>> +	struct v4l2_async_subdev *asd, *tmp;
>>>> +	bool i2c_used = false, platform_used = false;
>>>> +	int ret;
>>>> +
>>>> +	/* This group is inactive so far - no notifiers yet */
>>>> +	list_for_each_entry_safe(asd, tmp,&group->group, list) {
>>>> +		if (asd->sdpd.subdev) {
>>>> +			/* Simulate a BIND event */
>>>> +			if (group->bind_cb)
>>>> +				group->bind_cb(group, asd);
>>>> +
>>
>> Still we can't be sure at this moment asd->sdpd.subdev's driver is
>> valid and not unloaded, can we ?
>>
>> In the case when a sub-device driver is probed after the host driver
>> (a caller of this function) I assume doing
>>
>> 	asd->sdpd.subdev = i2c_get_clientdata(to_i2c_client(dev));
>> 	...
>> 	ret = v4l2_device_register_subdev(v4l2_dev, asd->sdpd.subdev);
>>
>> is safe, because it is done in the i2c bus notifier callback itself,
>> i.e. under device_lock(dev).
>>
>> But for these already probed sub-devices, how do we prevent races from
>> subdev module unloading ? By not setting CONFIG_MODULE_UNLOAD?... ;)
> 
> Right, I also think there's a race there. I have a solution for it - in
> the current mainline version of sh_mobile_ceu_camera.c look at the code
> around the line
> 
> 		err = bus_register_notifier(&platform_bus_type,&wait.notifier);
> 
> sh_mobile_ceu_probe(). I think, that guarantees, that we either lock the
> module _safely_ in memory per try_module_get(dev->driver->owner) or get
> notified, that the module is unavailable. It looks ugly, but I don't have
> a better solution ATM. We could do the same here too.

IMHO even "ugly" solution is better than completely ignoring the problem.

I have some doubts whether your method eliminates the race issue. Firstly, 
shouldn't the bus_notify callback [1] be active on BUS_NOTIFY_UNBIND_DRIVER, 
rather than US_NOTIFY_UNBOUND_DRIVER ? Upon US_NOTIFY_UNBOUND_DRIVER 
dev->driver is already NULL and still it is being referenced in a call to 
try_module_get() (line 2224, [1]).

Secondly, what guarantees that before bus_register_notifier() call [1],
we are not already after blocking_notifier_call_chain() (line 504, [2])
which means we miss the notification and the sub-device driver is going 
away together with its module under our feet ?

[1] http://lxr.linux.no/#linux+v3.6/drivers/media/video/sh_mobile_ceu_camera.c#L2055
[2] http://lxr.linux.no/#linux+v3.6/drivers/base/dd.c#L478

--
Thanks,
Sylwester
