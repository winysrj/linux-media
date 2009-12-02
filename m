Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f191.google.com ([209.85.222.191]:49340 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZLBUsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 15:48:11 -0500
Date: Wed, 2 Dec 2009 12:48:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091202204811.GE22689@core.coreip.homeip.net>
References: <4B15852D.4050505@redhat.com> <20091202093803.GA8656@core.coreip.homeip.net> <4B16614A.3000208@redhat.com> <20091202171059.GC17839@core.coreip.homeip.net> <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com> <4B16BE6A.7000601@redhat.com> <20091202195634.GB22689@core.coreip.homeip.net> <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com> <20091202201404.GD22689@core.coreip.homeip.net> <434927DD-0E66-4D0E-B705-022B7FCCCDB0@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434927DD-0E66-4D0E-B705-022B7FCCCDB0@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 02, 2009 at 03:42:13PM -0500, Jarod Wilson wrote:
> On Dec 2, 2009, at 3:14 PM, Dmitry Torokhov wrote:
> 
> > On Wed, Dec 02, 2009 at 03:04:30PM -0500, Jarod Wilson wrote:
> >> On Dec 2, 2009, at 2:56 PM, Dmitry Torokhov wrote:
> >> 
> >>> On Wed, Dec 02, 2009 at 02:22:18PM -0500, Jarod Wilson wrote:
> >>>> On 12/2/09 12:30 PM, Jon Smirl wrote:
> >>>>>>>> (for each remote/substream that they can recognize).
> >>>>>>>>> 
> >>>>>>>>> I'm assuming that, by remote, you're referring to a remote receiver (and not to
> >>>>>>>>> the remote itself), right?
> >>>>>>> 
> >>>>>>> If we could separate by remote transmitter that would be the best I
> >>>>>>> think, but I understand that it is rarely possible?
> >>>>> 
> >>>>> The code I posted using configfs did that. Instead of making apps IR
> >>>>> aware it mapped the vendor/device/command triplets into standard Linux
> >>>>> keycodes.  Each remote was its own evdev device.
> >>>> 
> >>>> Note, of course, that you can only do that iff each remote uses distinct  
> >>>> triplets. A good portion of mythtv users use a universal of some sort,  
> >>>> programmed to emulate another remote, such as the mce remote bundled  
> >>>> with mceusb transceivers, or the imon remote bundled with most imon  
> >>>> receivers. I do just that myself.
> >>>> 
> >>>> Personally, I've always considered the driver/interface to be the  
> >>>> receiver, not the remote. The lirc drivers operate at the receiver  
> >>>> level, anyway, and the distinction between different remotes is made by  
> >>>> the lirc daemon.
> >>> 
> >>> The fact that lirc does it this way does not necessarily mean it is the
> >>> most corerct way.
> >> 
> >> No, I know that, I'm just saying that's how I've always looked at it, and that's how lirc does it right now, not that it must be that way.
> >> 
> >>> Do you expect all bluetooth input devices be presented
> >>> as a single blob just because they happen to talk to the sane receiver
> >>> in yoru laptop? Do you expect your USB mouse and keyboard be merged
> >>> together just because they end up being serviced by the same host
> >>> controller? If not why remotes should be any different?
> >> 
> >> A bluetooth remote has a specific device ID that the receiver has to
> >> pair with. Your usb mouse and keyboard each have specific device IDs.
> >> A usb IR *receiver* has a specific device ID, the remotes do not. So
> >> there's the major difference from your examples.
> >> 
> > 
> > Not exactly... I can have 2 identical USB keyboadrs form the same
> > manufacturer and they will still be treated separately. BT has session
> > ID to help distinguish between devices.
> 
> Semantics. :)
> 
> My main point is that each of these devices has device ID that can be determined without having to first do some protocol analysis and table lookups to figure out which "device" some random IR input is actually coming from.
> 

Heh, right back at ya ;) The fact that you need to do some more work
to separate 2 physical devices does not mean it should not be done.

-- 
Dmitry
