Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZBKHoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 02:44:10 -0500
Date: Wed, 11 Feb 2009 05:43:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Engel <david@istwok.net>
Cc: Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090211054329.6c54d4ad@pedra.chehab.org>
In-Reply-To: <20090211035016.GA3258@opus.istwok.net>
References: <20090209004343.5533e7c4@caramujo.chehab.org>
	<1234226235.2790.27.camel@pc10.localdom.local>
	<1234227277.3932.4.camel@pc10.localdom.local>
	<1234229460.3932.27.camel@pc10.localdom.local>
	<20090210003520.14426415@pedra.chehab.org>
	<1234235643.2682.16.camel@pc10.localdom.local>
	<1234237395.2682.22.camel@pc10.localdom.local>
	<20090210041512.6d684be3@pedra.chehab.org>
	<1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com>
	<20090210102732.5421a296@pedra.chehab.org>
	<20090211035016.GA3258@opus.istwok.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 21:50:16 -0600
David Engel <david@istwok.net> wrote:

> On Tue, Feb 10, 2009 at 10:27:32AM -0200, Mauro Carvalho Chehab wrote:
> > On Tue, 10 Feb 2009 06:07:51 -0600
> > Jonathan Isom <jeisom@gmail.com> wrote:
> > > On Tue, Feb 10, 2009 at 12:15 AM, Mauro Carvalho Chehab
> > > > Ah, ok. So, now, we just need CityK (or someone else with ATSC 115) to confirm
> > > > that everything is fine on their side. This patch may also fix other similar
> > > > troubles on a few devices that seem to need some i2c magic before probing the
> > > > tuner.
> > > 
> > > Just tried the latest hg and I can confirm that both an ATSC 110 and
> > > 115 work with tvtime
> > > and ATSC.
> > > 
> > Jonathan,
> > 
> > You tried the latest tree at http://linuxtv.org/hg/v4l-dvb or my saa7134 tree
> > (http://linuxtv.org/hg/~mchehab/saa7134)?
> > 
> > In the first case, could you please confirm that it works fine also with the saa7134 tree?
> 
> I tried both trees with my ATSC 115.  
> 
> The v4l-dvb did not work.  tvtime showed only a blue screen,
> presumably due to lack of a signal.  The last commit in the tree was
> as follows:
> 
>     changeset:   10503:9cb19f080660
>     tag:         tip
>     parent:      10495:d76f0c9b75fd
>     parent:      10502:b1d0225eeec4
>     user:        Mauro Carvalho Chehab <mchehab@redhat.com>
>     date:        Tue Feb 10 05:26:05 2009 -0200
>     summary:     merge: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7146
> 
> The saa7134 worked.

Ok. I've merged from saa7134 tree. This is the patch that changed the open gate
for ATSC115 (and other saa7134 devices whose i2c gate open sequences are known):

changeset:   10507:ec84c420abdd
user:        Mauro Carvalho Chehab <mchehab@redhat.com>
date:        Sun Feb 08 10:33:15 2009 -0200
summary:     saa7134: Fix analog mode on devices that need to open an i2c gate

> MythTV eventually worked too, but I had to do the
> "unload/reload modules and run tvtime" procedure I reported earlier
> when I tried Hans' kworld tree.

Maybe this is a race condition I have here with tda1004x. With tda1004x, the i2c
bus shouldn't be used by any other device during the firmware transfers,
otherwise the firmware load will fail, and tda1004x goes into an unstable
state. With this device, it even affects all subsequent i2c acesses. The only
alternative to recover tda1004x is to reboot the card (e. g. with my cardbus
device, I have to physically remove it and re-insert).

What happens is that some softwares (including udev) open the device, and send
some VIDIOC_G_TUNER in order to check some tuner characteristics. However, this
command generates some i2c transfers, to retrieve signal strength. If this
happens while the firmware is being loaded, the bug occurs.

In order to fix, a careful review of all locks on the driver is needed. We will
likely need to change the demod interface for the boards that have this
trouble, in order to be aware of when a firmware transfer started.

This lock review is currently on my TODO list.

To be sure that this is the case, could you please add this on
your /etc/modprobe (or at a file inside /etc/modprobe.d):

	options nxt200x debug=1
	options tuner-simple debug=1
	options tuner debug=1
	options dvb-core frontend_debug=1

And test again, sending us the produced logs when the device works and when it
breaks. I guess we'll discover some tuner dmesg's in the middle of the firmware
load sequence.

As a reference, this is the logs for the race condition with tda1004x:

DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision ff -- invalid
tda1004x: trying to boot from eeprom
tda829x 1-004b: tda8290 is locked, AGC: 241
tda829x 1-004b: adjust gain, step 1. Agc: 241, ADC stat: 108, lock: 128
tda829x 1-004b: setting tda829x to system B
tda827x: setting tda827x to system B
tda827x: AGC2 gain is: 1
tda829x 1-004b: tda8290 not locked, no signal?
tda829x 1-004b: tda8290 not locked, no signal?
tda829x 1-004b: tda8290 not locked, no signal?
tda829x 1-004b: adjust gain, step 1. Agc: 236, ADC stat: 0, lock: 0
tda829x 1-004b: adjust gain, step 2. Agc: 128, lock: 0
tda829x 1-004b: adjust gain, step 3. Agc: 128
tda829x 1-004b: setting tda829x to system B
tda829x 1-004b: setting tda829x to system B
tda1004x: found firmware revision ff -- invalid

The firmware load stops at the last message. Notice that, during the firmware
transfer, the tuner status were checked. This generated a breakage at the i2c
transfer. Maybe we'll need a sort of locking between tuner and demod i2c access
to avoid such troubles.

Cheers,
Mauro
