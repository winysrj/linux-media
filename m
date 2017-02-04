Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38886 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751201AbdBDWeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Feb 2017 17:34:22 -0500
Date: Sun, 5 Feb 2017 00:33:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: laurent.pinchart@ideasonboard.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170204223350.GF12291@valkosipuli.retiisi.org.uk>
References: <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170204215610.GA9243@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Sat, Feb 04, 2017 at 10:56:10PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > +Required properties
> > > > > +===================
> > > > > +
> > > > > +compatible	: must contain "video-bus-switch"
> > > > 
> > > > How generic is this? Should we have e.g. nokia,video-bus-switch? And if so,
> > > > change the file name accordingly.
> > > 
> > > Generic for "single GPIO controls the switch", AFAICT. But that should
> > > be common enough...
> > 
> > Um, yes. Then... how about: video-bus-switch-gpio? No Nokia prefix.
> 
> Ok, done. I also fixed the english a bit.
> 
> > > > > +reg		: The interface:
> > > > > +		  0 - port for image signal processor
> > > > > +		  1 - port for first camera sensor
> > > > > +		  2 - port for second camera sensor
> > > > 
> > > > I'd say this must be pretty much specific to the one in N900. You could have
> > > > more ports. Or you could say that ports beyond 0 are camera sensors. I guess
> > > > this is good enough for now though, it can be changed later on with the
> > > > source if a need arises.
> > > 
> > > Well, I'd say that selecting between two sensors is going to be the
> > > common case. If someone needs more than two, it will no longer be
> > > simple GPIO, so we'll have some fixing to do.
> > 
> > It could be two GPIOs --- that's how the GPIO I2C mux works.
> > 
> > But I'd be surprised if someone ever uses something like that
> > again. ;-)
> 
> I'd say.. lets handle that when we see hardware like that.

Yes. :-)

> 
> > > > Btw. was it still considered a problem that the endpoint properties for the
> > > > sensors can be different? With the g_routing() pad op which is to be added,
> > > > the ISP driver (should actually go to a framework somewhere) could parse the
> > > > graph and find the proper endpoint there.
> > > 
> > > I don't know about g_routing. I added g_endpoint_config method that
> > > passes the configuration, and that seems to work for me.
> > > 
> > > I don't see g_routing in next-20170201 . Is there place to look?
> > 
> > I think there was a patch by Laurent to LMML quite some time ago. I suppose
> > that set will be repicked soonish.
> > 
> > I don't really object using g_endpoint_config() as a temporary solution; I'd
> > like to have Laurent's opinion on that though. Another option is to wait,
> > but we've already waited a looong time (as in total).
> 
> Laurent, do you have some input here? We have simple "2 cameras
> connected to one signal processor" situation here. We need some way of
> passing endpoint configuration from the sensors through the switch. I
> did this:
> 
> > > @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> > >                          const struct v4l2_mbus_config *cfg);
> > >     int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> > >                        unsigned int *size);
> > > +   int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > > +                       struct v4l2_of_endpoint *cfg);
> 
> Google of g_routing tells me:
> 
> 9) Highly reconfigurable hardware - Julien Beraud
> 
> - 44 sub-devices connected with an interconnect.
> - As long as formats match, any sub-device could be connected to any
> - other sub-device through a link.
> - The result is 44 * 44 links at worst.
> - A switch sub-device proposed as the solution to model the
> - interconnect. The sub-devices are connected to the switch
> - sub-devices through the hardware links that connect to the
> - interconnect.
> - The switch would be controlled through new IOCTLs S_ROUTING and
> - G_ROUTING.
> - Patches available:
>  http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=xilinx-wip
> 
> but the patches are from 2005. So I guess I'll need some guidance here...

Yeah, that's where it began (2015?), but right now I can only suggest to
wait until there's more. My estimate is within next couple of weeks /
months. But it won't be years.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
