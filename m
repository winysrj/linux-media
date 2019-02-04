Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDA3C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76683217D6
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfBDIBS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 03:01:18 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:52879 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfBDIBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 03:01:18 -0500
X-Originating-IP: 90.88.147.226
Received: from localhost (aaubervilliers-681-1-27-226.w90-88.abo.wanadoo.fr [90.88.147.226])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 68C7F40013;
        Mon,  4 Feb 2019 08:01:13 +0000 (UTC)
Date:   Mon, 4 Feb 2019 09:01:13 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] media: sun6i: Fix CSI regmap's max_register
Message-ID: <20190204080113.77qxun2rhx6qnnzi@flea>
References: <20190203160358.21050-1-wens@csie.org>
 <20190203160358.21050-2-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ou2ebljt6hd6aqku"
Content-Disposition: inline
In-Reply-To: <20190203160358.21050-2-wens@csie.org>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ou2ebljt6hd6aqku
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2019 at 12:03:56AM +0800, Chen-Yu Tsai wrote:
> max_register is currently set to 0x1000. This is beyond the mapped
> address range of the hardware, so attempts to dump the regmap from
> debugfs would trigger a kernel exception.
>=20
> Furthermore, the useful registers only occupy a small section at the
> beginning of the full range. Change the value to 0x9c, the last known
> register on the V3s and H3.
>=20
> On the A31, the register range is extended to support additional
> capture channels. Since this is not yet supported, ignore it for now.
>=20
> Fixes: 5cc7522d8965 ("media: sun6i: Add support for Allwinner CSI V3s")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ou2ebljt6hd6aqku
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFfxNwAKCRDj7w1vZxhR
xTHSAQCkh2SviUW9URUVI4sWGCc2D1O80N9rKqkileBHg8OStgEAlQWQdQ3QI6TY
k5ICq4fv6va4eBEzdV9qTsp8C/zuigQ=
=NRUp
-----END PGP SIGNATURE-----

--ou2ebljt6hd6aqku--
