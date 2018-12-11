Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96052C07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 11:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A2A72084A
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 11:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A2A72084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbeLKLdz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 06:33:55 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37991 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbeLKLdz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 06:33:55 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 5563860002;
        Tue, 11 Dec 2018 11:33:51 +0000 (UTC)
Date:   Tue, 11 Dec 2018 12:33:49 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: rcar-csi2: Fix PHTW table values for E3/V3M
Message-ID: <20181211113349.GH5597@w540>
References: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org>
 <2063363.Wr8td8jMvS@avalon>
 <20181211020115.GK17972@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JIpyCmsTxyPLrmrM"
Content-Disposition: inline
In-Reply-To: <20181211020115.GK17972@bigcity.dyn.berto.se>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--JIpyCmsTxyPLrmrM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent, Niklas,

On Tue, Dec 11, 2018 at 03:01:15AM +0100, Niklas S=C3=B6derlund wrote:
> Hi Laurent,
>
> Thanks for your feedback,
>
> On 2018-12-10 22:16:52 +0200, Laurent Pinchart wrote:
> > Hi Jacopo,
> >
> > Thank you for the patch.
> >
> > On Monday, 10 December 2018 16:53:55 EET Jacopo Mondi wrote:
> > > The PHTW selection algorithm implemented in rcsi2_phtw_write_mbps() c=
hecks
> > > for lower bound of the interval used to match the desired bandwidth. =
Use
> > > that in place of the currently used upport bound.
> >
> > The rcsi2_phtw_write_mbps() function performs the following (error hand=
ling
> > removed):
> >
> >         const struct rcsi2_mbps_reg *value;
> >
> >         for (value =3D values; value->mbps; value++)
> >                 if (value->mbps >=3D mbps)
> >                         break;
> >
> >         return rcsi2_phtw_write(priv, value->reg, code);
> >
> > With this patch, an mbps value of 85 will match the second entry in the
> > phtw_mbps_v3m_e3 table:
> >
> > [0]	{ .mbps =3D   80, .reg =3D 0x00 },
> > [1]	{ .mbps =3D   90, .reg =3D 0x20 },
> > ...
> >
> > The datasheet however documents the range 80-89 to map to 0x00.
> >
> > What am I missing ?
>
> I'm afraid you are missing a issue with the original implementation of
> the rcar-csi2 driver (my fault). The issue you point out is a problem
> with the current freq selection logic not the tables themself which
> needs to be corrected.
>
> This patch aligns the table with the other tables in the driver and is
> sound. A patch (Jacopo care to submit it?) is needed to resolve the
> faulty logic in the driver. It should select the range according to
> Laurents findings and not the range above it as the current code does.
>
> >

I've been notified my previous patch broke the matching logic in the
CSI-2 driver, and so to keep it consistent, I basically reverted what
I've done.

Anyway, a re-work of those matching loop and tables is welcome, and as
you suggested in your last email, it should be done not only for PHTW
but for other tables as well.

In the meantime, I think this patch should go in (afaik there have
been no functional changes on E3/V3M) so that we start from a
(slightly suboptimal) fixed point.

Thanks
   j

> > > Fixes: 10c08812fe60 ("media: rcar: rcar-csi2: Update V3M/E3 PHTW tabl=
es")
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  drivers/media/platform/rcar-vin/rcar-csi2.c | 62 ++++++++++++-------=
------
> > >  1 file changed, 31 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> > > 80ad906d1136..7e9cb8bcfe70 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > > @@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg
> > > phtw_mbps_h3_v3h_m3n[] =3D { };
> > >
> > >  static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] =3D {
> > > -	{ .mbps =3D   89, .reg =3D 0x00 },
> > > -	{ .mbps =3D   99, .reg =3D 0x20 },
> > > -	{ .mbps =3D  109, .reg =3D 0x40 },
> > > -	{ .mbps =3D  129, .reg =3D 0x02 },
> > > -	{ .mbps =3D  139, .reg =3D 0x22 },
> > > -	{ .mbps =3D  149, .reg =3D 0x42 },
> > > -	{ .mbps =3D  169, .reg =3D 0x04 },
> > > -	{ .mbps =3D  179, .reg =3D 0x24 },
> > > -	{ .mbps =3D  199, .reg =3D 0x44 },
> > > -	{ .mbps =3D  219, .reg =3D 0x06 },
> > > -	{ .mbps =3D  239, .reg =3D 0x26 },
> > > -	{ .mbps =3D  249, .reg =3D 0x46 },
> > > -	{ .mbps =3D  269, .reg =3D 0x08 },
> > > -	{ .mbps =3D  299, .reg =3D 0x28 },
> > > -	{ .mbps =3D  329, .reg =3D 0x0a },
> > > -	{ .mbps =3D  359, .reg =3D 0x2a },
> > > -	{ .mbps =3D  399, .reg =3D 0x4a },
> > > -	{ .mbps =3D  449, .reg =3D 0x0c },
> > > -	{ .mbps =3D  499, .reg =3D 0x2c },
> > > -	{ .mbps =3D  549, .reg =3D 0x0e },
> > > -	{ .mbps =3D  599, .reg =3D 0x2e },
> > > -	{ .mbps =3D  649, .reg =3D 0x10 },
> > > -	{ .mbps =3D  699, .reg =3D 0x30 },
> > > -	{ .mbps =3D  749, .reg =3D 0x12 },
> > > -	{ .mbps =3D  799, .reg =3D 0x32 },
> > > -	{ .mbps =3D  849, .reg =3D 0x52 },
> > > -	{ .mbps =3D  899, .reg =3D 0x72 },
> > > -	{ .mbps =3D  949, .reg =3D 0x14 },
> > > -	{ .mbps =3D  999, .reg =3D 0x34 },
> > > -	{ .mbps =3D 1049, .reg =3D 0x54 },
> > > -	{ .mbps =3D 1099, .reg =3D 0x74 },
> > > +	{ .mbps =3D   80, .reg =3D 0x00 },
> > > +	{ .mbps =3D   90, .reg =3D 0x20 },
> > > +	{ .mbps =3D  100, .reg =3D 0x40 },
> > > +	{ .mbps =3D  110, .reg =3D 0x02 },
> > > +	{ .mbps =3D  130, .reg =3D 0x22 },
> > > +	{ .mbps =3D  140, .reg =3D 0x42 },
> > > +	{ .mbps =3D  150, .reg =3D 0x04 },
> > > +	{ .mbps =3D  170, .reg =3D 0x24 },
> > > +	{ .mbps =3D  180, .reg =3D 0x44 },
> > > +	{ .mbps =3D  200, .reg =3D 0x06 },
> > > +	{ .mbps =3D  220, .reg =3D 0x26 },
> > > +	{ .mbps =3D  240, .reg =3D 0x46 },
> > > +	{ .mbps =3D  250, .reg =3D 0x08 },
> > > +	{ .mbps =3D  270, .reg =3D 0x28 },
> > > +	{ .mbps =3D  300, .reg =3D 0x0a },
> > > +	{ .mbps =3D  330, .reg =3D 0x2a },
> > > +	{ .mbps =3D  360, .reg =3D 0x4a },
> > > +	{ .mbps =3D  400, .reg =3D 0x0c },
> > > +	{ .mbps =3D  450, .reg =3D 0x2c },
> > > +	{ .mbps =3D  500, .reg =3D 0x0e },
> > > +	{ .mbps =3D  550, .reg =3D 0x2e },
> > > +	{ .mbps =3D  600, .reg =3D 0x10 },
> > > +	{ .mbps =3D  650, .reg =3D 0x30 },
> > > +	{ .mbps =3D  700, .reg =3D 0x12 },
> > > +	{ .mbps =3D  750, .reg =3D 0x32 },
> > > +	{ .mbps =3D  800, .reg =3D 0x52 },
> > > +	{ .mbps =3D  850, .reg =3D 0x72 },
> > > +	{ .mbps =3D  900, .reg =3D 0x14 },
> > > +	{ .mbps =3D  950, .reg =3D 0x34 },
> > > +	{ .mbps =3D 1000, .reg =3D 0x54 },
> > > +	{ .mbps =3D 1050, .reg =3D 0x74 },
> > >  	{ .mbps =3D 1125, .reg =3D 0x16 },
> > >  	{ /* sentinel */ },
> > >  };
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> >
> >
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--JIpyCmsTxyPLrmrM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcD6CdAAoJEHI0Bo8WoVY8LrEP/ifxKEILs3LRPi76pJlV7Z3K
8AAnqoXX78AqQCwXyjzgwvjM5YVoiOe+FHZOCAF3ODgXJ3S+uvdSvwlNLH021JCU
edp3NIbqRwVwMEWUxuqU+QgI4RJpBIm+KzRlbM9aLIHDd/OmXgvpJv8aN2ac47C4
6hhTNu38Tc6mrZZgRJj35WNP5aUb6d6Vrox8UXiL8MDK4owUSdOiic7FhqtTQHar
JE7ysru3OH1lyJI1BJibZqpOHqQOoa73zpRkzxfCRncj7YKo8dWYFLk5E4ZKIz64
Wstnoxb5DMlPlTPrk20Wshc2gy/URFVKF9wL/S+FKcGUYu6ig4Vikwuyb6rJTser
S8gJU5bevTOPS8GMiAEzlce+mCl3KVHbP8RpfkumHoKjRvj9Y38bBTsEauBVrEbj
m7Rk5EXg1PBFJOCBYZZRkdWwUiqySA9SY4M48lZvJKRBzNw66uPtbLnzzok7KY5s
cXmRYq/7WOicUTbNrQa72xqDtaQz8yRm6jJqf2k4PilnkBuhwD94uGMBlLXrl94k
D4z50IXoKQCfErYTzTXVn5gn1p5Ag6S8oWDXPgtHqWboCSE16seGB7t7g/b4N6bI
tGVitN3cmb+htnTEf9PBhunRDb7bFlMhtIS9N4jQFZ44hiAYQ4uJlwN4wTtW5SH6
FBPWw7UdS2GMMVK4J2gG
=vkHW
-----END PGP SIGNATURE-----

--JIpyCmsTxyPLrmrM--
