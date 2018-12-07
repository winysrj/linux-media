Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06D5C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0F2C20882
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:09:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0F2C20882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbeLGJJi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:09:38 -0500
Received: from mail.bootlin.com ([62.4.15.54]:46455 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbeLGJJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 04:09:38 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 5831E20717; Fri,  7 Dec 2018 10:09:35 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 2AF3720510;
        Fri,  7 Dec 2018 10:09:35 +0100 (CET)
Date:   Fri, 7 Dec 2018 10:09:35 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v2 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
Message-ID: <20181207090935.xw5oonoe7od7hmkq@flea>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <f149ff50-b158-ef35-bf86-26d6b38c8068@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="troqpcfqchs4wkuw"
Content-Disposition: inline
In-Reply-To: <f149ff50-b158-ef35-bf86-26d6b38c8068@ti.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--troqpcfqchs4wkuw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 07, 2018 at 10:30:55AM +0530, Kishon Vijay Abraham I wrote:
> Maxime,
>=20
> On 06/11/18 8:24 PM, Maxime Ripard wrote:
> > Hi,
> >=20
> > Here is a set of patches to allow the phy framework consumers to test a=
nd
> > apply runtime configurations.
> >=20
> > This is needed to support more phy classes that require tuning based on
> > parameters depending on the current use case of the device, in addition=
 to
> > the power state management already provided by the current functions.
> >=20
> > A first test bed for that API are the MIPI D-PHY devices. There's a num=
ber
> > of solutions that have been used so far to support these phy, most of t=
he
> > time being an ad-hoc driver in the consumer.
> >=20
> > That approach has a big shortcoming though, which is that this is quite
> > difficult to deal with consumers integrated with multiple variants of p=
hy,
> > of multiple consumers integrated with the same phy.
> >=20
> > The latter case can be found in the Cadence DSI bridge, and the CSI
> > transceiver and receivers. All of them are integrated with the same phy=
, or
> > can be integrated with different phy, depending on the implementation.
> >=20
> > I've looked at all the MIPI DSI drivers I could find, and gathered all =
the
> > parameters I could find. The interface should be complete, and most of =
the
> > drivers can be converted in the future. The current set converts two of
> > them: the above mentionned Cadence DSI driver so that the v4l2 drivers =
can
> > use them, and the Allwinner MIPI-DSI driver.
>=20
> Are you planning to send one more revision of this series after fixing the
> comments?

I'll send a new version today.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--troqpcfqchs4wkuw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAo4zwAKCRDj7w1vZxhR
xbdOAQCILMy+JAxd6RYgHspolG6rz2rl0icJwBXZiKs8fE/kMwD/ch79eAPk78lF
sYujEN+9EIEfzYtOZi8/7VZdxA9JKwU=
=vt2O
-----END PGP SIGNATURE-----

--troqpcfqchs4wkuw--
