Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE17C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B41D1217D6
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfBDIFO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 03:05:14 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:34994 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfBDIFN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 03:05:13 -0500
Received: from relay11.mail.gandi.net (unknown [217.70.178.231])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id A3A783A2DDA
        for <linux-media@vger.kernel.org>; Mon,  4 Feb 2019 09:02:01 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-27-226.w90-88.abo.wanadoo.fr [90.88.147.226])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id A7B7410000C;
        Mon,  4 Feb 2019 08:01:56 +0000 (UTC)
Date:   Mon, 4 Feb 2019 09:01:55 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] media: sun6i: Add support for RGB565 formats
Message-ID: <20190204080155.biexifi5n6j7pqgv@flea>
References: <20190203160358.21050-1-wens@csie.org>
 <20190203160358.21050-3-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eup3rtre4wld6kk3"
Content-Disposition: inline
In-Reply-To: <20190203160358.21050-3-wens@csie.org>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--eup3rtre4wld6kk3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2019 at 12:03:57AM +0800, Chen-Yu Tsai wrote:
> The CSI controller can take raw data from the data bus and output RGB565
> format. The controller does not distinguish between RGB565 LE and BE.
> Instead this is determined by the media bus format, i.e. the format or
> order the sensor is sending data in.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--eup3rtre4wld6kk3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFfxcwAKCRDj7w1vZxhR
xR1NAP9+zje4qgdL2tlnTj7AoGJbpJmE1Thox430idh7XItChAEA0p+d0eZV76WU
P29fyx2zClEpuvkpnmvwFKBP0yoTNAU=
=0wIP
-----END PGP SIGNATURE-----

--eup3rtre4wld6kk3--
