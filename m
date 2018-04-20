Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50108 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755978AbeDTQHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 12:07:40 -0400
Date: Fri, 20 Apr 2018 17:07:31 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 5/7] drm/i2c: tda9950: add CEC driver
Message-ID: <20180420160731.GA16141@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
 <E1f5Viq-0002Lj-Ru@rmk-PC.armlinux.org.uk>
 <20180420153137.GZ16141@n2100.armlinux.org.uk>
 <bd644882-50b3-3022-de21-1f0b7fe008b7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd644882-50b3-3022-de21-1f0b7fe008b7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 05:48:12PM +0200, Hans Verkuil wrote:
> On 04/20/2018 05:31 PM, Russell King - ARM Linux wrote:
> > Hi Hans,
> > 
> > Any comments?
> 
> I have been traveling and haven't had time to look at this. Next week will
> be busy as well, but I expect to be able to look at it the week after that.

Well, that doesn't work because I won't be reading mail that week,
and I'll probably simply ignore the excessive backlog when I do
start reading mail again.

> I remember from the previous series that I couldn't test it with my BeagleBone
> Black board (the calibration gpio had to switch from in to out but it wasn't allowed
> since it had an associated irq). That's still a problem?
> 
> I didn't see any changes in that area when I did a quick scan.

Correct, and unless you wish me to do the work for you (in which case
you can pay me) nothing is going to change on that front!  Seriously,
please do not expect me to add support for platforms I don't have
access to.  I'm just a volunteer for this, probably the same as you.

I don't think we ended up with an answer for that problem.  I don't
see that dropping the requested interrupt, using the GPIO, and then
re-requesting the interrupt is an option - how do we handle a failure
to re-request the interrupt?  Do we just ignore the error, or let DRM
stop working properly?

In any case, I don't have a working HDMI CEC-compliant setup anymore,
(no TV, just a HDMI monitor now) so I would rather _not_ change the
driver from its known-to-be-working state.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
