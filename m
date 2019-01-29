Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED082C282C7
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72982084A
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfA2JIP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:08:15 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:36055 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfA2JIP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 04:08:15 -0500
X-Originating-IP: 90.88.29.206
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id C83C140016;
        Tue, 29 Jan 2019 09:08:11 +0000 (UTC)
Date:   Tue, 29 Jan 2019 10:08:11 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     wens@csie.org, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/6] dt-bindings: sram: sunxi: Add compatible for the H6
 SRAM C1
Message-ID: <20190129090811.3e632at6m5aaydyu@flea>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
 <20190128205504.11225-5-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3wc4hstkps7hlfrd"
Content-Disposition: inline
In-Reply-To: <20190128205504.11225-5-jernej.skrabec@siol.net>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3wc4hstkps7hlfrd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2019 at 09:55:02PM +0100, Jernej Skrabec wrote:
> This introduces a new compatible for the H6 SRAM C1 section, that is
> compatible with the SRAM C1 section as found on the A10.
>=20
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>

Applied, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--3wc4hstkps7hlfrd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFAX+wAKCRDj7w1vZxhR
xY+pAQDkkqWhhDktjNFyJztfMG4HcYb+Eptr9kO2x15VhxOxggD8DJA18X3e1fFV
9uUeI6cGBV2ZEKZ+jtOvCCVWa0h/JwA=
=LnNd
-----END PGP SIGNATURE-----

--3wc4hstkps7hlfrd--
