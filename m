Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38438 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932462AbcKOWz6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 17:55:58 -0500
Date: Wed, 16 Nov 2016 00:55:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161115225522.GC12971@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161103224843.itxlvvotni6w6tmu@earth>
 <20161115105425.GA24212@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115105425.GA24212@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Nov 15, 2016 at 11:54:25AM +0100, Pavel Machek wrote:
> Hi!
> 
> > On Tue, Nov 01, 2016 at 12:54:08AM +0200, Sakari Ailus wrote:
> > > > > Thanks, this answered half of my questions already. ;-)
> > > > :-).
> > > > 
> > > > I'll have to go through the patches, et8ek8 driver is probably not
> > > > enough to get useful video. platform/video-bus-switch.c is needed for
> > > > camera switching, then some omap3isp patches to bind flash and
> > > > autofocus into the subdevice.
> > > > 
> > > > Then, device tree support on n900 can be added.
> > > 
> > > I briefly discussed with with Sebastian.
> > > 
> > > Do you think the elusive support for the secondary camera is worth keeping
> > > out the main camera from the DT in mainline? As long as there's a reasonable
> > > way to get it working, I'd just merge that. If someone ever gets the
> > > secondary camera working properly and nicely with the video bus switch,
> > > that's cool, we'll somehow deal with the problem then. But frankly I don't
> > > think it's very useful even if we get there: the quality is really bad.
> > 
> > If we want to keep open the option to add proper support for the
> > second camera, we could also add the bus switch and not add the
> > front camera node in DT. Then adding the front camera does not
> 
> Now that we have ack on the device tree parts, could you merge the
> et8ek8 driver (or provide review comments?)?
> 
> Yes, there are more parts missing for useful camera support on n900,
> but the chip driver is neccessary part and it should be ready.

Sure, I was somehow expecting we could perhaps merge the rest of the
necessary patches sooner than it now appears.

Let me check the latest et8ek8 patch.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
