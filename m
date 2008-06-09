Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K5mNR-0003Or-2e
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 20:45:57 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Mon, 9 Jun 2008 20:45:21 +0200
References: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
	<484CD9F5.60906@okg-computer.de> <20080609205900.69768a02@bk.ru>
In-Reply-To: <20080609205900.69768a02@bk.ru>
MIME-Version: 1.0
Message-Id: <200806092045.22041.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] scan & szap for new multiproto api (was - How to
	get a PCTV Sat HDTC Pro USB (452e) running?)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0362307754=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0362307754==
Content-Type: multipart/signed;
  boundary="nextPart1253115.AdllG7VyvT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1253115.AdllG7VyvT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 09 June 2008, Goga777 wrote:
> Hi
>=20
> > >> I'm glad everything worked out for you :).
> > >> with szap to tune to DVB-S2 channels use this option "-t 2" default =
is
> > >> "- t 0" which is for DVB-S
> > >> to tune to 'Astra HD Promo 2' you do:
> > >> szap -r -c 19 -t 2 "Astra HD Promo 2"
> > >>    =20
> > >
> > > I will try so. It will be fine if new dvb-s2 option will include in s=
zap --help output
> > >  =20
> >=20
> > jens@midas-phalanx:/usr/src/dvb-apps-patched/util/szap# ./szap -h
> >=20
> > usage: szap -q
> >          list known channels
> >        szap [options] {-n channel-number|channel_name}
> >          zap to channel via number or full name (case insensitive)
> >      -a number : use given adapter (default 0)
> >      -f number : use given frontend (default 0)
> >      -d number : use given demux (default 0)
> >      -c file   : read channels list from 'file'
> >      -b        : enable Audio Bypass (default no)
> >      -x        : exit after tuning
> >      -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
> >      -l lnb-type (DVB-S Only) (use -l help to print types) or
> >      -l low[,high[,switch]] in Mhz
> >      -i        : run interactively, allowing you to type in channel nam=
es
> >      -p        : add pat and pmt to TS recording (implies -r)
> >                  or -n numbers for zapping
> >           -t        : delivery system type DVB-S=3D0, DSS=3D1, DVB-S2=
=3D2
> >=20
> >=20
> > You see the last line? The Information is included!! ;-)
>=20
> yes, I see. But in my patched szap I don't see this information. I don't =
know why :(
>=20
> /usr/src/dvb-apps# cat patch_scan_szap_jens.diff | patch -p1 --dry-run
Why do you use the --dry-run option here?=20
man patch=20
shows:
 - -dry-run=20
 Print the results of applying the patches without actually changing any fi=
les.



Dominik

--nextPart1253115.AdllG7VyvT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhNekIACgkQ6OXrfqftMKIsbACgjZ0/mjKSAXRP5PSPjSrK0PVs
nxEAn2LPIjQplvZlLU/JWxJO9Yv9vN1M
=2Kfn
-----END PGP SIGNATURE-----

--nextPart1253115.AdllG7VyvT--


--===============0362307754==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0362307754==--
