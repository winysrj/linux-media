Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42361 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754299AbeDWHmC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:42:02 -0400
Date: Mon, 23 Apr 2018 09:41:56 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Peter Rosin <peda@axentia.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, daniel@ffwll.ch,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] drm: bridge: thc63lvd1024: Add support for LVDS mode
 map
Message-ID: <20180423074156.GO4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-4-git-send-email-jacopo+renesas@jmondi.org>
 <86c2d4c9-8079-9f25-f24a-58c7866a8274@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NyChO5MpGs3JHJbz"
Content-Disposition: inline
In-Reply-To: <86c2d4c9-8079-9f25-f24a-58c7866a8274@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NyChO5MpGs3JHJbz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Peter,

On Sun, Apr 22, 2018 at 10:02:51PM +0200, Peter Rosin wrote:
> On 2018-04-19 11:31, Jacopo Mondi wrote:
> > The THC63LVD1024 LVDS to RGB bridge supports two different LVDS mapping
> > modes, selectable by means of an external pin.
> >
> > Add support for configurable LVDS input mapping modes, using the newly
> > introduced support for bridge input image formats.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/gpu/drm/bridge/thc63lvd1024.c | 41 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/bridge/thc63lvd1024.c b/drivers/gpu/drm/bridge/thc63lvd1024.c
> > index 48527f8..a3071a1 100644
> > --- a/drivers/gpu/drm/bridge/thc63lvd1024.c
> > +++ b/drivers/gpu/drm/bridge/thc63lvd1024.c
> > @@ -10,9 +10,15 @@
> >  #include <drm/drm_panel.h>
> >
> >  #include <linux/gpio/consumer.h>
> > +#include <linux/of.h>
> >  #include <linux/of_graph.h>
> >  #include <linux/regulator/consumer.h>
> >
> > +enum thc63_lvds_mapping_mode {
> > +	THC63_LVDS_MAP_MODE2,
> > +	THC63_LVDS_MAP_MODE1,
> > +};
> > +
> >  enum thc63_ports {
> >  	THC63_LVDS_IN0,
> >  	THC63_LVDS_IN1,
> > @@ -116,6 +122,37 @@ static int thc63_parse_dt(struct thc63_dev *thc63)
> >  	return 0;
> >  }
> >
> > +static int thc63_set_bus_fmt(struct thc63_dev *thc63)
> > +{
> > +	u32 bus_fmt;
> > +	u32 map;
> > +	int ret;
> > +
> > +	ret = of_property_read_u32(thc63->dev->of_node, "thine,map", &map);
> > +	if (ret) {
> > +		dev_err(thc63->dev,
> > +			"Unable to parse property \"thine,map\": %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	switch (map) {
> > +	case THC63_LVDS_MAP_MODE1:
> > +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
> > +		break;
> > +	case THC63_LVDS_MAP_MODE2:
> > +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;
>
> Why do you assume rgb888/1x7x4 here? It might as well be rgb666/1x7x3
> or rgb101010/1x7x5, no?

I should combine the 'map' pin input mode property with the 'bus_width' one
to find that out probably.

Thanks
   j


>
> Cheers,
> Peter
>
> > +		break;
> > +	default:
> > +		dev_err(thc63->dev,
> > +			"Invalid value for property \"thine,map\": %u\n", map);
> > +		return -EINVAL;
> > +	}
> > +
> > +	drm_bridge_set_bus_formats(&thc63->bridge, &bus_fmt, 1);
> > +
> > +	return 0;
> > +}
> > +
> >  static int thc63_gpio_init(struct thc63_dev *thc63)
> >  {
> >  	thc63->oe = devm_gpiod_get_optional(thc63->dev, "oe", GPIOD_OUT_LOW);
> > @@ -166,6 +203,10 @@ static int thc63_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		return ret;
> >
> > +	ret = thc63_set_bus_fmt(thc63);
> > +	if (ret)
> > +		return ret;
> > +
> >  	thc63->bridge.driver_private = thc63;
> >  	thc63->bridge.of_node = pdev->dev.of_node;
> >  	thc63->bridge.funcs = &thc63_bridge_func;
> >
>

--NyChO5MpGs3JHJbz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3Y5EAAoJEHI0Bo8WoVY8JwcP/02uvblFIFHBRV8hNd2CsuWM
iak+iVSqM6cjH06kELz4FtQOQLoA5jSlL5Zq3MtNlFISIbW0CVjPqus0NTuSJvGN
fk79kMv66dbEsQAI+TZQHuKAHOGihuLFLrHOlM3qefL+30P0cPIzZPkR6UKrDuFO
Tf7ZP/civlbJFGg6vOSA2+tNPhykOqo2e3Z75n/l10k17ETygyQcdmAPLuJdqSkT
H3aSUBRE/h451m0Fg5/CvFu0zaHNf3Li4q3POsmUVaHBZXt5ukrhguthqwSP00Gw
sNQ2TQvpONUeDYCu9n5Bk0PmiMdKs8OYVecxA8h+GinR8VSJ+ip5m/lfN9AbYmIm
0Tr5Dptpn1Z+yq8ugTz6XcQU+qvlVwbRy1nbmd4Xso1UdQDIxQdrz83mujhHgFAT
E8JKs2YHaBjF1qSzIflx0xr4EHMjRKN86ACC9eEJQKWEau2X99pzB3eXJaJcCXfm
lB66JbHd20bpn0ZghnlEyhAf4A0ZSQ3tQXDq8d5NNPpp2GSc0fvy9P/F1+iSlhCE
0ngxZGbwQ9pMeht/P5tpfSqvCAiKWlf0UIdGNd+03GJDyWTLEPlrxE4XlA+ZYFPA
FfqduV+PAlxkUHicB1Vmx4MxGvtPkSbmxQnr9szH5YKasZpL2TATD85B2IcrQSzX
lVUlAZ+h6Ol5Ki2hAco0
=WFaU
-----END PGP SIGNATURE-----

--NyChO5MpGs3JHJbz--
