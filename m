Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3526 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1AVIw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 03:52:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: v4l2-compliance utility
Date: Sat, 22 Jan 2011 09:52:18 +0100
Cc: linux-media@vger.kernel.org
References: <201101212337.54213.hverkuil@xs4all.nl> <1295652919.2474.14.camel@localhost>
In-Reply-To: <1295652919.2474.14.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101220952.18293.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 22, 2011 00:35:19 Andy Walls wrote:
> On Fri, 2011-01-21 at 23:37 +0100, Hans Verkuil wrote:
> > Hi all,
> > 
> > As you may have seen I have been adding a lot of tests to the v4l2-compliance
> > utility in v4l-utils lately. It is now getting to the state that is becomes
> > quite useful even though there is no full coverage yet.
> > 
> > Currently the following ioctls are being tested:
> 
> Hans,
> 
> This is a great thing to have.  Thanks!
> 
> 
> > Also tested is whether you can open device nodes multiple times.
> > 
> > These tests are pretty exhaustive and more strict than the spec itself.
> 
> OK, so multiple open is not strictly required by the spec, IIRC.  If you
> check the ivtv /dev/radio node, it does not allow multiple open, IIRC,
> so it should not get OK for that test.

And indeed it fails on that test.

> I also think during the subdev conversion, some of the less popular ivtv
> cards with GPIO controlled radio audio may have been broken (and still
> not fixed yet :(  ), but working for the PVR-150, PVR-500, etc..

What the tool does not do of course is test if your driver actually works.
So it tests if you can e.g. set the audio output to some value, but whether
you actually get audio on that output is a completely separate matter :-)
 
> The DEBUG ioctl()s can be compiled out too.

In that case the tool should report 'Not Supported'.

> 
> So for someone making decisions based on the output of this tool:
> 
> 1. if something comes back as "Not supported", that still means the
> driver is API specification compliant, right?

Yes. And as far as the compliance tool is concerned the driver tells it
that it doesn't support that particular API. E.g. a card without a tuner
should report 'Not Supported' for the S/G_TUNER tests.

> 2. could it be the case that this compliance tool will be sensitive to
> the driver/hardware combination and not the driver alone?

Definitely. If certain features (e.g. a tuner) are only available on certain
cards, then the tool can only test what the hardware you use at the moment
supports.

The utility tests whether, for the current kernel configuration, driver and
hardware, the V4L2 device node works as it should.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
