Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16550 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415Ab2JXMAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 08:00:18 -0400
Message-id: <5087D84F.6050407@samsung.com>
Date: Wed, 24 Oct 2012 14:00:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice
 registration
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange>
 <201210221354.44944.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210221421020.26216@axis700.grange>
 <201210221536.03112.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1210221553390.26216@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1210221553390.26216@axis700.grange>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gueanndi,

On 10/22/2012 04:48 PM, Guennadi Liakhovetski wrote:
> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>> On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>> On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
>>>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>>>> On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
>>>>>>> Currently bridge device drivers register devices for all subdevices
>>>>>>> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
>>>>>>> is attached to a video bridge device, the bridge driver will create an I2C
>>>>>>> device and wait for the respective I2C driver to probe. This makes linking
>>>>>>> of devices straight forward, but this approach cannot be used with
>>>>>>> intrinsically asynchronous and unordered device registration systems like
>>>>>>> the Flattened Device Tree. To support such systems this patch adds an
>>>>>>> asynchronous subdevice registration framework to V4L2. To use it respective
>>>>>>> (e.g. I2C) subdevice drivers must request deferred probing as long as their
>>>>>>> bridge driver hasn't probed. The bridge driver during its probing submits a
>>>>>>> an arbitrary number of subdevice descriptor groups to the framework to
>>>>>>> manage. After that it can add callbacks to each of those groups to be
>>>>>>> called at various stages during subdevice probing, e.g. after completion.
>>>>>>> Then the bridge driver can request single groups to be probed, finish its
>>>>>>> own probing and continue its video subsystem configuration from its
>>>>>>> callbacks.
>>>>>>
>>>>>> What is the purpose of allowing multiple groups?
>>>>>
>>>>> To support, e.g. multiple sensors connected to a single bridge.
>>>>
>>>> So, isn't that one group with two sensor subdevs?
>>>
>>> No, one group consists of all subdevices, necessary to operate a single 
>>> video pipeline. A simple group only contains a sensor. More complex groups 
>>> can contain a CSI-2 interface, a line shifter, or anything else.
>>
>> Why? Why would you want to wait for completion of multiple groups? You need all
>> subdevs to be registered. If you split them up in multiple groups, then you
>> have to wait until all those groups have completed, which only makes the bridge
>> driver more complex. It adds nothing to the problem that we're trying to solve.
> 
> I see it differently. Firstly, there's no waiting. Secondly, you don't 
> need all of them. With groups as soon as one group is complete you can 
> start using it. If you require all your subdevices to complete their 
> probing before you can use anything. In fact, some subdevices might never 
> probe, but groups, that don't need them can be used regardless.

Isn't that host drivers that create video and subdev devnodes (directly or
indirectly) when all required devices according to platform data or device tree
structure are initialized ? I would expect a driver to respond to user requests
only when it is fully initialized. Or in a known state, that e.g. something has
failed and there is no (or nearly none) chance to get everything complete
and then a host driver can decide if it continues with limited functionality 
or not. After all subdev probing shouldn't be relatively significantly time 
consuming.

>>>> A bridge driver has a list of subdevs. There is no concept of 'groups'. Perhaps
>>>> I misunderstand?
>>>
>>> Well, we have a group ID, which can be used for what I'm proposing groups 
>>> for. At least on soc-camera we use the group ID exactly for this purpose. 
>>> We attach all subdevices to a V4L2 device, but assign group IDs according 
>>> to pipelines. Then subdevice operations only act on members of one 
>>> pipeline. I know that we currently don't specify precisely what that group 
>>> ID should be used for in general. So, this my group concept is an 
>>> extension of what we currently have in V4L2.
>>
>> How the grp_id field is used is entirely up to the bridge driver. It may not
>> be used at all, it may uniquely identify each subdev, it may put each subdev
>> in a particular group and perhaps a single subdev might belong to multiple
>> groups. There is no standard concept of a group. It's just a simple method
>> (actually, more of a hack) of allowing bridge drivers to call ops for some
>> subset of the sub-devices.
> 
> Yes, I know, at least it's something that loosely indicates a group 
> concept in the current code:-)
> 
>> Frankly, I wonder if most of the drivers that use grp_id actually need it at
>> all.
>>
>> Just drop the group concept, things can be simplified quite a bit without it.
> 
> So far I think we should keep it. Also think about our DT layout. A bridge 
> can have several ports each with multiple links (maybe it has already been 
> decided to change names, don't remember by heart, sorry). Each of them 
> would then start a group.

Hmm, until now I can see it mostly as a complication. How would those
groups be defined, who decides what device goes where ? I think it might
be difficult to even assign devices to such groups.

>>>>>> I can't think of any reason
>>>>>> why you would want to have more than one group. If you have just one group
>>>>>> you can simplify this code quite a bit: most of the v4l2_async_group fields
>>>>>> can just become part of struct v4l2_device, you don't need the 'list' and
>>>>>> 'v4l2_dev' fields anymore and the 'bind' and 'complete' callbacks can be
>>>>>> implemented using the v4l2_device notify callback which we already have.
>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>>>>> ---
>>>>>>>
>>>>>>> One more thing to note about this patch. Subdevice drivers, supporting 
>>>>>>> asynchronous probing, and using this framework, need a unified way to 
>>>>>>> detect, whether their probing should succeed or they should request 
>>>>>>> deferred probing. I implement this using device platform data. This means, 
>>>>>>> that all subdevice drivers, wishing to use this API will have to use the 
>>>>>>> same platform data struct. I don't think this is a major inconvenience, 
>>>>>>> but if we decide against this, we'll have to add a V4L2 function to verify 
>>>>>>> "are you ready for me or not." The latter would be inconvenient, because 
>>>>>>> then we would have to look through all registered subdevice descriptor 
>>>>>>> groups for this specific subdevice.
>>>>>>
>>>>>> I have to admit that I don't quite follow this. I guess I would need to see
>>>>>> this being used in an actual driver.
>>>>>
>>>>> The issue is simple: subdevice drivers have to recognise, when it's still 
>>>>> too early to probe and return -EPROBE_DEFER. If you have a sensor, whose 
>>>>> master clock is supplied from an external oscillator. You load its driver, 
>>>>> it will happily get a clock reference and find no reason to fail probe(). 
>>>>> It will initialise its subdevice and return from probing. Then, when your 
>>>>> bridge driver probes, it will have no way to find that subdevice.
>>>>
>>>> This problem is specific to platform subdev drivers, right? Since for i2c
>>>> subdevs you can use i2c_get_clientdata().
>>>
>>> But how do you get the client? With DT you can follow our "remote" 
>>> phandle, and without DT?
>>
>> You would need a i2c_find_client() function for that. I would like to see some
>> more opinions about this.
> 
> And then the same for SPI, UART... and platform devices cannot use it 
> anyway... Why not just handle all uniformly?

I'm not against handling it uniformly, but it likely shouldn't be enforced
on drivers to use asynchronous platform subdev registration. With deferred
probing mechanism we have all what is needed to support that already - 
driver_for_each_device(), bus_find_device(), of_find_device_by_node(), ...

>>>> I wonder whether it isn't a better idea to have platform_data embed a standard
>>>> struct containing a v4l2_subdev pointer. Subdevs can use container_of to get
>>>> from the address of that struct to the full platform_data, and you don't have
>>>> that extra dereference (i.e. a pointer to the new struct which has a pointer
>>>> to the actual platform_data). The impact of that change is much smaller for
>>>> existing subdevs.
>>>
>>> This standard platform data object is allocated by the bridge driver, so, 
>>> it will not know where it is embedded in the subdevice specific platform 
>>> data.
>>
>> It should. The platform_data is specific to the subdev, so whoever is allocating
>> the platform_data has to know the size and contents of the struct. Normally this
>> structure is part of the board code for embedded systems.
> 
> Sorry, probably I didn't explain well enough. Let's take a no-DT case for 
> simplicity. Say, we have a bridge and a single sensor. The board code 
> provides platform data for each of the two drivers. The platform data for 
> the bridge driver is supplied directly to its platform device as
> 
> static struct platform_device ceu_device = {
> 	...
> 	.dev	= {
> 		.platform_data		= &sh_mobile_ceu_info,
> 		...
> 	},
> };
> 
> Normally, you would also provide platform data to I2C devices like
> 
> static struct i2c_board_info sensor_device = {
> 	I2C_BOARD_INFO("sensor", 0x22),
> 	.platform_data	= &sensor_pdata,
> 	...
> };
> 
> but in our case we don't want to do that, instead we want to supply a 
> pointer to that sensor_data to the bridge driver, to later be supplied to 
> the sensor driver. Currently in the bus notifier upon BIND event (before 
> sensor driver's probe() is called) I supply the platform data to a 
> standard platform data holder struct to dev->platform_data and that holder 
> points to the original platform data from the board code (roughly):
> 
> 	struct v4l2_subdev_platform_data *sdpd = kzalloc();
> 
> 	sdpd->platform_data = board_platform_data;
> 	dev->platform_data = sdpd;
> 
> Then, upon BOUND (after sensor driver's probe() has completed 
> successfully) we make sure sdpd->subdev points to the sensor's subdevice. 
> This works for all device types - I2C or anything else.
> 
> Now, you're suggesting to embed sdpd into the platform data. The first 
> part would still work, we just would pass the original platform data down 
> to the sensor's driver. But upon BOUND - how do we find the subdevice 
> pointer??

Do we really need platform_data to retrive the subdev pointer ? Can't 
i2c_get_clientdata() or platform_get_drvdata() be used for that ?
Sorry, I'm not quite following...

>> That soc-camera doesn't do this is a major soc-camera design flaw. Soc-camera
>> should not force the platform_data contents for subdev drivers.
> 
> Soc-camera does approximately the same - it has a compulsory standard 
> platform data part and an optional driver-specific part.
> 
>>>> And if it isn't necessary for i2c subdev drivers, then I think we should do
>>>> this only for platform drivers.
>>>
>>> See above, and I don't think we should implement 2 different methods. 
>>> Besides, the change is very small. You anyway have to adapt sensor drivers 
>>> to return -EPROBE_DEFER. This takes 2 lines of code:
>>>
>>> +	if (!client->dev.platform_data)
>>> +		return -EPROBE_DEFER;
>>>
>>> If the driver isn't using platform data, that's it. If it is, you add two 
>>> more lines:
>>>
>>> -	struct my_platform_data *pdata = client->dev.platform_data;
>>> +	struct v4l2_subdev_platform_data *sdpd = client->dev.platform_data;
>>> +	struct my_platform_data *pdata = sdpd->platform_data;
>>>
>>> That's it. Of course, you have to do this everywhere, where the driver 
>>> dereferences client->dev.platform_data, but even that shouldn't be too 
>>> difficult.
>>
>> I'd like to see other people's opinions on this as well. I do think I prefer
>> embedding it (in most if not all cases such a standard struct would be at the
>> beginning of the platform_data).
>>
>>>> That said, how does this new framework take care of timeouts if one of the
>>>> subdevs is never bound?
>>>
>>> It doesn't.
>>>
>>>> You don't want to have this wait indefinitely, I think.
>>>
>>> There's no waiting:-) The bridge and other subdev drivers just remain 
>>> loaded and inactive.
>>
>> Is that what we want? I definitely would like to get other people's opinions
>> on this.

I assume some sort of timeout might be useful here. For instance if camera
sensor fails for some reason the host could continue after figuring that out,
with e.g. mem-to-mem functionality only. Now it is not known at the host 
whether a subdev is broken or simply not yet initialized. This seems a general
problem with deferred probing though.

>> For the record: while it is waiting, can you safely rmmod the module?
>> Looking at the code I think you can, but I'm not 100% certain.
> 
> It certainly should work. If it doesn't, we have to fix it.
> 
> And I really think it'd be better not to use the term "waiting" here. The 
> current code is waiting _synchronously_ after registering a new I2C device 
> until its driver has probed. We want to get rid of that and switch to 
> asynchronous notifications. Whetever becomes available can be used. 
> There's no waiting instance in the new concept.

Still some drivers will simply wait for their subdevs to be initialized,
or at least a group of subdevs, until they create device node(s) usable 
at user space. These asynchronous make sense in case the list of 
sub-devices is determined only at run time. But here we simply specify
them in the device tree or in the board code.

--

Thanks,
Sylwester
