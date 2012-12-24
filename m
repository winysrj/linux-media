Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56596 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2LXOHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 09:07:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <rob.clark@linaro.org>,
	Dave Airlie <airlied@gmail.com>,
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
Date: Mon, 24 Dec 2012 15:08:58 +0100
Message-ID: <8375165.paX7MkzlqD@avalon>
In-Reply-To: <CAAQKjZMt+13oooEw39mOM1rF2=ss4ih1s7iVS362di-50h4+Hg@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAKMK7uF3Ahh8isvzZr4605X3wz-TQ2EHreTUnc5K_Z0DwrY6xw@mail.gmail.com> <CAAQKjZMt+13oooEw39mOM1rF2=ss4ih1s7iVS362di-50h4+Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Inki,

On Tuesday 18 December 2012 18:38:31 Inki Dae wrote:
> 2012/12/18 Daniel Vetter <daniel@ffwll.ch>
> > On Tue, Dec 18, 2012 at 7:21 AM, Rob Clark <rob.clark@linaro.org> wrote:
> > >> The other thing I'd like you guys to do is kill the idea of fbdev and
> > >> v4l drivers that are "shared" with the drm codebase, really just
> > >> implement fbdev and v4l on top of the drm layer, some people might
> > >> think this is some sort of maintainer thing, but really nothing else
> > >> makes sense, and having these shared display frameworks just to avoid
> > >> having using drm/kms drivers seems totally pointless. Fix the drm
> > >> fbdev emulation if an fbdev interface is needed. But creating a fourth
> > >> framework because our previous 3 frameworks didn't work out doesn't
> > >> seem like a situation I want to get behind too much.
> > > 
> > > yeah, let's not have multiple frameworks to do the same thing.. For
> > > fbdev, it is pretty clear that it is a dead end.  For v4l2
> > > (subdev+mcf), it is perhaps bit more flexible when it comes to random
> > > arbitrary hw pipelines than kms.  But to take advantage of that, your
> > > userspace isn't going to be portable anyways, so you might as well use
> > > driver specific properties/ioctls.  But I tend to think that is more
> > > useful for cameras.  And from userspace perspective, kms planes are
> > > less painful to use for output than v4l2, so lets stick to drm/kms for
> > > output (and not try to add camera/capture support to kms).. k, thx
> > 
> > Yeah, I guess having a v4l device also exported by the same driver
> > that exports the drm interface might make sense in some cases. But in
> > many cases I think the video part is just an independent IP block and
> > shuffling data around with dma-buf is all we really need. So yeah, I
> > guess sharing display resources between v4l and drm kms driver should
> > be a last resort option, since coordination (especially if it's
> > supposed to be somewhat dynamic) will be extremely hairy.
> 
> I think the one reason that the CDF was appeared is to avoid duplicating
> codes. For example, we should duplicate mipi-dsi or dbi drivers into drm to
> avoid ordering issue. And for this, those should be re-implemented in based
> on drm framework so that those could be treated as all one device.
> Actually, in case of Exynos, some guys tried to duplicate eDP driver into
> exynos drm framework in same issue. So I think the best way is to avoid
> duplicating codes and resolve ordering issue such as s/r operations between
> all the various components.
> 
> And the below is my opinion,
> 
>                                           +--------------------------------+
> Display Controller -------- CDF --------- |MIPI-DSI/DBI-----------LCD Panel|
>                                           +--------------------------------+
> 
> 1. to access MIPI-DSI/DBI and LCD Panel drivers.
>     - Display Controller is controlled by linux framebuffer or drm kms
> based specific drivers like now. And each driver calls some interfaces of
> CDF.
> 
> 2. to control the power of these devices.
>     - drm kms based specific driver calls dpms operation and next the dpms
> operation calls fb blank operation of linux framebuffer.
>       But for this, we need some interfaces that it can connect between drm
> and linux framebuffer framework and you can refer to the below link.
> 
> http://lists.freedesktop.org/archives/dri-devel/2011-July/013242.html

(Just FYI, I plan to clean up the backlight framework when I'll be done with 
CDF, to remove the FBDEV dependency)

>     - linux framebuffer based driver calls fb blank operation.
> 
> fb blank(fb)---------pm runtime(fb)-----------fb_blank----------mipi and lcd
> dpms(drm kms)--------pm runtime(drm kms)------fb_blank----------mipi and lcd
> 
> 3. suspend/resume
>     - pm suspend/resume are implemented only in linux framebuffer or drm
> kms based specific drivers.
>     - MIPI-DSI/DBI and LCD Panel drivers are controlled only by fb blank
> interfaces.
> 
> s/r(fb)------------------------pm runtime(fb)--------fb blank---mipi and lcd
> s/r(drm kms)---dpms(drm kms)---pm runtime(drm kms)---fb_blank---mipi and lcd
> 
> 
> We could resolve ordering issue to suspend/resume simply duplicating
> relevant drivers but couldn't avoid duplicating codes. So I think we could
> avoid the ordering issue using fb blank interface of linux framebuffer and
> also duplicating codes.

As I mentioned before, we have multiple ordering issues related to suspend and 
resume. Panels and display controllers will likely want to enforce a S/R order 
on the video bus, and control busses will also require a specific S/R order. 
My plan is to use early suspend/late resume in the display controller driver 
to control the video busses, and let the PM core handle control bus ordering 
issues. This will of course need to be prototyped and tested.

-- 
Regards,

Laurent Pinchart

