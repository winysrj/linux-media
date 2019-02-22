Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1EDC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 15:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D727320700
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 15:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfBVPjk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:39:40 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:36216 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfBVPjk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 10:39:40 -0500
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 208013A4F15
        for <linux-media@vger.kernel.org>; Fri, 22 Feb 2019 15:04:25 +0000 (UTC)
Received: from localhost (aaubervilliers-681-1-81-190.w90-88.abo.wanadoo.fr [90.88.23.190])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id E4D18200012;
        Fri, 22 Feb 2019 15:04:21 +0000 (UTC)
Date:   Fri, 22 Feb 2019 16:04:21 +0100
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
Message-ID: <20190222150421.ilg62fyvrxwp2moh@flea>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
 <20190221162020.keonztyi7yq2a4hg@ti.com>
 <20190222143959.gothnp6namn2gt2w@flea>
 <20190222145456.3v6lsslj7slb2kob@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="b4zlivgwiaaewqlx"
Content-Disposition: inline
In-Reply-To: <20190222145456.3v6lsslj7slb2kob@ti.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--b4zlivgwiaaewqlx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2019 at 08:54:56AM -0600, Benoit Parrot wrote:
> Maxime Ripard <maxime.ripard@bootlin.com> wrote on Fri [2019-Feb-22 15:39=
:59 +0100]:
> > On Thu, Feb 21, 2019 at 10:20:20AM -0600, Benoit Parrot wrote:
> > > Hi Maxime,
> > >=20
> > > A couple of questions,
> > >=20
> > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-11 0=
4:21:00 -0500]:
> > > > The clock rate, while hardcoded until now, is actually a function o=
f the
> > > > resolution, framerate and bytes per pixel. Now that we have an algo=
rithm to
> > > > adjust our clock rate, we can select it dynamically when we change =
the
> > > > mode.
> > > >=20
> > > > This changes a bit the clock rate being used, with the following ef=
fect:
> > > >=20
> > > > +------+------+------+------+-----+-----------------+--------------=
--+-----------+
> > > > | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed cloc=
k | Deviation |
> > > > +------+------+------+------+-----+-----------------+--------------=
--+-----------+
> > > > |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       6143040=
0 | 8.84 %    |
> > > > |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      12286080=
0 | 8.84 %    |
> > > > | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       6143040=
0 | 8.84 %    |
> > > > | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      12286080=
0 | 8.84 %    |
> > > > |  320 |  240 | 1896 |  984 |  15 |        56000000 |       5596992=
0 | 0.05 %    |
> > > > |  320 |  240 | 1896 |  984 |  30 |       112000000 |      11193984=
0 | 0.05 %    |
> > > > |  176 |  144 | 1896 |  984 |  15 |        56000000 |       5596992=
0 | 0.05 %    |
> > > > |  176 |  144 | 1896 |  984 |  30 |       112000000 |      11193984=
0 | 0.05 %    |
> > > > |  720 |  480 | 1896 |  984 |  15 |        56000000 |       5596992=
0 | 0.05 %    |
> > > > |  720 |  480 | 1896 |  984 |  30 |       112000000 |      11193984=
0 | 0.05 %    |
> > > > |  720 |  576 | 1896 |  984 |  15 |        56000000 |       5596992=
0 | 0.05 %    |
> > > > |  720 |  576 | 1896 |  984 |  30 |       112000000 |      11193984=
0 | 0.05 %    |
> > > > | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       4200240=
0 | 0.01 %    |
> > > > | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       8400480=
0 | 0.01 %    |
> > > > | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       8400000=
0 | 0.00 %    |
> > > > | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      16800000=
0 | 0.00 %    |
> > > > | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      16586208=
0 | 49.36 %   |
> > > > +------+------+------+------+-----+-----------------+--------------=
--+-----------+
> > >=20
> > > Is the computed clock above the same for both parallel and CSI2?
> > >=20
> > > I want to add controls for PIXEL_RATE and LINK_FREQ, would you have a=
ny
> > > quick pointer on taking the computed clock and translating that into =
the
> > > PIXEL_RATE and LINK_FREQ values?
> > >=20
> > > I am trying to use this sensor with TI CAL driver which at the moment=
 uses
> > > the PIXEL_RATE values in order to compute ths_settle and ths_term val=
ues
> > > needed to program the DPHY properly. This is similar in behavior as t=
he way
> > > omap3isp relies on this info as well.
> >=20
> > I haven't looked that much into the csi-2 case, but the pixel rate
> > should be the same at least.
>=20
> I'll have to study the way the computed clock is actually calculated for
> either case, but if they yield the same number then I would be surprised
> that the pixel rate would be the same as in parallel mode you get 8 data
> bits per clock whereas in CSI2 using 2 data lanes you get 4 data bits per
> clock.

The bus rate will be different, but the pixel rate is the same: you
have as many pixels per frames and as many frames per seconds in the
parallel and CSI cases.

> So just to be certain here the "Computed clock" column above would be the
> pixel clock frequency?

it is

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--b4zlivgwiaaewqlx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXHAPdQAKCRDj7w1vZxhR
xZqSAP9+3nMjNPFCIOA0EiRI8ATsogkc9uNU/S/ucDFa1HUH5QEA7D8thiA76cxd
oASo9KCCorKPGS9tcXR4ZK6v/9JQtwc=
=NdtI
-----END PGP SIGNATURE-----

--b4zlivgwiaaewqlx--
