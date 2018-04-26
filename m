Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33063 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeDZSlI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 14:41:08 -0400
Date: Thu, 26 Apr 2018 20:40:56 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, airlied@linux.ie, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] drm: bridge: Add support for static image formats
Message-ID: <20180426184056.GQ4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-2-git-send-email-jacopo+renesas@jmondi.org>
 <3108314.q4SV6s3NXE@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XjbSsFHOHxvQpKib"
Content-Disposition: inline
In-Reply-To: <3108314.q4SV6s3NXE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XjbSsFHOHxvQpKib
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,

On Mon, Apr 23, 2018 at 12:27:39PM +0300, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Thursday, 19 April 2018 12:31:02 EEST Jacopo Mondi wrote:
> > Add support for storing image format information in DRM bridges with
> > associated helper function.
> >
> > This patch replicates for bridges what 'drm_display_info_set_bus_formats()'
> > is for connectors.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/gpu/drm/drm_bridge.c | 30 ++++++++++++++++++++++++++++++
> >  include/drm/drm_bridge.h     |  8 ++++++++
> >  2 files changed, 38 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
> > index 1638bfe..e2ad098 100644
> > --- a/drivers/gpu/drm/drm_bridge.c
> > +++ b/drivers/gpu/drm/drm_bridge.c
> > @@ -157,6 +157,36 @@ void drm_bridge_detach(struct drm_bridge *bridge)
> >  }
> >
> >  /**
> > + * drm_bridge_set_bus_formats() - set bridge supported image formats
> > + * @bridge: the bridge to set image formats in
> > + * @formats: array of MEDIA_BUS_FMT\_ supported image formats
>
> Why the \ (here and below) ?

mmm, I can't tell where I made that up from... Will change with
MEDIA_BUS_FMT_*

>
> > + * @num_formats: number of elements in the @formats array
> > + *
> > + * Store a list of supported image formats in a bridge.
> > + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h
> > for
> > + * a full list of available formats.
> > + */
> > +int drm_bridge_set_bus_formats(struct drm_bridge *bridge, const u32
> > *formats,
> > +			       unsigned int num_formats)
> > +{
> > +	u32 *fmts;
> > +
> > +	if (!formats || !num_formats)
> > +		return -EINVAL;
> > +
> > +	fmts = kmemdup(formats, sizeof(*formats) * num_formats, GFP_KERNEL);
>
> This memory will be leaked when the bridge is destroyed.

Right. I'm afraid this may open a pandora box, but, ehm, where is the
bridge objects lifetime managed? The best I can think of is to use the
resource managed version of kmemdup, associating that memory to
the drm_device device object. That means the memory will be freed at
DRM pipeline teardown time only if I'm not wrong. Can a bridge be
destroyed before that?

Thanks
   j

>
> > +	if (!fmts)
> > +		return -ENOMEM;
> > +
> > +	kfree(bridge->bus_formats);
> > +	bridge->bus_formats = fmts;
> > +	bridge->num_bus_formats = num_formats;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(drm_bridge_set_bus_formats);
> > +
> > +/**
> >   * DOC: bridge callbacks
> >   *
> >   * The &drm_bridge_funcs ops are populated by the bridge driver. The DRM
> > diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
> > index 3270fec..6b3648c 100644
> > --- a/include/drm/drm_bridge.h
> > +++ b/include/drm/drm_bridge.h
> > @@ -258,6 +258,9 @@ struct drm_bridge_timings {
> >   * @encoder: encoder to which this bridge is connected
> >   * @next: the next bridge in the encoder chain
> >   * @of_node: device node pointer to the bridge
> > + * @bus_formats: wire image formats. Array of @num_bus_formats
> > MEDIA_BUS_FMT\_
> > + * elements
> > + * @num_bus_formats: size of @bus_formats array
> >   * @list: to keep track of all added bridges
> >   * @timings: the timing specification for the bridge, if any (may
> >   * be NULL)
> > @@ -271,6 +274,9 @@ struct drm_bridge {
> >  #ifdef CONFIG_OF
> >  	struct device_node *of_node;
> >  #endif
> > +	const u32 *bus_formats;
> > +	unsigned int num_bus_formats;
> > +
> >  	struct list_head list;
> >  	const struct drm_bridge_timings *timings;
> >
> > @@ -296,6 +302,8 @@ void drm_bridge_mode_set(struct drm_bridge *bridge,
> >  			struct drm_display_mode *adjusted_mode);
> >  void drm_bridge_pre_enable(struct drm_bridge *bridge);
> >  void drm_bridge_enable(struct drm_bridge *bridge);
> > +int drm_bridge_set_bus_formats(struct drm_bridge *bridge, const u32 *fmts,
> > +			       unsigned int num_fmts);
> >
> >  #ifdef CONFIG_DRM_PANEL_BRIDGE
> >  struct drm_bridge *drm_panel_bridge_add(struct drm_panel *panel,
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

--XjbSsFHOHxvQpKib
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa4h03AAoJEHI0Bo8WoVY8q+wP/0ttfJ3DbbFi82FZvilz9zPE
4fzTqr/SQyP7SixvfX8/P/f5bK2VB62pmUbDnUIO9PChMWYcaz0PYnVXKgnCpcpW
TYPk5CKtnXLSbCC3B7Jl1/39Qy2I6ACgXuhDMtYe3z099mGDVImuSEB3ibMYrwCR
GkcnC9Eqk9E9hPDsJTL3C4pzDlUxCLR+KXt21SnMlgy1jTuntjD56AeXl6FRDMnT
+mmWw8Cd9DXoSmDoVrxIACTzGlQypeDY+3YhTJXY0PlJ0LoG01YZDpjShq0qzFlU
jcTbVItr5Sxe5SNIMEKyf6qVhd8d0oyax8HA4mp8YE63TCrqQY0EBbdvlacmCyMt
IAS65gwn50NsgDoCU2cMRQ14TyYsi4zL7XVd1c/dznOYM05QrS5mb/AJhjTbGC90
F1yxvZe3umv85HUGmTXN/OG4XIsyENtGY9cV6UT6eRXykdNx+cVWQb6qOdDV6n4p
rDYKNq2S9df8NowfTsOFKB4BIQ243HvB8CklqxZhNHJX4rWuT1DEVDAZtCSkYhw7
p6KCm7ohjphurt2ni15xdDTNnCdn9Ae86GI4u6Z4Og8cYlXgi/fCmfgGpb567Jia
mWkwqV1c9CQSnQFl5g0T71kR9hiqBlZ5myhi7EUsY8BTjFew+PsrjUyPyzgEVbla
GrTNopn4sckxVWJ1GAng
=F88E
-----END PGP SIGNATURE-----

--XjbSsFHOHxvQpKib--
