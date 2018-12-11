Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F6FC5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77C72084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B77C72084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbeLKQXs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:23:48 -0500
Received: from mail.bootlin.com ([62.4.15.54]:54530 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbeLKPnN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:43:13 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id E6BD92079D; Tue, 11 Dec 2018 16:43:10 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-89-7.w90-88.abo.wanadoo.fr [90.88.30.7])
        by mail.bootlin.com (Postfix) with ESMTPSA id BB4D52039F;
        Tue, 11 Dec 2018 16:43:10 +0100 (CET)
Date:   Tue, 11 Dec 2018 16:43:11 +0100
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
Subject: Re: [PATCH v3 2/6] media: sun6i: Add A64 compatible support
Message-ID: <20181211154311.bq4zwt44vlxa6vzb@flea>
References: <20181210115246.8188-1-jagan@amarulasolutions.com>
 <20181210115246.8188-3-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sqb6ne2soszzc2qd"
Content-Disposition: inline
In-Reply-To: <20181210115246.8188-3-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--sqb6ne2soszzc2qd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2018 at 05:22:42PM +0530, Jagan Teki wrote:
> Allwinner A64 CSI has single channel time-multiplexed BT.656
> CMOS sensor interface like H3 but work by lowering clock than
> default mod clock.
>=20
> So use separate compatibe to support it.
>=20
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> ---
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers=
/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> index ee882b66a5ea..bbe45e893722 100644
> --- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> +++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> @@ -892,6 +892,7 @@ static int sun6i_csi_remove(struct platform_device *p=
dev)
>  }
> =20
>  static const struct of_device_id sun6i_csi_of_match[] =3D {
> +	{ .compatible =3D "allwinner,sun50i-a64-csi", },

Even though it's not strictly alphabetical, we usually order the 50
after the 8.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--sqb6ne2soszzc2qd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXA/bDwAKCRDj7w1vZxhR
xcXaAP9CNqd1vg8fOx7E4Z37qqsklU3grFrR7ZqVBDhaCuRuzwD7Bj/CcLDq2nvQ
p1XEWtCMAxQiD/3qgosJuFSaUzDIyw8=
=H4Wq
-----END PGP SIGNATURE-----

--sqb6ne2soszzc2qd--
