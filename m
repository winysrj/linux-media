Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:37919 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3K0K3Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 05:29:24 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so5202912lab.10
        for <linux-media@vger.kernel.org>; Wed, 27 Nov 2013 02:29:23 -0800 (PST)
Message-ID: <5295C980.7050201@cogentembedded.com>
Date: Wed, 27 Nov 2013 14:29:20 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl> <528CA9E1.2020401@cogentembedded.com> <528CD86D.70506@xs4all.nl> <528CDB0B.3000109@cogentembedded.com> <52951270.9040804@cogentembedded.com> <5295AB82.2010003@xs4all.nl>
In-Reply-To: <5295AB82.2010003@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2013 12:21 PM, Hans Verkuil wrote:
> On 11/26/2013 10:28 PM, Valentine wrote:
>> On 11/20/2013 07:53 PM, Valentine wrote:
>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>>>> Hi Valentine,

Hi Hans,

>>
>> Hi Hans,
>>
>>>>
>>>> Did you ever look at this adv7611 driver:
>>>>
>>>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4afa42af2daa12
>>>
>>> No, I missed that one somehow, although I did search for the adv7611/7612 before implementing this one.
>>> I'm going to look closer at the patch and test it.
>>>
>>
>> I've tried the patch and I doubt that it was ever tested on adv7611.
>> I haven't been able to make it work so far. Here's the description of some of the issues
>> I've encountered.
>>
>> The patch does not apply cleanly so I had to make small adjustments just to make it apply
>> without changing the functionality.
>>
>> First of all the driver (adv7604_dummy_client function) does not set default I2C slave addresses
>> in the I/O map in case they are not set in the platform data.
>> This is not needed for 7604, since the default addresses are already set in the I/O map after chip reset.
>> However, the map is zeroed on 7611/7612 after power up, and we always have to set it manually.
>
> So, the platform data for the 7611/2 should always give i2c addresses. That seems
> reasonable.

Yes, but currently the comment in include/media/adv7604.h says
"i2c addresses: 0 == use default", and this is true for 7604, but
it doesn't work for 7611.

Probably the recommended value from the docs should be set by
the driver in case an I2C address is zero in the platform data.
This will help us to keep the same approach across all 76xx chips.

>
>> I had to implement the IRQ handler since the soc_camera model does not use
>> interrupt_service_routine subdevice callback and R-Car VIN knows nothing about adv7612
>> interrupt routed to a GPIO pin.
>> So I had to schedule a workqueue and call adv7604_isr from there in case an interrupt happens.
>
> For our systems the adv7604 interrupts is not always hooked up to a gpio irq, instead
> a register has to be read to figure out which device actually produced the irq. So I
> want to keep the interrupt_service_routine(). However, adding a gpio field to the
> platform_data that, if set, will tell the driver to request an irq and setup a
> workqueue that calls interrupt_service_routine() would be fine with me. That will
> benefit a lot of people since using gpios is much more common.
>
>> The driver enables multiple interrupts on the chip, however, the adv7604_isr callback doesn't
>> seem to handle them correctly.
>> According to the docs:
>> "If an interrupt event occurs, and then a second interrupt event occurs before the system controller
>> has cleared or masked the first interrupt event, the ADV7611 does not generate a second interrupt signal."
>>
>> However, the interrupt_service_routine doesn't account for that.
>> For example, in case fmt_change interrupt happens while fmt_change_digital interrupt is being
>> processed by the adv7604_isr routine. If fmt_change status is set just before we clear fmt_change_digital,
>> we never clear fmt_change. Thus, we end up with fmt_change interrupt missed and therefore further interrupts disabled.
>> I've tried to call the adv7604_isr routine in a loop and return from the worlqueue only when all interrupt status bits are cleared.
>> This did help a bit, but sometimes I started getting lots of I2C read/write errors for some reason.
>
> I'm not sure if there is much that can be done about this. The code reads the
> interrupt status, then clears the interrupts right after. There is always a
> race condition there since this isn't atomic ('read and clear'). Unless Lars-Peter
> has a better idea?
>
> What can be improved, though, is to clear not just the interrupts that were
> read, but all the interrupts that are unmasked. You are right, you could
> loose an interrupt that way.
>
>> I'm also not sure how the dv_timing API should be used.
>> The internal adv7604 state->timings structure is used when getting mbus format.
>> However, the driver does not set the structure neither at start-up nor in the interrupt service callback when format changes.
>> Is it supposed to be set by the upper level camera driver?
>
> It would be nice if the adv7604 would set up an initial timings format. In our
> case it is indeed the bridge driver that sets it up, but in the general case it
> is better if the i2c driver also sets an initial timings struct. 720p60 is
> generally a good initial value.
>
> The irq certainly shouldn't change timings: changing timings will most likely
> require changes in the video buffer sizes, which generally requires stopping
> streaming, reconfiguring the pipeline and restarting streaming. That's not
> something the i2c driver can do.
>
> The confusion you have with mbus vs dv_timings is that soc_camera lacks dv_timings
> support. It was designed for sensors, although there is now some support for SDTV
> receivers (s/g_std ioctls), but dv_timings support has to be added there as well
> along the lines of what is done for s/g_std. Basically it is just a passthrough.
>
> The way s_mbus_fmt is defined in adv7604 today is correct. s_dv_timings should be
> called to change the format, s_mbus_fmt should just return the current width/height.
> For HDTV there is more involved than just width and height when changing formats,
> just as SDTV.
>
> So the right approach is to add support for query/enum/s/g_dv_timings and dv_timings_cap
> to soc_camera (just passthroughs). Then you can use it the way you are supposed to.
>
>> For example, when the camera driver receives v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
>> does it have to do the following:
>> v4l2_subdev_call(sd, video, query_dv_timings, timings);
>> v4l2_subdev_call(sd, video, s_dv_timings, timings);?
>>
>> I don't think that this is how it should work.
>
> And it shouldn't work like that. The soc_camera driver has to send out a FMT_CHANGE
> event to the application. It is the application that will receive that event, and
> will have to call QUERY_DV_TIMINGS, stop streaming, allocate new buffers to accomodate
> the new buffer size, call S_DV_TIMINGS and STREAMON to restart the newly configured
> pipeline.
>

IIUC, we can't just use VIDIOC_S_FMT, prepare the buffers and read a frame from HDTV.
We have to query dv_timings instead.
It looks like VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT may in fact return incorrect
data unless the application queries and sets DV timings before using S/G/TRY FMT ioctls.
What's the use of the FMT ioctls then?

> And we still haven't defined that FMT_CHANGE event. This is literally the first time
> that an upstreamed bridge driver has to support this.
>
> I will make an RFC for this today or tomorrow. It's really time that we add it.

Thanks!

>
>>
>> Anyways, I've tried to call query_dv_timings to initialize state->timings from the interrupt service workqueue.
>
> That's absolutely a no-go. Drivers should never change format midstream.
>
>> I've been able to catch format change events though it looks very sloppy at the moment.
>>
>> BTW, the driver doesn't provide any locking for reading/writing the state->settings which I believe could cause
>> some issues reading incomplete format when it changes asynchronously to the subdevice g_mbus_fmt operation.
>
> That shouldn't happen asynchronously. If you have asynchronous behavior like that, then
> that needs a close look.
>
> Another issue you have is how to set up the EDID in the receiver. Currently this
> is done through the v4l2-subdevX device node of the subdev and the VIDIOC_SUBDEV_G/S_EDID
> ioctls. However, soc_camera does not create those device nodes at the moment.
> For simple pipelines this may be overkill anyway. In our (non-upstreamed) bridge
> drivers we just implement VIDIOC_SUBDEV_G/S_EDID in the bridge driver and
> pass it through to the subdev. I have to think about this a bit more, perhaps
> I should create VIDIOC_G/S_EDID ioctls that can be used by standard, simple
> v4l2 devices as well. I'll add it to the RFC.
>
> Regardless, soc_camera needs to add support for setting/getting EDIDs one way
> or another.
>
>>
>>>>
>>>> It adds adv761x support to the adv7604 in a pretty clean way.
>>
>> Doesn't seem that clean to me after having a look at it.
>> It tries to handle both 7604 and 7611 chips in the same way, though,
>> I'm not exactly sure if it's a good idea since 7611/12 is a pure HDMI receiver with no analog inputs.
>
> The analog support of the adv7604 is pretty separate from the HDMI part, so
> I don't see that as a big deal. That said, I do have to reevaluate that when
> I see the latest version of this patch from Analog Devices later this week.
>
>>
>>>>
>>>> Thinking it over I prefer to use that code (although you will have to
>>>> add the soc-camera hack for the time being) over your driver.
>>>>
>>>> Others need adv7611 support as well, but with all the dv_timings etc. features
>>>> that are removed in your driver. So I am thinking that it is easier to merge
>>>> the xilinx version and add whatever you need on top of that.
>>
>> To be honest I'm more inclined to drop non-soc camera support from my driver and
>> move it to media/i2c/soc_camera/ the moment. That would be easier.
>
> I won't accept that, sorry.The issues you have derive more from misunderstanding
> the way an HDTV receiver is supposed to work (it's not all that easy to wrap your
> head around it) and from missing functionality for HDTV in soc_camera and even in
> the V4L2 API (because certain bridge drivers that demonstrate how it works couldn't
> be upstreamed and we want to avoid adding API additions without having drivers
> using it).

Thank you very much for your explanations.
Yes, it's kind of hard to get a hold of it with some functionality missing in the API
and the drivers. Your help is much appreciated.

>
>> I don't have any h/w I could test the xilinx version with non-SoC camera interface.
>
> Other than the glue to get hold of the platform_data there is no need for additional
> soc_camera changes in the driver, so that's not the issue. But soc_camera itself
> needs to be enhanced with dv_timings/FMT_CHANGE/EDID support.
>

Thanks,
Val.


