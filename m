Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4643 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab0JTGpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 02:45:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: rtl2832u support
Date: Wed, 20 Oct 2010 08:44:57 +0200
Cc: Damjan Marion <damjan.marion@gmail.com>,
	linux-media@vger.kernel.org
References: <B757CA7E-493B-44D6-8CE5-2F7AED446D70@gmail.com> <201010192227.39364.hverkuil@xs4all.nl> <AANLkTimk9kP5pb4yy+L0Zu0Om0siLnsDUzDZ2AmZkHMd@mail.gmail.com>
In-Reply-To: <AANLkTimk9kP5pb4yy+L0Zu0Om0siLnsDUzDZ2AmZkHMd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010200844.58041.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, October 19, 2010 23:28:49 Devin Heitmueller wrote:
> On Tue, Oct 19, 2010 at 4:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Bullshit.
> 
> Not exactly the level of mutual respect for your peers that I would
> expect of you, Hans.

You I right, that could have been phrased more diplomatically. So I'm human
after all :-)

> > First of all these rules are those of the kernel community
> > as a whole and *not* linuxtv as such, and secondly you can upstream such
> > drivers in the staging tree. If you want to move it out of staging, then
> > it will take indeed more work since the quality requirements are higher
> > there.
> 
> You are correct - while I indeed say it was the position of the
> LinuxTV developers, I didn't intend to single them out from the rest
> of the Linux kernel community.  The problem I described is systemic to
> working with the Linux kernel community in general.
> 
> > Them's the rules for kernel development.
> >
> > I've done my share of coding style cleanups. I never understand why people
> > dislike doing that. In my experience it always greatly improves the code
> > (i.e. I can actually understand it) and it tends to highlight the remaining
> > problematic areas in the driver.
> 
> Because it's additional work.  I agree that *sometimes* it can be
> useful.  And yet many times it's a bunch of changes that provide
> little actual value and only make it harder to keep the Linux driver
> in sync with the upstream source (in many cases, the GPL driver is
> derived from some Windows driver or other source).

Yes, it is additional work, but there is a big payout at the end: once the
driver is merged in the mainline, then your maintenance level falls down
to just bug fixing. That is a *huge* cost saving.

I also have to say that in my experience most driver code made this way
(i.e. OS independent) tends to be truly awful code.
 
> Alex makes a point that I think it's worth expanding on a bit:
> 
> The Linux kernel developers' goals are different than those of the
> product/chipset vendor.  The product/chipset vendor typically wants
> consistency across operating systems.  This usually involves some sort
> of OS portability layer to abstract out the OS specific parts (which
> is usually done as a combination of OS specific header files and C
> macros).  This reduces the maintenance cost for the author as it makes
> it easier to be confident that changes to the core will basically
> "just work" on other operating systems.

Been there, done that.
 
> The Linux kernel developer wants consistency across Linux drivers
> regardless of who wrote them.  This makes sense for the Linux kernel
> community in that it makes it easier to work on drivers that you
> didn't necessarily write.  However it also means that all of the
> portability code and macros are seen as "crap which has to be stripped
> out".  The net effect is a driver that looks little like the original
> platform independent driver, making it easier for the Linux kernel
> community to maintain but harder for the original author to provide
> updates to.

Ah, and there is the crucial phrase: "making it easier for the Linux kernel
community to maintain". That's the pay-off: once it is in you no longer have
to care about maintaining it besides bug fixes. The maintenance level of
out-of-tree drivers seems quite low in the beginning but over time it can
skyrocket. Particularly in a subsystem like v4l which is undergoing a lot
of change.

> I can appreciate why the Linux development community chose this route,
> but let's not pretend that it doesn't come at a significant cost.

It's the difference between 'high initial cost, low or no cost afterwards'
and 'low initial cost, ever increasing cost afterwards'. In my experience,
the first option has always a (much) lower total cost compared to the
second option. Not to mention a much higher code quality. But it can be
very hard to convince companies of that, particularly when they just start
out doing linux work.

A special case is when the hardware needs to support a new feature for which
a new public API is needed. There the initial cost can be very high indeed.

For small companies that can be prohibitive. I have no real solution for this
at the moment. But it does make me appreciate companies like TI, Samsung and
Nokia who are willing to take the long road, hopefully with a big payout at
the end.

> Kind of like how the Git move has resulted in developers who want to
> build drivers on a known-stable kernel (as opposed to the bleeding
> edge) being treated as second class citizens.

That's a typical example of having limited resources. I also would like to
see better support for building against stable kernels (and I have to test
Mauro's new approach one of these days), but there is only so much time
(and money) available.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
