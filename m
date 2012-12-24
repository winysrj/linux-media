Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2LXNhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 08:37:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Rob Clark <rob.clark@linaro.org>, Dave Airlie <airlied@gmail.com>,
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
Date: Mon, 24 Dec 2012 14:39:02 +0100
Message-ID: <2197335.PVFVBmr4Hc@avalon>
In-Reply-To: <CAKMK7uF3Ahh8isvzZr4605X3wz-TQ2EHreTUnc5K_Z0DwrY6xw@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com> <CAKMK7uF3Ahh8isvzZr4605X3wz-TQ2EHreTUnc5K_Z0DwrY6xw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Tuesday 18 December 2012 09:30:00 Daniel Vetter wrote:
> On Tue, Dec 18, 2012 at 7:21 AM, Rob Clark <rob.clark@linaro.org> wrote:
> >> The other thing I'd like you guys to do is kill the idea of fbdev and
> >> v4l drivers that are "shared" with the drm codebase, really just
> >> implement fbdev and v4l on top of the drm layer, some people might
> >> think this is some sort of maintainer thing, but really nothing else
> >> makes sense, and having these shared display frameworks just to avoid
> >> having using drm/kms drivers seems totally pointless. Fix the drm
> >> fbdev emulation if an fbdev interface is needed. But creating a fourth
> >> framework because our previous 3 frameworks didn't work out doesn't
> >> seem like a situation I want to get behind too much.
> > 
> > yeah, let's not have multiple frameworks to do the same thing.. For
> > fbdev, it is pretty clear that it is a dead end.  For v4l2
> > (subdev+mcf), it is perhaps bit more flexible when it comes to random
> > arbitrary hw pipelines than kms.  But to take advantage of that, your
> > userspace isn't going to be portable anyways, so you might as well use
> > driver specific properties/ioctls.  But I tend to think that is more
> > useful for cameras.  And from userspace perspective, kms planes are
> > less painful to use for output than v4l2, so lets stick to drm/kms for
> > output (and not try to add camera/capture support to kms).. k, thx
> 
> Yeah, I guess having a v4l device also exported by the same driver that
> exports the drm interface might make sense in some cases. But in many cases
> I think the video part is just an independent IP block and shuffling data
> around with dma-buf is all we really need. So yeah, I guess sharing display
> resources between v4l and drm kms driver should be a last resort option,
> since coordination (especially if it's supposed to be somewhat dynamic) will
> be extremely hairy.

I totally agree. As explained in my replies to Dave and Rob, I don't want to 
share devices between the different subsystems at runtime, but I'd like to 
avoid writing two drivers for a single device that can be used for display and 
graphics on one board, and video output on another board (HDMI transmitters 
are a good example).

-- 
Regards,

Laurent Pinchart

