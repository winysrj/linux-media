Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48086 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeJ3XhG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 19:37:06 -0400
Date: Tue, 30 Oct 2018 11:43:16 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Sean Young <sean@mess.org>
Subject: Re: Adding to input-event-codes.h - feedback welcome
Message-ID: <20181030114316.52be36ed@coco.lan>
In-Reply-To: <CAA7C2qiqHX5K3SrEC0OZWDXcxGTRQzTWkKRxcOT-bfTeLrYu0g@mail.gmail.com>
References: <CAA7C2qiqHX5K3SrEC0OZWDXcxGTRQzTWkKRxcOT-bfTeLrYu0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Oct 2018 06:55:13 -0700
VDR User <user.vdr@gmail.com> escreveu:

> Hi,
> 
> I've noticed a lot of common & useful remote control buttons are
> missing. I'd like to suggest or submit patches to add some of them
> since Linux is so wildly used for media playback (via remote
> controls). I've spoken to Sean Young (and cc'ed him here), who does a
> ton with Linux rc, and he agrees it would be good to add them. Once
> added to input-event-codes.h, we could then start adding/updating rc
> keymaps accordingly.

As those keys are related to remote controllers, better to c/c the
Linux Media mailing list.

Btw, I agree with you here with regards to the idea: there are several
keys that are commonly found on remote controllers and are not easy
to map into the ones defined by input-event-codes.h.

We even had to add a table at media documentation, in order to
describe how each key should be mapped:

	Documentation/media/uapi/rc/rc-tables.rst

IMHO, nowadays I would actually try to review such documentation
and eventually move it to Documentation/input, as there are several
cases where it is not trivial to map an specific key to the
Linux key code.

Still, I think that this discussion could be more productive if
you submit it as a patch (or a patch series).

> 
> The following is a list of (common) keys I'd like to propose be added. Please
> let us know what you think.
> 
> KEY_LIVE_TV: Jump directly to live tv view (from watching recordings,
> menus, VOD, etc). KEY_TV exists but only to select a "TV" input device
> but not related to the actual content being watched.
> 
> KEY_PIP: Toggle Picture-In-Picture on/off.
> 
> KEY_PIP_POSITION: Used to change PIP window position (typically upper left,
> lower left, lower right, upper right)
> 
> KEY_PIP_SWAP: Used to swap the main & PIP windows contents. (KEY_AB
> exists but is broad and could already be used for another function
> such as swapping audio outputs.)

Yeah, those seem to be missing.

> 
> KEY_USER1...KEY_USER16: Provide user-defined keys for special buttons
> that a remote control may have that are usable but may not be labeled
> to a specific common action. For example, we use Dish Network remote
> controls with our Linux-based htpc's - There's "DISH" and "Dish On
> Demand" buttons that are usable but not related to a common action.
> With KEY_USER* they could be mapped and used however the user wants.
> 16 user keys may be a lot, and 8 could be a better number, but any
> less than that is too limiting.

There are actually KEY_RED & friends that are normally used for
user-defined keys.

Not sure if I like the idea of a KEY_USER?, as it may mean that the
same key would be mapped different on different remote controllers.

We might be using KEY_FN?? or BTN_* for those, but I guess that
this is also not a good idea.

> 
> Any feedback or suggestions is appreciated.
> 
> Best regards,
> Derek



Thanks,
Mauro
