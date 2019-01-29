Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37808C282C7
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AACE2177E
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfA2JIe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:08:34 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48599 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbfA2JId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 04:08:33 -0500
X-Originating-IP: 90.88.29.206
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 2D557C0006;
        Tue, 29 Jan 2019 09:08:30 +0000 (UTC)
Date:   Tue, 29 Jan 2019 10:08:29 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     wens@csie.org, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/6] arm64: dts: allwinner: h6: Add support for the SRAM
 C1 section
Message-ID: <20190129090829.k7omjzplkjiwvboq@flea>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
 <20190128205504.11225-6-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2tlylttralbldoot"
Content-Disposition: inline
In-Reply-To: <20190128205504.11225-6-jernej.skrabec@siol.net>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--2tlylttralbldoot
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2019 at 09:55:03PM +0100, Jernej Skrabec wrote:
> Add a node for H6 SRAM C1 section.
>=20
> Manual calls it VE SRAM, but for consistency with older SoCs, SRAM C1
> name is used.
>=20
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>

Applied, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--2tlylttralbldoot
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFAYDQAKCRDj7w1vZxhR
xe1vAP91XGwjUCzq4Xg2ocqx14PZOtQumiewdjEwbaURwrZFEAD9FbGBtYoHh40e
IB+CrsbKA2JpX1fQxvRHNt6uQsNmFww=
=uqSI
-----END PGP SIGNATURE-----

--2tlylttralbldoot--
