Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53440 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXRjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 12:39:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hans.verkuil@cisco.com
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 24 Dec 2012 18:40:30 +0100
Message-ID: <1488203.DaUueByIJ6@avalon>
In-Reply-To: <CAF6AEGt6=RhKRnJZJVytzObvxm2GuvwADNhACOR9vnY-9n=ATw@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <50D1DF42.3070008@ti.com> <CAF6AEGt6=RhKRnJZJVytzObvxm2GuvwADNhACOR9vnY-9n=ATw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

(CC'ing Hans Verkuil)

On Wednesday 19 December 2012 10:05:27 Rob Clark wrote:
> On Wed, Dec 19, 2012 at 9:37 AM, Tomi Valkeinen wrote:
> > On 2012-12-19 17:26, Rob Clark wrote:
> >> And, there are also external HDMI encoders (for example connected over
> >> i2c) that can also be shared between boards.  So I think there will be
> >> a number of cases where CDF is appropriate for HDMI drivers.  Although
> >> trying to keep this all independent of DRM (as opposed to just something
> >> similar to what drivers/gpu/i2c is today) seems a bit overkill for me. 
> >> Being able to use the helpers in drm and avoiding an extra layer of
> >> translation seems like the better option to me.  So my vote would be
> >> drivers/gpu/cdf.
> > 
> > Well, we need to think about that. I would like to keep CDF independent
> > of DRM. I don't like tying different components/frameworks together if
> > there's no real need for that.
> > 
> > Also, something that Laurent mentioned in our face-to-face discussions:
> > Some IPs/chips can be used for other purposes than with DRM.
> > 
> > He had an example of a board, that (if I understood right) gets video
> > signal from somewhere outside the board, processes the signal with some
> > IPs/chips, and then outputs the signal. So there's no framebuffer, and
> > the image is not stored anywhere. I think the framework used in these
> > cases is always v4l2.
> > 
> > The IPs/chips in the above model may be the exact same IPs/chips that
> > are used with "normal" display. If the CDF was tied to DRM, using the
> > same drivers for normal and these streaming cases would probably not be
> > possible.
> 
> Well, maybe there is a way, but it really seems to be over-complicating
> things unnecessarily to keep CDF independent of DRM..  there will be a lot
> more traditional uses of CDF compared to one crazy use-case.  So I don't
> really fancy making it more difficult than in needs to be for everyone.

Most of the use cases will be in DRM, we agree on that. However, I don't think 
that the use case mentioned by Tomi is in any way crazy. TI has DaVinci chips 
that can process/capture/generate up to 18 (if my memory is correct) video 
streams, and those are extensively used in video conferencing solutions or set 
top boxes for instance. A couple of the output video streams are display-based 
and should be handled by DRM/KMS, but most of them are V4L2 streams. That's 
something we should discuss with Hans Verkuil, he might be able to provide us 
with more information.

> Probably the thing to do is take a step back and reconsider that one crazy
> use-case.  For example, KMS doesn't enforce that the buffer handled passed
> when you create a drm framebuffer object to scan out is a GEM buffer.  So on
> that one crazy platform, maybe it makes sense to have a DRM/KMS display
> driver that takes a handle to identify which video stream coming from the
> capture end of the pipeline.  Anyways, that is just an off-the-top-of-my-
> head idea, probably there are other options too.

-- 
Regards,

Laurent Pinchart

