Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB9AC282C2
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654EC2073D
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 12:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfBFMZv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:25:51 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54577 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbfBFMZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 07:25:50 -0500
X-Originating-IP: 185.94.189.187
Received: from localhost (unknown [185.94.189.187])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 3F4E21C0007;
        Wed,  6 Feb 2019 12:25:46 +0000 (UTC)
Date:   Wed, 6 Feb 2019 13:25:46 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Rafal Ciepiela <rafalc@cadence.com>,
        Krzysztof Witos <kwitos@cadence.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chen-Yu Tsai <wens@csie.org>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/9] phy: Add configuration interface for MIPI D-PHY
 devices
Message-ID: <20190206122546.7zucalixgcm4ph36@flea>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
 <fc5427d3-674e-cebc-99b9-11493f976a20@ti.com>
 <20190205084620.GW3271@phenom.ffwll.local>
 <4177fba5-279d-3283-88f0-c681f72e5951@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fx3o27cxlmcnehgf"
Content-Disposition: inline
In-Reply-To: <4177fba5-279d-3283-88f0-c681f72e5951@ti.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--fx3o27cxlmcnehgf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kishon,

On Wed, Feb 06, 2019 at 05:43:12PM +0530, Kishon Vijay Abraham I wrote:
> On 05/02/19 2:16 PM, Daniel Vetter wrote:
> > On Mon, Feb 04, 2019 at 03:33:31PM +0530, Kishon Vijay Abraham I wrote:
> >>
> >>
> >> On 21/01/19 9:15 PM, Maxime Ripard wrote:
> >>> Hi,
> >>>
> >>> Here is a set of patches to allow the phy framework consumers to test=
 and
> >>> apply runtime configurations.
> >>>
> >>> This is needed to support more phy classes that require tuning based =
on
> >>> parameters depending on the current use case of the device, in additi=
on to
> >>> the power state management already provided by the current functions.
> >>>
> >>> A first test bed for that API are the MIPI D-PHY devices. There's a n=
umber
> >>> of solutions that have been used so far to support these phy, most of=
 the
> >>> time being an ad-hoc driver in the consumer.
> >>>
> >>> That approach has a big shortcoming though, which is that this is qui=
te
> >>> difficult to deal with consumers integrated with multiple variants of=
 phy,
> >>> of multiple consumers integrated with the same phy.
> >>>
> >>> The latter case can be found in the Cadence DSI bridge, and the CSI
> >>> transceiver and receivers. All of them are integrated with the same p=
hy, or
> >>> can be integrated with different phy, depending on the implementation.
> >>>
> >>> I've looked at all the MIPI DSI drivers I could find, and gathered al=
l the
> >>> parameters I could find. The interface should be complete, and most o=
f the
> >>> drivers can be converted in the future. The current set converts two =
of
> >>> them: the above mentionned Cadence DSI driver so that the v4l2 driver=
s can
> >>> use them, and the Allwinner MIPI-DSI driver.
> >>
> >> Can the PHY changes go independently of the consumer drivers? or else =
I'll need
> >> ACKs from the GPU MAINTAINER.
> >=20
> > Maxime is a gpu maintainer, so you're all good :-)
>=20
> cool.. I've merged all the patches except drm/bridge.
>=20
> Please see if everything looks okay once it shows up in phy -next (give a=
 day)

Thanks!

If possible (and if that's still an option), it would be better if the
sun6i related patches (patches 4 and 5) would go through the DRM tree
(with your Acked-by of course).

We have a number of patches in flight that have a decent chance to
conflict with patch 4.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--fx3o27cxlmcnehgf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFrSSgAKCRDj7w1vZxhR
xbeGAQCUUWz4qDcV+nxpYh+ZbDPmwLNfMdN1zKuRBy1FmWaG3gEAr/XazPw8k2fB
fCRt6alMEBPKWQv2aIPz8bvGM09kFgw=
=FI1q
-----END PGP SIGNATURE-----

--fx3o27cxlmcnehgf--
