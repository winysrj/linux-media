Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1632 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZDUM5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 08:57:47 -0400
Message-ID: <43394.62.70.2.252.1240318665.squirrel@webmail.xs4all.nl>
Date: Tue, 21 Apr 2009 14:57:45 +0200 (CEST)
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: gatoguan-os@yahoo.com
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
> On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> On Tue, 21 Apr 2009, Agustin wrote:
>> >
>> > Hi,
>> >
>> > On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> > > Video (sub)devices, connecting to SoCs over generic i2c busses
>> cannot
>> > > provide a pointer to struct v4l2_device in i2c-adapter driver_data,
>> and
>> > > provide their own i2c_board_info data, including a platform_data
>> field.
>> > > Add a v4l2_i2c_new_dev_subdev() API function that does exactly the
>> same
>> > > as v4l2_i2c_new_subdev() but uses different parameters, and make
>> > > v4l2_i2c_new_subdev() a wrapper around it.
>> >
>> > [snip]
>> >
>> > I am wondering about this ongoing effort and its pursued goal: is it
>> > to hierarchize the v4l architecture, adding new abstraction levels?
>> > If so, what for?
>
>> Driver-reuse. soc-camera framework will be able to use all available and
>> new v4l2-subdev drivers, and vice versa.
>
> Well, "Driver reuse." sounds more as a mantra than a reason for me. Then I
> can't find any "available" v4l2-subdev driver in 2.6.29.

Look in 2.6.30. Also look in Documentation/video4linux/v4l2-framework.txt
which documents the new framework.

> I assume this subdev stuff plays a mayor role in current V4L2 architecture
> refactorization. Then we probably should take this opportunity to relieve
> V4L APIs from all its explicit I2C mangling, because...

That is the case if you use v4l2_subdev. That's completely bus independent.

>> > To me, as an eventual driver developer, this makes it harder to
>> > integrate my own drivers, as I use I2C and V4L in my system but I
>> > don't want them to be tightly coupled.
>
>> This conversion shouldn't make the coupling any tighter.
>
> But still I think V4L system should not be aware of I2C at all.
>
> To me, V4L is a kernel subsystem in charge of moving multimedia data
> from/to userspace/hardware, and the APIs should reflect just that.
>
> If one V4L driver uses I2C for device control, what does V4L have to say
> about that, really? Or why V4L would never care about usb or SPI links?
>
> I2C and V4L should stay cleanly and clearly apart.

Again, that's what v4l2_subdev does. And in fact it is used like that
already in the ivtv and cx18 drivers.

>> > Of course I can ignore this "subdev" stuff and just link against
>> > soc-camera which is what I need, and manage I2C without V4L knowing
>> > about it. Which is what I do.
>
>> You won't be able to. The only link to woc-camera will be the
>> v4l2-subdev link. Already now with this patch many essential
>> soc-camera API operations are gone.
>
> I guess you mean that I will have to use v4l2-subdev interface to connect
> to soc-camera, and not to surrender my I2C management to an I2C-extraneous
> subsystem. Is that right?
>
> (Sorry for arriving this late to the discussion just to critizise your
> good efforts.)

All i2c v4l drivers should use v4l2_subdev so that they can be reused in
other PCI/USB/platform/whatever drivers. Currently sensor drivers such as
mt9m111 are tied to soc-camera and are impossible to reuse in e.g. a USB
webcam driver. In 2.6.30 all i2c v4l drivers used by PCI and USB drivers
are converted to v4l2_subdev. By 2.6.31 I hope that the soc-camera i2c
drivers and the i2c drivers based on v4l2-int-device.h are also converted,
thus making the i2c v4l drivers completely reusable.

In addition, the flexibility of v4l2_subdev allows it to be used for other
non-i2c devices as well.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

