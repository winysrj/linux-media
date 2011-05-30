Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1297 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1E3KwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 06:52:25 -0400
Message-ID: <322765c00a668d7915214de27d3debe7.squirrel@webmail.xs4all.nl>
In-Reply-To: <4DE365A8.9050508@section5.ch>
References: <4DE244F4.90203@section5.ch>
    <201105300932.59570.hverkuil@xs4all.nl>
    <4DE365A8.9050508@section5.ch>
Date: Mon, 30 May 2011 12:52:21 +0200
Subject: Re: v4l2 device property framework in userspace
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Martin Strubel" <hackfin@section5.ch>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi,
>
>>
>> Yes. As long as the sensors are implemented as sub-devices (see
>> Documentation/video4linux/v4l2-framework.txt) then you can add lots of
>> custom
>> controls to those subdevs that can be exposed to userspace. Writing
>> directly
>> to sensor registers from userspace is a no-go. If done correctly using
>> the
>> control framework (see Documentation/video4linux/v4l2-controls.txt) this
>> shouldn't
>> take a lot of code. The hardest part is probably documentation of those
>> controls.
>>
>
> Well, we could generate all the control handlers from XML by writing
> appropriate style sheets, but the point is that there are by now a few
> hundreds of registers covered up in the current driver. Putting this
> into the kernel would horribly bloat it, and this again is a no go on
> our embedded system.
> Documentation is also generated per property, BTW (as long as the user
> fills in the <info> node)
> Just to outline again what we're doing: The access to the registers (at
> least to the SPI control interface) is in fact in kernel space, just the
> handlers (and remember, there are a few 100s of them) are not. This
> keeps the kernel layer lean and mean.

Can you give examples of the sort of things that are in those registers?
Is that XML file available somewhere? Are there public datasheets?

BTW, you should need just a single control handler that just looks up all
the relevant information in a table.

> For machine vision people, most of the typical v4l2 controls are
> irrelevant, but for things like video format, we just pass ioctl calls
> to user space via kernel events, handle them, and pass the register
> read/write sequence back to the kernel.
> What problem do you see doing it this way? There seem to be various uio
> based drivers out for v4l2 devices.

If V4L2 drivers want to go into the kernel, then it is highly unlikely we
want to allow uio drivers. Such drivers cannot be reused. A typical sensor
can be used by many vendors and products. By ensuring that access to the
sensor is standardized you ensure that anyone can use that sensor and that
fixes/improvements to that sensor will benefit everyone.

You don't have that with uio, and that's the reason we don't want it
(other reasons are possible abuse of uio allowing closed source drivers
being build on top of it).

Regards,

         Hans

