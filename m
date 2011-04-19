Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34885 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1DSRU3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 13:20:29 -0400
Received: by vws1 with SMTP id 1so4414114vws.19
        for <linux-media@vger.kernel.org>; Tue, 19 Apr 2011 10:20:28 -0700 (PDT)
Date: Tue, 19 Apr 2011 13:12:20 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
Message-ID: <20110419171220.GA4883@mgebm.net>
References: <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
 <1302015521.4529.17.camel@morgan.silverblock.net>
 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
 <1302481535.2282.61.camel@localhost>
 <20110411163239.GA4324@mgebm.net>
 <20110418141514.GA4611@mgebm.net>
 <ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
 <20110418224855.GB4611@mgebm.net>
 <1303215523.2274.27.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <1303215523.2274.27.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Apr 2011, Andy Walls wrote:

> On Mon, 2011-04-18 at 18:48 -0400, Eric B Munson wrote:
> > On Mon, 18 Apr 2011, Andy Walls wrote:
> >=20
> > > Eric B Munson <emunson@mgebm.net> wrote:
> > >=20
> > > >On Mon, 11 Apr 2011, Eric B Munson wrote:
> > > >
> > > >> On Sun, 10 Apr 2011, Andy Walls wrote:
> > > >>=20
> > > >> > On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
> > > >> > > On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls
>=20
> > > >
> > > >Is there anything else I can provide to help with this?
> > >=20
> > > Eric,
> > >=20
> > > Sorry for not getting back sooner (I've been dealing with a personal
> > situation and haven't logged into my dev system for a few weeks).
> > >=20
> > > What rf analog source are you using?
> >=20
> > Sorry, very new to this, I am not sure what you are asking for here.
>=20
> I mean: analog cable, DTV Set Top Box (STB), VCR, etc.
>=20
> I have only tested the driver on analog US Broadcast Channel 3, since I
> only have a DTV STB as an RF analog TV source.

I am using analog cable.  Cable here is about 25% digital and 75% analog.

>=20
>=20
>=20
> > > Have you used v4l2-ctl to ensure the tuner is set to the right tv
> > standard (my changes default to NTSC-M)?
> >=20
> > emunson@grover:~$ v4l2-ctl -S
> > Video Standard =3D 0x0000b000
> > 	NTSC-M/M-JP/M-KR
> > emunson@grover:~$ v4l2-ctl -s ntsc
> > Standard set to 0000b000
> > emunson@grover:~$ v4l2-ctl -S
> > Video Standard =3D 0x0000b000
> > 	NTSC-M/M-JP/M-KR
> >=20
> > What should the default be?  NTSC-443?  When I set to NTSC-443 I see
> > the same behaviour as below when I try and change channels.
>=20
> NTSC-M is the default.  Having it set to autodetect the US, Japanese
> (-JP), or South Korean (-KR) variants is OK.
>=20
> Never use NTSC-443 as you likely will never encounter it in your life.
> NTSC-443 is never broadcast over the air or cable.  It is a weird
> combination of NTSC video usings a PAL color subcarrier frequency.
>=20
>=20
>=20
>=20
> > > Have you used v4l2-ctl or ivtv-tune to tune to the proper tv channel
> > (the driver defaults to US channel 4)?
> >=20
> > emunson@grover:~$ v4l2-ctl -F
> > Frequency: 0 (0.000000 MHz)
> > emunson@grover:~$ v4l2-ctl -f 259.250
> > Frequency set to 4148 (259.250000 MHz)
> > emunson@grover:~$ v4l2-ctl -F
> > Frequency: 0 (0.000000 MHz)
>=20
> OK, that doesn't look good.  The tda18271 tuner and/or tda8290 demod
> drivers may not be working right.
>=20
> I'll have to look into that later this week.
>=20
> BTW, Mike Krufky just submitted some patches that may be relevant:
>=20
> 	http://kernellabs.com/hg/~mkrufky/tda18271-fix
>=20

I have applied these patches and I am still seeing the same problem (freque=
ncy
still report 0 after being set) and mplayer still closes immediately.

>=20
> >=20
> > > Does v4l2-ctl --log-status still show no signal present for the '843 =
core in the CX23418?
> >=20
> > Yeah,
> >    [94465.349721] cx18-0 843: Video signal:              not present
>=20
> The tuner or demod isn't tuning to a channel or getting a signal.
>=20
> Can you try channel 3 (61.250 MHz)?  That one works for me.

Still shows not present on channel 3.

>=20
>=20
> > > Does mplayer /dev/videoN -cache 8192 have a tv station when set to th=
e rf analog input with v4l2-ctl?
> >=20
> > emunson@grover:~$ mplayer /dev/video0 -cache 8192
> > MPlayer 1.0rc4-4.4.5 (C) 2000-2010 MPlayer Team
> >=20
> > Playing /dev/video0.
> > Cache fill:  0.00% (0 bytes)
> >=20
> >=20
> > Exiting... (End of file)
>=20
> Hmmm.  I would have expected at least a black picture with snow, if not
> tuned to a channel.
>=20
> Does analog S-Video or Composite work?

Unfortunately, I do not have anything I can use to test these.  The card on=
ly
takes coaxial or S-Video input and I don't have any sort of S-Video cables =
or
converters.

Eric

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNrcJ0AAoJEH65iIruGRnNKFcIALBi800ZiCJc6bD9kcoQH3ZH
A3nnmX2SjoTc7Y476fOHkCU5YC5k5Z/9j0fAwkwHFRLwjQjD1u6mkSyIxOdQVfYa
UyGV6cwmZsef+2yBodsYW+vWfMibpM2H5Dvz3jsC1zuX7uAOjNeKWgPRT431ActO
Bpy34Ct/+79pXgVC/PBiI7vbdV5ujAEgw9XtygvTs/bSNOwDklik5HVZA6RDX88z
jKjAJpWogS/p9wtRUt1+ODRH2GzMXeuzD2Bzt/NxKQfabhsLoOg7uPrWNb7ha485
JDRlLdSnVkVvXRCEZVvGjgANSJWsFJZX7qceqWElKXnZaaJXhGunAbFLKg/mMeM=
=Fk61
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
