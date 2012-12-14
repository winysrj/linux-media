Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43681 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab2LNRds (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:33:48 -0500
Date: Fri, 14 Dec 2012 19:26:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214172616.GC9620@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <20121214172809.GT4989@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 14, 2012 at 09:28:09AM -0800, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [121120 12:00]:
> > Hi,
> >=20
> > * Timo Kokkonen <timo.t.kokkonen@iki.fi> [121118 07:15]:
> > > --- a/drivers/media/rc/ir-rx51.c
> > > +++ b/drivers/media/rc/ir-rx51.c
> > > @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_r=
x51)
> > >  			      OMAP_TIMER_TRIGGER_NONE);
> > >  }
> > > =20
> > > +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
> > > +{
> > > +	if (lirc_rx51->wbuf_index < 0)
> > > +		return;
> > > +
> > > +	lirc_rx51_off(lirc_rx51);
> > > +	lirc_rx51->wbuf_index =3D -1;
> > > +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> > > +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> > > +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> > > +	wake_up(&lirc_rx51->wqueue);
> > > +}
> > > +
> > >  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
> > >  {
> > >  	u32 load, match;
> >=20
> > Good fixes in general.. But you won't be able to access the
> > omap_dm_timer functions after we enable ARM multiplatform support
> > for omap2+. That's for v3.9 probably right after v3.8-rc1.
> >=20
> > We need to find some Linux generic API to use hardware timers
> > like this, so I've added Thomas Gleixner and linux-arm-kernel
> > mailing list to cc.
> >=20
> > If no such API is available, then maybe we can export some of
> > the omap_dm_timer functions if Thomas is OK with that.
>=20
> Just to update the status on this.. It seems that we'll be moving
> parts of plat/dmtimer into a minimal include/linux/timer-omap.h
> unless people have better ideas on what to do with custom
> hardware timers for PWM etc.

if it's really for PWM, shouldn't we be using drivers/pwm/ ??

Meaning that $SUBJECT would just request a PWM device and use it. That
doesn't solve the whole problem, however, as pwm-omap.c would still need
access to timer-omap.h.

--=20
balbi

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQy2E4AAoJEIaOsuA1yqREsesQAK30CFedD1Gas2SmqCJVh/tT
xsWHwNmBXKf02QuvNkfnNaiEbZF9cEn0Y/hrhHBmeMRBkwwfCXb6cxwm/2yds4Mb
7/RPnm59BcTa52bc03n0L6RjsW1zMIhtSSL1jphJHDJlvULtKvFv6akQ0UPiXVxO
rEFgZ7t1To/ZTtbJOYJ28uWsBJ6HhW4HJNORmTl4jgJx1w93KxbI8pF2mwlRMZr0
Pd2ca4V9zfvXaxEw6JN342ZyaGJhtm2Xm22amPJ2y0+zy8u/OwfthdAgFOR3askD
oh+74s01dAebTJOTUtxShA8Y/6SW+lhXcbMLlH99m5b1BxOhRtEL7FkO/b4OD3cW
oKcImVeH8KY/mrXY0yBxe+iOwVWS4UK9OCf6KOv8kU5V+XZp3k6I2PwGCzZWKihw
5PbxzFVJVUvlL9izH3qap8QP75yVjRYHXQPejj7hgdgpNvk1dKnEzC1lYA/vM7Gq
rXbF0WLEjBguK5zuxZiKq6/V0OJVVvFP7hKzP5ozQMQTMFZtJ+zRW2Nhm2w0FKwn
Fk0YPPPRCcGb4EAS4zoRWrL7/kr2J2IbolxeswJI2+dXBFETxFOjvzNLqtlXGJyr
rLSzH/PeBHgWVkNfBdXUC/wFJT0VQrmXML2EBe6Artg/Ysbj6O0Z59gjhKtTJPo1
CX0swDnAoGDueuENJ6ma
=FXYI
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
