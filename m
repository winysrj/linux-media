Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52247 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751604AbaBZWT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 17:19:56 -0500
Date: Wed, 26 Feb 2014 22:19:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
	componentised subsystems
Message-ID: <20140226221939.GC21483@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk> <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk> <Pine.LNX.4.64.1402262144190.10826@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1402262144190.10826@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 26, 2014 at 10:00:25PM +0100, Guennadi Liakhovetski wrote:
> Hi Russell
> 
> (I suspect this my email will be rejected by ALKML too like other my 
> recent emails, but at least other MLs will pick it up and individual CCs 
> too, so, if replying, maybe it would be good to keep my entire reply, all 
> the more that it's going to be very short)
> 
> On Thu, 2 Jan 2014, Russell King wrote:
> 
> > Subsystems such as ALSA, DRM and others require a single card-level
> > device structure to represent a subsystem.  However, firmware tends to
> > describe the individual devices and the connections between them.
> > 
> > Therefore, we need a way to gather up the individual component devices
> > together, and indicate when we have all the component devices.
> > 
> > We do this in DT by providing a "superdevice" node which specifies
> > the components, eg:
> > 
> > 	imx-drm {
> > 		compatible = "fsl,drm";
> > 		crtcs = <&ipu1>;
> > 		connectors = <&hdmi>;
> > 	};
> 
> It is a pity linux-media wasn't CC'ed and apparently V4L developers didn't 
> notice this and other related patches in a "clean up" series, and now this 
> patch is already in the mainline. But at least I'd like to ask whether the 
> bindings, defined in 
> Documentation/devicetree/bindings/media/video-interfaces.txt and 
> implemented in drivers/media/v4l2-core/v4l2-of.c have been considered for 
> this job, and - if so - why have they been found unsuitable? Wouldn't it 
> have been better to use and - if needed - extend them to cover any 
> deficiencies? Even though the implementation is currently located under 
> drivers/media/v4l2-code/ it's pretty generic and should be easily 
> transferable to a more generic location.

The component helpers have nothing to do with DT apart from solving
the problem of how to deal with subsystems which expect a single device,
but we have a group of devices and their individual drivers to cope with.
Subsystems like DRM and ALSA.

It is completely agnostic to whether you're using platform data, DT or
even ACPI - this code could *not* care less.  None of that comes anywhere
near what this patch does.  It merely provides a way to collect up
individual devices from co-operating drivers, and control their binding
such that a subsystem like DRM or ALSA can be presented with a "card"
level view of the hardware rather than a multi-device medusa with all
the buggy, racy, crap fsckage that people come up to make that kind of
thing work.

Now, as for the binding above, first, what does "eg" mean... and
secondly, how would a binding which refers to crtcs and connectors
have anything to do with ALSA?  Clearly this isn't an example of a
binding for an ALSA use, which was talked about in the very first
line of the above commit commentry.  So it's quite clear that what is
given there is an example of how it /could/ be used.

I suppose I could have instead turned imx-drm into a completely unusable
mess by not coming up with some kind of binding, and instead submitted
a whole pile of completely untested code.  Alternatively, I could've
used the OF binding as you're suggesting, but that would mean radically
changing the /existing/ bindings for the IPU as a whole - something
which others are better suited at as they have a /much/ better
understanding of the complexities of this hardware than I.

So, what I have done is implemented - for a driver in staging which is
still subject to ongoing development and non-stable DT bindings -
something which allows forward progress with a *minimum* of disruption
to the existing DT bindings for everyone, while still allowing forward
progress.

Better bindings for imx-drm are currently being worked on.  Philipp
Zabel of Pengutronix is currently looking at it, and has posted many
RFC patches on this very subject, including moving the V4L2 OF helpers
to a more suitable location.  OF people have been involved in that
discussion over the preceding weeks, and there's a working implementation
of imx-drm using these helpers from v4l2.

I'm finding people who are working in the same area and trying to get
everyone talking to each other so that we /do/ end up with a set of
bindings for the display stuff which are suitable for everyone.  Tomi
from TI has already expressed his input to this ongoing discussion.

You're welcome to get involved in those discussions too.

I hope this makes it clear, and clears up the confusion.

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
