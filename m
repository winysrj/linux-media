Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56726 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbbCaXsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 19:48:37 -0400
Date: Tue, 31 Mar 2015 20:47:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc
 interface
Message-ID: <20150331204716.6795177d@concha.lan>
In-Reply-To: <20150330211819.GA18426@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
	<20150330211819.GA18426@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Mar 2015 23:18:19 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
> >This patch series tries to fix the lirc interface and extend it so it can
> >be used to send/recv scancodes in addition to raw IR:

Haven't look at the series yet. I just arrived from ELC/Linux Media conf.

> >
> > - Make it possible to receive scancodes from hardware that generates 
> >   scancodes (with rc protocol information)
> > - Make it possible to receive decoded scancodes from raw IR, from the 
> >   in-kernel decoders (not mce mouse/keyboard). Now you can take any
> >   remote, run ir-rec and you will get both the raw IR and the decoded
> >   scancodes plus rc protocol information.
> > - Make it possible to send scancodes; in kernel-encoding of IR
> > - Make it possible to send scancodes for hardware that can only do that
> >   (so that lirc_zilog can be moved out of staging, not completed yet)
> > - Possibly the lirc interface can be used for cec?
> >
> >This requires a little refactoring.
> > - All rc-core devices will have a lirc device associated with them
> > - The rc-core <-> lirc bridge no longer is a "decoder", this never made 
> >   sense and caused confusion
> 
> IIRC, it was written that way to make the lirc module optional.

Yes, the idea is that LIRC is an option for most devices. For devices
with TX, however, it would make sense to always have an association, if
compiled with LIRC support (otherwise, TX would be disabled).

Maybe we could track this with an additional config option (CONFIG_IR_TX?).

> >This requires new API for rc-core lirc devices.
> > - New feature LIRC_CAN_REC_SCANCODE and LIRC_CAN_SEND_SCANCODE
> > - REC_MODE and SEND_MODE do not enable LIRC_MODE_SCANCODE by default since 
> >   this would confuse existing userspace code
> > - For each scancode we need: 
> >   - rc protocol (RC_TYPE_*) 
> >   - toggle and repeat bit for some protocols
> >   - 32 bit scancode
> 
> I haven't looked at the patches in detail, but I think exposing the
> scancodes to userspace requires some careful consideration.
> 
> First of all, scancode length should be dynamic, there are protocols
> (NEC48 and, at least theoretically, RC6) that have scancodes > 32 bits.

Good point.
 
> Second, if we expose protocol type (which we should, not doing so is
> throwing away valuable information) we should tackle the NEC scancode
> question. I've already explained my firm conviction that always
> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
> is of the opinion that NEC16/24/32 should be essentially different
> protocols.

Changing NEC would break userspace, as existing tables won't work.
So, no matter what I think, changing it won't happen as we're not
allowed to break userspace.

(and yes, I think NEC16 is *the* NEC protocol; the other are just
variants made by some vendors to fill their needs)

> Third, we should still have a way to represent the protocol in the
> keymap as well.

Not sure about that, but this is a different matter. 

> And on a much more general level...I still think we should start from
> scratch with a rc specific chardev with it's own API that is generic
> enough to cover both scancode / raw ir / future / other protocols (not
> that such an undertaking would preclude adding stuff to the lirc API of
> course).

Starting from scratch sounds a bad idea. We don't do that on Linux,
except when we really screwed everything very badly. Also, the input
developers already denied adding a separate chardev with its own API
when we started discussing about the remote controller core.

Adding a new chardev would make things very confusing, as we'll need
to keep reporting data on both new and old chardev. We have this already
for LIRC, but with different interfaces, so, no big issue. Also, LIRC
can be dynamically disabled at runtime. So, it seems that this is the
best approach, IMO.

> 
> Re,
> David
> 
> PS
> Thanks for your continued RC efforts Sean!
> 


-- 

Cheers,
Mauro
