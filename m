Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45197 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2LRIhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 03:37:13 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so124247bkc.38
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2012 00:37:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<CAPM=9txFJzJ0haTyBnr8hEmmqNb+gSAyBno+Zs0Z-qvVMTwz9A@mail.gmail.com>
	<CAF6AEGsLdLasS4=j1PsX_P8miG8NcTXMUP9VYj+4gdU8Qhm2YQ@mail.gmail.com>
Date: Tue, 18 Dec 2012 09:30:00 +0100
Message-ID: <CAKMK7uF3Ahh8isvzZr4605X3wz-TQ2EHreTUnc5K_Z0DwrY6xw@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <rob.clark@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 18, 2012 at 7:21 AM, Rob Clark <rob.clark@linaro.org> wrote:
>> The other thing I'd like you guys to do is kill the idea of fbdev and
>> v4l drivers that are "shared" with the drm codebase, really just
>> implement fbdev and v4l on top of the drm layer, some people might
>> think this is some sort of maintainer thing, but really nothing else
>> makes sense, and having these shared display frameworks just to avoid
>> having using drm/kms drivers seems totally pointless. Fix the drm
>> fbdev emulation if an fbdev interface is needed. But creating a fourth
>> framework because our previous 3 frameworks didn't work out doesn't
>> seem like a situation I want to get behind too much.
>
> yeah, let's not have multiple frameworks to do the same thing.. For
> fbdev, it is pretty clear that it is a dead end.  For v4l2
> (subdev+mcf), it is perhaps bit more flexible when it comes to random
> arbitrary hw pipelines than kms.  But to take advantage of that, your
> userspace isn't going to be portable anyways, so you might as well use
> driver specific properties/ioctls.  But I tend to think that is more
> useful for cameras.  And from userspace perspective, kms planes are
> less painful to use for output than v4l2, so lets stick to drm/kms for
> output (and not try to add camera/capture support to kms).. k, thx

Yeah, I guess having a v4l device also exported by the same driver
that exports the drm interface might make sense in some cases. But in
many cases I think the video part is just an independent IP block and
shuffling data around with dma-buf is all we really need. So yeah, I
guess sharing display resources between v4l and drm kms driver should
be a last resort option, since coordination (especially if it's
supposed to be somewhat dynamic) will be extremely hairy.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
