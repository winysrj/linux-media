Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50608 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab1DKQcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 12:32:47 -0400
Received: by qyk7 with SMTP id 7so1391264qyk.19
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 09:32:47 -0700 (PDT)
Date: Mon, 11 Apr 2011 12:32:39 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
Message-ID: <20110411163239.GA4324@mgebm.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
 <1301922737.5317.7.camel@morgan.silverblock.net>
 <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
 <1302015521.4529.17.camel@morgan.silverblock.net>
 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
 <1302481535.2282.61.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1302481535.2282.61.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Apr 2011, Andy Walls wrote:

> On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
> > On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls <awalls@md.metrocast.net> w=
rote:
> > > On Mon, 2011-04-04 at 14:36 -0400, Eric B Munson wrote:
> > >> On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson <emunson@mgebm.net> w=
rote:
> > >> > On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls <awalls@md.metrocast.ne=
t> wrote:
> > >> >> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
> > >> >>> I the above mentioned capture card and the digital side of the c=
ard
> > >> >>> works well.  However, when I try to get video from the analog si=
de of
> > >> >>> the card, all I get is a red screen and no sound regardless of c=
hannel
> > >> >>> requested.  This is a problem I see in 2.6.39-rc1 though I typic=
ally
> > >> >>> run the ubuntu 10.10 kernel with the newest drivers built from s=
ource.
> > >> >>>  Is there something in setup or configuration that I may be miss=
ing?
> > >> >>
> > >> >> Eric,
> > >> >>
> > >> >> You are likely missing the last 3 fixes here:
> > >> >>
> > >> >> http://git.linuxtv.org/awalls/media_tree.git?a=3Dshortlog;h=3Dref=
s/heads/cx18_39
> > >> >>
> > >> >> (one of which is critical for analog to work).
> > >> >>
> > >> >> Also check the ivtv-users and ivtv-devel list for past discussion=
s on
> > >> >> the "red screen" showing up for known well supported models and w=
hat to
> > >> >> try.
> > >> >>
> > >> > Thanks, I will try hand applying these.
> > >> >
> > >>
> > >> I don't have a red screen anymore, now all get from analog static and
> > >> mythtv's digital channel scanner now seems broken.
> > >
> > > Hmmm.
> > >
> > > 1. Please provide the output of dmesg when the cx18 driver loads.
> >=20

[332935.115343] cx18:  Start initialization, version 1.4.1
[332935.115385] cx18-0: Initializing card 0
[332935.115389] cx18-0: Autodetected Hauppauge card
[332935.115449] cx18 0000:04:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[332935.127005] cx18-0: cx23418 revision 01010000 (B)
[332935.342426] tveeprom 0-0050: Hauppauge model 74351, rev F1F5, serial# 7=
384278
[332935.342432] tveeprom 0-0050: MAC address is 00:0d:fe:70:ac:d6
[332935.342437] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type =
54)
[332935.342443] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM=
(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[332935.342448] tveeprom 0-0050: audio processor is CX23418 (idx 38)
[332935.342453] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
[332935.342457] tveeprom 0-0050: has no radio
[332935.342460] cx18-0: Autodetected Hauppauge HVR-1600
[332935.392016] cx18-0: Simultaneous Digital and Analog TV capture supported
[332935.497007] tuner 1-0042: Tuner -1 found with type(s) Radio TV.
[332935.501259] cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[332935.548567] tda829x 1-0042: setting tuner address to 60
[332935.572554] tda18271 1-0060: creating new instance
[332935.612568] TDA18271HD/C2 detected @ 1-0060
[332936.676587] tda18271: performing RF tracking filter calibration
[332950.816567] tda18271: RF tracking filter calibration complete
[332950.864571] tda829x 1-0042: type set to tda8295+18271
[332951.569137] cx18-0: Registered device video0 for encoder MPEG (64 x 32.=
00 kB)
[332951.569143] DVB: registering new adapter (cx18)
[332951.672187] tda18271 0-0060: creating new instance
[332951.678691] TDA18271HD/C2 detected @ 0-0060
[332951.737797] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
[332951.876157] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (14120=
0 bytes)
[332951.882195] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
[332951.984040] DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/=
8VSB Frontend)...
[332951.984208] cx18-0: DVB Frontend registered
[332951.984214] cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
[332951.984268] cx18-0: Registered device video32 for encoder YUV (20 x 101=
=2E25 kB)
[332951.984320] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 =
bytes)
[332951.984367] cx18-0: Registered device video24 for encoder PCM audio (25=
6 x 4.00 kB)
[332951.984372] cx18-0: Initialized card: Hauppauge HVR-1600
[332951.984415] cx18:  End initialization
[332951.994916] cx18-alsa: module loading...
[332952.733994] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[332952.753703] cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (1=
6382 bytes)

> > > 3. Please provide the relevant portion of the mythbackend log where
> > > where the digital scanner starts and then fails.
> >=20
> > So the Digital scanner doesn't fail per se, it just doesn't pick up
> > most of the digital channels available.  The same is true of scan, it
> > seems to find only 1 channel when I know that I have access to 18.
>=20
> Make sure it's not a signal integrity problem:
>=20
> 	http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
>=20
> wild speculation: If the analog tuner driver init failed, maybe that is
> having some bad EMI efect on the digital tuner
>=20
> I'm assumiong you got more than the 1 channel before trying to enable
> analog tuning.A

That is true, when I was running the backported drivers on the Ubuntu 10.10
kernel I was able to see 16 of the 18 available to me.

>=20
> > >
> > > 4. Does digital tuning still work in MythTV despite the digital scann=
er
> > > not working?
> >=20
> > Using the command line tools you linked I am able to tune to the
> > channel that is found and watch it via mplayer.
>=20
> Can you tune to other known digital channels?

I will have to see if I can set one up by hand and try it.  I will get back=
 to
you when I am able to do this (should be later today).

>=20
> > Let me know if you need anything else.
>=20
> Are you tuning digital cable (North American QAM) or digital Over The
> Air (ATSC)?

I am using digital cable (NA QAM).

>=20
> I tune ATSC with a high gain antenna and a Winegard preamplifer for
> fringe areas; I'm 75 miles away from the city.  One of the most
> important contributions to getting a good signal was a lightning
> protection/grounding block for the coaxial cable shield near the antenna
> end of the cable.  I suspect I was picking up a lot of EMI from in-home
> sources and other local sources.
>=20
> If using a preamp, make sure you are not over-amplifying the signal.  It
> will cause clipping in the tuner's front end, inducing intermodulation
> products which look like noise and degrade the SNR.
>=20
> Regards,
> Andy
>=20
>=20
>=20

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNoy0nAAoJEH65iIruGRnNntYH+wQh814/EWQs2C/8ATIcrfVh
Le6UjpVZvCWgVQdbpiAM1GwpZAs/1otcNxKYwahDybnZl0WjAumTWezubxJvCoqz
IAlCyZmeBnuXubXshMzNa4JBBdj/bG+ieVSCn8HIo/4X1iFMK4vLEfQ/r4+c4X5L
7t/HbgOsjO2WbWmklqbDRnuFaKi5G9vX0T7QujShFdvvRdWWYnBuUXOMbHH1w5uC
JkjRtoKzcIC6TEjhCDpi8nXNv/cdeShLtWjG6UqLyTztPolNHy9NnujfvrLoztxv
pQMC8XYFfoN9YGqY7IyYkZ2z8o9kPOjK/bMkdXJYzzxhbnuqJCY6OKS6u09fhPo=
=3HhF
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
