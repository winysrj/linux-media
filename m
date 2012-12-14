Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44752 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab2LNR4u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:56:50 -0500
Date: Fri, 14 Dec 2012 19:49:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214174918.GA11029@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
 <20121214172616.GC9620@arwen.pp.htv.fi>
 <20121214174629.GV4989@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20121214174629.GV4989@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 14, 2012 at 09:46:29AM -0800, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121214 09:36]:
> > Hi,
> >=20
> > On Fri, Dec 14, 2012 at 09:28:09AM -0800, Tony Lindgren wrote:
> > > * Tony Lindgren <tony@atomide.com> [121120 12:00]:
> > > > Hi,
> > > >=20
> > > > * Timo Kokkonen <timo.t.kokkonen@iki.fi> [121118 07:15]:
> > > > > --- a/drivers/media/rc/ir-rx51.c
> > > > > +++ b/drivers/media/rc/ir-rx51.c
> > > > > @@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *li=
rc_rx51)
> > > > >  			      OMAP_TIMER_TRIGGER_NONE);
> > > > >  }
> > > > > =20
> > > > > +static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
> > > > > +{
> > > > > +	if (lirc_rx51->wbuf_index < 0)
> > > > > +		return;
> > > > > +
> > > > > +	lirc_rx51_off(lirc_rx51);
> > > > > +	lirc_rx51->wbuf_index =3D -1;
> > > > > +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> > > > > +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> > > > > +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> > > > > +	wake_up(&lirc_rx51->wqueue);
> > > > > +}
> > > > > +
> > > > >  static int init_timing_params(struct lirc_rx51 *lirc_rx51)
> > > > >  {
> > > > >  	u32 load, match;
> > > >=20
> > > > Good fixes in general.. But you won't be able to access the
> > > > omap_dm_timer functions after we enable ARM multiplatform support
> > > > for omap2+. That's for v3.9 probably right after v3.8-rc1.
> > > >=20
> > > > We need to find some Linux generic API to use hardware timers
> > > > like this, so I've added Thomas Gleixner and linux-arm-kernel
> > > > mailing list to cc.
> > > >=20
> > > > If no such API is available, then maybe we can export some of
> > > > the omap_dm_timer functions if Thomas is OK with that.
> > >=20
> > > Just to update the status on this.. It seems that we'll be moving
> > > parts of plat/dmtimer into a minimal include/linux/timer-omap.h
> > > unless people have better ideas on what to do with custom
> > > hardware timers for PWM etc.
> >=20
> > if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> >=20
> > Meaning that $SUBJECT would just request a PWM device and use it. That
> > doesn't solve the whole problem, however, as pwm-omap.c would still need
> > access to timer-omap.h.
>=20
> That would only help with omap_dm_timer_set_pwm() I think.
>=20
> The other functions are also needed by the clocksource and clockevent
> drivers. And tidspbridge too:

well, we _do_ have drivers/clocksource ;-)

--=20
balbi

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQy2aeAAoJEIaOsuA1yqREnw4P/RzUA80xfINreNTrO6gsLYhq
uJj/YYLb6inB2KVu3tX8GRF1H0BVb0n4AOxG9MFpo1PxrMKeWQQdy9IgK6QbMUmH
c6RUea8qMtUJ+ICUamrpe5075PeY3Jax6Ri4UHHGqHZMIGLaSKS0ymfbKDLUgRWj
0tFwpJpdwbFKVAUDs9df9MIvUaJv4m6jLkWjtPbcyOPbrDmCbDa5CtdDiToz3FsL
s+BwLXBntGBWIM00BrbidG7DWUcb+zk3V4WM1IfeGFHBbXnDp/Lrt1LVcoUrWIcF
SOO13/gfTamDSdPW7qPu+YVIwIi12CF1JNU2osyUI+yj8aT6LEq4Y8MrpwNUE+DK
praOYjZbeuJP0WaH4+Y0xYKgvKsXEEnGRe6vOQr/W26pjRcAXovWCUUL1Rp/lmuL
HbX9ywilL5MUSkFMKZnVZV8NnCzkeWuKMotQ3Hwfsu/BF9CP4GQD35sBQaXMoPAi
8oNopDHuFxw8o1IPFNBa2DKPotx4rVuFjaah2MxaA4q3yT/Z1wGbbse6E59HqNBX
qn6ty3aInbnkah6dEb5KJ8/2af3lbK57txdPPTFuCC/60LtA7izMsD0WglL2/I2X
YdpeZV5AUt996NFyXcdtfOOg2I4SjTKZl+5Jl+L++B5ZE0GywrmCWLlyHrwzdgfA
x68r9r8O8MKoCPuvr0Gu
=Y3FW
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
