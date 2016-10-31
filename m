Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34046 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S946090AbcJaWyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 18:54:13 -0400
Date: Tue, 1 Nov 2016 00:54:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161023203315.GC6391@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sun, Oct 23, 2016 at 10:33:15PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Thanks, this answered half of my questions already. ;-)
> 
> :-).
> 
> I'll have to go through the patches, et8ek8 driver is probably not
> enough to get useful video. platform/video-bus-switch.c is needed for
> camera switching, then some omap3isp patches to bind flash and
> autofocus into the subdevice.
> 
> Then, device tree support on n900 can be added.

I briefly discussed with with Sebastian.

Do you think the elusive support for the secondary camera is worth keeping
out the main camera from the DT in mainline? As long as there's a reasonable
way to get it working, I'd just merge that. If someone ever gets the
secondary camera working properly and nicely with the video bus switch,
that's cool, we'll somehow deal with the problem then. But frankly I don't
think it's very useful even if we get there: the quality is really bad.

> > Do all the modes work for you currently btw.?
> 
> I don't think I got 5MP mode to work. Even 2.5MP mode is tricky (needs
> a lot of continuous memory).

The OMAP 3 ISP has got an MMU, getting some contiguous memory is not really
a problem when you have a 4 GiB empty space to use.

> Anyway, I have to start somewhere, and I believe this is a good
> starting place; I'd like to get the code cleaned up and merged, then
> move to the next parts.

I wonder if something else could be the problem. I think the data rate is
higher in the 5 MP mode, and that might be the reason. I don't remember how
similar is the clock tree in the 3430 to the 3630. Could it be that the ISP
clock is lower than it should be for some reason, for instance?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
