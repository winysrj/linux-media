Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42426 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3BFQOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 11:14:43 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so2157097ieb.31
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 08:14:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51127008.7050808@ti.com>
References: <1990856.qS9uisuiVF@avalon>
	<51123A5F.9050604@ti.com>
	<CADnq5_P1GFbAwoe9kTeARq8ZLP1tOBc9Rn1h2KrRYxkoLxLXfw@mail.gmail.com>
	<51127008.7050808@ti.com>
Date: Wed, 6 Feb 2013 17:14:42 +0100
Message-ID: <CAKMK7uFABFoNLbY0wqN2YxOMCCtMpeHZ=vPoS738F7eNOW7Pqg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] CDF meeting @FOSDEM report
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Thierry Reding <thierry.reding@avionic-desi.gn.de>,
	Mark Zhang <markz@nvidia.com>, dri-devel@lists.freedesktop.org,
	Sunil Joshi <joshi@samsung.com>,
	linaro-mm-sig@lists.linaro.org,
	=?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 4:00 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>> not always a perfect match to the hardware.  For example a lot of GPUs
>> have a DVO encoder which feeds a secondary encoder like an sil164 DVO
>> to TMDS encoder.
>
> Right. I think mapping the DRM entities to CDF ones is one of the bigger
> question marks we have with CDF. While I'm no expert on DRM, I think we
> have the following options:
>
> 1. Force DRM's model to CDF, meaning one encoder.
>
> 2. Extend DRM to support multiple encoders in a chain.
>
> 3. Support multiple encoders in a chain in CDF, but somehow map them to
> a single encoder in DRM side.

4. Ignore drm kms encoders.

They are only exposed to userspace as a means for userspace to
discover very simple constraints, e.g. 1 encoder connected to 2
outputs means you can only use one of the outputs at the same time.
They are completely irrelevant for the actual modeset interface
exposed to drivers, so you could create a fake kms encoder for each
connector you expose through kms.

The crtc helpers use the encoders as a real entity, and if you opt to
use the crtc helpers to implement the modeset sequence in your driver
it makes sense to map them to some real piece of hw. But you can
essentially pick any transcoder in your crtc -> final output chain for
this. Generic userspace needs to be able to cope with a failed modeset
due to arbitrary reasons anyway, so can't presume that simply because
the currently exposed constraints are fulfilled it'll work.

> I really dislike the first option, as it would severely limit where CDF
> can be used, or would force you to write some kind of combined drivers,
> so that you can have one encoder driver running multiple encoder devices.

Imo CDF and drm encoders don't really have that much to do with each
another, it should just be a driver implementation detail. Of course,
if common patterns emerge we could extract them somehow. E.g. if many
drivers end up exposing the CDF transcoder chain as a drm encoder
using the crtc helpers, we could add some library functions to make
that simpler.

Another conclusion (at least from my pov) from the fosdem discussion
is that we should separate the panel interface from the actual
control/pixel data buses. That should give us more flexibility for
insane hw and also directly exposing properties and knobs to the
userspace interface from e.g. dsi transcoders. So I don't think we'll
end up with _the_ canonical CDF sink interface anyway.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
