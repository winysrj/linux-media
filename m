Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40042 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2LXNgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 08:36:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 14:37:24 +0100
Message-ID: <9690842.n93imGlCHA@avalon>
In-Reply-To: <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com> <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tuesday 18 December 2012 00:21:32 Rob Clark wrote:
> On Mon, Dec 17, 2012 at 11:04 PM, Dave Airlie <airlied@gmail.com> wrote:
> >> Many developers showed interest in the first RFC, and I've had the
> >> opportunity to discuss it with most of them. I would like to thank (in
> >> no particular order) Tomi Valkeinen for all the time he spend helping me
> >> to draft v2, Marcus Lorentzon for his useful input during Linaro Connect
> >> Q4 2012, and Linaro for inviting me to Connect and providing a venue to
> >> discuss this topic.
> > 
> > So this might be a bit off topic but this whole CDF triggered me
> > looking at stuff I generally avoid:
> > 
> > The biggest problem I'm having currently with the whole ARM graphics
> > and output world is the proliferation of platform drivers for every
> > little thing. The whole ordering of operations with respect to things
> > like suspend/resume or dynamic power management is going to be a real
> > nightmare if there are dependencies between the drivers. How do you
> > enforce ordering of s/r operations between all the various components?
> 
> I tend to think that sub-devices are useful just to have a way to probe hw
> which may or may not be there, since on ARM we often don't have any
> alternative.. but beyond that, suspend/resume, and other life-cycle aspects,
> they should really be treated as all one device. Especially to avoid
> undefined suspend/resume ordering.

I tend to agree, except that I try to reuse the existing PM infrastructure 
when possible to avoid reinventing the wheel. So far handling suspend/resume 
ordering related to data busses in early suspend/late resume operations and 
allowing the Linux PM core to handle control busses using the Linux device 
tree worked pretty well.

> CDF or some sort of mechanism to share panel drivers between drivers is
> useful.  Keeping it within drm, is probably a good idea, if nothing else to
> simplify re-use of helper fxns (like avi-infoframe stuff, for example) and
> avoid dealing with merging changes across multiple trees. Treating them more
> like shared libraries and less like sub-devices which can be dynamically
> loaded/unloaded (ie. they should be not built as separate modules or
> suspend/resumed or probed/removed independently of the master driver) is a
> really good idea to avoid uncovering nasty synchronization issues later
> (remove vs modeset or pageflip) or surprising userspace in bad ways.

We've tried that in V4L2 years ago and realized that the approach led to a 
dead-end, especially when OF/DT got involved. With DT-based device probing, 
I2C camera sensors started getting probed asynchronously to the main camera 
device, as they are children of the I2C bus master. We will have similar 
issues with I2C HDMI transmitters or panels, so we should be prepared for it.

On PC hardware the I2C devices are connected to an I2C master provided by the 
GPU, but on embedded devices they are usually connected to an independent I2C 
master. We thus can't have a single self-contained driver that controls 
everything internally, and need to interface with the rest of the SoC drivers.

I agree that probing/removing devices independently of the master driver can 
lead to bad surprises, which is why I want to establish clear rules in CDF 
regarding what can and can't be done with display entities. Reference counting 
will be one way to make sure that devices don't disappear all of a sudden.

> > The other thing I'd like you guys to do is kill the idea of fbdev and
> > v4l drivers that are "shared" with the drm codebase, really just
> > implement fbdev and v4l on top of the drm layer, some people might
> > think this is some sort of maintainer thing, but really nothing else
> > makes sense, and having these shared display frameworks just to avoid
> > having using drm/kms drivers seems totally pointless. Fix the drm
> > fbdev emulation if an fbdev interface is needed. But creating a fourth
> > framework because our previous 3 frameworks didn't work out doesn't
> > seem like a situation I want to get behind too much.
> 
> yeah, let's not have multiple frameworks to do the same thing.. For fbdev,
> it is pretty clear that it is a dead end.  For v4l2 (subdev+mcf), it is
> perhaps bit more flexible when it comes to random arbitrary hw pipelines
> than kms.  But to take advantage of that, your userspace isn't going to be
> portable anyways, so you might as well use driver specific
> properties/ioctls.  But I tend to think that is more useful for cameras. 
> And from userspace perspective, kms planes are less painful to use for
> output than v4l2, so lets stick to drm/kms for output (and not try to add
> camera/capture support to kms)..

Agreed. I've started to advocate the deprecation of FBDEV during LPC. The 
positive response has motivated me to continue doing so :-) For V4L2 the 
situation is a little bit different, I think V4L2 shouldn't be used for 
graphics and display hardware, but it still has use cases on the video output 
side for pure video devices (such as pass-through video pipelines with 
embedded processing for instance). As those can use subdevices found in 
display and graphics hardware, I'd like to avoid code duplication.

-- 
Regards,

Laurent Pinchart

