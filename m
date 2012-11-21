Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60941 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KUNHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 08:07:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 4/6] fbmon: add of_videomode helpers
Date: Wed, 21 Nov 2012 14:08:38 +0100
Message-ID: <10179127.YBNtqAP453@avalon>
In-Reply-To: <50ACCDDA.2070606@ti.com>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de> <50ACCDDA.2070606@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1659085.vgPrB2GWIs"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1659085.vgPrB2GWIs
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Wednesday 21 November 2012 14:49:30 Tomi Valkeinen wrote:
> On 2012-11-20 17:54, Steffen Trumtrar wrote:
> > Add helper to get fb_videomode from devicetree.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/video/fbmon.c |   42 +++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/fb.h    |    7 +++++++
> >  2 files changed, 48 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/fb.h b/include/linux/fb.h
> > index 920cbe3..41b5e49 100644
> > --- a/include/linux/fb.h
> > +++ b/include/linux/fb.h
> > @@ -15,6 +15,8 @@
> > 
> >  #include <linux/slab.h>
> >  #include <asm/io.h>
> >  #include <linux/videomode.h>
> > 
> > +#include <linux/of.h>
> > +#include <linux/of_videomode.h>
> 
> Guess what? =)
> 
> To be honest, I don't know what the general opinion is about including
> header files from header files. But I always leave them out if they are
> not strictly needed.

I agree, I favor structure declaration as well when possible.

> >  struct vm_area_struct;
> >  struct fb_info;
> > 
> > @@ -715,6 +717,11 @@ extern void fb_destroy_modedb(struct fb_videomode
> > *modedb);> 
> >  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int
> >  rb); extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> > 
> > +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> > +extern int of_get_fb_videomode(const struct device_node *np,
> > +			       struct fb_videomode *fb,
> > +			       unsigned int index);
> > +#endif
> > 
> >  #if IS_ENABLED(CONFIG_VIDEOMODE)
> >  extern int fb_videomode_from_videomode(const struct videomode *vm,
> >  
> >  				       struct fb_videomode *fbmode);
> 
> Do you really need these #ifs in the header files? They do make it look
> a bit messy. If somebody uses the functions and CONFIG_VIDEOMODE is not
> enabled, he'll get a linker error anyway.

-- 
Regards,

Laurent Pinchart

--nextPart1659085.vgPrB2GWIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQrNJgAAoJEIkPb2GL7hl1+n0IAIwcErVb/UkPyQ/59qqZNlkn
A5E/H2P2Jusk7RLIRbTDCq25Uc2Tdu4SdkOhFKGwxMD/4hb0IObvXWLuLnfDXigr
Tt8Il7HWHKWdULdl4LXJxTx9moosnewa3leAJiJpb64pefR7BiJOAIKgZNuTBt28
ETw31xySKhYvj4CESJ92rAASe382WQQ4JsjnOWvgcIrIE8zz5zl7E3zLprqhFn48
Zm9QgD9Yar/BzpuRh0dYKzPrHN+a5f24yzPuxJStpY9Ew9zcWdTAO9UWgFIiL+gQ
iOJTnJh3eXUjkx38YzWP7l1Dre4Csp+KUyX/YAMSNigy/ZUlzXUGbKB6GlBYins=
=Q873
-----END PGP SIGNATURE-----

--nextPart1659085.vgPrB2GWIs--

