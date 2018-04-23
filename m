Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48845 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbeDWHfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:35:12 -0400
Date: Mon, 23 Apr 2018 09:35:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Peter Rosin <peda@axentia.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, daniel@ffwll.ch,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] dt-bindings: display: bridge: thc63lvd1024: Add lvds
 map property
Message-ID: <20180423073504.GN4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
 <17d6f6b0-e657-4a5f-63a6-572cdf062bd3@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="D6IIOQQv2Iwyp54J"
Content-Disposition: inline
In-Reply-To: <17d6f6b0-e657-4a5f-63a6-572cdf062bd3@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--D6IIOQQv2Iwyp54J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Peter,
   thanks for commenting,

On Sun, Apr 22, 2018 at 10:02:41PM +0200, Peter Rosin wrote:
> On 2018-04-19 11:31, Jacopo Mondi wrote:
> > The THC63LVD1024 LVDS to RGB bridge supports two different input mapping
> > modes, selectable by means of an external pin.
> >
> > Describe the LVDS mode map through a newly defined mandatory property in
> > device tree bindings.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  .../devicetree/bindings/display/bridge/thine,thc63lvd1024.txt          | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> > index 37f0c04..0937595 100644
> > --- a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> > +++ b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> > @@ -12,6 +12,8 @@ Required properties:
> >  - compatible: Shall be "thine,thc63lvd1024"
> >  - vcc-supply: Power supply for TTL output, TTL CLOCKOUT signal, LVDS input,
> >    PPL and digital circuitry
> > +- thine,map: LVDS mapping mode selection signal, pin name "MAP". Shall be <1>
> > +  for mapping mode 1, <0> for mapping mode 2
>
> Since the MAP pin is an input pin, I would expect there to be an optional gpio
> specifier like thine,map-gpios so that the driver can set it according to
> the value given in thine,map in case the HW has a line from some gpio output
> to the MAP pin (instead of hardwired hi/low which seem to be your thinking).

I see... As the only use case I had has the pin tied to vcc, I
thought about making it a binary property, and I wonder in how many
cases the chip 'MAP' pin would actually be GPIO controlled input and
not an hardwired one instead. I don't see the LVDS mapping mode to be
changed at runtime, but you are right, who knows....

Do you think we can add an options 'thine,map-gpios' property along
to the proposed ones?

thanks
   j

>
> Cheers,
> Peter
>
> >
> >  Optional properties:
> >  - powerdown-gpios: Power down GPIO signal, pin name "/PDWN". Active low
> > @@ -36,6 +38,7 @@ Example:
> >
> >  		vcc-supply = <&reg_lvds_vcc>;
> >  		powerdown-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
> > +		thine,map = <1>;
> >
> >  		ports {
> >  			#address-cells = <1>;
> >
>

--D6IIOQQv2Iwyp54J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3YynAAoJEHI0Bo8WoVY8dl8P/i0yToIkzEvqWHs1+lqzgB8r
9L5j9C4G+MvNIybk/J/edo0UIIXttc/GAtr5ESNw3zl8qj3fPwkZ4LHnDaVnow8U
qbdrgBKV9d4OeOOttz7JoufVGg1CkdIry2oFQsqAgSOWUAda78XRxzXx0n2FGOJe
tIja6IJkDSXuPrKc7p4GldZd/5ZUwY/0b/MVAbqq56XEwveX2deeW1lmt1lWEcmw
TFH1jfigtjrnQBqh1WLalUDbmVnDk90ooGg10ooRb5SuLNdhBpDCMl5Kv43Wuuq3
AAC/5gaTkXaLbeLxHkEa2PG113/sEXurAEOi1EiWHLvwA1fNYdV9Wr28/BF/kKI4
Z9FiCfuW/lqdSFAxmtDrfHJYZhbEdAZmP4VFnSjOMd3pYiPffyW4Rl+f+cHykRu4
DqTtvAELMAfbEv1GFsty/j+bfYV4PBssfCkYeMY1W8b/2xUBbhabyg3tuCNh8Q65
ffHXiGB1qHtQL90F457beTu+ABix2lnSV46MiYQzyXbQYoO67hWWWC3nZFAHnueA
2fyp8tGTluy5G61cp9Y3IcPp+Q0cxqyef8Pzk8KIj4yJSD7lxg/xzLNz4MAzuybG
BbPmo0uUkZ16t0+t3AhCjsW/W/xyAfhXBwrRHzAXNgXqmqBfGFKtBZTUw/l8ckGZ
PSlPzfBpb3uT7QZZk9vG
=4Kpk
-----END PGP SIGNATURE-----

--D6IIOQQv2Iwyp54J--
