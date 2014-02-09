Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58685 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457AbaBIKEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 05:04:42 -0500
Date: Sun, 9 Feb 2014 10:04:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Clark <robdclark@gmail.com>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC 0/2] drivers/base: simplify simple DT-based
	components
Message-ID: <20140209100424.GK26684@n2100.arm.linux.org.uk>
References: <cover.1391793068.git.moinejf@free.fr> <20140207202351.GH26684@n2100.arm.linux.org.uk> <20140209102219.3ab40b5e@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209102219.3ab40b5e@armhf>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 09, 2014 at 10:22:19AM +0100, Jean-Francois Moine wrote:
> On Fri, 7 Feb 2014 20:23:51 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > Here's my changes to the TDA998x driver to add support for the component
> > helper.  The TDA998x driver retains support for the old way so that
> > drivers can be transitioned.  For any one DRM "card" the transition to
> 
> I rewrote the tda998x as a simple encoder+connector (i.e. not a
> slave_encoder) with your component helper, and the code is much clearer
> and simpler: the DRM driver has nothing to do except to know that the
> tda998x is a component and to set the possible_crtcs.

That's exactly what I've done - the slave encoder veneer can be simply
deleted when tilcdc is converted.

> AFAIK, only the tilcdc drm driver is using the tda998x as a
> slave_encoder. It does a (encoder+connector) conversion to
> (slave_encoder). Then, in your changes in the TDA998x, you do a
> (slave_encoder) translation to (encoder+connector).
> This seems rather complicated!

No.  I first split out the slave encoder functions to be a veneer onto
the tda998x backend, and then add the encoder & connector component
support.  Later, the slave encoder veneer can be deleted.

The reason for this is that virtually all the tda998x backend is what's
required by the encoder & connector support - which is completely logical
when you realise that the generic slave encoder support is just a veneer
itself adapting the encoder & connector support to a slave encoder.

So, we're basically getting rid of two veneers, but we end up with exactly
the same functionality.

> > And yes, I'm thinking that maybe moving compare_of() into the component
> > support so that drivers can share this generic function may be a good
> > idea.
> 
> This function exists already in drivers/of/platform.c as
> of_dev_node_match(). It just needs to be exported.

Good, thanks for pointing that out.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
