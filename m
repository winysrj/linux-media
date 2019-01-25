Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7A5C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA83E218DE
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfAYPkL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:40:11 -0500
Received: from mail.bootlin.com ([62.4.15.54]:53883 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfAYPkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:40:11 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 9176020742; Fri, 25 Jan 2019 16:40:08 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 5ADC120397;
        Fri, 25 Jan 2019 16:39:58 +0100 (CET)
Date:   Fri, 25 Jan 2019 16:39:58 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com
Subject: Re: [PATCH] media: ov5640: Fix set 15fps regression
Message-ID: <20190125153958.3aertsxgdzjldlzd@flea>
References: <20190124175801.28018-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="364yr3wufj4pv3uo"
Content-Disposition: inline
In-Reply-To: <20190124175801.28018-1-jagan@amarulasolutions.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--364yr3wufj4pv3uo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2019 at 11:28:01PM +0530, Jagan Teki wrote:
> The ov5640_try_frame_interval operation updates the FPS as per user
> input based on default ov5640_frame_rate, OV5640_30_FPS which is failed
> to update when user trigger 15fps.
>=20
> So, initialize the default ov5640_frame_rate to OV5640_15_FPS so-that
> it can satisfy to update all fps.
>=20
> Fixes: 5a3ad937bc78 ("media: ov5640: Make the return rate type more expli=
cit")
> Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>

I'm pretty sure I tested this and it was working fine. You're
mentionning a regression, but what regression is there exactly (ie,
what was working before that commit that doesn't work anymore?). What
tools/commands are you using to see this behaviour?

It really isn't obvious from your patch and the patch you mention what
could go wrong or be improved.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--364yr3wufj4pv3uo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEstzgAKCRDj7w1vZxhR
xUqJAQCQ/aFQZNYuMsvi68I8+5cbRnDBykNs/HVqsTk0QmT5jwEAj1/hGIOnYqRb
etr2+87pF2dSusJetWCl6ZprkzqwgA8=
=10uE
-----END PGP SIGNATURE-----

--364yr3wufj4pv3uo--
