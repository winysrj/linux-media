Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED58C43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 13:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6307D208E3
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 13:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfADNfn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 08:35:43 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:53735 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfADNfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2019 08:35:43 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D166E20001B;
        Fri,  4 Jan 2019 13:35:39 +0000 (UTC)
Date:   Fri, 4 Jan 2019 14:35:41 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 2/4] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work
 with V4L2_SUBDEV_FORMAT_TRY
Message-ID: <20190104133541.zlqn2rlimvjdrg2q@uno.localdomain>
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com>
 <20181231105418.nt4b6abe2tnvsge7@pengutronix.de>
 <CAC5umyiSoo46A7d-V1fRMny0HhV9=gbch4_vBhy-GN1O54CJjw@mail.gmail.com>
 <20190103134704.3rabugqd3pqzrazb@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ly3sdmg6ncgtrzqt"
Content-Disposition: inline
In-Reply-To: <20190103134704.3rabugqd3pqzrazb@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--ly3sdmg6ncgtrzqt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
  sorry to jump in

On Thu, Jan 03, 2019 at 02:47:04PM +0100, Marco Felsch wrote:
> On 19-01-01 02:07, Akinobu Mita wrote:
> > 2018=E5=B9=B412=E6=9C=8831=E6=97=A5(=E6=9C=88) 19:54 Marco Felsch <m.fe=
lsch@pengutronix.de>:
> > >
> > > On 18-12-30 02:07, Akinobu Mita wrote:
> > > > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > > > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_AC=
TIVE
> > > > is specified.
> > > >
> > > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > > ---
> > > >  drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
> > > >  1 file changed, 31 insertions(+)
> > > >
> > > > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m11=
1.c
> > > > index f0e47fd..acb4dee 100644
> > > > --- a/drivers/media/i2c/mt9m111.c
> > > > +++ b/drivers/media/i2c/mt9m111.c
> > > > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev =
*sd,
> > > >       if (format->pad)
> > > >               return -EINVAL;
> > > >
> > > > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > > > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > >
> > > This ifdef is made in the include/media/v4l2-subdev.h, so I would drop
> > > it.
> >
> > I sent similar fix for ov2640 driver and kerel test robot reported
> > build test failure.  So I think this ifdef is necessary.
> >
> > v1: https://www.mail-archive.com/linux-media@vger.kernel.org/msg137098.=
html
> > v2: https://www.mail-archive.com/linux-media@vger.kernel.org/msg141735.=
html
>
> You are absolutely true, sorry my mistake.. Unfortunately my patch [1] wa=
sn't
> applied which fixes it commonly. This patch will avoid the 2nd ifdef in
> init_cfg() too.
>
> [1] https://www.spinics.net/lists/linux-media/msg138940.html
>

There have been recents attempts to do the same, please see:
https://lkml.org/lkml/2018/11/28/1080
and Hans' attempt at
https://patchwork.kernel.org/patch/10717699/

Unfortunately seems like we're gonna live with those ifdefs

Thanks
  j

--ly3sdmg6ncgtrzqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlwvYSgACgkQcjQGjxah
VjyR/xAAjstEjxGSAhkHnK1+lo7mqjlNKbzJX/zTBVpQujSEfEig6gBeQa79Kos8
mLesEPA7TwHzKE8RbsXz1QzuNh/dK+gFZ8eLuduegWxa3JV3y1LvIoiqO0mFIy7W
PkHxyD+ED0cHVz7OZStNC2tZLkfQbuEUu1Ir4NcATjLEbUJPtKSvUu9HO5Yin7DO
vnK+CBXfvjJ3K1b//X3WxzSGoTG2hSRpadl4pvfbSz8YmUqsstp20VFv0A1uflOq
p5sDDtUWE0b8cWBbaYiTDJpHqUoHrkWjOPANPfodnp66N5RUHel9mNLoi+SK5quL
i7VUI4xr6i6RMGwzQSnkDsDqC7jSxFoktmGeA02Td2MnL6dDcwV8ELc194QNluC3
NQIzWhhjgkEfh0MbJ868AnYSjxvnmd4c7qk/G6/GMF3QbRKTBBCH/L0Ha7FANiLs
eKjvcFOFXh3Hw7HAE6FIszoaHEzENd17YrBS6tEaiNPljdYxX3rqLGFw8pLAjNCT
DNutkYyoiXrj615uTdbFp6qf2MZqgIvU/pWXk1vf4EdnRidTKGeWVGcloS0FPAIA
oyBcmZMlCQXhya71pkvQR9FAgLuxiO8PELt1VUqiNblKXb50dGiLPUjKNL7jARCb
uEdnnSXIchAndTktwu8F4Nwc8qFV0hkq3snXDKx6xMyjQ5p6nVk=
=gbfv
-----END PGP SIGNATURE-----

--ly3sdmg6ncgtrzqt--
