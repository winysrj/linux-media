Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA45DC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 07:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278B420849
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 07:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="NG1Kt3JS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 278B420849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbeLKHsv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 02:48:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54744 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbeLKHsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 02:48:46 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6685F53F;
        Tue, 11 Dec 2018 08:48:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544514523;
        bh=mBX1CIJoEA9U5Gx0uU2VAfxtTyzhot56IRzaQFPSx/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NG1Kt3JSEv4FhWMhh+jpt1x7kglN9W+mvg/xrAn2FnLNG6sR7TuqXujaoPWf+Tn+I
         hDWj1Jcg4hFu91ebCKrGAa/6QQoA20IjkTO/5QeUJAPDK5gAHayFeptZR2SLSTsuKP
         KiWp0XICXfrn2x2DmU7YMFy9UeX6sGR6ZiqndN+M=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: rcar-csi2: Fix PHTW table values for E3/V3M
Date:   Tue, 11 Dec 2018 09:49:26 +0200
Message-ID: <1776809.Zlo14oacIu@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181211020115.GK17972@bigcity.dyn.berto.se>
References: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org> <2063363.Wr8td8jMvS@avalon> <20181211020115.GK17972@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On Tuesday, 11 December 2018 04:01:15 EET Niklas S=F6derlund wrote:
> On 2018-12-10 22:16:52 +0200, Laurent Pinchart wrote:
> > On Monday, 10 December 2018 16:53:55 EET Jacopo Mondi wrote:
> >> The PHTW selection algorithm implemented in rcsi2_phtw_write_mbps()
> >> checks for lower bound of the interval used to match the desired
> >> bandwidth. Use that in place of the currently used upport bound.
> >=20
> > The rcsi2_phtw_write_mbps() function performs the following (error
> > handling removed):
> >=20
> >         const struct rcsi2_mbps_reg *value;
> >        =20
> >         for (value =3D values; value->mbps; value++)
> >                 if (value->mbps >=3D mbps)
> >                         break;
> >        =20
> >         return rcsi2_phtw_write(priv, value->reg, code);
> >=20
> > With this patch, an mbps value of 85 will match the second entry in the
> > phtw_mbps_v3m_e3 table:
> >=20
> > [0]	{ .mbps =3D   80, .reg =3D 0x00 },
> > [1]	{ .mbps =3D   90, .reg =3D 0x20 },
> > ...
> >=20
> > The datasheet however documents the range 80-89 to map to 0x00.
> >=20
> > What am I missing ?
>=20
> I'm afraid you are missing a issue with the original implementation of
> the rcar-csi2 driver (my fault). The issue you point out is a problem
> with the current freq selection logic not the tables themself which
> needs to be corrected.
>=20
> This patch aligns the table with the other tables in the driver and is
> sound. A patch (Jacopo care to submit it?) is needed to resolve the
> faulty logic in the driver. It should select the range according to
> Laurents findings and not the range above it as the current code does.

I wonder whether we should instead modify the tables, to avoid making the=20
selection logic more complicated and less efficient CPU-wise.

Speaking of which, the tables are interestingly specified in three differen=
t=20
ways in the datasheet:

=2D The TESTDIN_DATA table specifies non-overlapping ranges

e.g. [80, 89]: 0x00, [90, 99]: 0x20, [100, 109]: 0x40, ...

In this regard this patch is an improvement (that is if the faulty selectio=
n=20
logic gets fixed), as otherwise a frequency of 109.5 would be classified in=
=20
the [110, 129] range, while I think it is meant to be in the [100, 109] ran=
ge.

Another option would be to set the table mbps value to the high bound of th=
e=20
range:

        { .mbps =3D   90, .reg =3D 0x00 },
        { .mbps =3D  100, .reg =3D 0x20 },
        { .mbps =3D  110, .reg =3D 0x40 },
        ...

and use strict lower comparison logic:

        const struct rcsi2_mbps_reg *value;

        for (value =3D values; value->mbps; value++)
                if (mbps < value->mbps)
                        break

=2D The PHTW table specifies individual bit rates

e.g. 80: 0x86, 90: 0x86, 100: 0x87, ..

I'm not sure how to interpret this. If I had to guess, I would say it means

[80, 90[: 0x86, [90, 100[: 0x86, [100, 110[: 0x87, ..

We could thus use the same logic than for the TESTDIN_DATA table (and while=
 at=20
it merge adjacent ranges that share the same PHTW value).

=2D The HSFREQRANGE tables specify overlapping ranges

e.g. [80, 131.25]: 0x20, [80.75, 141.75]: 0x30, [90.25, 152.25]: 0x01, ...

This has to be converted to non-overlapping ranges. I would advice centerin=
g=20
each non-overlapping range to the center of the corresponding overlapping=20
range. Today we instead have non-overlapping ranges in the driver whose bou=
nds=20
are set to the center of the overlapping ranges, and I don't think this is=
=20
right.

And we could then use the same logic as above here too.

The downside is that the tables would need to be carefully reviewed as they=
=20
would derive from the values in the datasheet instead of computing them=20
blindly, and the upside would be simpler code. If we want to instead copy t=
he=20
tables blindly for ease of review, then I think we'll need more complex=20
selection logic, with different logics for the different tables.

> >> Fixes: 10c08812fe60 ("media: rcar: rcar-csi2: Update V3M/E3 PHTW
> >> tables")
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-csi2.c | 62 +++++++++++---------=
=2D--
> >>  1 file changed, 31 insertions(+), 31 deletions(-)
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> >> 80ad906d1136..7e9cb8bcfe70 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> @@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg
> >> phtw_mbps_h3_v3h_m3n[] =3D { };
> >>=20
> >>  static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] =3D {
> >> -	{ .mbps =3D   89, .reg =3D 0x00 },
> >> -	{ .mbps =3D   99, .reg =3D 0x20 },
> >> -	{ .mbps =3D  109, .reg =3D 0x40 },
> >> -	{ .mbps =3D  129, .reg =3D 0x02 },
> >> -	{ .mbps =3D  139, .reg =3D 0x22 },
> >> -	{ .mbps =3D  149, .reg =3D 0x42 },
> >> -	{ .mbps =3D  169, .reg =3D 0x04 },
> >> -	{ .mbps =3D  179, .reg =3D 0x24 },
> >> -	{ .mbps =3D  199, .reg =3D 0x44 },
> >> -	{ .mbps =3D  219, .reg =3D 0x06 },
> >> -	{ .mbps =3D  239, .reg =3D 0x26 },
> >> -	{ .mbps =3D  249, .reg =3D 0x46 },
> >> -	{ .mbps =3D  269, .reg =3D 0x08 },
> >> -	{ .mbps =3D  299, .reg =3D 0x28 },
> >> -	{ .mbps =3D  329, .reg =3D 0x0a },
> >> -	{ .mbps =3D  359, .reg =3D 0x2a },
> >> -	{ .mbps =3D  399, .reg =3D 0x4a },
> >> -	{ .mbps =3D  449, .reg =3D 0x0c },
> >> -	{ .mbps =3D  499, .reg =3D 0x2c },
> >> -	{ .mbps =3D  549, .reg =3D 0x0e },
> >> -	{ .mbps =3D  599, .reg =3D 0x2e },
> >> -	{ .mbps =3D  649, .reg =3D 0x10 },
> >> -	{ .mbps =3D  699, .reg =3D 0x30 },
> >> -	{ .mbps =3D  749, .reg =3D 0x12 },
> >> -	{ .mbps =3D  799, .reg =3D 0x32 },
> >> -	{ .mbps =3D  849, .reg =3D 0x52 },
> >> -	{ .mbps =3D  899, .reg =3D 0x72 },
> >> -	{ .mbps =3D  949, .reg =3D 0x14 },
> >> -	{ .mbps =3D  999, .reg =3D 0x34 },
> >> -	{ .mbps =3D 1049, .reg =3D 0x54 },
> >> -	{ .mbps =3D 1099, .reg =3D 0x74 },
> >> +	{ .mbps =3D   80, .reg =3D 0x00 },
> >> +	{ .mbps =3D   90, .reg =3D 0x20 },
> >> +	{ .mbps =3D  100, .reg =3D 0x40 },
> >> +	{ .mbps =3D  110, .reg =3D 0x02 },
> >> +	{ .mbps =3D  130, .reg =3D 0x22 },
> >> +	{ .mbps =3D  140, .reg =3D 0x42 },
> >> +	{ .mbps =3D  150, .reg =3D 0x04 },
> >> +	{ .mbps =3D  170, .reg =3D 0x24 },
> >> +	{ .mbps =3D  180, .reg =3D 0x44 },
> >> +	{ .mbps =3D  200, .reg =3D 0x06 },
> >> +	{ .mbps =3D  220, .reg =3D 0x26 },
> >> +	{ .mbps =3D  240, .reg =3D 0x46 },
> >> +	{ .mbps =3D  250, .reg =3D 0x08 },
> >> +	{ .mbps =3D  270, .reg =3D 0x28 },
> >> +	{ .mbps =3D  300, .reg =3D 0x0a },
> >> +	{ .mbps =3D  330, .reg =3D 0x2a },
> >> +	{ .mbps =3D  360, .reg =3D 0x4a },
> >> +	{ .mbps =3D  400, .reg =3D 0x0c },
> >> +	{ .mbps =3D  450, .reg =3D 0x2c },
> >> +	{ .mbps =3D  500, .reg =3D 0x0e },
> >> +	{ .mbps =3D  550, .reg =3D 0x2e },
> >> +	{ .mbps =3D  600, .reg =3D 0x10 },
> >> +	{ .mbps =3D  650, .reg =3D 0x30 },
> >> +	{ .mbps =3D  700, .reg =3D 0x12 },
> >> +	{ .mbps =3D  750, .reg =3D 0x32 },
> >> +	{ .mbps =3D  800, .reg =3D 0x52 },
> >> +	{ .mbps =3D  850, .reg =3D 0x72 },
> >> +	{ .mbps =3D  900, .reg =3D 0x14 },
> >> +	{ .mbps =3D  950, .reg =3D 0x34 },
> >> +	{ .mbps =3D 1000, .reg =3D 0x54 },
> >> +	{ .mbps =3D 1050, .reg =3D 0x74 },
> >>  	{ .mbps =3D 1125, .reg =3D 0x16 },
> >>  	{ /* sentinel */ },
> >> =20
> >>  };

=2D-=20
Regards,

Laurent Pinchart



