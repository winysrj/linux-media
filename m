Return-path: <mchehab@pedra>
Received: from mxout003.mail.hostpoint.ch ([217.26.49.182]:65262 "EHLO
	mxout003.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab1E3Jiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 05:38:55 -0400
Message-ID: <4DE365A8.9050508@section5.ch>
Date: Mon, 30 May 2011 11:38:48 +0200
From: Martin Strubel <hackfin@section5.ch>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 device property framework in userspace
References: <4DE244F4.90203@section5.ch> <201105300932.59570.hverkuil@xs4all.nl>
In-Reply-To: <201105300932.59570.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> 
> Yes. As long as the sensors are implemented as sub-devices (see
> Documentation/video4linux/v4l2-framework.txt) then you can add lots of custom
> controls to those subdevs that can be exposed to userspace. Writing directly
> to sensor registers from userspace is a no-go. If done correctly using the
> control framework (see Documentation/video4linux/v4l2-controls.txt) this shouldn't
> take a lot of code. The hardest part is probably documentation of those controls.
> 

Well, we could generate all the control handlers from XML by writing
appropriate style sheets, but the point is that there are by now a few
hundreds of registers covered up in the current driver. Putting this
into the kernel would horribly bloat it, and this again is a no go on
our embedded system.
Documentation is also generated per property, BTW (as long as the user
fills in the <info> node)
Just to outline again what we're doing: The access to the registers (at
least to the SPI control interface) is in fact in kernel space, just the
handlers (and remember, there are a few 100s of them) are not. This
keeps the kernel layer lean and mean.
For machine vision people, most of the typical v4l2 controls are
irrelevant, but for things like video format, we just pass ioctl calls
to user space via kernel events, handle them, and pass the register
read/write sequence back to the kernel.
What problem do you see doing it this way? There seem to be various uio
based drivers out for v4l2 devices.
For i2c, we access the registers even through the /dev/i2c-X. So far I
see no problem with that, it turned out to provide better latencies (for
the video acquisition) in some scenarios that way. This does not allow
to switch configs in real-time, but this is a hacky task for i2c anyhow.

> ...
> 
> That's why you want to always go through a kernel driver instead of mixing
> kernel and userspace.
> 
> However, at the moment we do not have the ability to set and active a
> configuration at a specific time. It is something on our TODO list, though.
> You are not the only one that wants this.
> 

If we're adapting our stuff to the new framework, it will likely be
opensource, too. Just a few people will need to be convinced..

Cheers,

- Martin
