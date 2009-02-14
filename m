Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58708 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZBNO05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 09:26:57 -0500
Subject: Re: VIDIOC_G_REGISTER question
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200902141051.52447.hverkuil@xs4all.nl>
References: <1234574774.3112.16.camel@palomino.walls.org>
	 <200902141051.52447.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 09:27:01 -0500
Message-Id: <1234621621.3073.48.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-02-14 at 10:51 +0100, Hans Verkuil wrote:
> On Saturday 14 February 2009 02:26:14 Andy Walls wrote:
> > I'm treating the CX23418 A/V Core as a non-I2C host chip.
> >
> > Am I allowed to modify the register value passed in to a
> > VIDIOC_G_REGISTER ioctl() like below?  The spec doesn't say if this
> > feedback is expected or not.
> 
> Good point. The short answer is no, because no other driver does that AFAIK. 
> 
> The long answer is that perhaps we should do this, but that requires going 
> through all drivers and updating them, and it requires changing the API for 
> s_register (currently that has a const argument) and requiring drivers to 
> update reg in s_register as well. But I do not really see much of an 
> advantage in doing this. It would also make it impossible to have a 
> for-loop on the reg field when iterating over registers (for the record: 
> v4l2-dbg doesn't do that).

Yeah.  I thought better of it.  The g/s_register now returns -EINVAL if
the input address is not 4 byte aligned.  I figured that was a
reasonable simplification that only impacts the expert user.




> Nice idea, BTW, making the analog front end addr 1 on the host.

Well, since I was logicaly treating it like a second chip (and not the
host) and the V4L2 Spec said to use MATCH_HOST with a non-0 address for
the Nth non-host, non-I2C, chip on the board, that is what fell out.  (I
was surpirsed to see the explicit AC97 chip match option.  It seemed out
of place when looking at the V4L2 spec.)

Really I just wanted a convenient alias to the CX18-AV register set.
Using register addresses like 0x404 is alot easier on my memory than
addresses like 0x2c40404.

I suppose I could do something similar for all the functionally
different register space partitions on the chip, but that's just
overkill.  Honestly the v4l2_device/v4l2_subdev framework looks like it
can let a driver writer do all sorts of abstractions along this lines.



> For the chip revision I would suggest looking at various revision registers 
> in the analog front end: regs 0x0000, 0x0004, 0x000c and 0x0100 all have 
> some sort of a version/revision ID in them. The 0x0100 should match the 
> revision as used in the cx2584x. I never really looked at these regs, so I 
> don't know which makes the most sense.

I believe the internal device *always* claims to be an '843 when you
look at the register.  I don't think the minor rev of this internal
digitizer core is going to matter given the host chip revision.  I was
more worried about confusion with a real CX25843, which has 1 byte
"alignment", and this AV decoder, which has 4 byte alignment.  The '418
revision number is a cheap hack to make sure external apps know the
difference without having to squirrel away the host chip id..  If that's
the wrong thing, I can give it a new real ID in the CX25840 block of the
id enumeration and provide the real revision.


> Just FYI, once all drivers are using v4l2_subdev I'm going to simplify the 
> chip_ident and s/g_register functions by integrating it into v4l2_subdev. 
> The idea is to put ident and revision into the v4l2_subdev struct, and have 
> a dbg_match op in v4l2_subdev that is used to do the matching for 
> g_chip_ident and g/s_register. For i2c devices this will be a standard 
> function in v4l2-common.h. So g_chip_ident will disappear and g/s_register 
> no longer needs to do any matching.

Excellent.

Regards,
Andy



> Regards,
> 
> 	Hans


