Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZBMLFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 06:05:31 -0500
Date: Fri, 13 Feb 2009 09:04:46 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Engel <david@istwok.net>
Cc: Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090213090446.2d77435a@pedra.chehab.org>
In-Reply-To: <20090213030750.GA3721@opus.istwok.net>
References: <1234229460.3932.27.camel@pc10.localdom.local>
	<20090210003520.14426415@pedra.chehab.org>
	<1234235643.2682.16.camel@pc10.localdom.local>
	<1234237395.2682.22.camel@pc10.localdom.local>
	<20090210041512.6d684be3@pedra.chehab.org>
	<1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com>
	<20090210102732.5421a296@pedra.chehab.org>
	<20090211035016.GA3258@opus.istwok.net>
	<20090211054329.6c54d4ad@pedra.chehab.org>
	<20090211232149.GA28415@opus.istwok.net>
	<20090213030750.GA3721@opus.istwok.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Feb 2009 21:07:50 -0600
David Engel <david@istwok.net> wrote:

> On Wed, Feb 11, 2009 at 05:21:49PM -0600, David Engel wrote:
> > On Wed, Feb 11, 2009 at 05:43:29AM -0200, Mauro Carvalho Chehab wrote:
> > > On Tue, 10 Feb 2009 21:50:16 -0600
> > > David Engel <david@istwok.net> wrote:
> > > > MythTV eventually worked too, but I had to do the
> > > > "unload/reload modules and run tvtime" procedure I reported earlier
> > > > when I tried Hans' kworld tree.
> > > 
> > > Maybe this is a race condition I have here with tda1004x. With tda1004x, the i2c
> > > bus shouldn't be used by any other device during the firmware transfers,
> > > otherwise the firmware load will fail, and tda1004x goes into an unstable
> > > state. With this device, it even affects all subsequent i2c acesses. The only
> > > alternative to recover tda1004x is to reboot the card (e. g. with my cardbus
> > > device, I have to physically remove it and re-insert).
> > > 
> > > What happens is that some softwares (including udev) open the device, and send
> > > some VIDIOC_G_TUNER in order to check some tuner characteristics. However, this
> > > command generates some i2c transfers, to retrieve signal strength. If this
> > > happens while the firmware is being loaded, the bug occurs.
> > > 
> > > In order to fix, a careful review of all locks on the driver is needed. We will
> > > likely need to change the demod interface for the boards that have this
> > > trouble, in order to be aware of when a firmware transfer started.
> > > 
> > > This lock review is currently on my TODO list.
> > > 
> > > To be sure that this is the case, could you please add this on
> > > your /etc/modprobe (or at a file inside /etc/modprobe.d):
> > > 
> > > 	options nxt200x debug=1
> > > 	options tuner-simple debug=1
> > > 	options tuner debug=1
> > > 	options dvb-core frontend_debug=1
> > > 
> > > And test again, sending us the produced logs when the device works and when it
> > > breaks. I guess we'll discover some tuner dmesg's in the middle of the firmware
> > > load sequence.
> > 
> > I will do this, but it will be tomorrow evening before I can get to
> > it.
> 
> Here are my logs.  They are annoteded in-line with the actions I took.
> I need to add that the results with MythTv aren't always consistent.
> Sometimes it works right away when I don't expect it to and sometimes
> it doesn't work after the reload when I do expect it to.  The results
> shown below are what happens most of the time -- MythTV doesn't work
> until the modules are reloaded and tvtime is run.

Ok, I did a diff between the two logs. On the first module probing,
saa7134-alsa were probed before than on the second log. I don't think that this
would be relevant for this issue.

However, on both logs, we see a tuner write to the wrong address (0x0a, instead
of 0x61):

First log sequence (mythtv broken):
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
> Feb 12 20:34:13 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01
> Feb 12 20:34:13 opus kernel: tuner 1-0061: tv freq set to 67.25
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
> Feb 12 20:34:13 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01


Second log sequence (mythtv ok):

> Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: using tuner params #0 (ntsc)
> Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
> Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
> Feb 12 20:37:48 opus kernel: tuner-simple 1-000a: tv 0x07 0x10 0xce 0x01

Aparently, the second tuner call setting went to the proper i2c address:
> Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01
> Feb 12 20:37:48 opus kernel: tuner 1-0061: tv freq set to 67.25
> Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: using tuner params #0 (ntsc)
> Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0xce, cb = 0x01
> Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
> Feb 12 20:37:48 opus kernel: tuner-simple 1-0061: tv 0x07 0x10 0xce 0x01

It seems that some parts of saa7134 (or frontend) is overriding the i2c
address,to write at the demod, causing a mess. Another alternative would be
some bug at v4l subdev interface.

I'll seek at saa7134 code to see who is causing this error.

Cheers,
Mauro
