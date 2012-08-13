Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61792 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2HMOqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:46:47 -0400
Received: by ghrr11 with SMTP id r11so3065330ghr.19
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 07:46:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208131604.28675.hverkuil@xs4all.nl>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<201208131604.28675.hverkuil@xs4all.nl>
Date: Mon, 13 Aug 2012 10:46:45 -0400
Message-ID: <CALzAhNVFSH0+y9XU39EzzBhH4rAAC2RStZKA3hzTfexzCKBHRQ@mail.gmail.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for your feedback.

Oh dear. I don't think you're going to like my response, but I think
we know each other well enough to realize that neither of us are
trying to antagonize or upset either other. We're simply stating our
positions. Please read on.

> I went through this driver from a high-level point of view, and I'm afraid I
> have quite a number of issues with this driver.
>
> One of the bigger ones is that vc8x0-ad7441.c should be implemented as
> a subdevice. I have two other AD drivers in my queue (adv7604 and ad9389b),
> so you can look at those for comparison.
>
> See: http://www.spinics.net/lists/linux-media/msg51501.html

Oh, I understand how to write video decoder drivers. I just chose
specifically not to do it. This was intensional on my part. If when
another card comes along with an ad7441 when they are welcome to split
the code and/or create the subdevs. It's extra engineering today that
does't improve the support for the 820 card and doesn't benefit any
other known product. It's a feature that's exclusive to the 820.
Future developers are welcome to fork, slice and/or copy the code.

Today, the driver is tuned exactly for the card, it works very nicely
for end users and the code is easy to read, simple to debug and relies
on only a handful of v4l2 framework apis.

If anyone knew how much time and suffering I've had with the cx25840
over the years, why I think has gotten worse with the subdev controls,
you'd be shocked. The subdev framework (in my opinion) has become
unwieldily and difficult to debug, based on my recent experience
dealing with some cx23885 issues. I'm intensionally trying not to use
it.

I should be clear, my comments are not mean to antagonize or inflame,
I'm simply pointing out that when at all possible I chose not to use
the subdev framework because if it's delays and difficulties when it
comes to debugging.

When did the subdev framework become a mandatory requirement for any
driver merge?

>
> These Analog Devices chips are quite complex, and you really want to be able
> to reuse drivers.

I am certainly more than willing to discuss re-use, when re-use make
sense. Right now we have no-practical re-use for this part to speak
of. The code is targeted towards the 820, in the use case that end
users need. If someone would like to build a ad7441 subdevice and use
that in their driver then they are welcome to the code. In practise,
sharing complex video decoders across driver designs leads to massive
regressions, as witnessed on the list this year.

I am also aware that the cx25840 driver is complex, and the end result
was that driver maintainers effectively forked the cx25840 and brought
the codebase back into their core drivers (cx18 for example), to avoid
issues where regression testing was troublesome across so many cards.
If I had the time and/or energy, we'd do the same with the cx25840.
Keeping complex code close to the PCI/PCIe bridge bring big dividends
when debugging complex problems and mitigating issues where code is
re-used across multiple products (growing any regression test
requirements).

The entire driver was intensionally written to be self-enclosed,
highly portable between 2.6.3x and v3.x kernels without subdev
breakages and/or api changes. With a small external Makefile it even
builds very nicely outside of the kernel on any kernel you like, that
shipped in the last 2-3 years.

>
> Some of the other issues are:
>
> - Please use the control framework. All new drivers must use it, unless there
>   are very, very good reasons not to. I'm gradually converting all drivers to
>   the control framework, so I really don't want to introduce new drivers to
>   that list.

I think the control framework is a great design, it's just too
difficult to debug and when I go near it - it breaks, or I spend an
hour trying to understand why my subdev call doesn't reach the subdev
device. My comments are not designed to inflame or upset you, I'm
simply pointing out that any work I've done recently (on two new PCIe
bridges - unreleased code) I've decided not to use it.

Again, I specifically chosen to isolate this driver from certain key
areas of the (now enormous) v4l2 infrastructure.

>
> - TRY_FMT can actually set the format, something that should never happen.

I can check, but I think gstreamer or tvtime actually relies on that behavior.

>
> - Use the new DV_TIMINGS ioctls for the HDTV formats. S_FMT should not be used
>   to select the HDTV format!

gstreamer on 2.6.37 and better didn't support DVTIMINGs. I would
certainly like to discuss adding better timing support once
applications are fully aware and can control the hardware using it.
The lack of a good timin API (and adoption by the application
developers) forced my hand to use S_FMT.

Right now the driver works today, on old and new systems, for hardware
that's shipping. It satisfies end user needs.

>
> - The procfs additions seem unnecessary to me. VIDIOC_LOG_STATUS or perhaps
>   debugfs are probably much more suitable.

I agree. It can probably be removed altogether.

>
> - Using videobuf2 is very much recommended.

I went with what I know to be honest. I neither agree nor disagree
with your comments. If videobuf2 is supported on 2.6.3x then this is
good news.

>
> - Please run v4l2-compliance and fix any reported issues!
>
> It's a pretty big driver, so I only looked skimmed the patch, but these are
> IMHO fairly major issues. As it stands it is only suitable to be merged in
> drivers/staging/media.

I'm not sure I agree. I think I don't agree in general that subdev and
the control framework is mandatory for any driver. I think they are
accelerator frameworks designed to help. I my case I don't think they
do. So I avoided using them.

I guess Mauro has the final decision.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
