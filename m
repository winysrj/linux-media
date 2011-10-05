Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1JEVlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 17:41:37 -0400
Message-ID: <4E8CCF07.2010400@infradead.org>
Date: Wed, 05 Oct 2011 18:41:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <201110032344.08963.laurent.pinchart@ideasonboard.com> <4E8A2F76.4020209@infradead.org> <201110052208.00714.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110052208.00714.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-10-2011 17:08, Laurent Pinchart escreveu:
> Hi Mauro,
>
> On Monday 03 October 2011 23:56:06 Mauro Carvalho Chehab wrote:
>> Em 03-10-2011 18:44, Laurent Pinchart escreveu:
>>> On Monday 03 October 2011 21:16:45 Mauro Carvalho Chehab wrote:
>>>> Em 03-10-2011 08:53, Laurent Pinchart escreveu:
>>>>> On Monday 03 October 2011 11:53:44 Javier Martinez Canillas wrote:
>>>>>
>>>>> [snip]
>>>>>
>>>>>> Laurent, I have a few questions about MCF and the OMAP3ISP driver if
>>>>>> you are so kind to answer.
>>>>>>
>>>>>> 1- User-space programs that are not MCF aware negotiate the format
>>>>>> with the V4L2 device (i.e: OMAP3 ISP CCDC output), which is a sink
>>>>>> pad. But the real format is driven by the analog video format in the
>>>>>> source pad (i.e: tvp5151).
>>>>>
>>>>> That's not different from existing systems using digital sensors, where
>>>>> the format is driven by the sensor.
>>>>>
>>>>>> I modified the ISP driver to get the data format from the source pad
>>>>>> and set the format for each pad on the pipeline accordingly but I've
>>>>>> read from the documentation [1] that is not correct to propagate a
>>>>>> data format from source pads to sink pads, that the correct thing is
>>>>>> to do it from sink to source.
>>>>>>
>>>>>> So, in this case an administrator has to externally configure the
>>>>>> format for each pad and to guarantee a coherent format on the whole
>>>>>> pipeline?.
>>>>>
>>>>> That's correct (except you don't need to be an administrator to do so
>>>>>
>>>>> :-)).
>>>>
>>>> NACK.
>>>
>>> Double NACK :-D
>>>
>>>> When userspace sends a VIDIOC_S_STD ioctl to the sink node, the subdevs
>>>> that are handling the video/audio standard should be changed, in order
>>>> to obey the V4L2 ioctl. This is what happens with all other drivers
>>>> since the beginning of the V4L1 API. There's no reason to change it,
>>>> and such change would be a regression.
>>>
>>> The same could have been told for the format API:
>>>
>>> "When userspace sends a VIDIOC_S_FMT ioctl to the sink node, the subdevs
>>> that are handling the video format should be changed, in order to obey
>>> the V4L2 ioctl. This is what happens with all other drivers since the
>>> beginning of the V4L1 API. There's no reason to change it, and such
>>> change would be a regression."
>>>
>>> But we've introduced a pad-level format API. I don't see any reason to
>>> treat standard differently.
>>
>> Neither do I. The pad-level API should not replace the V4L2 API for
>> standard, for controls and/or for format settings.
>
> The pad-level API doesn't replace the V4L2 API, it complements it. I'm of
> course not advocating modifying any driver to replace V4L2 ioctls by direct
> subdev access. However, the pad-level API needs to be exposed to userspace, as
> some harware simply can't be configured through a video node only.
>
> As Hans also mentionned in his reply, the pad-level API is made of two parts:
> an in-kernel API made of subdev operations, and a userspace API accessed
> through ioctls. As the userspace API is needed for some devices, the kernel
> API needs to be implemented by drivers. We should phase out the non pad-level
> format operations in favor of pad-level operations, as the former can be
> implemented using the later. That has absolutely no influence on the userspace
> API.

What I'm seeing is that:
	- the drivers that are implementing the MC/pad API's aren't
compatible with generic V4L2 applications;
	- there's no way to write a generic application that works with all
drivers, even implementing MC/pad API's there as each driver is taking different
a approach on how to map things at the different API's, and pipeline configuration
is device-dependent;
	- there's no effort to publish patches to libv4l to match the changes
at the kernel driver.

At the time I tried to test the Samsung drivers, I failed to see how this would
work, e. g. how an application like tvtime or xawtv could be used with such
devices. I don't have here any omap3 hardware with cameras or tv tuners, but I
don't see any patches at libv4l that allows using V4L2 to communicate with an
omap3 hardware.

So, in practice, there's no device abstraction that would expose those
hardware to userspace in a manner that the application developer could write
a generic application that would work for all hardware.

I'm fine on providing raw interfaces, just like we have for some types of device
(like the block raw interfaces used by CD-ROM drivers) as a bonus, but this should
never replace an API where an application developed by a third party could work
with all media hardware, without needing hardware specific details.

So, let's take a more pragmatic approach: please provide me means where I test those
drivers with a real hardware, using generic applications (xawtv, tvtime, camorama,
qv4l2, etc), and being able to double check that they will behave just like any
other existing driver.

>>>>>> Or does exist a way to do this automatic?. i.e: The output entity on
>>>>>> the pipeline promotes the capabilities of the source pad so
>>>>>> applications can select a data format and this format gets propagated
>>>>>> all over the pipeline from the sink pad to the source?
>>>>>
>>>>> It can be automated in userspace (through a libv4l plugin for
>>>>> instance), but it's really not the kernel's job to do so.
>>>>
>>>> It is a kernel job to handle VIDIOC_S_STD, and not a task to be left to
>>>> any userspace plugin.
>>>
>>> And VIDIOC_S_FMT is handled by userspace for the OMAP3 ISP today. Why are
>>> standards different ?
>>
>> All v4l media devices have sub-devices with either tv decoders or sensors
>> connected into a sink. The sink implements the /dev/video? node.
>> When an ioctl is sent to the v4l node, the sensors/decoders are controlled
>> to implement whatever is requested: video standards, formats etc.
>
> But that simply doesn't work out with the OMAP3 ISP or similar hardware. If
> applications only set the format on the video node the driver has no way to
> know how to configure the individual subdevs in the pipeline. When more than a
> handful of subdevs are involved, the approach simply doesn't scale.
>
> On the other hand, when the TV decoder is connected to a bridge that is only
> capable of transferring the data to memory, there is no reason to require
> applications to configure subdevs directly. In that case the bridge driver can
> configure the subdevs itself.

For good or for bad, an analog TV standard weren't mapped on V4L on its canonical
form. One single bitmask carries 3 different types of information inside:
	- the analog TV monochromatic standard:
		for 50 Hz line frequency: /A /B /D /K, ...
		for 60 Hz line frequency: /M /60
	- the analog TV chroma standard: PAL, NTSC, SECAM;
	- the audio standard: MTS/BTSC, EIA-J, NICAM, A2.

Due to that, any operation that touches on it should not be done at PAD level, as
the entire pipeline needs to know when something has changed there.

For example, a S_STD call needs to change the tuner saw filters (as the analog
monochromatic standard will need to adjust to the channel bandwidth, and, on some
digital tuners, to the audio and chroma subcarrier frequencies), configure the
tuner IF, configure the demod to work with the same IF as the tuner, set the number
of lines at the analog video demod and at the audio demod, etc.

In particular, when a format is changed between 50Hz and 60Hz standards, the
driver needs to validate the selected format (S_FMT), as most hardware scallers
don't support using 576 lines with 60Hz standards (as the maximum number of
lines provided by those standards are 480 lines).

The standards detection logic also need to merge information from the audio demod
and the video demod, in order to distinguish between standards like NTSC_M,
NTSC_M_JP and NTSC_M_KR, where the only difference is at the audio subcarrier
(there are some similar examples for PAL standards as well).

The support for those at the kernel level is as easy as broadcasting the message
to all subdevs, via the V4L2 "service bus". Only the drivers that hook into the
s_std/g_std/querystd ops will handle such request.

So, a PAD level support for it doesn't make sense, as it would duplicate a
functionality from kernelspace into userspace, and make harder to tune userspace
to work with all hardware, as userspace will never know what devices need to
be accessed when a video standard is changed.

>
>> Changing it would be a major regression. If OMAP3 is not doing the right
>> thing, it should be fixed, and not the opposite.
>>
>> The MC/subdev API is there to fill the blanks, e. g. to handle cases where
>> the same function could be implemented on two different places of the
>> pipeline, e. g. when both the sensor and the bridge could do scaling, and
>> userspace wants to explicitly use one, or the other, but it were never
>> meant to replace the V4L2 functionality.
>
> Isn't that what I've been saying ? :-)
>
>>>>>> [1]: http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
>>>>>>
>>>>>> 2- If the application want a different format that the default
>>>>>> provided by the tvp5151, (i.e: 720x576 for PAL), where do I have to
>>>>>> crop the image? I thought this can be made using the CCDC, copying
>>>>>> less lines to memory or the RESIZER if the application wants a bigger
>>>>>> image. What is the best approach for this?
>>>>
>>>> Not sure if I understood your question, but maybe you're mixing two
>>>> different concepts here.
>>>>
>>>> If the application wants a different image resolution, it will use
>>>> S_FMT. In this case, what userspace expects is that the driver will
>>>> scale, if supported, or return -EINVAL otherwise.
>>>
>>> With the OMAP3 ISP, which is I believe what Javier was asking about, the
>>> application will set the format on the OMAP3 ISP resizer input and output
>>> pads to configure scaling.
>>
>> The V4L2 API doesn't tell where a function like scaler will be implemented.
>> So, it is fine to implement it at tvp5151 or at the omap3 resizer, when a
>> V4L2 call is sent.
>
> By rolling a dice ? :-)

By using good sense. I never had a case where I had doubts about where the
scaling should be implemented on the drivers I've coded. For omap3/tvp5151, the
decision is also clear: it should be done at the bridge (omap3) resizer, as the
demod doesn't support scaling.

>> I'm ok if you want to offer the possibility of doing scale on the other
>> parts of the pipeline, as a bonus, via the MC/subdev API, but the absolute
>> minimum requirement is to implement it via the V4L2 API.
>
> The absolute minimum requirement is to make the driver usable by applications
> using the V4L2 API in a crippled mode with only a subdev of features
> available. For the OMAP3 ISP that means full-size capture, with no scaling.

As far as I can remember, all the existing drivers that have analog TV support
allows scaling. The worse case are the em2800 devices (the first series,
manufactured before 2005 - I never had one of those - newer em28xx supports
full scaling) and tm5600/tm60x0 devices. On both, the device can only scale between
full and half lines and full and half columns. All of them were already discontinued.

All modern drivers that support analog TV I'm aware does allow scaling and cropping.
and this is one of the things I check when I receive a new analog TV driver: if scaling
API (S_FMT) is properly written, otherwise, I nack the driver.
So, If OMAP3 can't support scaling at all, then you're right. Otherwise, scaling
support via S_FMT needs to be implemented.

Regards,
Mauro
