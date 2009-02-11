Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:46868 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZBKXVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 18:21:54 -0500
Date: Wed, 11 Feb 2009 17:21:49 -0600
From: David Engel <david@istwok.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Isom <jeisom@gmail.com>,
	V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090211232149.GA28415@opus.istwok.net>
References: <1234227277.3932.4.camel@pc10.localdom.local> <1234229460.3932.27.camel@pc10.localdom.local> <20090210003520.14426415@pedra.chehab.org> <1234235643.2682.16.camel@pc10.localdom.local> <1234237395.2682.22.camel@pc10.localdom.local> <20090210041512.6d684be3@pedra.chehab.org> <1767e6740902100407t6737d9f4j5d9edefef8801e27@mail.gmail.com> <20090210102732.5421a296@pedra.chehab.org> <20090211035016.GA3258@opus.istwok.net> <20090211054329.6c54d4ad@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211054329.6c54d4ad@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2009 at 05:43:29AM -0200, Mauro Carvalho Chehab wrote:
> On Tue, 10 Feb 2009 21:50:16 -0600
> David Engel <david@istwok.net> wrote:
> > MythTV eventually worked too, but I had to do the
> > "unload/reload modules and run tvtime" procedure I reported earlier
> > when I tried Hans' kworld tree.
> 
> Maybe this is a race condition I have here with tda1004x. With tda1004x, the i2c
> bus shouldn't be used by any other device during the firmware transfers,
> otherwise the firmware load will fail, and tda1004x goes into an unstable
> state. With this device, it even affects all subsequent i2c acesses. The only
> alternative to recover tda1004x is to reboot the card (e. g. with my cardbus
> device, I have to physically remove it and re-insert).
> 
> What happens is that some softwares (including udev) open the device, and send
> some VIDIOC_G_TUNER in order to check some tuner characteristics. However, this
> command generates some i2c transfers, to retrieve signal strength. If this
> happens while the firmware is being loaded, the bug occurs.
> 
> In order to fix, a careful review of all locks on the driver is needed. We will
> likely need to change the demod interface for the boards that have this
> trouble, in order to be aware of when a firmware transfer started.
> 
> This lock review is currently on my TODO list.
> 
> To be sure that this is the case, could you please add this on
> your /etc/modprobe (or at a file inside /etc/modprobe.d):
> 
> 	options nxt200x debug=1
> 	options tuner-simple debug=1
> 	options tuner debug=1
> 	options dvb-core frontend_debug=1
> 
> And test again, sending us the produced logs when the device works and when it
> breaks. I guess we'll discover some tuner dmesg's in the middle of the firmware
> load sequence.

I will do this, but it will be tomorrow evening before I can get to
it.

David
-- 
David Engel
david@istwok.net
