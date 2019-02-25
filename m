Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC82C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1EAB2084D
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfBYJVb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 04:21:31 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47955 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfBYJVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 04:21:31 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 5773D1C0005;
        Mon, 25 Feb 2019 09:21:26 +0000 (UTC)
Date:   Mon, 25 Feb 2019 10:21:51 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
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
Message-ID: <20190225092151.pra7mvgvpvekth7z@uno.localdomain>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-6-maxime.ripard@bootlin.com>
 <20190221162020.keonztyi7yq2a4hg@ti.com>
 <20190222143959.gothnp6namn2gt2w@flea>
 <20190222145456.3v6lsslj7slb2kob@ti.com>
 <20190222150421.ilg62fyvrxwp2moh@flea>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4o3ltaxgxd7u3nlp"
Content-Disposition: inline
In-Reply-To: <20190222150421.ilg62fyvrxwp2moh@flea>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--4o3ltaxgxd7u3nlp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Maxime, Benoit,
  sorry for chiming in, but I'm a bit confused...

On Fri, Feb 22, 2019 at 04:04:21PM +0100, Maxime Ripard wrote:
> On Fri, Feb 22, 2019 at 08:54:56AM -0600, Benoit Parrot wrote:
> > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Fri [2019-Feb-22 15:=
39:59 +0100]:
> > > On Thu, Feb 21, 2019 at 10:20:20AM -0600, Benoit Parrot wrote:
> > > > Hi Maxime,
> > > >
> > > > A couple of questions,
> > > >
> > > > Maxime Ripard <maxime.ripard@bootlin.com> wrote on Thu [2018-Oct-11=
 04:21:00 -0500]:
> > > > > The clock rate, while hardcoded until now, is actually a function=
 of the
> > > > > resolution, framerate and bytes per pixel. Now that we have an al=
gorithm to
> > > > > adjust our clock rate, we can select it dynamically when we chang=
e the
> > > > > mode.
> > > > >
> > > > > This changes a bit the clock rate being used, with the following =
effect:
> > > > >
> > > > > +------+------+------+------+-----+-----------------+------------=
----+-----------+
> > > > > | Hact | Vact | Htot | Vtot | FPS | Hardcoded clock | Computed cl=
ock | Deviation |
> > > > > +------+------+------+------+-----+-----------------+------------=
----+-----------+
> > > > > |  640 |  480 | 1896 | 1080 |  15 |        56000000 |       61430=
400 | 8.84 %    |
> > > > > |  640 |  480 | 1896 | 1080 |  30 |       112000000 |      122860=
800 | 8.84 %    |
> > > > > | 1024 |  768 | 1896 | 1080 |  15 |        56000000 |       61430=
400 | 8.84 %    |
> > > > > | 1024 |  768 | 1896 | 1080 |  30 |       112000000 |      122860=
800 | 8.84 %    |
> > > > > |  320 |  240 | 1896 |  984 |  15 |        56000000 |       55969=
920 | 0.05 %    |
> > > > > |  320 |  240 | 1896 |  984 |  30 |       112000000 |      111939=
840 | 0.05 %    |
> > > > > |  176 |  144 | 1896 |  984 |  15 |        56000000 |       55969=
920 | 0.05 %    |
> > > > > |  176 |  144 | 1896 |  984 |  30 |       112000000 |      111939=
840 | 0.05 %    |
> > > > > |  720 |  480 | 1896 |  984 |  15 |        56000000 |       55969=
920 | 0.05 %    |
> > > > > |  720 |  480 | 1896 |  984 |  30 |       112000000 |      111939=
840 | 0.05 %    |
> > > > > |  720 |  576 | 1896 |  984 |  15 |        56000000 |       55969=
920 | 0.05 %    |
> > > > > |  720 |  576 | 1896 |  984 |  30 |       112000000 |      111939=
840 | 0.05 %    |
> > > > > | 1280 |  720 | 1892 |  740 |  15 |        42000000 |       42002=
400 | 0.01 %    |
> > > > > | 1280 |  720 | 1892 |  740 |  30 |        84000000 |       84004=
800 | 0.01 %    |
> > > > > | 1920 | 1080 | 2500 | 1120 |  15 |        84000000 |       84000=
000 | 0.00 %    |
> > > > > | 1920 | 1080 | 2500 | 1120 |  30 |       168000000 |      168000=
000 | 0.00 %    |
> > > > > | 2592 | 1944 | 2844 | 1944 |  15 |        84000000 |      165862=
080 | 49.36 %   |
> > > > > +------+------+------+------+-----+-----------------+------------=
----+-----------+
> > > >
> > > > Is the computed clock above the same for both parallel and CSI2?
> > > >
> > > > I want to add controls for PIXEL_RATE and LINK_FREQ, would you have=
 any
> > > > quick pointer on taking the computed clock and translating that int=
o the
> > > > PIXEL_RATE and LINK_FREQ values?
> > > >
> > > > I am trying to use this sensor with TI CAL driver which at the mome=
nt uses
> > > > the PIXEL_RATE values in order to compute ths_settle and ths_term v=
alues
> > > > needed to program the DPHY properly. This is similar in behavior as=
 the way
> > > > omap3isp relies on this info as well.
> > >
> > > I haven't looked that much into the csi-2 case, but the pixel rate
> > > should be the same at least.
> >
> > I'll have to study the way the computed clock is actually calculated for
> > either case, but if they yield the same number then I would be surprised
> > that the pixel rate would be the same as in parallel mode you get 8 data
> > bits per clock whereas in CSI2 using 2 data lanes you get 4 data bits p=
er
> > clock.
>
> The bus rate will be different, but the pixel rate is the same: you
> have as many pixels per frames and as many frames per seconds in the
> parallel and CSI cases.
>

I agree with that, but..

> > So just to be certain here the "Computed clock" column above would be t=
he
> > pixel clock frequency?
>
> it is

=2E..it seems to me the Computed clock column is actually the "byte clock".

=46rom a simple calculation for the 640x480@15FPS case:
"Computed clock" =3D 1896 * 1080 * 15 * 2 =3D 61430400

While, in my understanding, the pixel clock would just be
pixel_clock =3D HTOT * VTOT * FPS =3D 1896 * 1080 * 15 =3D 30715200

So I suspect the "* 2" there is the number of bytes per pixel.

That would match what's also reported here
file:///home/jmondi/project/renesas/linux/linux-build/Documentation/output/=
media/kapi/csi2.html?highlight=3Dlink_freq

Where:
link_freq =3D (pixel_rate * bpp) / (2 * nr_lanes)

So if I were to calculate PIXEL_RATE and LINK_FREQ in this driver,
that would be:
PIXEL_RATE =3D mode->vtot * mode->htot * ov5640_framerates[sensor->current_=
fr];
LINK_FREQ =3D PIXEL_RATE * 16 / ( 2 * sensor->ep.bus.mipi_csi2.num_data_lan=
es);
(assuming, as the driver does now, all formats have 16bpp)

Does this match your understanding as well?

Thanks
  j

>
> Maxime
>
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com



--4o3ltaxgxd7u3nlp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxzs6gACgkQcjQGjxah
VjwRmRAAplxpKjSyn//+ZParGZ9AFnt2YODptKU8zGUoKMruPt95+NCNOliCJdRk
Z7tqOGwzsIzFo1tg7itAqw10eWI6XJdiLLxVf81VuwNcdaJVAR9jrnXt7XUSKqNS
XVJ6VePM8gLzS9n/p+oEXkPtowBgtIdJ9rUnLMUEsdkN1sh75yY1hnhFQgWRbxgj
WUBzXMRoSKwR+pKSAPMwQ0+kZMLmPZXAECzuEDAdXftV1QSRgBO04DlpBEhJ9/Ct
esJV7AfkSpBDotnnBpmSwLM+wu5I55Id0cCXgRLj0Wk5XfYUUq0tqDcUSsl6nl3H
sb9HsAQR0HrliEiChH/cQOFAtFN8LgGgOwLtkCxls2dVY+hmqjcL6rSwRmKN/sAB
5jbCslNdi6zxDiEaL0p/88n+3PIv4l9NoagpKeZAY8ZEdZBe3iQaNw1yLzwhZXnw
/flZEgpJioCnKdsspAKCS2sg9HKVgZ0eyIDp8oT6s8TE53Dl7gfZidzhfw3KVEBB
lWb8ILR5EqC9cSQL4MijrRvn9o02cvwxh4QTT+xj3npUSnUR5Du7tU00AtWhwnIR
H5wFeiJZTKg7STGRp+PRfcRERyrh61LcOxMoAqEn7yokr2Rtb1AQoSe+knwifyL0
8Z2LjdCKwMO9yUH3VuBhxtGKSjPgdD8k7ySBDgL72kK//uzVd5c=
=YBzW
-----END PGP SIGNATURE-----

--4o3ltaxgxd7u3nlp--
