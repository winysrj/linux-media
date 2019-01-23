Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77837C282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 15:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51336218A2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 15:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfAWPok (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:44:40 -0500
Received: from mail.bootlin.com ([62.4.15.54]:41488 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfAWPok (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 10:44:40 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 65FC2207AC; Wed, 23 Jan 2019 16:44:37 +0100 (CET)
Received: from localhost (unknown [185.94.189.187])
        by mail.bootlin.com (Postfix) with ESMTPSA id 28D672077B;
        Wed, 23 Jan 2019 16:44:37 +0100 (CET)
Date:   Wed, 23 Jan 2019 16:44:37 +0100
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
Subject: Re: [PATCH v6 2/6] media: sun6i: Add mod_rate quirk
Message-ID: <20190123154437.zjrpzzsenoioi43e@flea>
References: <20190118163158.21418-1-jagan@amarulasolutions.com>
 <20190118163158.21418-3-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yz2zv5rwxvomehn4"
Content-Disposition: inline
In-Reply-To: <20190118163158.21418-3-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--yz2zv5rwxvomehn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2019 at 10:01:54PM +0530, Jagan Teki wrote:
> Unfortunately default CSI_SCLK rate cannot work properly to
> drive the connected sensor interface, particularly on few
> Allwinner SoC's like A64.
>=20
> So, add mod_rate quirk via driver data so-that the respective
> SoC's which require to alter the default mod clock rate can assign
> the operating clock rate.
>=20
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>

You still don't need the variant stuff. If the sole difference is that
we need that clock rate to be fixed, then the following patch is enough.

http://code.bulix.org/9au998-562745?raw

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--yz2zv5rwxvomehn4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEiL5QAKCRDj7w1vZxhR
xW+OAP9I14o2aqaDvi2Zkm7tBUQNgMKU5/cRvH0+/vPUZBw7tQEAi4AHCxrJMB7W
dAeL9m2LXQ6M4nDrZE51/vBKoTOpQgM=
=UHSo
-----END PGP SIGNATURE-----

--yz2zv5rwxvomehn4--
