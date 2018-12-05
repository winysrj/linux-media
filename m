Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC75C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E82B20672
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E82B20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbeLELA2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:00:28 -0500
Received: from mail.bootlin.com ([62.4.15.54]:47540 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeLELA2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 06:00:28 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id C8F4A20C18; Wed,  5 Dec 2018 12:00:26 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 2595B20CC9;
        Wed,  5 Dec 2018 12:00:09 +0100 (CET)
Date:   Wed, 5 Dec 2018 12:00:09 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 11/15] dt-bindings: media: cedrus: Add compatibles for
 the A64 and H5
Message-ID: <20181205110009.f4st7fspaxiphnmn@flea>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
 <20181205092444.29497-12-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lzx3jafuwqktgjoq"
Content-Disposition: inline
In-Reply-To: <20181205092444.29497-12-paul.kocialkowski@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--lzx3jafuwqktgjoq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2018 at 10:24:40AM +0100, Paul Kocialkowski wrote:
> This introduces two new compatibles for the cedrus driver, for the
> A64 and H5 platforms.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--lzx3jafuwqktgjoq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAevuQAKCRDj7w1vZxhR
xftIAP9U8aHjcpqk2dL0l0oLpZZiJ6ZMEbXUCrgStsWNlU9QvgEAvrnA6bduvOGH
8X8BVPhBM60c42rwTEoR3v7eqRifswQ=
=6tph
-----END PGP SIGNATURE-----

--lzx3jafuwqktgjoq--
