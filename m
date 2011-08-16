Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1HPPbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 11:31:06 -0400
Message-ID: <4E4A8D27.1040602@redhat.com>
Date: Tue, 16 Aug 2011 08:30:47 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <201108151430.42722.laurent.pinchart@ideasonboard.com> <4E49B60C.4060506@redhat.com> <201108161057.57875.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108161057.57875.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-08-2011 01:57, Laurent Pinchart escreveu:
> Hi Mauro,
 
>>> My point is that the ISP driver developer can't know in advance which
>>> sensor will be used systems that don't exist yet.
>>
>> As far as such hardware is projected, someone will know. It is a simple
>> trivial patch to associate a new hardware with a hardware profile at the
>> platform data.
> 
> Platform data must contain hardware descriptions only, not policies. This is 
> even clearer now that ARM is moving away from board code to the Device Tree.

Again, a cell phone with one frontal camera and one hear camera has two
sensor inputs only. This is not a "policy". It is a hardware constraint.
The driver should allow setting the pipeline for both sensors via S_INPUT,
otherwise a V4L2 only userspace application won't work.

It is as simple as that.

>> Also, on most cases, probing a sensor is as trivial as reading a sensor
>> ID during device probe. This applies, for example, for all Omnivision
>> sensors.
>>
>> We do things like that all the times for PC world, as nobody knows what
>> webcam someone would plug on his PC.
> 
> Sorry, but that's not related. You simply can't decide in an embedded ISP 
> driver how to deal with sensor controls, as the system will be used in a too 
> wide variety of applications and hardware configurations. All controls need to 
> be exposed, period.

We're not talking about controls. We're talking about providing the needed
V4L2 support to allow an userspace application to access the hardware
sensor.

>>>> I never saw an embedded hardware that allows physically changing the
>>>> sensor.
>>>
>>> Beagleboard + pluggable sensor board.
>>
>> Development systems like beagleboard, pandaboard, Exynos SMDK, etc, aren't
>> embeeded hardware. They're development kits.
> 
> People create end-user products based on those kits. That make them first-
> class embedded hardware like any other.

No doubt they should be supported, but it doesn't make sense to create tons
of input pipelines to be used for S_INPUT for each different type of possible
sensor. Somehow, userspace needs to tell what's the sensor that he attached
to the hardware, or the driver should suport auto-detecting it.

In other words, I see 2 options for that:
	1) add hardware auto-detection at the sensor logic. At driver probe,
try to probe all sensors, if it is a hardware development kit;
	2) add one new parameter at the driver: "sensors". If the hardware
is one of those kits, this parameter will allow the developer to specify
the used sensors. It is the same logic as we do with userspace TV and
grabber cards without eeprom or any other way to auto-detect the hardware.

>> I don't mind if, for those kits the developer that is playing with it has to
>> pass a mode parameter and/or run some open harware-aware small application
>> that makes the driver to select the sensor type he is using, but, if the
>> hardware is, instead, a N9 or a Galaxy Tab (or whatever embedded hardware),
>> the driver should expose just the sensors that exists on such hardware. It
>> shouldn't be ever allowed to change it on userspace, using whatever API on
>> those hardware.
> 
> Who talked about changing sensors from userspace on those systems ? Platform 
> data (regardless of whether it comes from board code, device tree, or 
> something else) will contain a hardware description, and the kernel will 
> create the right devices and load the right drivers. The issue we're 
> discussing is how to expose controls for those devices to userspace, and that 
> needs to be done through subdev nodes.

The issue that is under discussion is the removal of S_INPUT from the samsung 
driver, and the comments at the patches that talks about removing V4L2 API
support in favor of using a MC-only API for some fundamental things.

For example, with a patch like this one, only one sensor will be supported
without the MC API (either the front or back sensor on a multi-sensor camera):
	http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/47751733a322a241927f9238b8ab1441389c9c41

Look at the comment on this patch also:
	http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/c6fb462c38be60a45d16a29a9e56c886ee0aa08c

What is called "API compatibility mode" is not clear, but it transmitted
me that the idea is to expose the controls only via subnodes.

Those are the rationale for those discussions: V4L2 API is not being deprecated
in favor of MC API, e. g. controls shouldn't be hidden from the V4L2 API without
a good reason.

>>>>> Even if you did, fine image quality tuning requires accessing pretty
>>>>> much all controls individually anyway.
>>>>
>>>> The same is also true for non-embedded hardware. The only situation
>>>> where V4L2 API is not enough is when there are two controls of the same
>>>> type active. For example, 2 active volume controls, one at the audio
>>>> demod, and another at the bridge. There may have some cases where you
>>>> can do the same thing at the sensor or at a DSP block. This is where MC
>>>> API gives an improvement, by allowing changing both, instead of just
>>>> one of the controls.
>>>
>>> To be precise it's the V4L2 subdev userspace API that allows that, not
>>> the MC API.
>>>
>>>>>>> This is a hack...sorry, just joking ;-) Seriously, I think the
>>>>>>> situation with the userspace subdevs is a bit different. Because with
>>>>>>> one API we directly expose some functionality for applications, with
>>>>>>> other we code it in the kernel, to make the devices appear uniform at
>>>>>>> user space.
>>>>>>
>>>>>> Not sure if I understood you. V4L2 export drivers functionality to
>>>>>> userspace in an uniform way. MC api is for special applications that
>>>>>> might need to access some internal functions on embedded devices.
>>>>>>
>>>>>> Of course, there are some cases where it doesn't make sense to export
>>>>>> a subdev control via V4L2 API.
>>>>>>
>>>>>>>>> Also, the sensor subdev can be configured in the video node driver
>>>>>>>>> as well as through the subdev device node. Both APIs can do the
>>>>>>>>> same thing but in order to let the subdev API work as expected the
>>>>>>>>> video node driver must be forbidden to configure the subdev.
>>>>>>>>
>>>>>>>> Why? For the sensor, a V4L2 API call will look just like a bridge
>>>>>>>> driver call. The subdev will need a mutex anyway, as two MC
>>>>>>>> applications may be opening it simultaneously. I can't see why it
>>>>>>>> should forbid changing the control from the bridge driver call.
>>>>>>>
>>>>>>> Please do not forget there might be more than one subdev to configure
>>>>>>> and that the bridge itself is also a subdev (which exposes a scaler
>>>>>>> interface, for instance). A situation pretty much like in Figure 4.4
>>>>>>> [1] (after the scaler there is also a video node to configure, but we
>>>>>>> may assume that pixel resolution at the scaler pad 1 is same as at
>>>>>>> the video node). Assuming the format and crop configuration flow is
>>>>>>> from sensor to host scaler direction, if we have tried to configure
>>>>>>> _all_ subdevs when the last stage of the pipeline is configured
>>>>>>> (i.e. video node) the whole scaler and crop/composition
>>>>>>> configuration we have been destroyed at that time. And there is more
>>>>>>> to configure than
>>>>>>> VIDIOC_S_FMT can do.
>>>>>>
>>>>>> Think from users perspective: all user wants is to see a video of a
>>>>>> given resolution. S_FMT (and a few other VIDIOC_* calls) have
>>>>>> everything that the user wants: the desired resolution, framerate and
>>>>>> format.
>>>>>>
>>>>>> Specialized applications indeed need more, in order to get the best
>>>>>> images for certain types of usages. So, MC is there.
>>>>>>
>>>>>> Such applications will probably need to know exactly what's the
>>>>>> sensor, what are their bugs, how it is connected, what are the DSP
>>>>>> blocks in the patch, how the DSP algorithms are implemented, etc, in
>>>>>> order to obtain the the perfect image.
>>>>>>
>>>>>> Even on embedded devices like smartphones and tablets, I predict that
>>>>>> both types of applications will be developed and used: people may use
>>>>>> a generic application like flash player, and an specialized
>>>>>> application provided by the manufacturer. Users can even develop
>>>>>> their own applications generic apps using V4L2 directly, at the
>>>>>> devices that allow that.
>>>>>>
>>>>>> As I said before: both application types are welcome. We just need to
>>>>>> warrant that a pure V4L application will work reasonably well.
>>>>>
>>>>> That's why we have libv4l. The driver simply doesn't receive enough
>>>>> information to configure the hardware correctly from the VIDIOC_*
>>>>> calls. And as mentioned above, 3A algorithms, required by "simple"
>>>>> V4L2 applications, need to be implemented in userspace anyway.
>>>>
>>>> It is OK to improve users experience via libv4l. What I'm saying is that
>>>> it is NOT OK to remove V4L2 API support from the driver, forcing users
>>>> to use some hardware plugin at libv4l.
>>>
>>> Let me be clear on this. I'm *NOT* advocating removing V4L2 API support
>>> from any driver (well, on the drivers I can currently think of, if you
>>> show me a wifi driver that implements a V4L2 interface I might change my
>>> mind :-)).
>>
>> This thread is all about a patch series partially removing V4L2 API
>> support.
> 
> Because that specific part of the API doesn't make sense for this use case. 
> You wouldn't object to removing S_INPUT support from a video output driver, as 
> it wouldn't make sense either.

A device with two sensors input where just one node can be switched to use
either input is a typical case where S_INPUT needs to be provided.

> 
>>> The V4L2 API has been designed mostly for desktop hardware. Thanks to its
>>> clean design we can use it for embedded hardware, even though it requires
>>> extensions. What we need to do is to define which parts of the whole API
>>> apply as-is to embedded hardware, and which should better be left
>>> unused.
>>
>> Agreed. I'm all in favor on discussing this topic. However, before he have
>> such iscussions and come into a common understanding, I won't take any
>> patch removing V4L2 API support, nor I'll accept any driver that won't
>> allow it to be usable by a V4L2 userspace application.
> 
> A pure V4L2 userspace application, knowing about video device nodes only, can 
> still use the driver. Not all advanced features will be available.

That's exactly what I'm saying.

Regards,
Mauro.
