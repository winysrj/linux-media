Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34830 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751071AbdLUJFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 04:05:48 -0500
Date: Thu, 21 Dec 2017 11:05:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pavel Machek <pavel@ucw.cz>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20171221090545.okcemn3a3v7xrnzy@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
 <75694885.3PuLWzx4qN@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75694885.3PuLWzx4qN@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 20, 2017 at 07:54:12PM +0200, Laurent Pinchart wrote:
> Hi Pavel,
> 
> On Saturday, 4 February 2017 23:56:10 EET Pavel Machek wrote:
> > Hi!
> > 
> > >>>> +Required properties
> > >>>> +===================
> > >>>> +
> > >>>> +compatible	: must contain "video-bus-switch"
> > >>> 
> > >>> How generic is this? Should we have e.g. nokia,video-bus-switch? And
> > >>> if so, change the file name accordingly.
> > >> 
> > >> Generic for "single GPIO controls the switch", AFAICT. But that should
> > >> be common enough...
> > > 
> > > Um, yes. Then... how about: video-bus-switch-gpio? No Nokia prefix.
> > 
> > Ok, done. I also fixed the english a bit.
> > 
> > >>>> +reg		: The interface:
> > >>>> +		  0 - port for image signal processor
> > >>>> +		  1 - port for first camera sensor
> > >>>> +		  2 - port for second camera sensor
> > >>> 
> > >>> I'd say this must be pretty much specific to the one in N900. You
> > >>> could have more ports. Or you could say that ports beyond 0 are
> > >>> camera sensors. I guess this is good enough for now though, it can be
> > >>> changed later on with the source if a need arises.
> > >> 
> > >> Well, I'd say that selecting between two sensors is going to be the
> > >> common case. If someone needs more than two, it will no longer be
> > >> simple GPIO, so we'll have some fixing to do.
> > > 
> > > It could be two GPIOs --- that's how the GPIO I2C mux works.
> > > 
> > > But I'd be surprised if someone ever uses something like that
> > > again. ;-)
> > 
> > I'd say.. lets handle that when we see hardware like that.
> > 
> > >>> Btw. was it still considered a problem that the endpoint properties
> > >>> for the sensors can be different? With the g_routing() pad op which is
> > >>> to be added, the ISP driver (should actually go to a framework
> > >>> somewhere) could parse the graph and find the proper endpoint there.
> > >> 
> > >> I don't know about g_routing. I added g_endpoint_config method that
> > >> passes the configuration, and that seems to work for me.
> > >> 
> > >> I don't see g_routing in next-20170201 . Is there place to look?
> > > 
> > > I think there was a patch by Laurent to LMML quite some time ago. I
> > > suppose that set will be repicked soonish.
> > > 
> > > I don't really object using g_endpoint_config() as a temporary solution;
> > > I'd like to have Laurent's opinion on that though. Another option is to
> > > wait, but we've already waited a looong time (as in total).
> > 
> > Laurent, do you have some input here? We have simple "2 cameras
> > connected to one signal processor" situation here. We need some way of
> > passing endpoint configuration from the sensors through the switch. I
> > did this:
> 
> Could you give me a bit more information about the platform you're targeting: 
> how the switch is connected, what kind of switch it is, and what endpoint 
> configuration data you need ?
> 
> > >> @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> > >>                          const struct v4l2_mbus_config *cfg);
> > >>     int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> > >>                        unsigned int *size);
> > >> +   int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > >> +                       struct v4l2_of_endpoint *cfg);
> > 
> > Google of g_routing tells me:
> > 
> > 9) Highly reconfigurable hardware - Julien Beraud
> > 
> > - 44 sub-devices connected with an interconnect.
> > - As long as formats match, any sub-device could be connected to any
> > - other sub-device through a link.
> > - The result is 44 * 44 links at worst.
> > - A switch sub-device proposed as the solution to model the
> > - interconnect. The sub-devices are connected to the switch
> > - sub-devices through the hardware links that connect to the
> > - interconnect.
> > - The switch would be controlled through new IOCTLs S_ROUTING and
> > - G_ROUTING.
> > - Patches available:
> >  http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/log/?h=xilinx-wip
> > 
> > but the patches are from 2005. So I guess I'll need some guidance here...
> 
> You made me feel very old for a moment. The patches are from 2015 :-)

There are up-to-date patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vc>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
