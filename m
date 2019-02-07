Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C4EC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D321218FE
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfBGJQo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:16:44 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:38167 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfBGJQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 04:16:44 -0500
Received: from localhost (aaubervilliers-681-1-80-177.w90-88.abo.wanadoo.fr [90.88.22.177])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 203D5100003;
        Thu,  7 Feb 2019 09:16:39 +0000 (UTC)
Date:   Thu, 7 Feb 2019 10:16:39 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Krzysztof Witos <kwitos@cadence.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chen-Yu Tsai <wens@csie.org>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 6/9] drm/bridge: cdns: Separate DSI and D-PHY
 configuration
Message-ID: <20190207091639.4doo4h3okqqfbvw6@flea>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
 <0b3bea44e05745b65c23af7926ca546bc80a1bcc.1548085432.git-series.maxime.ripard@bootlin.com>
 <1d6fb3d0f97880d829a88b6da5aa71456f50507f.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bghpz54hbxx3ahfa"
Content-Disposition: inline
In-Reply-To: <1d6fb3d0f97880d829a88b6da5aa71456f50507f.camel@bootlin.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--bghpz54hbxx3ahfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 2019 at 09:44:46AM +0100, Paul Kocialkowski wrote:
> Hi,
>=20
> On Mon, 2019-01-21 at 16:45 +0100, Maxime Ripard wrote:
> > The current configuration of the DSI bridge and its associated D-PHY is
> > intertwined. In order to ease the future conversion to the phy framework
> > for the D-PHY part, let's split the configuration in two.
>=20
> See below about a silly mistake when refactoring. Looks good otherwise,
> so with that fixed:
>=20
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

I've fixed it while applying, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--bghpz54hbxx3ahfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFv3dwAKCRDj7w1vZxhR
xTBuAQDttACZStsezB6blvrLn0ablceJCGfKESgvEhrq44HuUAD+KCTaTPBfs3Lk
HyRXYkXUE6Oh0CTNJhLV5hJ3c7x+dwk=
=JSUm
-----END PGP SIGNATURE-----

--bghpz54hbxx3ahfa--
