Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49144 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753217AbcKAUL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Nov 2016 16:11:27 -0400
Date: Tue, 1 Nov 2016 22:11:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161101201122.GF3217@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivaylo,

On Tue, Nov 01, 2016 at 08:36:57AM +0200, Ivaylo Dimitrov wrote:
> Hi,
> 
> On  1.11.2016 00:54, Sakari Ailus wrote:
> >Hi Pavel,
> >
> >On Sun, Oct 23, 2016 at 10:33:15PM +0200, Pavel Machek wrote:
> >>Hi!
> >>
> >>>Thanks, this answered half of my questions already. ;-)
> >>
> >>:-).
> >>
> >>I'll have to go through the patches, et8ek8 driver is probably not
> >>enough to get useful video. platform/video-bus-switch.c is needed for
> >>camera switching, then some omap3isp patches to bind flash and
> >>autofocus into the subdevice.
> >>
> >>Then, device tree support on n900 can be added.
> >
> >I briefly discussed with with Sebastian.
> >
> >Do you think the elusive support for the secondary camera is worth keeping
> >out the main camera from the DT in mainline? As long as there's a reasonable
> >way to get it working, I'd just merge that. If someone ever gets the
> >secondary camera working properly and nicely with the video bus switch,
> >that's cool, we'll somehow deal with the problem then. But frankly I don't
> >think it's very useful even if we get there: the quality is really bad.
> >
> 
> Yes, lets merge what we have till now, it will be way easier to improve on
> it once it is part of the mainline.
> 
> BTW, I have (had) patched VBS working almost without problems, when it comes
> to it I'll dig it.

I wonder if I'm the only one who wonders what VBS is here. Don't tell me its
the old MS thing. :-) ;-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
