Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2280 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZELHuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 03:50:25 -0400
Message-ID: <53599.62.70.2.252.1242114622.squirrel@webmail.xs4all.nl>
Date: Tue, 12 May 2009 09:50:22 +0200 (CEST)
Subject: Re: [PATCH v2 0/7] [RFC] FM Transmitter (si4713) and another
     changes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tue, May 12, 2009 at 09:03:18AM +0200, ext Hans Verkuil wrote:
>> On Monday 11 May 2009 11:31:42 Eduardo Valentin wrote:
>> > Hello all,
>> >
>> > It took a few but I'm resending the FM transmitter driver again.
>> > Sorry for this delay, but I had another things to give attention.
>> >
>> > Anyway, after reading the API and re-writing the code I came up
>> > with the following 7 patches. Three of them are in the v4l2 API.
>> > The other 4 are for the si4713 device.
>> >
>> > It is because of the first 3 patches that I'm sending this as a RFC.
>> >
>> > The first and second patches, as suggested before, are creating
>> another
>> > v4l2 extended controls class, the V4L2_CTRL_CLASS_FMTX. At this
>> > first interaction, I've put all si4713 device extra properties there.
>> > But I think that some of the can be moved to private class
>> > (V4L2_CID_PRIVATE_BASE). That's the case of the region related things.
>> > Comments are wellcome.
>> >
>> > The third patch came *maybe* because I've misunderstood something. But
>> > I realized that the v4l2-subdev helper functions for I2C devices
>> assumes
>> > that the bridge device will create an I2C adaptor. And in that case,
>> only
>> > I2C address and its type are suffient. But in this case, makes no
>> sense
>> > to me to create an adaptor for the si4713 platform device driver. This
>> is
>> > the case where the device (si4713) is connected to an existing
>> adaptor.
>> > That's why I've realized that currently there is no way to pass I2C
>> board
>> > info using the current v4l2 I2C helper functions. Other info like irq
>> > line and platform data are not passed to subdevices. So, that's why
>> I've
>> > created that patch.
>>
>> I've made several changes to the v4l2-subdev helpers: you now pass the
>> i2c
>> adapter directly. I've also fixed the unregister code to properly
>> unregister any i2c client so you can safely rmmod and modprobe the i2c
>> module.
>
> Right. I will check those.
>
>>
>> What sort of platform data do you need to pass to the i2c driver? I have
>> yet
>> to see a valid use case for this that can't be handled in a different
>> way.
>> Remember that devices like this are not limited to fixed platforms, but
>> can
>> also be used in USB or PCI devices.
>
> Yes, sure. Well, a simple "set_power" procedure is an example of things
> that
> I see as platform specific. Which may be passed by platform data
> structures.
> In some platform a set power / reset line may be done by a simple gpio.
> but
> in others it may be a different procedure.

The v4l2_device struct has a notify callback: you can use that one
instead. That way the subdev driver doesn't have to have any knowledge
about the platform it is used in.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

