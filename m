Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:33472 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2LSQNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 11:13:46 -0500
MIME-Version: 1.0
In-Reply-To: <50D1DF42.3070008@ti.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1608840.IleINgrx5J@avalon>
	<87pq28hb72.fsf@intel.com>
	<1671267.x0lxGrFjjV@avalon>
	<87pq26ay2z.fsf@intel.com>
	<CAF6AEGuSt0CL2sFGK-PZnw6+r9zhGHO4CEjJEWaR8eGhks2=UQ@mail.gmail.com>
	<50D1DF42.3070008@ti.com>
Date: Wed, 19 Dec 2012 10:05:27 -0600
Message-ID: <CAF6AEGt6=RhKRnJZJVytzObvxm2GuvwADNhACOR9vnY-9n=ATw@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rob Clark <rob.clark@linaro.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 19, 2012 at 9:37 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 2012-12-19 17:26, Rob Clark wrote:
>>
>> And, there are also external HDMI encoders (for example connected over
>> i2c) that can also be shared between boards.  So I think there will be
>> a number of cases where CDF is appropriate for HDMI drivers.  Although
>> trying to keep this all independent of DRM (as opposed to just
>> something similar to what drivers/gpu/i2c is today) seems a bit
>> overkill for me.  Being able to use the helpers in drm and avoiding an
>> extra layer of translation seems like the better option to me.  So my
>> vote would be drivers/gpu/cdf.
>
> Well, we need to think about that. I would like to keep CDF independent
> of DRM. I don't like tying different components/frameworks together if
> there's no real need for that.
>
> Also, something that Laurent mentioned in our face-to-face discussions:
> Some IPs/chips can be used for other purposes than with DRM.
>
> He had an example of a board, that (if I understood right) gets video
> signal from somewhere outside the board, processes the signal with some
> IPs/chips, and then outputs the signal. So there's no framebuffer, and
> the image is not stored anywhere. I think the framework used in these
> cases is always v4l2.
>
> The IPs/chips in the above model may be the exact same IPs/chips that
> are used with "normal" display. If the CDF was tied to DRM, using the
> same drivers for normal and these streaming cases would probably not be
> possible.

Well, maybe there is a way, but it really seems to be
over-complicating things unnecessarily to keep CDF independent of
DRM..  there will be a lot more traditional uses of CDF compared to
one crazy use-case.  So I don't really fancy making it more difficult
than in needs to be for everyone.

Probably the thing to do is take a step back and reconsider that one
crazy use-case.  For example, KMS doesn't enforce that the buffer
handled passed when you create a drm framebuffer object to scan out is
a GEM buffer.  So on that one crazy platform, maybe it makes sense to
have a DRM/KMS display driver that takes a handle to identify which
video stream coming from the capture end of the pipeline.  Anyways,
that is just an off-the-top-of-my-head idea, probably there are other
options too.

BR,
-R

>  Tomi
>
>
