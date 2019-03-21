Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900A4C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 08:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BF3218D4
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 08:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfCUIUr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 04:20:47 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42511 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfCUIUr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 04:20:47 -0400
X-Originating-IP: 90.88.33.153
Received: from localhost (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 71FF660009;
        Thu, 21 Mar 2019 08:20:42 +0000 (UTC)
Date:   Thu, 21 Mar 2019 09:20:41 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 06/20] lib: Add video format information library
Message-ID: <20190321082041.aswin5sgpejnx76t@flea>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
 <a2ecd9e599e0b536c2a005e5feb140463566788e.1553032382.git-series.maxime.ripard@bootlin.com>
 <20190320143944.10454b3b@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e2jb2zt3fdhdz6iq"
Content-Disposition: inline
In-Reply-To: <20190320143944.10454b3b@collabora.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--e2jb2zt3fdhdz6iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Boris,

On Wed, Mar 20, 2019 at 02:39:44PM +0100, Boris Brezillon wrote:
> On Tue, 19 Mar 2019 22:57:11 +0100
> Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> > Move the DRM formats API to turn this into a more generic image formats API
> > to be able to leverage it into some other places of the kernel, such as
> > v4l2 drivers.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  include/linux/image-formats.h | 240 +++++++++++-
> >  lib/Kconfig                   |   7 +-
> >  lib/Makefile                  |   3 +-
> >  lib/image-formats-selftests.c | 326 +++++++++++++++-
> >  lib/image-formats.c           | 760 +++++++++++++++++++++++++++++++++++-
> >  5 files changed, 1336 insertions(+)
> >  create mode 100644 include/linux/image-formats.h
> >  create mode 100644 lib/image-formats-selftests.c
> >  create mode 100644 lib/image-formats.c
> >
>
> [...]
>
> > --- /dev/null
> > +++ b/lib/image-formats.c
> > @@ -0,0 +1,760 @@
> > +#include <linux/bug.h>
> > +#include <linux/image-formats.h>
> > +#include <linux/kernel.h>
> > +#include <linux/math64.h>
> > +
> > +#include <uapi/drm/drm_fourcc.h>
> > +
> > +static const struct image_format_info formats[] = {
> > +	{
>
> ...
>
> > +	},
> > +};
> > +
> > +#define __image_format_lookup(_field, _fmt)			\
> > +	({							\
> > +		const struct image_format_info *format = NULL;	\
> > +		unsigned i;					\
> > +								\
> > +		for (i = 0; i < ARRAY_SIZE(formats); i++)	\
> > +			if (formats[i]._field == _fmt)		\
> > +				format = &formats[i];		\
> > +								\
> > +		format;						\
> > +	})
> > +
> > +/**
> > + * __image_format_drm_lookup - query information for a given format
> > + * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
> > + *
> > + * The caller should only pass a supported pixel format to this function.
> > + *
> > + * Returns:
> > + * The instance of struct image_format_info that describes the pixel format, or
> > + * NULL if the format is unsupported.
> > + */
> > +const struct image_format_info *__image_format_drm_lookup(u32 drm)
> > +{
> > +	return __image_format_lookup(drm_fmt, drm);
> > +}
> > +EXPORT_SYMBOL(__image_format_drm_lookup);
> > +
> > +/**
> > + * image_format_drm_lookup - query information for a given format
> > + * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
> > + *
> > + * The caller should only pass a supported pixel format to this function.
> > + * Unsupported pixel formats will generate a warning in the kernel log.
> > + *
> > + * Returns:
> > + * The instance of struct image_format_info that describes the pixel format, or
> > + * NULL if the format is unsupported.
> > + */
> > +const struct image_format_info *image_format_drm_lookup(u32 drm)
> > +{
> > +	const struct image_format_info *format;
> > +
> > +	format = __image_format_drm_lookup(drm);
> > +
> > +	WARN_ON(!format);
> > +	return format;
> > +}
> > +EXPORT_SYMBOL(image_format_drm_lookup);
>
> I think this function and the DRM formats table should be moved in
> drivers/gpu/drm/drm_image_format.c since they are DRM specific. The
> remaining functions can IMHO be placed in include/linux/image-formats.h
> as static inline funcs. This way you can get rid of lib/image-formats.c
> and the associated Kconfig entry.

I'm not quite sure what you mean. The whole point of the series is to
split out that table out of DRM so that we can use it in other places,
so surely putting it back into DRM defeats the purpose?

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--e2jb2zt3fdhdz6iq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXJNJWQAKCRDj7w1vZxhR
xTILAQDHHRBU77XsVzzXciL/8qvCrPNaAQuh6xVBpCgHVWb1+gD/SbS0s6OYIshv
X8tkZEQEoreInmyKBXKuaUjwfXXgQgE=
=zZ6Q
-----END PGP SIGNATURE-----

--e2jb2zt3fdhdz6iq--
