Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56334 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752331AbdBCVfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 16:35:01 -0500
Date: Fri, 3 Feb 2017 23:34:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203210610.GA18379@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Fri, Feb 03, 2017 at 10:06:10PM +0100, Pavel Machek wrote:
> Hi!
> 
> > My apologies for the delays in reviewing. Feel free to ping me in the future
> > if this happens. :-)
> 
> No problem :-). If you could review the C-code, too... that would be
> nice. It should be in your inbox somewhere (and I attached it below,
> without the dts part).
> 
> 
> > > +Required properties
> > > +===================
> > > +
> > > +compatible	: must contain "video-bus-switch"
> > 
> > How generic is this? Should we have e.g. nokia,video-bus-switch? And if so,
> > change the file name accordingly.
> 
> Generic for "single GPIO controls the switch", AFAICT. But that should
> be common enough...

Um, yes. Then... how about: video-bus-switch-gpio? No Nokia prefix.

> 
> > > +reg		: The interface:
> > > +		  0 - port for image signal processor
> > > +		  1 - port for first camera sensor
> > > +		  2 - port for second camera sensor
> > 
> > I'd say this must be pretty much specific to the one in N900. You could have
> > more ports. Or you could say that ports beyond 0 are camera sensors. I guess
> > this is good enough for now though, it can be changed later on with the
> > source if a need arises.
> 
> Well, I'd say that selecting between two sensors is going to be the
> common case. If someone needs more than two, it will no longer be
> simple GPIO, so we'll have some fixing to do.

It could be two GPIOs --- that's how the GPIO I2C mux works.

But I'd be surprised if someone ever uses something like that again. ;-)

> 
> > Btw. was it still considered a problem that the endpoint properties for the
> > sensors can be different? With the g_routing() pad op which is to be added,
> > the ISP driver (should actually go to a framework somewhere) could parse the
> > graph and find the proper endpoint there.
> 
> I don't know about g_routing. I added g_endpoint_config method that
> passes the configuration, and that seems to work for me.
> 
> I don't see g_routing in next-20170201 . Is there place to look?

I think there was a patch by Laurent to LMML quite some time ago. I suppose
that set will be repicked soonish.

I don't really object using g_endpoint_config() as a temporary solution; I'd
like to have Laurent's opinion on that though. Another option is to wait,
but we've already waited a looong time (as in total).

I'll reply to the other patch containing the code.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
