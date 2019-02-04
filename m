Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83FCC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 13:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926152081B
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 13:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfBDNvH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 08:51:07 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42639 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfBDNvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 08:51:06 -0500
X-Originating-IP: 185.94.189.188
Received: from localhost (unknown [185.94.189.188])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 35569E0002;
        Mon,  4 Feb 2019 13:51:00 +0000 (UTC)
Date:   Mon, 4 Feb 2019 14:51:00 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>
Subject: Re: [PATCH v5 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
Message-ID: <20190204135100.cnlf2dpnng6fad2t@flea>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
 <fc5427d3-674e-cebc-99b9-11493f976a20@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d5cpay2p6yr7wia2"
Content-Disposition: inline
In-Reply-To: <fc5427d3-674e-cebc-99b9-11493f976a20@ti.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--d5cpay2p6yr7wia2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon,

On Mon, Feb 04, 2019 at 03:33:31PM +0530, Kishon Vijay Abraham I wrote:
> On 21/01/19 9:15 PM, Maxime Ripard wrote:
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
> Can the PHY changes go independently of the consumer drivers? or else I'l=
l need
> ACKs from the GPU MAINTAINER.

At least for the Allwinner driver, they can go through through the
drm-misc tree. Since we have a number of patches in flight for that
driver, it would even be easier to handle there.

For the cadence driver, since it doesn't really work on any system but
simulators for now, I guess the wakeup regression isn't super
important either.

So I'd say we can have the phy related patches go through your tree,
and the other through drm-misc.

Would that work for you?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--d5cpay2p6yr7wia2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFhDRAAKCRDj7w1vZxhR
xR5PAP9L3aHo233MQj0fTl0YnxIvU8ZLGWSGvGIfnSolldJHeQD/aoCag+19/Lcp
PeiLEU1SeJW4FCAggKQBNWjcd+D5uwM=
=YUnh
-----END PGP SIGNATURE-----

--d5cpay2p6yr7wia2--
