Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36338 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752729AbcKNV7F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 16:59:05 -0500
Date: Mon, 14 Nov 2016 23:58:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161114215827.GU3217@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161103224843.itxlvvotni6w6tmu@earth>
 <20161103230501.GJ3217@valkosipuli.retiisi.org.uk>
 <20161104000525.jzouapxxwwiwdwjy@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161104000525.jzouapxxwwiwdwjy@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Fri, Nov 04, 2016 at 01:05:25AM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Nov 04, 2016 at 01:05:01AM +0200, Sakari Ailus wrote:
> > On Thu, Nov 03, 2016 at 11:48:43PM +0100, Sebastian Reichel wrote:
> > > On Tue, Nov 01, 2016 at 12:54:08AM +0200, Sakari Ailus wrote:
> > > > > > Thanks, this answered half of my questions already. ;-)
> > > > > :-).
> > > > > 
> > > > > I'll have to go through the patches, et8ek8 driver is probably not
> > > > > enough to get useful video. platform/video-bus-switch.c is needed for
> > > > > camera switching, then some omap3isp patches to bind flash and
> > > > > autofocus into the subdevice.
> > > > > 
> > > > > Then, device tree support on n900 can be added.
> > > > 
> > > > I briefly discussed with with Sebastian.
> > > > 
> > > > Do you think the elusive support for the secondary camera is worth keeping
> > > > out the main camera from the DT in mainline? As long as there's a reasonable
> > > > way to get it working, I'd just merge that. If someone ever gets the
> > > > secondary camera working properly and nicely with the video bus switch,
> > > > that's cool, we'll somehow deal with the problem then. But frankly I don't
> > > > think it's very useful even if we get there: the quality is really bad.
> > > 
> > > If we want to keep open the option to add proper support for the
> > > second camera, we could also add the bus switch and not add the
> > > front camera node in DT. Then adding the front camera does not
> > > require DT or userspace API changes. It would need an additional
> > > DT quirk in arch/arm/mach-omap2/board-generic.c for RX51, which
> > > adds the CCP2 bus settings from the camera node to the bus
> > > switch node to keep isp_of_parse_node happy. That should be
> > > easy to implement and not add much delay in upstreaming.
> > 
> > By adding the video bus switch we have a little bit more complex system as a
> > whole. The V4L2 async does not currently support this. There's more here:
> > 
> > <URL:http://www.spinics.net/lists/linux-media/msg107262.html>
> 
> I'm not sure what part relevant for video-bus-switch is currently
> not supported?
> 
> video-bus-switch registers its own async notifier and only registers
> itself as subdevices to omap3isp, once its own subdevices have been
> registered successfully.

Do you happen to have patches for this?

I still think we should clean up the V4L2 async framework though.

> 
> > What I thought was that once we have everything that's required in
> > place, we can just change what's in DT. But the software needs to
> > continue to work with the old DT content.
> 
> Right, so DT is not a problem. But adding the switch would change
> the media-graph, which is exposed to userspace.

Well, yes, indeed. We'll have those cases coming anyway, as support for
multiple streams over a single link is added. In some cases more sub-devices
will be needed to expose all the necessary configurability to the user.

> 
> > > For actually getting both cameras available with runtime-switching
> > > the proper solution would probably involve moving the parsing of
> > > the bus-settings to the sensor driver and providing a callback.
> > > This callback can be called by omap3isp when it wants to configure
> > > the phy (which is basically when it starts streaming). That seems
> > > to be the only place needing the buscfg anyways.
> > > 
> > > Then the video-bus-switch could do something like this (pseudocode):
> > > 
> > > static void get_buscfg(struct *this, struct *buscfg) {
> > >     if (selected_cam == 0)
> > >         return this->sensor_a->get_buscfg(buscfg);
> > >     else
> > >         return this->sensor_b->get_buscfg(buscfg);
> > > }
> > > 
> > > Regarding the usefulness: I noticed, that the Neo900 people also
> > > plan to have the bus-switch [0]. It's still the same crappy front-cam,
> > > though. Nevertheless it might be useful for testing. It has nice
> > > test-image capabilities, which might be useful for regression
> > > testing once everything is in place.
> > > 
> > > [0] http://neo900.org/stuff/block-diagrams/neo900/neo900.html
> > 
> > Seriously? I suppose there should be no need for that anymore, is there?
> > 
> > I think they wanted to save one GPIO in order to shave off 0,0001 cents from
> > the manufacturing costs or something like that. And the result is...
> > painful. :-I
> 
> CSI1/CCP2 is more than a single I/O pin, isn't it? Or do you
> reference to the GPIO dual use to enable frontcam and switch
> between the cameras? That is indeed a really ugly solution :(

The GPIO, yes. It was a really bad idea...

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
