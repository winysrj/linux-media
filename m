Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1323 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2HMPuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 11:50:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Mon, 13 Aug 2012 17:49:27 +0200
Cc: "Linux-Media" <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208131604.28675.hverkuil@xs4all.nl> <CALzAhNVFSH0+y9XU39EzzBhH4rAAC2RStZKA3hzTfexzCKBHRQ@mail.gmail.com>
In-Reply-To: <CALzAhNVFSH0+y9XU39EzzBhH4rAAC2RStZKA3hzTfexzCKBHRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131749.27701.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 13 2012 16:46:45 Steven Toth wrote:
> Hans,
> 
> Thanks for your feedback.
> 
> Oh dear. I don't think you're going to like my response, but I think
> we know each other well enough to realize that neither of us are
> trying to antagonize or upset either other. We're simply stating our
> positions. Please read on.

I didn't think you'd like my response either :-)

> > I went through this driver from a high-level point of view, and I'm afraid I
> > have quite a number of issues with this driver.
> >
> > One of the bigger ones is that vc8x0-ad7441.c should be implemented as
> > a subdevice. I have two other AD drivers in my queue (adv7604 and ad9389b),
> > so you can look at those for comparison.
> >
> > See: http://www.spinics.net/lists/linux-media/msg51501.html
> 
> Oh, I understand how to write video decoder drivers. I just chose
> specifically not to do it. This was intensional on my part. If when
> another card comes along with an ad7441 when they are welcome to split
> the code and/or create the subdevs. It's extra engineering today that
> does't improve the support for the 820 card and doesn't benefit any
> other known product. It's a feature that's exclusive to the 820.
> Future developers are welcome to fork, slice and/or copy the code.
> Today, the driver is tuned exactly for the card, it works very nicely
> for end users and the code is easy to read, simple to debug and relies
> on only a handful of v4l2 framework apis.

The problem is that it is very hard, if not impossible, to split something
up after the fact. There are almost no drivers left that still have an
integral i2c driver as opposed to a separate i2c driver. I only know of
a few old ones and at least one in staging (not counting reverse
engineered drivers such as in gspca where there is no choice).

The main advantage is that it is much easier to extend the functionality
of your driver, particularly for devices with a lot of functionality like
those ADV drivers.

> If anyone knew how much time and suffering I've had with the cx25840
> over the years, why I think has gotten worse with the subdev controls,
> you'd be shocked.

As someone who has been heavily involved with the cx25840 I know how you
feel. However, in my opinion that is mostly caused by the cx25840 hardware
itself which is a piece of sh*t. Most other subdevices see much less change
and are not as sensitive to breakage as that one.

> The subdev framework (in my opinion) has become
> unwieldily and difficult to debug, based on my recent experience
> dealing with some cx23885 issues. I'm intensionally trying not to use
> it.

In what respect does the subdev framework make debugging hard? I'd like to
know about it so we can try and improve it.

The subdev framework was made to make reuse possible. If everyone refuses
to use it, then we're back to the bad old times where you get 20
almost-but-not-quite identical i2c driver implementations.

> I should be clear, my comments are not mean to antagonize or inflame,
> I'm simply pointing out that when at all possible I chose not to use
> the subdev framework because if it's delays and difficulties when it
> comes to debugging.
> 
> When did the subdev framework become a mandatory requirement for any
> driver merge?

It is certainly highly recommended, and in my opinion there should be
very good reasons for not doing it. In the end it is Mauro who decides,
although I personally would be in favor of mandating it. Not to pester
people, but it is so much harder to split it up after the fact. Just like
the fact that documentation is now required if a new API is added, because
nobody ever writes documentation afterwards.

> >
> > These Analog Devices chips are quite complex, and you really want to be able
> > to reuse drivers.
> 
> I am certainly more than willing to discuss re-use, when re-use make
> sense. Right now we have no-practical re-use for this part to speak
> of. The code is targeted towards the 820, in the use case that end
> users need. If someone would like to build a ad7441 subdevice and use
> that in their driver then they are welcome to the code. In practise,
> sharing complex video decoders across driver designs leads to massive
> regressions, as witnessed on the list this year.
> 
> I am also aware that the cx25840 driver is complex, and the end result
> was that driver maintainers effectively forked the cx25840 and brought
> the codebase back into their core drivers (cx18 for example), to avoid
> issues where regression testing was troublesome across so many cards.

I don't think the cx18 ever used the cx25840 codebase: while the cx23418
uses a similar IP as the cx25840 there were too many differences to allow
us (actually, I think it was me who wrote it initially for the cx18) to
reuse the cx25840.

That's a general problem, BTW: reuse works well for the exact same chip.
But when you get variants of the chip (or it gets integrated in another chip
as an IP block), then at some point keeping track of those differences and
preventing regressions becomes harder than it would be if they were done as
separate drivers.

Where that boundary is is not always clear, and for the cx25840 we probably
exceeded it.

But sharing a subdevice driver for a single chip among different boards has
never been much of a problem in my experience. I'm not saying we never got
regressions, but not many and they were generally quickly caught.

> If I had the time and/or energy, we'd do the same with the cx25840.
> Keeping complex code close to the PCI/PCIe bridge bring big dividends
> when debugging complex problems and mitigating issues where code is
> re-used across multiple products (growing any regression test
> requirements).
> 
> The entire driver was intensionally written to be self-enclosed,
> highly portable between 2.6.3x and v3.x kernels without subdev
> breakages and/or api changes. With a small external Makefile it even
> builds very nicely outside of the kernel on any kernel you like, that
> shipped in the last 2-3 years.

??? We have the media_build system for that, so why care about older kernels?

> >
> > Some of the other issues are:
> >
> > - Please use the control framework. All new drivers must use it, unless there
> >   are very, very good reasons not to. I'm gradually converting all drivers to
> >   the control framework, so I really don't want to introduce new drivers to
> >   that list.
> 
> I think the control framework is a great design, it's just too
> difficult to debug and when I go near it - it breaks, or I spend an
> hour trying to understand why my subdev call doesn't reach the subdev
> device. My comments are not designed to inflame or upset you, I'm
> simply pointing out that any work I've done recently (on two new PCIe
> bridges - unreleased code) I've decided not to use it.

Ask me if there are problems with the control framework! I'm happy to help out.

I can't fix it, improve it, etc. if I don't here about it.

The reason why all drivers should use it is that is behaves the same for all
drivers, and apps can start to rely on that behavior. If something doesn't work,
and you can't figure it out, then I am more than happy to help.

But I will NACK this driver unless it is using the control framework. Otherwise
I just have to do that later, and I really don't want to. There aren't many
controls in this driver so it should be pretty quick to do it.

In addition, the control framework will make it easy to implement control events,
another thing that should be rolled out to all drivers.

> Again, I specifically chosen to isolate this driver from certain key
> areas of the (now enormous) v4l2 infrastructure.

There is a reason for that infrastructure, you know. Consistent behavior from
the point of view of applications is the most important one. And it actually
takes a lot of work off your hands. Again, if there are questions, then I'm
happy to help out (and possible improve the code or documentation).

> 
> >
> > - TRY_FMT can actually set the format, something that should never happen.
> 
> I can check, but I think gstreamer or tvtime actually relies on that behavior.

Highly unlikely. TRY_FMT should *never* change the actual format. It's been like
that since the very beginning.

> 
> >
> > - Use the new DV_TIMINGS ioctls for the HDTV formats. S_FMT should not be used
> >   to select the HDTV format!
> 
> gstreamer on 2.6.37 and better didn't support DVTIMINGs. I would
> certainly like to discuss adding better timing support once
> applications are fully aware and can control the hardware using it.
> The lack of a good timin API (and adoption by the application
> developers) forced my hand to use S_FMT.

You said that it was in your queue for some time, so it may be that it wasn't
available when you started out. The problem is, the API is now available, and
if drivers do not implement it, then there is also no reason for applications
to use it, isn't it? Chicken and egg.

I will NACK if the driver doesn't add support for it. Otherwise we end up with
some drivers that implement it correctly, and others that use a different
method. No application writer will ever thank us for that.

Also, I didn't go through all the hard work of designing and adding an API and
then see it being ignored in favor of a non-standard solution.

> Right now the driver works today, on old and new systems, for hardware
> that's shipping. It satisfies end user needs.
> 
> >
> > - The procfs additions seem unnecessary to me. VIDIOC_LOG_STATUS or perhaps
> >   debugfs are probably much more suitable.
> 
> I agree. It can probably be removed altogether.
> 
> >
> > - Using videobuf2 is very much recommended.
> 
> I went with what I know to be honest. I neither agree nor disagree
> with your comments. If videobuf2 is supported on 2.6.3x then this is
> good news.

If you use media_build to compile your driver, then everything including vb2
is supported from 2.6.31 onwards (the oldest kernel supported by media_build).

> 
> >
> > - Please run v4l2-compliance and fix any reported issues!
> >
> > It's a pretty big driver, so I only looked skimmed the patch, but these are
> > IMHO fairly major issues. As it stands it is only suitable to be merged in
> > drivers/staging/media.
> 
> I'm not sure I agree. I think I don't agree in general that subdev and
> the control framework is mandatory for any driver. I think they are
> accelerator frameworks designed to help. I my case I don't think they
> do. So I avoided using them.
>
> I guess Mauro has the final decision.

Of course.

BTW, I saw another thing that must be changed: you use the .ioctl file
operation instead of unlocked_ioctl. This is no longer allowed for new
drivers since the removal of the BKL. The v4l2 core implementation of
.ioctl attempts to simulate the old BKL and is very inefficient, in
particular for drivers like this that do not use struct v4l2_device.
If you have multiple ViewCast cards, then all v4l2 ioctls will go through
a single V4L2 core lock, leading to substantial latencies.

See also the comment in v4l2_ioctl() in v4l2_dev.c.

New drivers must use unlocked_ioctl. I am in the (very slow, but steady)
process of fixing any old drivers that still use .ioctl and once all are
converted .ioctl will be removed altogether.

Regards,

	Hans
