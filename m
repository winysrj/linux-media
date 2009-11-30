Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:47270 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZK3PEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 10:04:24 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ray Lee <ray-lk@madrabbit.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <9e4733910911300601x513e8ac5n86b9b745536ca955@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	 <1259515703.3284.11.camel@maxim-laptop>
	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	 <1259537732.5231.11.camel@palomino.walls.org> <4B13B2FA.4050600@redhat.com>
	 <1259585852.3093.31.camel@palomino.walls.org>
	 <1259588608.13049.16.camel@maxim-laptop>
	 <9e4733910911300601x513e8ac5n86b9b745536ca955@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 17:04:21 +0200
Message-ID: <1259593461.13049.49.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-30 at 09:01 -0500, Jon Smirl wrote: 
> On Mon, Nov 30, 2009 at 8:43 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Mon, 2009-11-30 at 07:57 -0500, Andy Walls wrote:
> >> On Mon, 2009-11-30 at 09:56 -0200, Mauro Carvalho Chehab wrote:
> >> > Andy Walls wrote:
> >> > > On Sun, 2009-11-29 at 09:49 -0800, Ray Lee wrote:
> >> > >> On Sun, Nov 29, 2009 at 9:28 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> > >>> This has zero advantages besides good developer feeling that "My system
> >> > >>> has one less daemon..."
> >> > >> Surely it's clear that having an unnecessary daemon is introducing
> >> > >> another point of failure?
> >> > >
> >> > > A failure in a userspace IR daemon is worst case loss of IR
> >> > > functionality.
> >> > >
> >> > > A failure in kernel space can oops or panic the machine.
> >> >
> >> > If IR is the only interface between the user and the system (like in a TV
> >> > or a Set Top Box), both will give you the same practical result: the system
> >> > will be broken, if you got a crash at the IR driver.
> >>
> >> Yes, true.  I had forgotten about the embedded space.
> >>
> >> Nonetheless I'd still rather debug a problem with a dead process in
> >> userspace than an oops or panic (not that an end user cares) and avoid
> >> the risk of filesystem corruption.
> >>
> >> > Userspace is much more flexible.
> >> >
> >> > Why? The flexibility about the same on both kernelspace and userspace,
> >> > except for the boot time.
> >>
> >> I suppose my best answer to that is question back to you: Why does udev
> >> run in userspace versus a kernel thread?
> >>
> >>
> >> My personal thoughts on why user space is more flexible:
> >>
> >> 1. You have all of *NIX available to you to use as tools to achieve your
> >> requirements.
> >>
> >> 2. You are not constrained to use C.
> >>
> >> 3. You can link in libraries with functions that are not available in
> >> the kernel.  (udev has libudev IIRC to handle complexities)
> >>
> >> 4. Reading a configuration file or other file from the filesystem is
> >> trivial - file access from usespace is easy.
> >>
> >> 5. You don't have to be concerned about the running context (am I
> >> allowed to sleep here or not?).
> >
> >
> > 6. You can modify userspace driver easily to cope with all weird setups.
> > Like you know that there are remotes that send whole packet of data that
> > consist of many numbers that are also displayed on the LCD of the
> > remote.
> > Otherwise you will have to go through same fight for every minor thing
> > you like to add to kernel...
> >
> >
> > 7. You don't have an ABI constraints, your userspace program can read a
> > configuration file in any format you wish.
> > I for example was thinking about putting all lirc config files into an
> > sqllite database, and pulling them out when specific remote is detected.
> 
> Linux is not a microkernel it is a monolithic kernel.
> http://en.wikipedia.org/wiki/Microkernel


The above is trolling.

Maybe it will come as a surprise to you, but I am quite big supporter of
in-kernel code.

For example I don't quite like that alsa doesn't do mixing and
re-sampling in kernel.
These days pulseaudio works quite well, but it still sucks in some sense
sometimes.
I know about dmix/dsnoop, etc, these are nice, but still I would be
happy if kernel did that critical for both performance and latency thing
in kernel.

Some time ago an idea to move kernel VT support in userspace surfaced,
and I was against it too.


However, following established concept in philosophy, extremes are
equally bad.

Both pushing everything out of kernel, and shoving everything in is
equally bad.

So I am not blindly saying that, 'Everything belongs to kernel!'
or 'Lets put everything out, its more stable that way!, Moore law will
take care of performance...'

Instead I consider the pros and cons of both solutions, picking the best
one.

In that particular case I was even happy to see your kernel patches at
first glance, but then, after deep review I found that in-kernel
approach will create only problems, won't eliminate userspace decoding,
and solve only one problem, that is give good feeling about 'one less
daemon in system'.



> Once things get into the kernel they become far harder to change.
> Stop for a minute and think about designing the best IR system for
> Linux and forget about making a cross platform solution. IR is an
> input device, it should be integrated into the Linux input subsystem.
> You may not like the designs I have proposed, but running IR in user
> space and injecting a keystroke at the end of the process is not
> integrating it into the input subsystem.
Yes it is, like it or not.

Best  regards,
Maxim Levitsky



> 
> 
> >
> >
> >>
> >>
> >>
> >>
> >>
> >>
> >> > A kernelspace input device driver can start working since boot time.
> >> > On the other hand, an userspace device driver will be available only
> >> > after mounting the filesystems and starting the deamons
> >> > (e. g. after running inittab).
> >> >
> >> > So, you cannot catch a key that would be affecting the boot
> >> > (for example to ask the kernel to run a different runlevel or entering
> >> > on some administrative mode).
> >>
> >> Right.  That's another requirement that makes sense, if we're talking
> >> about systems that don't have any other keyboard handy to the user.
> >>
> >> So are we optimizing for the embedded/STB and HTPC with no keyboard use
> >> case, or the desktop or HTPC with a keyboard for maintencance?
> >>
> >>
> >> Regards,
> >> Andy
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> 
> 
> 


