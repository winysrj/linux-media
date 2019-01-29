Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 272EDC169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CEC21473
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfA2JAj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:00:39 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:40399 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfA2JAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 04:00:39 -0500
X-Originating-IP: 90.88.29.206
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id BAB75C0009;
        Tue, 29 Jan 2019 09:00:35 +0000 (UTC)
Date:   Tue, 29 Jan 2019 10:00:35 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com
Subject: Re: [PATCH] media: ov5640: Fix set 15fps regression
Message-ID: <20190129090035.lopfq3sdbx5glkl4@flea>
References: <20190124175801.28018-1-jagan@amarulasolutions.com>
 <20190125153958.3aertsxgdzjldlzd@flea>
 <CAMty3ZCuBqiOGAixWhy5bYqUHk0_=NvX08zp2F+MT4GgVEo+Rw@mail.gmail.com>
 <20190128083304.nxuvxecrcq63v2vn@uno.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uratojj4iyju3ihf"
Content-Disposition: inline
In-Reply-To: <20190128083304.nxuvxecrcq63v2vn@uno.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--uratojj4iyju3ihf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2019 at 09:33:04AM +0100, Jacopo Mondi wrote:
> Hi everyone,
>=20
> On Mon, Jan 28, 2019 at 01:20:37PM +0530, Jagan Teki wrote:
> > On Fri, Jan 25, 2019 at 9:10 PM Maxime Ripard <maxime.ripard@bootlin.co=
m> wrote:
> > >
> > > On Thu, Jan 24, 2019 at 11:28:01PM +0530, Jagan Teki wrote:
> > > > The ov5640_try_frame_interval operation updates the FPS as per user
> > > > input based on default ov5640_frame_rate, OV5640_30_FPS which is fa=
iled
> > > > to update when user trigger 15fps.
> > > >
> > > > So, initialize the default ov5640_frame_rate to OV5640_15_FPS so-th=
at
> > > > it can satisfy to update all fps.
> > > >
> > > > Fixes: 5a3ad937bc78 ("media: ov5640: Make the return rate type more=
 explicit")
> > > > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > >
> > > I'm pretty sure I tested this and it was working fine. You're
> > > mentionning a regression, but what regression is there exactly (ie,
> > > what was working before that commit that doesn't work anymore?). What
> > > tools/commands are you using to see this behaviour?
> >
>=20
> I think Jagan's right, here.
>=20
> For the 15FPS use case, the below condition in the for loop of
> ov5640_try_frame_interval() never gets satisfied (0 < 0 ?) and 'rate' ret=
ains
> its initial value of 30FPS.
>=20
> 		if (abs(curr_fps - fps) < abs(best_fps - fps)) {
> 			best_fps =3D curr_fps;
> 			rate =3D i;
> 		}
>=20
> To make more clear what's happening, I would initialize 'rate' just
> before 'best_fps' before the for loop. Anyway, please add:
> Acked-by: Jacopo Mondi <jacopo@jmondi.org>
>=20
> Maxime, does this make sense to you?

With that explanation in the commit log, yes.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--uratojj4iyju3ihf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFAWMwAKCRDj7w1vZxhR
xegdAP4r2z5eA9iFiTsVqHFV7Oi1JLFpsREGDtn0FQ/NjZaN/AD+L9WU1PO/9nzQ
YamlzAgkMwbsxat0is32D+Q1EjT6IwE=
=dsC0
-----END PGP SIGNATURE-----

--uratojj4iyju3ihf--
