Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F251DC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 14:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA2C2075C
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 14:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfBVOkF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:40:05 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54227 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfBVOkE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 09:40:04 -0500
X-Originating-IP: 90.88.23.190
Received: from localhost (aaubervilliers-681-1-81-190.w90-88.abo.wanadoo.fr [90.88.23.190])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id CDB0F40020;
        Fri, 22 Feb 2019 14:39:59 +0000 (UTC)
Date:   Fri, 22 Feb 2019 15:39:59 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Benoit Parrot <bparrot@ti.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v4 05/12] media: ov5640: Compute the clock rate at runtime
Message-ID: <20190222143959.gothnp6namn2gt2w@flea>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
 <20190221162020.keonztyi7yq2a4hg@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t4su66mpevkbgbry"
Content-Disposition: inline
In-Reply-To: <20190221162020.keonztyi7yq2a4hg@ti.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--t4su66mpevkbgbry
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2019 at 10:20:20AM -0600, Benoit Parrot wrote:
> Hi Maxime,
>=20
> A couple of questions,
>=20
> Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-11 04:21=
:00 -0500]:
> > The clock rate, while hardcoded until now, is actually a function of the
> > resolution, framerate and bytes per pixel. Now that we have an algorith=
m to
> > adjust our clock rate, we can select it dynamically when we change the
> > mode.
> >=20
> > This changes a bit the clock rate being used, with the following effect:
> >=20
> > +------+------+------+------+-----+-----------------+----------------+-=
----------+
> > | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed clock | =
Deviation |
> > +------+------+------+------+-----+-----------------+----------------+-=
----------+
> > |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430400 | =
8.84 %    |
> > |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860800 | =
8.84 %    |
> > | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430400 | =
8.84 %    |
> > | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860800 | =
8.84 %    |
> > |  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969920 | =
0.05 %    |
> > |  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939840 | =
0.05 %    |
> > |  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969920 | =
0.05 %    |
> > |  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939840 | =
0.05 %    |
> > |  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969920 | =
0.05 %    |
> > |  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939840 | =
0.05 %    |
> > |  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969920 | =
0.05 %    |
> > |  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939840 | =
0.05 %    |
> > | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002400 | =
0.01 %    |
> > | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004800 | =
0.01 %    |
> > | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000000 | =
0.00 %    |
> > | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000000 | =
0.00 %    |
> > | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862080 | =
49.36 %   |
> > +------+------+------+------+-----+-----------------+----------------+-=
----------+
>=20
> Is the computed clock above the same for both parallel and CSI2?
>=20
> I want to add controls for PIXEL_RATE and LINK_FREQ, would you have any
> quick pointer on taking the computed clock and translating that into the
> PIXEL_RATE and LINK_FREQ values?
>=20
> I am trying to use this sensor with TI CAL driver which at the moment uses
> the PIXEL_RATE values in order to compute ths_settle and ths_term values
> needed to program the DPHY properly. This is similar in behavior as the w=
ay
> omap3isp relies on this info as well.

I haven't looked that much into the csi-2 case, but the pixel rate
should be the same at least.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--t4su66mpevkbgbry
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXHAJvwAKCRDj7w1vZxhR
xR2lAQDX3PIo23e6wv+OGwPsxBEFZ3BFl9FZ/D4dUlRq9iuqBQEAtpkZG+hgpcqr
br/ZbnrgDhLfnFJjL2bfTOTPfli0uQ8=
=BaPC
-----END PGP SIGNATURE-----

--t4su66mpevkbgbry--
