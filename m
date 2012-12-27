Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60320 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2L0TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 14:19:16 -0500
Date: Thu, 27 Dec 2012 20:18:59 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Clark <rob.clark@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Message-ID: <20121227191859.GX26326@pengutronix.de>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
 <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
 <9690842.n93imGlCHA@avalon>
 <CAF6AEGt+gwUq-xGze5bTgrKUMRijSBo_ORreq=Ot1RMD-WrbYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGt+gwUq-xGze5bTgrKUMRijSBo_ORreq=Ot1RMD-WrbYQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 27, 2012 at 09:54:55AM -0600, Rob Clark wrote:
> On Mon, Dec 24, 2012 at 7:37 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Rob,
> >
> > On Tuesday 18 December 2012 00:21:32 Rob Clark wrote:
> >> On Mon, Dec 17, 2012 at 11:04 PM, Dave Airlie <airlied@gmail.com> wrote:
> >> >> Many developers showed interest in the first RFC, and I've had the
> >> >> opportunity to discuss it with most of them. I would like to thank (in
> >> >> no particular order) Tomi Valkeinen for all the time he spend helping me
> >> >> to draft v2, Marcus Lorentzon for his useful input during Linaro Connect
> >> >> Q4 2012, and Linaro for inviting me to Connect and providing a venue to
> >> >> discuss this topic.
> >> >
> >> > So this might be a bit off topic but this whole CDF triggered me
> >> > looking at stuff I generally avoid:
> >> >
> >> > The biggest problem I'm having currently with the whole ARM graphics
> >> > and output world is the proliferation of platform drivers for every
> >> > little thing. The whole ordering of operations with respect to things
> >> > like suspend/resume or dynamic power management is going to be a real
> >> > nightmare if there are dependencies between the drivers. How do you
> >> > enforce ordering of s/r operations between all the various components?
> >>
> >> I tend to think that sub-devices are useful just to have a way to probe hw
> >> which may or may not be there, since on ARM we often don't have any
> >> alternative.. but beyond that, suspend/resume, and other life-cycle aspects,
> >> they should really be treated as all one device. Especially to avoid
> >> undefined suspend/resume ordering.
> >
> > I tend to agree, except that I try to reuse the existing PM infrastructure
> > when possible to avoid reinventing the wheel. So far handling suspend/resume
> > ordering related to data busses in early suspend/late resume operations and
> > allowing the Linux PM core to handle control busses using the Linux device
> > tree worked pretty well.
> >
> >> CDF or some sort of mechanism to share panel drivers between drivers is
> >> useful.  Keeping it within drm, is probably a good idea, if nothing else to
> >> simplify re-use of helper fxns (like avi-infoframe stuff, for example) and
> >> avoid dealing with merging changes across multiple trees. Treating them more
> >> like shared libraries and less like sub-devices which can be dynamically
> >> loaded/unloaded (ie. they should be not built as separate modules or
> >> suspend/resumed or probed/removed independently of the master driver) is a
> >> really good idea to avoid uncovering nasty synchronization issues later
> >> (remove vs modeset or pageflip) or surprising userspace in bad ways.
> >
> > We've tried that in V4L2 years ago and realized that the approach led to a
> > dead-end, especially when OF/DT got involved. With DT-based device probing,
> > I2C camera sensors started getting probed asynchronously to the main camera
> > device, as they are children of the I2C bus master. We will have similar
> > issues with I2C HDMI transmitters or panels, so we should be prepared for it.
> 
> What I've done to avoid that so far is that the master device
> registers the drivers for it's output sub-devices before registering
> it's own device.  At least this way I can control that they are probed
> first.  Not the prettiest thing, but avoids even uglier problems.

This implies that the master driver knows all potential subdevices,
something which is not true for SoCs which have external i2c encoders
attached to unrelated i2c controllers.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
