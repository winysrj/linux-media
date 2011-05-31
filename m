Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2772 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaIBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 04:01:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Strubel <hackfin@section5.ch>
Subject: Re: v4l2 device property framework in userspace
Date: Tue, 31 May 2011 10:01:40 +0200
Cc: linux-media@vger.kernel.org
References: <4DE244F4.90203@section5.ch> <bf5dd516b42805e8cb5ca0d66a4ed138.squirrel@webmail.xs4all.nl> <4DE39BEF.5080104@section5.ch>
In-Reply-To: <4DE39BEF.5080104@section5.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311001.40826.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, May 30, 2011 15:30:23 Martin Strubel wrote:
> Hi,
> 
> > 
> > The XML is basically just a dump of all the sensor registers, right?
> > 
> 
> There are two sections: The register tables, and the property wrappers.
> Property wrappers don't have to necessarily link to registers, but
> that's covered in the docs.
> 
> > So you are not talking about 'properties', but about reading/setting
> > registers directly. That's something that we do not support (or even want
> > to support) except for debugging (see the VIDIOC_DBG_G/S_REGISTER ioctls
> > which require root access).
> > 
> 
> I guess I should elaborate:
> For the case, when the hardware is "operation mode safe", i.e. you can
> set a value (like video format) in a register, you can wrap a property
> or ioctl directly into a register bit.
> For the case when it's not safe or more complex (i.e. you have to toggle
> a bit to actually enable the mode), you'll have to write handlers. It's
> up to you and the safety of the HW implementation, really.
> To the user, it's always just "Properties". What you do internally, is
> up to you. With a "non intelligent" register design, you'll have to
> indeed write quite some handler code.
> Where the handler lives (userspace or kernel) is again up to you.
> 
> > 
> > But this is not a driver. This is just a mapping of symbols to registers.
> > You are just moving the actual driver intelligence to userspace, making it
> > very hard to reuse. It's a no-go I'm afraid.
> > 
> 
> Actually no. IMHO, the kernel driver should not have all the
> intelligence (some might argue this contradicts the actual concept of a
> kernel).

Userspace tells the driver what it should do and the driver decides how to do it.
That's how it works.

> And for us it is even more reusable, because we can run the
> same thing on a standalone 'OS' (no OS really) and for example RTEMS.

That is never a consideration for linux. Hardware abstraction layers are not
allowed. Blame Linus, not me, although I completely agree with him on this.

> So for the various OS specifics, we only have one video acquisition
> driver which has no knowledge of the attached sensor. All generic v4l2
> properties again are tunneled through userspace to the "sensor daemon".
> I still don't see what is (technically) wrong with that.

It's the tunneling to a sensor daemon that is wrong. You can write a sensor
driver as a V4L subdevice driver and it is reusable by any 'video acquisition;
driver (aka V4L2 bridge/platform driver) without going through userspace and
requiring userspace daemons.

> For me, it works like a driver, plus it is way more flexible as I don't
> have to go through ioctls for special sensor properties.

You still have to go through the kernel to set registers. That's just as
expensive as an ioctl.

> 
> > 
> > As mentioned a list of registers does not make a driver. Someone has to do
> > the actual programming.
> > 
> 
> Sure. This aspect is covered by the netpp getters/setters.
> 
> >> recompile the kernel
> >> This is BTW a big issue for some embedded linux device vendors.
> >> So my question is still up, if there's room for userspace handlers for
> >> kernel events (ioctl requests). Our current hack is, to read events from
> >> a char device and push them through netpp.
> > 
> > Well, no. The policy is to have kernel drivers and not userspace drivers.
> > 
> > It's not just technical reasons, but also social reasons: suppose you have
> > userspace drivers, who is going to maintain all those drivers? Ensure that
> > they remain in sync, that new features can be added, etc.? That whole
> > infrastructure already exists if you use kernel drivers.
> 
> In the past we had a lot more work from each kernel release to update
> the kernel stuff because internals have been changing.

That's why you want to upstream drivers. Once it's upstream this work goes away.

> I don't see a problem maintaining the drivers, if you have lean & mean
> module interfaces. It creates a lot of work though, if you have to touch
> code over and over again (and this for each sensor implementation).
> If companies have to pay more for "social reasons", they won't do it.
> But again, this is argued about elsewhere..
> 
> I agree about an infrastructure, that's why I'm raising the discussion.
> 
> > 
> > Userspace drivers may be great in the short term and from the point of
> > view of a single company/user, but it's a lot less attractive in the long
> > term.
> > 
> > Anyway, using subdevices and judicious use of controls it really shouldn't
> > be that hard to create a kernel driver.
> > 
> 
> I don't know. Up to now (speaking Linux v2.6.34) I couldn't be
> convinced, and none of our customers could, either.  I'm aware that
> there are some crazy requirements from the machine vision domain that
> are of no relevance to a typical Linux webcam.

Note that much of the functionality you need didn't go into the kernel
until 2.6.39.

> Anyhow, if you don't want to support a userspace layer policy, it's no
> problem to us. We can just release the "dumb" acquisition driver and
> everyone can register his stuff on top.

Sure, no problem. It's open source after all. Just be aware that all the
maintenance effort is for you as long as you remain out of tree.

Regards,

	Hans
