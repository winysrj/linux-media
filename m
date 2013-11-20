Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63399 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3KTMYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Nov 2013 07:24:06 -0500
Received: by mail-lb0-f177.google.com with SMTP id w7so3411460lbi.36
        for <linux-media@vger.kernel.org>; Wed, 20 Nov 2013 04:24:03 -0800 (PST)
Message-ID: <528CA9E1.2020401@cogentembedded.com>
Date: Wed, 20 Nov 2013 16:24:01 +0400
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
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl>
In-Reply-To: <528C9ADB.3050803@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2013 03:19 PM, Hans Verkuil wrote:
> Hi Valentine,

Hi Hans,

>
> On 11/20/13 11:14, Valentine wrote:
>> On 11/19/2013 01:50 PM, Hans Verkuil wrote:
>>> Hi Valentine,
>>
>> Hi Hans,
>> thanks for your review.
>>
>>>
>>> I don't entirely understand how you use this driver with soc-camera.
>>> Since soc-camera doesn't support FMT_CHANGE notifies it can't really
>>> act on it. Did you hack soc-camera to do this?
>>
>> I did not. The format is queried before reading the frame by the user-space.
>> I'm not sure if there's some kind of generic interface to notify the camera
>> layer about format change events. Different subdevices use different FMT_CHANGE
>> defines for that. I've implemented the format change notifier based on the adv7604
>> in hope that it may be useful later.
>
> Yes, I need to generalize the FMT_CHANGE event.
>
> But what happens if you are streaming and the HDMI connector is unplugged?
> Or plugged back in again, possibly with a larger resolution? I'm not sure
> if the soc_camera driver supports such scenarios.

It doesn't. Currently it's up to the UI to poll the format and do the necessary changes.
Otherwise the picture will be incorrect.

>
>>
>>>
>>> The way it stands I would prefer to see a version of the driver without
>>> soc-camera support. I wouldn't have a problem merging that as this driver
>>> is a good base for further development.
>>
>> I've tried to implement the driver base good enough to work with both SoC
>> and non-SoC cameras since I don't think having 2 separate drivers for
>> different camera models is a good idea.
>>
>> The problem is that I'm using it with R-Car VIN SoC camera driver and don't
>> have any other h/w. Having a platform data quirk for SoC camera in
>> the subdevice driver seemed simple and clean enough.
>
> I hate it, but it isn't something you can do anything about. So it will have
> to do for now.
>
>> Hacking SoC camera to make it support both generic and SoC cam subdevices
>> doesn't seem that straightforward to me.
>
> Guennadi, what is the status of this? I'm getting really tired of soc-camera
> infecting sub-devices. Subdev drivers should be independent of any bridge
> driver using them, but soc-camera keeps breaking that. It's driving me nuts.
>
> I'll be honest, it's getting to the point that I want to just NACK any
> future subdev drivers that depend on soc-camera, just to force a solution.
> There is no technical reason for this dependency, it just takes some time
> to fix soc-camera.
>
>> Re-implementing R-Car VIN as a non-SoC model seems quite a big task that
>> involves a lot of regression testing with other R-Car boards that use different
>> subdevices with VIN.
>>
>> What would you suggest?
>
> Let's leave it as-is for now :-(
>
> I'm not happy, but as I said, it's not your fault.

OK, thanks.
Once a better solution is available we can remove the quirk.

>
> Regards,
>
> 	Hans

Thanks,
Val.

>
>>
>>>
>>> You do however have to add support for the V4L2_CID_DV_RX_POWER_PRESENT
>>> control. It's easy to implement and that way apps can be notified when
>>> the hotplug changes value.
>>
>> OK, thanks.
>>
>>>
>>> Regards,
>>>
>>>      Hans
>>
>> Thanks,
>> Val.
>>
>>>
>>> On 11/15/13 13:54, Valentine Barshak wrote:
>>>> This adds ADV7611/ADV7612 Xpressview  HDMI Receiver base
>>>> support. Only one HDMI port is supported on ADV7612.
>>>>
>>>> The code is based on the ADV7604 driver, and ADV7612 patch by
>>>> Shinobu Uehara <shinobu.uehara.xc@renesas.com>
>>>>
>>>> Changes in version 2:
>>>> * Used platform data for I2C addresses setup. The driver
>>>>     should work with both SoC and non-SoC camera models.
>>>> * Dropped unnecessary code and unsupported callbacks.
>>>> * Implemented IRQ handling for format change detection.
>>>>
>>>> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>


