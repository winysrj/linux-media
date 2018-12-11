Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0BAC5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CB0C2084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:21:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CB0C2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbeLKPoa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:44:30 -0500
Received: from mail.bootlin.com ([62.4.15.54]:54669 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbeLKPo3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:44:29 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4A6EE20726; Tue, 11 Dec 2018 16:44:27 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-89-7.w90-88.abo.wanadoo.fr [90.88.30.7])
        by mail.bootlin.com (Postfix) with ESMTPSA id D2AFE2039F;
        Tue, 11 Dec 2018 16:44:26 +0100 (CET)
Date:   Tue, 11 Dec 2018 16:44:27 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>
Subject: Re: [PATCH v3 3/6] media: sun6i: Set 300MHz mod clock for A64
Message-ID: <20181211154427.uekytnmp2wlgxwm2@flea>
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
 <20181210115246.8188-4-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="faq7xos5ziv2e6ih"
Content-Disposition: inline
In-Reply-To: <20181210115246.8188-4-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--faq7xos5ziv2e6ih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2018 at 05:22:43PM +0530, Jagan Teki wrote:
> The default CSI_SCLK seems unable to drive the sensor to capture
> the image, so update it to working clock rate 300MHz for A64.
>=20
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> ---
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers=
/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> index bbe45e893722..4b872800b244 100644
> --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -822,6 +822,11 @@ static int sun6i_csi_resource_request(struct sun6i_c=
si_dev *sdev,
>  		return PTR_ERR(sdev->clk_mod);
>  	}
> =20
> +	/* A64 need 300MHz mod clock to operate properly */
> +	if (of_device_is_compatible(pdev->dev.of_node,
> +				    "allwinner,sun50i-a64-csi"))
> +		clk_set_rate_exclusive(sdev->clk_mod, 300000000);
> +

Where is that 300MHz coming from? You claim in your comment that it
"operates properly", yet in your previous mail about this, you were
saying that 1080p @30Hz is broken. Which one is it?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--faq7xos5ziv2e6ih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXA/bWwAKCRDj7w1vZxhR
xdDMAP94RaXCEgkDKmVxakpYTM+VI1y0/E/u//LXpAldXToWTAEA7RxTw+Ks7v57
n5wjkBLnnQ0f0JWPzzSZZmA5AlLAUwY=
=eSxP
-----END PGP SIGNATURE-----

--faq7xos5ziv2e6ih--
