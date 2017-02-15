Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751833AbdBOQ6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 11:58:01 -0500
Date: Wed, 15 Feb 2017 17:57:46 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170215165745.dxabuuvjspof26pg@earth>
References: <20161228183036.GA13139@amd>
 <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
 <20170208125738.GA23236@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215102301.GA29330@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uo3cm3xwix3g5ehc"
Content-Disposition: inline
In-Reply-To: <20170215102301.GA29330@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uo3cm3xwix3g5ehc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 15, 2017 at 11:23:01AM +0100, Pavel Machek wrote:
> It seems csiphy_routing_cfg_3430 is not called at all. I added
> printks, but they don't trigger. If you have an idea what is going on
> there, it would help...

You added printk to csiphy_routing_cfg_3630 instead of csiphy_routing_cfg_3=
430
and N900 has OMAP3430. Function should be called when you start (or
stop) using the camera:

csiphy_routing_cfg_3430(...)
csiphy_routing_cfg(...)
omap3isp_csiphy_config(...)
omap3isp_csiphy_acquire(...) & omap3isp_csiphy_release(...)
ccp2_s_stream(...)

-- Sebastian

> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/=
platform/omap3isp/ispcsiphy.c
> index 6b814e1..fe9303a 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -30,6 +30,8 @@ static void csiphy_routing_cfg_3630(struct isp_csiphy *=
phy,
>  	u32 reg;
>  	u32 shift, mode;
> =20
> +	printk("routing cfg 3630: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B_P=
HY1);
> +=09
>  	regmap_read(phy->isp->syscon, phy->isp->syscon_offset, &reg);
> =20
>  	switch (iface) {
> @@ -74,6 +76,9 @@ static void csiphy_routing_cfg_3430(struct isp_csiphy *=
phy, u32 iface, bool on,
>  	u32 csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ
>  		| OMAP343X_CONTROL_CSIRXFE_RESET;
> =20
> +	/* FIXME: can this be used instead of if (isp->revision) in ispccp2.c? =
*/
> +=09
> +	printk("routing cfg: iface %d, %d\n", iface, ISP_INTERFACE_CCP2B_PHY1);
>  	/* Only the CCP2B on PHY1 is configurable. */
>  	if (iface !=3D ISP_INTERFACE_CCP2B_PHY1)
>  		return;
> @@ -105,6 +110,7 @@ static void csiphy_routing_cfg(struct isp_csiphy *phy,
>  			       enum isp_interface_type iface, bool on,
>  			       bool ccp2_strobe)
>  {
> +	printk("csiphy_routing_cfg\n");
>  	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3630 && on)
>  		return csiphy_routing_cfg_3630(phy, iface, ccp2_strobe);
>  	if (phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430)

--uo3cm3xwix3g5ehc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlikiIcACgkQ2O7X88g7
+pra9w//RdTyzeSxxcsM1aAwTrzQUstxwUOt+dOHn1G+w1h7f0oGnM1E/FiCPk50
Hsc5yQYn2GOnQ/WnWyemXmTlIZn/FLEdooN86e2VVOpzXbnm7DPOlK3T55jRelTv
sZHt/eHuq4HRpN3MVs0DM9PiM3yd40v8/W+MeqtekN196h3toohDBAZoZ03YUOWd
HhkfUdaB3p4xJAkyEzs+5X1A7IfNLBgOIXqWmgwdiky9Kp6JkkyQvjhQt8amfB5G
cVkPAhJbltHpxYjuX+tccOQpRIDME0a2fj567Ba1F01zKiRvns0o0tBNY3mbyMwM
gJ/EhuDx/WsT0jhTsTH1thg2R5kAUlv1Ks2YGPTIRFrWfsSyvNTRmE+4Q1Bf6F1A
zEV+DiFZZIH0BkmwCi1Fv1qy9xgRzKfciMRAmdSLp06gf8vEylUv+SzQgZLMN+kU
L8x1m/4Od6B6IfNTb3LQWL4eyO8DLuXAwBn+islneXrugsUMAvolNBPtmp1qhO+4
p0jrY0lCJuPhXwuMtxt5f4t3Ovhs+hzG9TXwyyg9TpXwj7gV96VIp/2KImpUX/Z8
4os4RouiQIgPrYszZZWK+OzDb8prZ4znVz9UahpesXZYp7X9SGgDmZpuYsa71fKk
G6gq+WuO2ysk69PXSia8tHkTq0DoJCks02CZBbInncLnW8DPGNY=
=qu1i
-----END PGP SIGNATURE-----

--uo3cm3xwix3g5ehc--
