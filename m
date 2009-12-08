Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:33837 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937398AbZLHRMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 12:12:34 -0500
Date: Tue, 8 Dec 2009 09:12:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091208171236.GC14143@core.coreip.homeip.net>
References: <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com> <4B1D934E.7030103@redhat.com> <20091208042340.GC11147@core.coreip.homeip.net> <4B1E3F7D.9070806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E3F7D.9070806@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 08, 2009 at 09:58:53AM -0200, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Mon, Dec 07, 2009 at 09:44:14PM -0200, Mauro Carvalho Chehab wrote:
> 
> >>> What about capabilities of the receiver, what frequencies?
> >>> If a receiver has multiple frequencies, how do you report what
> >>> frequency the data came in on?
> >> IMO, via sysfs.
> > 
> > We probably need to think what exactly we report through sysfs siunce it
> > is ABI of sorts.
> 
> Yes, sure.
> 
> Probably, the exact needs will popup only when we start to actually writing that
> part of the core.
> 
> My intention for now is to just create a /sys/class/irrcv, with one node
> per each IR receiver and adding a protocol enumeration/selection node
> there, and add some capabilities for the in-kernel decoders and lirc_dev
> to create new nodes under that class.
> 
> When the decoders/lirc_dev patches popup, we'll need to review those sysfs
> API's.
>  
> >>> What about multiple apps simultaneously using the pulse data?
> >> IMO, the better is to limit the raw interface to just one open.
> >>
> > 
> > Why woudl we want to do this? Quite often there is a need for "observer"
> > that maybe does not act on data but allows capturing it. Single-user
> > inetrfaces are PITA. 
> 
> That should work fine as well, but I'm not sure how we'll detect overrun with
> several kfifo readers.
> 

Push the data into readers so they can do te decoding at their own pace.
Some can do it in interrupt context, some will need workqueue/thread.
They can also regilate the depth of the buffer, according to their
needs.

> >>> How big is the receive queue?
> >> It should be big enough to receive at least one keycode event. Considering that
> >> the driver will use kfifo (IMO, it is a good strategy, especially since you
> >> won't need any lock if just one open is allowed), it will require a power of two size.
> >>
> > 
> > Would not it be wither driver- or protocol-specific?
> 
> Probably.
> 
> > 
> >>> How does access work, root only or any user?
> >> IMO, it should be the same requirement as used by an input interface.
> >>
> >>> How are capabilities exposed, sysfs, etc?
> >> IMO, sysfs.
> >>
> >>> What is the interface for attaching an in-kernel decoder?
> >> IMO, it should use the kfifo for it. However, if we allow both raw data and
> >> in-kernel decoders to read data there, we'll need a spinlock to protect the
> >> kfifo.
> >>
> > 
> > I think Jon meant userspace interface for attaching particular decoder.
> 
> I don't think we need an userspace interface for the in-kernel decoders. All
> it needs is to enable/disable the protocol decoders, imo via sysfs interface.
> 
> >>> If there is an in-kernel decoder should the pulse data stop being
> >>> reported, partially stopped, something else?
> >> I don't have a strong opinion here, but, from the previous discussions, it
> >> seems that people want it to be double-reported by default. If so, I think
> >> we need to implement a command at the raw interface to allow disabling the
> >> in-kernel decoder, while the raw interface is kept open.
> > 
> > Why don't you simply let consumers decide where they will get their data?
> 
> How?
> 

You end up with N evdev devices. Let application (MythTV) say "I want to
use /dev/input/event1" (well, it will need persistent udev rule, but
that's a detail). Another application will chose another event node.
User can decide she'd rather use lircd - and so configire applications
to use event5. Any maybe turned off the in-kernel decoders if they are
of no use and there is a concern that they consume too mcuh resoures.

Won't this work? 

-- 
Dmitry
