Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51039 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab1DRWtD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 18:49:03 -0400
Received: by vxi39 with SMTP id 39so3859273vxi.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 15:49:01 -0700 (PDT)
Date: Mon, 18 Apr 2011 18:48:55 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
Message-ID: <20110418224855.GB4611@mgebm.net>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
 <1301922737.5317.7.camel@morgan.silverblock.net>
 <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
 <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
 <1302015521.4529.17.camel@morgan.silverblock.net>
 <BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
 <1302481535.2282.61.camel@localhost>
 <20110411163239.GA4324@mgebm.net>
 <20110418141514.GA4611@mgebm.net>
 <ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Apr 2011, Andy Walls wrote:

> Eric B Munson <emunson@mgebm.net> wrote:
>=20
> >On Mon, 11 Apr 2011, Eric B Munson wrote:
> >
> >> On Sun, 10 Apr 2011, Andy Walls wrote:
> >>=20
> >> > On Wed, 2011-04-06 at 13:28 -0400, Eric B Munson wrote:
> >> > > On Tue, Apr 5, 2011 at 10:58 AM, Andy Walls
> ><awalls@md.metrocast.net> wrote:
> >> > > > On Mon, 2011-04-04 at 14:36 -0400, Eric B Munson wrote:
> >> > > >> On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson
> ><emunson@mgebm.net> wrote:
> >> > > >> > On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls
> ><awalls@md.metrocast.net> wrote:
> >> > > >> >> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
> >> > > >> >>> I the above mentioned capture card and the digital side of
> >the card
> >> > > >> >>> works well.  However, when I try to get video from the
> >analog side of
> >> > > >> >>> the card, all I get is a red screen and no sound
> >regardless of channel
> >> > > >> >>> requested.  This is a problem I see in 2.6.39-rc1 though I
> >typically
> >> > > >> >>> run the ubuntu 10.10 kernel with the newest drivers built
> >from source.
> >> > > >> >>>  Is there something in setup or configuration that I may
> >be missing?
> >> > > >> >>
> >> > > >> >> Eric,
> >> > > >> >>
> >> > > >> >> You are likely missing the last 3 fixes here:
> >> > > >> >>
> >> > > >> >>
> >http://git.linuxtv.org/awalls/media_tree.git?a=3Dshortlog;h=3Drefs/heads=
/cx18_39
> >> > > >> >>
> >> > > >> >> (one of which is critical for analog to work).
> >> > > >> >>
> >> > > >> >> Also check the ivtv-users and ivtv-devel list for past
> >discussions on
> >> > > >> >> the "red screen" showing up for known well supported models
> >and what to
> >> > > >> >> try.
> >> > > >> >>
> >> > > >> > Thanks, I will try hand applying these.
> >> > > >> >
> >> > > >>
> >> > > >> I don't have a red screen anymore, now all get from analog
> >static and
> >> > > >> mythtv's digital channel scanner now seems broken.
> >> > > >
> >> > > > Hmmm.
> >> > > >
> >> > > > 1. Please provide the output of dmesg when the cx18 driver
> >loads.
> >> > >=20
> >>=20
> >> [332935.115343] cx18:  Start initialization, version 1.4.1
> >> [332935.115385] cx18-0: Initializing card 0
> >> [332935.115389] cx18-0: Autodetected Hauppauge card
> >> [332935.115449] cx18 0000:04:01.0: PCI INT A -> GSI 16 (level, low)
> >-> IRQ 16
> >> [332935.127005] cx18-0: cx23418 revision 01010000 (B)
> >> [332935.342426] tveeprom 0-0050: Hauppauge model 74351, rev F1F5,
> >serial# 7384278
> >> [332935.342432] tveeprom 0-0050: MAC address is 00:0d:fe:70:ac:d6
> >> [332935.342437] tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155,
> >type 54)
> >> [332935.342443] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I)
> >SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> >> [332935.342448] tveeprom 0-0050: audio processor is CX23418 (idx 38)
> >> [332935.342453] tveeprom 0-0050: decoder processor is CX23418 (idx
> >31)
> >> [332935.342457] tveeprom 0-0050: has no radio
> >> [332935.342460] cx18-0: Autodetected Hauppauge HVR-1600
> >> [332935.392016] cx18-0: Simultaneous Digital and Analog TV capture
> >supported
> >> [332935.497007] tuner 1-0042: Tuner -1 found with type(s) Radio TV.
> >> [332935.501259] cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver
> >#0-0)
> >> [332935.548567] tda829x 1-0042: setting tuner address to 60
> >> [332935.572554] tda18271 1-0060: creating new instance
> >> [332935.612568] TDA18271HD/C2 detected @ 1-0060
> >> [332936.676587] tda18271: performing RF tracking filter calibration
> >> [332950.816567] tda18271: RF tracking filter calibration complete
> >> [332950.864571] tda829x 1-0042: type set to tda8295+18271
> >> [332951.569137] cx18-0: Registered device video0 for encoder MPEG (64
> >x 32.00 kB)
> >> [332951.569143] DVB: registering new adapter (cx18)
> >> [332951.672187] tda18271 0-0060: creating new instance
> >> [332951.678691] TDA18271HD/C2 detected @ 0-0060
> >> [332951.737797] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332
> >bytes)
> >> [332951.876157] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
> >(141200 bytes)
> >> [332951.882195] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
> >> [332951.984040] DVB: registering adapter 0 frontend 0 (Samsung
> >S5H1411 QAM/8VSB Frontend)...
> >> [332951.984208] cx18-0: DVB Frontend registered
> >> [332951.984214] cx18-0: Registered DVB adapter0 for TS (32 x 32.00
> >kB)
> >> [332951.984268] cx18-0: Registered device video32 for encoder YUV (20
> >x 101.25 kB)
> >> [332951.984320] cx18-0: Registered device vbi0 for encoder VBI (20 x
> >51984 bytes)
> >> [332951.984367] cx18-0: Registered device video24 for encoder PCM
> >audio (256 x 4.00 kB)
> >> [332951.984372] cx18-0: Initialized card: Hauppauge HVR-1600
> >> [332951.984415] cx18:  End initialization
> >> [332951.994916] cx18-alsa: module loading...
> >> [332952.733994] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382
> >bytes)
> >> [332952.753703] cx18-0 843: verified load of v4l-cx23418-dig.fw
> >firmware (16382 bytes)
> >>=20
> >> > > > 3. Please provide the relevant portion of the mythbackend log
> >where
> >> > > > where the digital scanner starts and then fails.
> >> > >=20
> >> > > So the Digital scanner doesn't fail per se, it just doesn't pick
> >up
> >> > > most of the digital channels available.  The same is true of
> >scan, it
> >> > > seems to find only 1 channel when I know that I have access to
> >18.
> >> >=20
> >> > Make sure it's not a signal integrity problem:
> >> >=20
> >> > 	http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
> >> >=20
> >> > wild speculation: If the analog tuner driver init failed, maybe
> >that is
> >> > having some bad EMI efect on the digital tuner
> >> >=20
> >> > I'm assumiong you got more than the 1 channel before trying to
> >enable
> >> > analog tuning.A
> >>=20
> >> That is true, when I was running the backported drivers on the Ubuntu
> >10.10
> >> kernel I was able to see 16 of the 18 available to me.
> >>=20
> >> >=20
> >> > > >
> >> > > > 4. Does digital tuning still work in MythTV despite the digital
> >scanner
> >> > > > not working?
> >> > >=20
> >> > > Using the command line tools you linked I am able to tune to the
> >> > > channel that is found and watch it via mplayer.
> >> >=20
> >> > Can you tune to other known digital channels?
> >>=20
> >> I will have to see if I can set one up by hand and try it.  I will
> >get back to
> >> you when I am able to do this (should be later today).
> >>=20
> >> >=20
> >> > > Let me know if you need anything else.
> >> >=20
> >> > Are you tuning digital cable (North American QAM) or digital Over
> >The
> >> > Air (ATSC)?
> >>=20
> >> I am using digital cable (NA QAM).
> >>=20
> >
> >Is there anything else I can provide to help with this?
>=20
> Eric,
>=20
> Sorry for not getting back sooner (I've been dealing with a personal situ=
ation and haven't logged into my dev system for a few weeks).
>=20
> What rf analog source are you using?

Sorry, very new to this, I am not sure what you are asking for here.

> Have you used v4l2-ctl to ensure the tuner is set to the right tv standar=
d (my changes default to NTSC-M)?

emunson@grover:~$ v4l2-ctl -S
Video Standard =3D 0x0000b000
	NTSC-M/M-JP/M-KR
emunson@grover:~$ v4l2-ctl -s ntsc
Standard set to 0000b000
emunson@grover:~$ v4l2-ctl -S
Video Standard =3D 0x0000b000
	NTSC-M/M-JP/M-KR

What should the default be?  NTSC-443?  When I set to NTSC-443 I see the sa=
me
behaviour as below when I try and change channels.

> Have you used v4l2-ctl or ivtv-tune to tune to the proper tv channel (the=
 driver defaults to US channel 4)?

emunson@grover:~$ v4l2-ctl -F
Frequency: 0 (0.000000 MHz)
emunson@grover:~$ v4l2-ctl -f 259.250
Frequency set to 4148 (259.250000 MHz)
emunson@grover:~$ v4l2-ctl -F
Frequency: 0 (0.000000 MHz)


> Does v4l2-ctl --log-status still show no signal present for the '843 core=
 in the CX23418?

Yeah,
   [94465.349721] cx18-0 843: Video signal:              not present

> Does mplayer /dev/videoN -cache 8192 have a tv station when set to the rf=
 analog input with v4l2-ctl?

emunson@grover:~$ mplayer /dev/video0 -cache 8192
MPlayer 1.0rc4-4.4.5 (C) 2000-2010 MPlayer Team

Playing /dev/video0.
Cache fill:  0.00% (0 bytes)


Exiting... (End of file)

>=20
> From what I recall the analog tuner init looked ok.
> -Andy
>=20

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNrL/XAAoJEH65iIruGRnNPdkIAKHutc1k/TBHD482dA/M5xct
k7S1575kmI6v1dghoRY3wD7QxfJjhXRVNgh7SVwUYPM4g2YmiiM8UXp5B4+oGGjs
QuZX4YKMQmxwYxd4m2dZhFsBK6lz+1F+v+utoMwqvgiU8H06w5IwS7w0sQ7PYDxu
Bt+PQREFeY92zFRnr3zeQOADiTAul4zK6nbDklCd3DJ7iLkxPCXNcl+LgQo4uGcN
vVIWs/qtWpi3cHmzzFpXWLqFRjoqADLHEQ2TXOQRaFqAZ/r7y/IMSlsMKjnfSb4g
FnGInBac2Uza7qxqLInvfcN/XSzUI6b/75XWkZPdqPNYvusezLL1sxgQoVhVdiE=
=7aZp
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
