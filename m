Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39042 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab0DXVYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:24:01 -0400
Date: Sat, 24 Apr 2010 23:23:53 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding
 LIRC and decoder plugins
Message-ID: <20100424212353.GB11879@hardeman.nu>
References: <20100402102011.GA6947@hardeman.nu>
 <p2ube3a4a1004051349y11e3004bk1c71e3ab38d3f669@mail.gmail.com>
 <20100407093205.GB3029@hardeman.nu>
 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com>
 <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
 <1272061228.3089.8.camel@palomino.walls.org>
 <20100424052254.GB3101@hardeman.nu>
 <m2j9e4733911004240535k4b14d64fu940f5dff17837b20@mail.gmail.com>
 <20100424141510.GA3070@hardeman.nu>
 <y2h9e4733911004240807wfa6b0e79q8deb18c425484b6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <y2h9e4733911004240807wfa6b0e79q8deb18c425484b6f@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 24, 2010 at 11:07:07AM -0400, Jon Smirl wrote:
> On Sat, Apr 24, 2010 at 10:15 AM, David Härdeman <david@hardeman.nu> wrote:
> > On Sat, Apr 24, 2010 at 08:35:48AM -0400, Jon Smirl wrote:
> >> On Sat, Apr 24, 2010 at 1:22 AM, David Härdeman <david@hardeman.nu> wrote:
> >> > I think we're eventually going to want to let rc-core create a 
> >> > chardev
> >> > per rc device to allow for things like reading out scancodes (when
> >> > creating keymaps for new and unknown remotes), raw timings (for
> >> > debugging in-kernel decoders and writing new ones), possibly also
> >> > ioctl's (for e.g. setting all RX parameters in one go or to
> >> > create/destroy additional keymaps, though I'm sure some will want all of
> >> > that to go through sysfs).
> >>
> >> That problem is handled differently in the graphics code.  You only
> >> have one /dev device for graphics. IOCTLs on it are divided into
> >> ranges - core and driver. The IOCTL call initially lands in the core
> >> code, but if it is in the driver range it simply gets forwarded to the
> >> specific driver and handled there.
> >>
> >> Doing it that was avoids needing two /dev devices nodes for the same
> >> device. Two device nodes has problems.  How do you keep them from
> >> being open by two different users and different privilege levels, or
> >> one is open and one closed, etc...
> >
> > I'm not sure which two devices you're talking about. ir-core currently
> > creates no device at all (unless you count the input device). And
> > further down the road I think each rc (ir) device should support
> > multiple keytables, each keytable having an associated input device.
> >
> > Input device(s) would be used by the majority of applications that only
> > want to react on keypresses, the rc device is used by rc-aware
> > applications that want to create new keytables, send ir commands, tweak
> > RX/TX parameters, etc. I do not see how any of your two-device concerns
> > would apply to that division...
> >
> >> Splitting the IOCTL range is easy to add to input core and it won't
> >> effect any existing user space code.
> >
> > The input maintainers have already NAK'ed adding any ir-specific ioctls
> > to the input layer, and I tend to agree with them.
> 
> Based on my experience with DRM adding a split to the IOCTL range is a
> good solution. The split does not add IR specific IOCTLs to the input
> core. The input core just looks at the IOCTL number and if it is out
> of range it forwards it down the chain - to IR core, which can process
> it  or forward to the specific driver.  This model is already in use
> and it works without problem.

I don't care either way. Get the input maintainers to agree and I'll 
happily write patches that follow that approach (writing TX data to the 
input dev will also have to be supported).

The only real problem I see is if we implement > 1 input device per 
rc/ir device (which I think we should do - each logical remote should 
have a separate keytable and input device).

-- 
David Härdeman
