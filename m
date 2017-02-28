Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34947 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdB1I7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 03:59:46 -0500
Received: by mail-wm0-f67.google.com with SMTP id u63so1218308wmu.2
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 00:59:45 -0800 (PST)
Date: Tue, 28 Feb 2017 09:51:41 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Vetter <daniel@ffwll.ch>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv4 1/9] video: add hotplug detect notifier support
Message-ID: <20170228085141.fvkhf2swt72gskm6@phenom.ffwll.local>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
 <20170206102951.12623-2-hverkuil@xs4all.nl>
 <20170227160841.3pgmpqwtidvjbnzn@phenom.ffwll.local>
 <20170227170454.GA21222@n2100.armlinux.org.uk>
 <bdc5a7a5-301d-c375-cbc0-6c119f06afc1@xs4all.nl>
 <20170227174650.GB21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170227174650.GB21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 27, 2017 at 05:46:51PM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 27, 2017 at 06:21:05PM +0100, Hans Verkuil wrote:
> > On 02/27/2017 06:04 PM, Russell King - ARM Linux wrote:
> > > I'm afraid that I walked away from this after it became clear that there
> > > was little hope for any forward progress being made in a timely manner
> > > for multiple reasons (mainly the core CEC code being out of mainline.)
> > 
> > In case you missed it: the core CEC code was moved out of staging and into
> > mainline in 4.10.
> 
> I was aware (even though I've not been publishing anything, I do keep
> dw-hdmi-cec and tda9950/tda998x up to date with every final kernel
> release.)
> 
> > > If you can think of a better approach, then I'm sure there's lots of
> > > people who'd be willing to do the coding for it... if not, I'm not
> > > sure where we go from here (apart from keeping code in private/vendor
> > > trees.)
> > 
> > For CEC there are just two things that it needs: the physical address
> > (contained in the EDID) and it needs to be informed when the EDID disappears
> > (typically due to a disconnect), in which case the physical address
> > becomes invalid (f.f.f.f).
> 
> Yep.  CEC really only needs to know "have new phys address" and
> "disconnect" provided that CEC drivers understand that they may receive
> a new phys address with no intervening disconnect.  (Consider the case
> where EDID changes, but the HDMI driver failed to spot the HPD signal
> pulse - unfortunately, there's hardware out there where HPD is next to
> useless.)

Ok, simplifying the CEC stuff like that would be a lot better I think, to
avoid overlap with other in-kernel interfaces. I still have some
questions, but this might be my misunderstanding of how CEC works:

I thought that CEC is driven through a special separate wire in the HDMI
bus, with the receiver in the TV. Which means that we'd have a 1:1
relationship between HDMI connector and CEC port. That's at least the
use-case I've heard of for Intel boards. Are there other use-cases where
we do not have a 1:1 relationship between HDMI connector and CEC port? Imo
notifier really only makes sense as a quick&dirty hack, or if you really
have n:m for at least one of n,m != 1. Otherwise some very specific
callback service which just provides the information the CEC side needs
seems like a much better idea to me.

> > Russell, do you have pending code that needs the ELD support in the
> > notifier?  CEC doesn't need it, so from my perspective it can be
> > dropped in the first version.
> 
> I was looking for that while writing the previous mail, and I think
> it's time to drop it - I had thought dw-hdmi-*audio would use it, or
> the ASoC people, but it's still got no users, so I think it's time
> to drop it.

For ELD I'd definitely say let's please use the hdmi-codec.h. It's what's
in tree, so better to converge on one solution instead of proliferating
even more. The entire sad story of multiple people inventing similar
wheels without talking with each another is water down the river, can't
fix that anymore :(

> I have seen some patch sets go by which are making use of the notifier,
> but I haven't paid close attention to how they're using it or what
> they're using it for... as I sort of implied in my previous mail, I
> had lost interest in mainline wrt CEC stuff due to the glacial rate
> of progress.  (That's not a criticism.)

Maybe some docs that would describe the flow we want to achieve here would
help? Doesn't need to be more than a few lines, but reconstructing that
from the various driver patches later on is indeed hard.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
