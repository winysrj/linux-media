Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489CAC282CF
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E9020882
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfA1LCY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:02:24 -0500
Received: from mail.bootlin.com ([62.4.15.54]:50292 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfA1LCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 06:02:24 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id DB27C209A7; Mon, 28 Jan 2019 12:02:20 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 9FDF220714;
        Mon, 28 Jan 2019 12:02:10 +0100 (CET)
Date:   Mon, 28 Jan 2019 12:02:11 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v8 2/5] media: sun6i: Add A64 CSI block support
Message-ID: <20190128110211.fmbnudcfrw2rnqya@flea>
References: <20190128085847.7217-1-jagan@amarulasolutions.com>
 <20190128085847.7217-3-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6okpvrlphzl3mugw"
Content-Disposition: inline
In-Reply-To: <20190128085847.7217-3-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--6okpvrlphzl3mugw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2019 at 02:28:44PM +0530, Jagan Teki wrote:
> CSI block in Allwinner A64 has similar features as like in H3,
> but the default CSI_SCLK rate cannot work properly to drive the
> connected sensor interface.
>=20
> The tested mod cock rate is 300 MHz and BSP vfe media driver is also
> using the same rate. Unfortunately there is no valid information about
> clock rate in manual or any other sources except the BSP driver. so more
> faith on BSP code, because same has tested in mainline.
>=20
> So, add support for A64 CSI block by setting updated mod clock rate.
>=20
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--6okpvrlphzl3mugw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXE7hMwAKCRDj7w1vZxhR
xUDUAQC8hj7QHPP/IFtTJaDkazmu6MXL/AJadiU0/vZ0ovo+EAD+ORm8Mrwb5wwY
IzkWk1Mjzvs6xuUjXHBKCUXENlDxGgs=
=IZEo
-----END PGP SIGNATURE-----

--6okpvrlphzl3mugw--
