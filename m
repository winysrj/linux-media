Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4657DC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 13:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16AF020842
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 13:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfBYNGM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:06:12 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:46609 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfBYNGM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 08:06:12 -0500
X-Originating-IP: 90.88.23.190
Received: from localhost (aaubervilliers-681-1-81-190.w90-88.abo.wanadoo.fr [90.88.23.190])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 01F3B40002;
        Mon, 25 Feb 2019 13:06:06 +0000 (UTC)
Date:   Mon, 25 Feb 2019 14:06:06 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v4 05/12] media: ov5640: Compute the clock rate at runtime
Message-ID: <20190225130606.wax6gmzivxwt5nlk@flea>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
 <20190221162020.keonztyi7yq2a4hg@ti.com>
 <20190222143959.gothnp6namn2gt2w@flea>
 <20190222145456.3v6lsslj7slb2kob@ti.com>
 <20190222150421.ilg62fyvrxwp2moh@flea>
 <20190225092151.pra7mvgvpvekth7z@uno.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oanyiruk7kgpgp7k"
Content-Disposition: inline
In-Reply-To: <20190225092151.pra7mvgvpvekth7z@uno.localdomain>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--oanyiruk7kgpgp7k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 25, 2019 at 10:21:51AM +0100, Jacopo Mondi wrote:
> Hello Maxime, Benoit,
>   sorry for chiming in, but I'm a bit confused...
>=20
> On Fri, Feb 22, 2019 at 04:04:21PM +0100, Maxime Ripard wrote:
> > On Fri, Feb 22, 2019 at 08:54:56AM -0600, Benoit Parrot wrote:
> > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Fri [2019-Feb-22 1=
5:39:59 +0100]:
> > > > On Thu, Feb 21, 2019 at 10:20:20AM -0600, Benoit Parrot wrote:
> > > > > Hi Maxime,
> > > > >
> > > > > A couple of questions,
> > > > >
> > > > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-=
11 04:21:00 -0500]:
> > > > > > The clock rate, while hardcoded until now, is actually a functi=
on of the
> > > > > > resolution, framerate and bytes per pixel. Now that we have an =
algorithm to
> > > > > > adjust our clock rate, we can select it dynamically when we cha=
nge the
> > > > > > mode.
> > > > > >
> > > > > > This changes a bit the clock rate being used, with the followin=
g effect:
> > > > > >
> > > > > > +------+------+------+------+-----+-----------------+----------=
------+-----------+
> > > > > > | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed =
clock | Deviation |
> > > > > > +------+------+------+------+-----+-----------------+----------=
------+-----------+
> > > > > > |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       614=
30400 | 8.84 %    |
> > > > > > |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      1228=
60800 | 8.84 %    |
> > > > > > | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       614=
30400 | 8.84 %    |
> > > > > > | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      1228=
60800 | 8.84 %    |
> > > > > > |  320 |  240 | 1896 |  984 |  15 |        56000000 |       559=
69920 | 0.05 %    |
> > > > > > |  320 |  240 | 1896 |  984 |  30 |       112000000 |      1119=
39840 | 0.05 %    |
> > > > > > |  176 |  144 | 1896 |  984 |  15 |        56000000 |       559=
69920 | 0.05 %    |
> > > > > > |  176 |  144 | 1896 |  984 |  30 |       112000000 |      1119=
39840 | 0.05 %    |
> > > > > > |  720 |  480 | 1896 |  984 |  15 |        56000000 |       559=
69920 | 0.05 %    |
> > > > > > |  720 |  480 | 1896 |  984 |  30 |       112000000 |      1119=
39840 | 0.05 %    |
> > > > > > |  720 |  576 | 1896 |  984 |  15 |        56000000 |       559=
69920 | 0.05 %    |
> > > > > > |  720 |  576 | 1896 |  984 |  30 |       112000000 |      1119=
39840 | 0.05 %    |
> > > > > > | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       420=
02400 | 0.01 %    |
> > > > > > | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       840=
04800 | 0.01 %    |
> > > > > > | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       840=
00000 | 0.00 %    |
> > > > > > | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      1680=
00000 | 0.00 %    |
> > > > > > | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      1658=
62080 | 49.36 %   |
> > > > > > +------+------+------+------+-----+-----------------+----------=
------+-----------+
> > > > >
> > > > > Is the computed clock above the same for both parallel and CSI2?
> > > > >
> > > > > I want to add controls for PIXEL_RATE and LINK_FREQ, would you ha=
ve any
> > > > > quick pointer on taking the computed clock and translating that i=
nto the
> > > > > PIXEL_RATE and LINK_FREQ values?
> > > > >
> > > > > I am trying to use this sensor with TI CAL driver which at the mo=
ment uses
> > > > > the PIXEL_RATE values in order to compute ths_settle and ths_term=
 values
> > > > > needed to program the DPHY properly. This is similar in behavior =
as the way
> > > > > omap3isp relies on this info as well.
> > > >
> > > > I haven't looked that much into the csi-2 case, but the pixel rate
> > > > should be the same at least.
> > >
> > > I'll have to study the way the computed clock is actually calculated =
for
> > > either case, but if they yield the same number then I would be surpri=
sed
> > > that the pixel rate would be the same as in parallel mode you get 8 d=
ata
> > > bits per clock whereas in CSI2 using 2 data lanes you get 4 data bits=
 per
> > > clock.
> >
> > The bus rate will be different, but the pixel rate is the same: you
> > have as many pixels per frames and as many frames per seconds in the
> > parallel and CSI cases.
> >
>=20
> I agree with that, but..
>=20
> > > So just to be certain here the "Computed clock" column above would be=
 the
> > > pixel clock frequency?
> >
> > it is
>=20
> ...it seems to me the Computed clock column is actually the "byte clock".
>=20
> From a simple calculation for the 640x480@15FPS case:
> "Computed clock" =3D 1896 * 1080 * 15 * 2 =3D 61430400
>=20
> While, in my understanding, the pixel clock would just be
> pixel_clock =3D HTOT * VTOT * FPS =3D 1896 * 1080 * 15 =3D 30715200
>=20
> So I suspect the "* 2" there is the number of bytes per pixel.
>=20
> That would match what's also reported here
> file:///home/jmondi/project/renesas/linux/linux-build/Documentation/outpu=
t/media/kapi/csi2.html?highlight=3Dlink_freq
>=20
> Where:
> link_freq =3D (pixel_rate * bpp) / (2 * nr_lanes)
>=20
> So if I were to calculate PIXEL_RATE and LINK_FREQ in this driver,
> that would be:
> PIXEL_RATE =3D mode->vtot * mode->htot * ov5640_framerates[sensor->curren=
t_fr];
> LINK_FREQ =3D PIXEL_RATE * 16 / ( 2 * sensor->ep.bus.mipi_csi2.num_data_l=
anes);
> (assuming, as the driver does now, all formats have 16bpp)
>=20
> Does this match your understanding as well?

You're totally right, sorry about that :)

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--oanyiruk7kgpgp7k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXHPoPgAKCRDj7w1vZxhR
xZFtAQDzDPfgCQTLIlF8Qp6sSWDfeDlaQ4K/OHALIEDkOoej0AD+ImDwmLFmcoyh
EGKSUKF/sONHnSb562NraGnnxq0vQQg=
=PZ+g
-----END PGP SIGNATURE-----

--oanyiruk7kgpgp7k--
