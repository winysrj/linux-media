Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50047 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeDZSoo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 14:44:44 -0400
Date: Thu, 26 Apr 2018 20:44:37 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Peter Rosin <peda@axentia.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, daniel@ffwll.ch,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] drm: bridge: Add support for static image formats
Message-ID: <20180426184437.GR4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-2-git-send-email-jacopo+renesas@jmondi.org>
 <10891e93-ede5-8c39-b53e-da892e163b52@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EEx6GiKZGZ1wKUra"
Content-Disposition: inline
In-Reply-To: <10891e93-ede5-8c39-b53e-da892e163b52@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EEx6GiKZGZ1wKUra
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Peter,

On Sun, Apr 22, 2018 at 10:02:23PM +0200, Peter Rosin wrote:
> On 2018-04-19 11:31, Jacopo Mondi wrote:
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
> > + * @num_formats: number of elements in the @formats array
> > + *
> > + * Store a list of supported image formats in a bridge.
> > + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
> > + * a full list of available formats.
> > + */
> > +int drm_bridge_set_bus_formats(struct drm_bridge *bridge, const u32 *formats,
> > +			       unsigned int num_formats)
> > +{
> > +	u32 *fmts;
> > +
> > +	if (!formats || !num_formats)
> > +		return -EINVAL;
>
> I see no compelling reason to forbid restoring the number of reported
> input formats to zero? I can't think of a use right now of course, but it
> seems a bit odd all the same.

It is, you're right. Will fix in v2 and will allow bridges to just
restore formats to 0 (as it is done for drm_connectors, by the way)

Thanks
   j
>
> Cheers,
> Peter
>
> > +
> > +	fmts = kmemdup(formats, sizeof(*formats) * num_formats, GFP_KERNEL);
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
> > + * @bus_formats: wire image formats. Array of @num_bus_formats MEDIA_BUS_FMT\_
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
> >
>

--EEx6GiKZGZ1wKUra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa4h4VAAoJEHI0Bo8WoVY8thgQAJkEA6XyBCY6uuUOGtVB/rxH
fLBQASfGMmI3oxYbJ2u0XnmJsN3BycHo9Wkh2d4lgvoRNp5DO2xliOzZMs+A0YLO
ZrEsCwsDf0c4pJ6m3DRlX0wA2xoVbpihE6SV4bUglZreUem4AsZHCi/FZWbX/iO+
qtmNvS90u5QBs0l0p+1GMAzJLLpr5+0Ema0D2uioQxYCjc+aHzE3+upbXwYBV0pC
7KED32km0chJRNP4sUTgBA2hZy5XsWE3LxCwoioVHaimx0F99sSF20wWdkvLtpHW
CDT0jzf6bJg8EQAIiS7iO4WDvEPKlGErmbO4MhcDNLrXagIpAj+Ke3qAI+xyzxBo
udWtgN5lzKqB0WM5lWEAFRWfnfUEqVanpYlM+pYgdfKyt74r++QoTiQH5GcaTkRp
97nenLb/IneP2sXEsS1zh68f71ObqoTsA6G1gw2bpwbUtQekAauxgLrJh3JxGzg5
11BSsu3FSadRsiYBKxZh7Ss8HYmgRavC2s1gOGHd4tHIiHjIwgx8/vfywedxCuSi
LVdCrXNKlwd5n7DIZkEr92r9FfbwORPkize1I13rZ72cJvzPOevg3H0ozSOoeg3G
Sglus58UPQIe6O8uvw1LXIXZKH/kBS5skopKxrjyFH2qJN22fMNmKjydouAMg0zz
r5vn8ltg8XMBpKgnyqq6
=mQ24
-----END PGP SIGNATURE-----

--EEx6GiKZGZ1wKUra--
