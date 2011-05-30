Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3593 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1E3HdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 03:33:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Strubel <hackfin@section5.ch>
Subject: Re: v4l2 device property framework in userspace
Date: Mon, 30 May 2011 09:32:59 +0200
Cc: linux-media@vger.kernel.org
References: <4DE244F4.90203@section5.ch>
In-Reply-To: <4DE244F4.90203@section5.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300932.59570.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, May 29, 2011 15:07:00 Martin Strubel wrote:
> Hello,
> 
> I was wondering if it makes sense to raise a discussion about a few
> aspects listed below - my apology, if this might be old coffee, I
> haven't been following this list for long.
> 
> Since older kernels didn't have the matching functionality, we (a few
> losely connected developers) had "hacked" a userspace framework to
> address various extra features (multi sensor head, realtime stuff or
> special sensor properties). So, our kernel driver (specific to the PPI
> port of the Blackfin architecture) is covering frame acquisition only,
> all sensor specific properties (that were historically rather to be
> integrated into the v4l2 system) are controller from userspace or over
> network using our netpp library (which was just released into opensource).
> 
> The reasons for this were:
> 1. 100's of register controlling various special properties on some SoC
> sensors
> 2. One software and kernel should work with all sorts of camera
> configuration
> 3. I'm lazy and hate to do a lot of boring code writing (ioctls()..).
> Also, we didn't want to bloat the kernel with property tables.
> 4. Some implementations did not have much to do with classic "video"
> 
> So nowadays we write or parse sensor properties into XML files and
> generate a library for it that wraps all sensor raw entities (registers
> and bits) into named entities for quick remote control and direct access
> to peripherals on the embedded target during the prototyping phase (this
> is what netpp does for us).
> 
> Now, the goal is to opensource stuff from the Blackfin-Side, too (as
> there seems to be no official v4l2 driver at the moment). Obviously, a
> lot of work has been done meanwhile on the upstream v4l2 side, but since
> I'm not completely into it yet, I'd like to ask the experts:
> 
> 1. Can we do multi sensor configurations on a tristated camera bus with
> the current kernel framework?

Yes. As long as the sensors are implemented as sub-devices (see
Documentation/video4linux/v4l2-framework.txt) then you can add lots of custom
controls to those subdevs that can be exposed to userspace. Writing directly
to sensor registers from userspace is a no-go. If done correctly using the
control framework (see Documentation/video4linux/v4l2-controls.txt) this shouldn't
take a lot of code. The hardest part is probably documentation of those controls.

> 2. Is there a preferred way to route ioctls() back to userspace
> "property handlers", so that standard v4l2 ioctls() can be implemented
> while special sensor properties are still accessible through userspace?

As mentioned, sensor properties should be implemented as V4L2 controls

> 3. Has anyone measured latencies (or is aware of such) with respect to
> process response to a just arrived video frame within the RT_PREEMPT
> context? (I assume any RT_PREEMPT latency research could be generalized
> to video, but asking anyhow)

I'm not aware of such measurements, but there is nothing special about video.
So it would be the same as any other process response to an interrupt.

> 4. For some applications it's mandatory to queue commands that are
> commited to a sensor immediately during a frame blank. This makes the
> shared userspace and kernel access for example to an SPI bus rather
> tricky. Can this be solved with the current (new) v4l2 framework?

That's why you want to always go through a kernel driver instead of mixing
kernel and userspace.

However, at the moment we do not have the ability to set and active a
configuration at a specific time. It is something on our TODO list, though.
You are not the only one that wants this.

Regards,

	Hans
