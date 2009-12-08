Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64309 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965011AbZLHRT2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 12:19:28 -0500
Date: Tue, 8 Dec 2009 09:19:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091208171931.GE14143@core.coreip.homeip.net>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com> <1259264614.1781.47.camel@localhost> <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com> <1260240142.3086.14.camel@palomino.walls.org> <4B1E394A.1090807@redhat.com> <1260276412.3094.17.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260276412.3094.17.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 08, 2009 at 07:46:52AM -0500, Andy Walls wrote:
> On Tue, 2009-12-08 at 09:32 -0200, Mauro Carvalho Chehab wrote:
> > Andy Walls wrote:
> > > On Mon, 2009-12-07 at 13:19 -0500, Jarod Wilson wrote:
> 
> > > So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
> > > end of the month.
> > 
> > Good! Please, try to design the decoder as an independent module that gets
> > data from a kfifo and generate scancodes for the input API.
> 
> Hmmm.  Let me see how the protoype turns out keeping that design
> objective in mind.  I've already got the current RC-5 and NEC decoding
> state machines in cx23885-input a bit layered, but they are taking
> advantage of specific events signaled by my v4l2_subdev implementation.
> 
> Strictly speaking the state machines don't have to.  All of the remote
> protocols I have played with make framing pretty easy.
> 
> 
> 
> > > I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
> > > a common set of parameters, so I may be able to set up the decoders to
> > > handle decoding from two different remote types at once.  The HVR boards
> > > can ship with either type of remote AFAIK.
> > > 
> > > I wonder if I can flip the keytables on the fly or if I have to create
> > > two different input devices?
> > 
> > IMO, the better is, by default, to open just one input device per IR receiver.
> > >From what I understand from our discussions, if the user wants to filter IR
> > commands into several input interfaces, some userspace interface will be 
> > provided to allow the creation of other input interfaces for that purpose.
> 
> Hmm. That's not what I just thought I read from Dmitry....
> 

I am a resonable guy ;) In cases when we can certainly say that there
are 2 separate remotes (and we know characteristics somehow) we need to
create 2 input devices. Otherwise we can't ;)

-- 
Dmitry
