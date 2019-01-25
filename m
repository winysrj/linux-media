Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B92C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F96A218DE
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfAYPlU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:41:20 -0500
Received: from mail.bootlin.com ([62.4.15.54]:53907 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfAYPlU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:41:20 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4D63520742; Fri, 25 Jan 2019 16:41:18 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 1B71820397;
        Fri, 25 Jan 2019 16:41:08 +0100 (CET)
Date:   Fri, 25 Jan 2019 16:41:08 +0100
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
Subject: Re: [PATCH v7 1/5] dt-bindings: media: sun6i: Add A64 CSI compatible
Message-ID: <20190125154108.jx6pkbfyn6rs3zdw@flea>
References: <20190124180736.28408-1-jagan@amarulasolutions.com>
 <20190124180736.28408-2-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="esdc27zz3merdu23"
Content-Disposition: inline
In-Reply-To: <20190124180736.28408-2-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--esdc27zz3merdu23
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2019 at 11:37:32PM +0530, Jagan Teki wrote:
> Allwinner A64 CSI is a single channel time-multiplexed BT.656
> protocol interface.
>=20
> Add separate compatible string for A64 since it require explicit
> change in sun6i_csi driver to update default CSI_SCLK rate.
>=20
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--esdc27zz3merdu23
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEsuFAAKCRDj7w1vZxhR
xU8TAQDKhJnqFXg5r7j7/T6te+vbxzCBG/p19dPyz/fgyHsgHwD+O7dBYp20F8r0
yn4PXjj4Rkt3a1pNJ0OEByvluMh0EQQ=
=ufZ6
-----END PGP SIGNATURE-----

--esdc27zz3merdu23--
