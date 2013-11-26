Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54543 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3KZV2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 16:28:21 -0500
Received: by mail-lb0-f174.google.com with SMTP id c11so4832531lbj.5
        for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 13:28:19 -0800 (PST)
Message-ID: <52951270.9040804@cogentembedded.com>
Date: Wed, 27 Nov 2013 01:28:16 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl> <528CA9E1.2020401@cogentembedded.com> <528CD86D.70506@xs4all.nl> <528CDB0B.3000109@cogentembedded.com>
In-Reply-To: <528CDB0B.3000109@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2013 07:53 PM, Valentine wrote:
> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>> Hi Valentine,

Hi Hans,

>>
>> Did you ever look at this adv7611 driver:
>>
>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4afa42af2daa12
>
> No, I missed that one somehow, although I did search for the adv7611/7612 before implementing this one.
> I'm going to look closer at the patch and test it.
>

I've tried the patch and I doubt that it was ever tested on adv7611.
I haven't been able to make it work so far. Here's the description of some of the issues
I've encountered.

The patch does not apply cleanly so I had to make small adjustments just to make it apply
without changing the functionality.

First of all the driver (adv7604_dummy_client function) does not set default I2C slave addresses
in the I/O map in case they are not set in the platform data.
This is not needed for 7604, since the default addresses are already set in the I/O map after chip reset.
However, the map is zeroed on 7611/7612 after power up, and we always have to set it manually.

I had to implement the IRQ handler since the soc_camera model does not use
interrupt_service_routine subdevice callback and R-Car VIN knows nothing about adv7612
interrupt routed to a GPIO pin.
So I had to schedule a workqueue and call adv7604_isr from there in case an interrupt happens.

The driver enables multiple interrupts on the chip, however, the adv7604_isr callback doesn't
seem to handle them correctly.
According to the docs:
"If an interrupt event occurs, and then a second interrupt event occurs before the system controller
has cleared or masked the first interrupt event, the ADV7611 does not generate a second interrupt signal."

However, the interrupt_service_routine doesn't account for that.
For example, in case fmt_change interrupt happens while fmt_change_digital interrupt is being
processed by the adv7604_isr routine. If fmt_change status is set just before we clear fmt_change_digital,
we never clear fmt_change. Thus, we end up with fmt_change interrupt missed and therefore further interrupts disabled.
I've tried to call the adv7604_isr routine in a loop and return from the worlqueue only when all interrupt status bits are cleared.
This did help a bit, but sometimes I started getting lots of I2C read/write errors for some reason.

I'm also not sure how the dv_timing API should be used.
The internal adv7604 state->timings structure is used when getting mbus format.
However, the driver does not set the structure neither at start-up nor in the interrupt service callback when format changes.
Is it supposed to be set by the upper level camera driver?
For example, when the camera driver receives v4l2_subdev_notify(sd, ADV7604_FMT_CHANGE, NULL);
does it have to do the following:
v4l2_subdev_call(sd, video, query_dv_timings, timings);
v4l2_subdev_call(sd, video, s_dv_timings, timings);?

I don't think that this is how it should work.

Anyways, I've tried to call query_dv_timings to initialize state->timings from the interrupt service workqueue.
I've been able to catch format change events though it looks very sloppy at the moment.

BTW, the driver doesn't provide any locking for reading/writing the state->settings which I believe could cause
some issues reading incomplete format when it changes asynchronously to the subdevice g_mbus_fmt operation.

>>
>> It adds adv761x support to the adv7604 in a pretty clean way.

Doesn't seem that clean to me after having a look at it.
It tries to handle both 7604 and 7611 chips in the same way, though,
I'm not exactly sure if it's a good idea since 7611/12 is a pure HDMI receiver with no analog inputs.

>>
>> Thinking it over I prefer to use that code (although you will have to
>> add the soc-camera hack for the time being) over your driver.
>>
>> Others need adv7611 support as well, but with all the dv_timings etc. features
>> that are removed in your driver. So I am thinking that it is easier to merge
>> the xilinx version and add whatever you need on top of that.

To be honest I'm more inclined to drop non-soc camera support from my driver and
move it to media/i2c/soc_camera/ the moment. That would be easier.
I don't have any h/w I could test the xilinx version with non-SoC camera interface.
Currently I'm trying to play with core settings since even though I've managed to glue adv7611 support and
the R-Car VIN SoC camera driver I haven't been able to capture a frame.

>>
>
> Thanks,
> Val.
>
>> Regards,
>>
>>     Hans
>>

Thanks,
Val.

>> On 11/20/13 13:24, Valentine wrote:
>>> On 11/20/2013 03:19 PM, Hans Verkuil wrote:
>>>> Hi Valentine,
>>>
>>> Hi Hans,
>>>
>>>>
>>>> On 11/20/13 11:14, Valentine wrote:
>>>>> On 11/19/2013 01:50 PM, Hans Verkuil wrote:
>>>>>> Hi Valentine,
>>>>>
>>>>> Hi Hans,
>>>>> thanks for your review.
>>>>>
>>>>>>
>>>>>> I don't entirely understand how you use this driver with soc-camera.
>>>>>> Since soc-camera doesn't support FMT_CHANGE notifies it can't really
>>>>>> act on it. Did you hack soc-camera to do this?
>>>>>
>>>>> I did not. The format is queried before reading the frame by the user-space.
>>>>> I'm not sure if there's some kind of generic interface to notify the camera
>>>>> layer about format change events. Different subdevices use different FMT_CHANGE
>>>>> defines for that. I've implemented the format change notifier based on the adv7604
>>>>> in hope that it may be useful later.
>>>>
>>>> Yes, I need to generalize the FMT_CHANGE event.
>>>>
>>>> But what happens if you are streaming and the HDMI connector is unplugged?
>>>> Or plugged back in again, possibly with a larger resolution? I'm not sure
>>>> if the soc_camera driver supports such scenarios.
>>>
>>> It doesn't. Currently it's up to the UI to poll the format and do the necessary changes.
>>> Otherwise the picture will be incorrect.
>>>
>>>>
>>>>>
>>>>>>
>>>>>> The way it stands I would prefer to see a version of the driver without
>>>>>> soc-camera support. I wouldn't have a problem merging that as this driver
>>>>>> is a good base for further development.
>>>>>
>>>>> I've tried to implement the driver base good enough to work with both SoC
>>>>> and non-SoC cameras since I don't think having 2 separate drivers for
>>>>> different camera models is a good idea.
>>>>>
>>>>> The problem is that I'm using it with R-Car VIN SoC camera driver and don't
>>>>> have any other h/w. Having a platform data quirk for SoC camera in
>>>>> the subdevice driver seemed simple and clean enough.
>>>>
>>>> I hate it, but it isn't something you can do anything about. So it will have
>>>> to do for now.
>>>>
>>>>> Hacking SoC camera to make it support both generic and SoC cam subdevices
>>>>> doesn't seem that straightforward to me.
>>>>
>>>> Guennadi, what is the status of this? I'm getting really tired of soc-camera
>>>> infecting sub-devices. Subdev drivers should be independent of any bridge
>>>> driver using them, but soc-camera keeps breaking that. It's driving me nuts.
>>>>
>>>> I'll be honest, it's getting to the point that I want to just NACK any
>>>> future subdev drivers that depend on soc-camera, just to force a solution.
>>>> There is no technical reason for this dependency, it just takes some time
>>>> to fix soc-camera.
>>>>
>>>>> Re-implementing R-Car VIN as a non-SoC model seems quite a big task that
>>>>> involves a lot of regression testing with other R-Car boards that use different
>>>>> subdevices with VIN.
>>>>>
>>>>> What would you suggest?
>>>>
>>>> Let's leave it as-is for now :-(
>>>>
>>>> I'm not happy, but as I said, it's not your fault.
>>>
>>> OK, thanks.
>>> Once a better solution is available we can remove the quirk.
>>>
>>>>
>>>> Regards,
>>>>
>>>>      Hans
>>>
>>> Thanks,
>>> Val.
>>>
>>>>
>>>>>
>>>>>>
>>>>>> You do however have to add support for the V4L2_CID_DV_RX_POWER_PRESENT
>>>>>> control. It's easy to implement and that way apps can be notified when
>>>>>> the hotplug changes value.
>>>>>
>>>>> OK, thanks.
>>>>>
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>>       Hans
>>>>>
>>>>> Thanks,
>>>>> Val.
>>>>>
>>>>>>
>>>>>> On 11/15/13 13:54, Valentine Barshak wrote:
>>>>>>> This adds ADV7611/ADV7612 Xpressview  HDMI Receiver base
>>>>>>> support. Only one HDMI port is supported on ADV7612.
>>>>>>>
>>>>>>> The code is based on the ADV7604 driver, and ADV7612 patch by
>>>>>>> Shinobu Uehara <shinobu.uehara.xc@renesas.com>
>>>>>>>
>>>>>>> Changes in version 2:
>>>>>>> * Used platform data for I2C addresses setup. The driver
>>>>>>>      should work with both SoC and non-SoC camera models.
>>>>>>> * Dropped unnecessary code and unsupported callbacks.
>>>>>>> * Implemented IRQ handling for format change detection.
>>>>>>>
>>>>>>> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
>>>
>>>
>>
>

