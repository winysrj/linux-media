Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:48076 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZK2Hed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 02:34:33 -0500
Date: Sat, 28 Nov 2009 23:34:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [IR-RFC PATCH v4 0/6] In-kernel IR support using evdev
Message-ID: <20091129073434.GX6936@core.coreip.homeip.net>
References: <20091127013217.7671.32355.stgit@terra> <4B0F43B3.4090804@wilsonet.com> <9e4733910911261958w2911f69dk4ab747b4bf12461@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911261958w2911f69dk4ab747b4bf12461@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 10:58:59PM -0500, Jon Smirl wrote:
> >
> >> Code is only lightly tested. Encoders and decoders have not been
> >> written for all protocols. Repeat is not handled for any protocol. I'm
> >> looking for help. There are 15 more existing LIRC drivers.
> >
> > And there's the hangup for me. The lirc drivers and interface have been
> > pretty heavily battle-tested over years and years in the field. And there
> > are those 15 more drivers that already work with the lirc interface. I'm
> > woefully short on time to work on any porting myself, and about to get even
> > shorter with some new responsibilities at work requiring even more of my
> > attention.
> >
> > If we go with a hybrid approach, all those existing drivers can be brought
> > in supporting just the lirc interface initially, and have in-kernel decode
> > support added as folks have time to work on them, if it actually makes sense
> > for those devices.
> >
> > Just trying to find a happy middle ground that minimizes regressions for
> > users *and* gives us maximum flexibility.
> 
> You are going to have to choose. Recreate the problems of type
> specific devices like /dev/mouse and /dev/kbd that evdev was created
> to fix, or skip those type specific devices and go straight to evdev.
> We've known for years the /dev/mouse was badly broken. How many more
> years is it going to be before it can be removed? /dev/lirc has the
> same type of problems that /dev/mouse has. The only reason that
> /dev/lirc works now is because there is a single app that uses it.
> 

Pardon my ignorance here but it does not seem that /dev/lirc actually
multiplexes data stream from different receivers but rather creates a
device per receiver... Multiplexing is the main issue with /dev/mouse
for me.

What are the other issues with LIRC interface _for lircd-type applications_
do we see? I see for example that it is not 32/64 bit clean so that is
somethign that we may consider re-evaluating before just acceptig it
into kernel. Is there anything else?

> Also, implementing a new evdev based system in the kernel in no way
> breaks existing lirc installations. Just don't load the new
> implementation and everything works exactly the same way as before.
> 
> I'd go the evdev only route for in-kernel and leave existing lirc out
> of tree. Existing lirc will continue to work. This is probably the
> most stable strategy, even more so than a hybrid approach. The
> in-kernel implementation will then be free to evolve without the
> constraint of legacy APIs. As people become happy with it they can
> switch over.
> 

If by evdev-based system you mean adding EV_IR event to the input core I
think it would be a mistake. Such data (EV_IR/IR_XXX) will have to be read
from an event device, processed (probably in userspace) and re-injected
back through uinput as (EV_KEY/KEY_XXX) for consumption again. Such
looping interface would be a mistake IMHO.

Still, the end result of the transformation should be EV_KEY/KEY_XXX
delivered on one of the event devices (preferrably one per remote, not
one per receiver), I believe everyone agrees on that.

-- 
Dmitry
