Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49078 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754304AbcKAUJO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Nov 2016 16:09:14 -0400
Date: Tue, 1 Nov 2016 22:08:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161101200831.GE3217@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161101153921.GA15268@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161101153921.GA15268@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Nov 01, 2016 at 04:39:21PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > I'll have to go through the patches, et8ek8 driver is probably not
> > > enough to get useful video. platform/video-bus-switch.c is needed for
> > > camera switching, then some omap3isp patches to bind flash and
> > > autofocus into the subdevice.
> > > 
> > > Then, device tree support on n900 can be added.
> > 
> > I briefly discussed with with Sebastian.
> > 
> > Do you think the elusive support for the secondary camera is worth keeping
> > out the main camera from the DT in mainline? As long as there's a reasonable
> > way to get it working, I'd just merge that. If someone ever gets the
> > secondary camera working properly and nicely with the video bus switch,
> > that's cool, we'll somehow deal with the problem then. But frankly I don't
> > think it's very useful even if we get there: the quality is really
> > bad.
> 
> Well, I am a little bit worried that /dev/video* entries will
> renumber themself when the the front camera support is merged,
> breaking userspace.
> 
> But the first step is still the same: get et8ek8 support merged :-).

Do you happen to have a patch for the DT part as well? People could more
easily test this...

> > > > Do all the modes work for you currently btw.?
> > > 
> > > I don't think I got 5MP mode to work. Even 2.5MP mode is tricky (needs
> > > a lot of continuous memory).
> > 
> > The OMAP 3 ISP has got an MMU, getting some contiguous memory is not really
> > a problem when you have a 4 GiB empty space to use.
> 
> Ok, maybe it is something else. 2.5MP mode seems to work better when
> there is free memory.

That's very odd. Do you use MMAP or USERPTR buffers btw.? I remember the
cache was different on 3430, that could be an issue as well (VIVT AFAIR, so
flushing requires making sure there are no other mappings or flushing the
entire cache).

> > > Anyway, I have to start somewhere, and I believe this is a good
> > > starting place; I'd like to get the code cleaned up and merged, then
> > > move to the next parts.
> > 
> > I wonder if something else could be the problem. I think the data rate is
> > higher in the 5 MP mode, and that might be the reason. I don't remember how
> > similar is the clock tree in the 3430 to the 3630. Could it be that the ISP
> > clock is lower than it should be for some reason, for instance?
> 
> No idea, really. I'd like to get the support merged, and then debug
> the code when we have common code base in the mainline.

Yes. It's much easier then. Which is why it'd be very nice to have the DT
content, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
