Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K5oI7-0002iN-UJ
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 22:48:36 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Mon, 9 Jun 2008 22:48:01 +0200
References: <200806071627.30907.dkuhlen@gmx.net>
	<484C056E.7010002@schoeller-soft.net>
In-Reply-To: <484C056E.7010002@schoeller-soft.net>
MIME-Version: 1.0
Message-Id: <200806092248.01786.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] pctv452e and TT-S2-3600 step-by-step howto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0142904354=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0142904354==
Content-Type: multipart/signed;
  boundary="nextPart1585903.XJFDyyvv8G";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1585903.XJFDyyvv8G
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 June 2008, Michael Sch=F6ller wrote:
> Dominik Kuhlen schrieb:
> > Hi,
> >
> > I have attached a step-by-step howto for these devices
> >
> >
> > Happy testing,
> >  Dominik
> >
> >  =20
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> Well bad news...it's not working.
> I try to notice any difference in my system to your description and well=
=20
> it's not much...
> My dmesg line:
>=20
> stb0899_get_dev_id: Device ID=3D[3], Release=3D[1]
>=20
> Your dmesg line:
>=20
> stb0899_get_dev_id: Device ID=3D[3], Release=3D[0]
>=20
> all other dmesg messages are identical.
>=20
>  next difference
>=20
> ls -l /dev/dvb/adapter0/
> # total 0
> # crw------- 1 schomi root 212, 4 Jun  7 15:37 demux0
> # crw------- 1 schomi root 212, 5 Jun  7 15:37 dvr0
> # crw------- 1 schomi root 212, 3 Jun  7 15:37 frontend0
> # crw------- 1 schomi root 212, 7 Jun  7 15:37 net0
>=20
> well just do be sure I also tried chmod a+rw * but that didn't change any=
thing. Well since schomi is my user I think that should be ok...
>=20
> So now to the real problem...
> ./simpledvbtune -f 11954
> using '/dev/dvb/adapter0/frontend0' as frontend
> frontend fd=3D3: type=3D0
> DVBFE_SET_DELSYS: Invalid argument
> ioclt: FE_SET_VOLTAGE : 1
> High band
> tone: 1
> dvbfe setparams :  delsys=3D1 1354MHz / Rate : 27500kBPS
> DVBFE_SET_PARAMS: Invalid argument
> tuning qpsk failed
Hmm, this is strange. looks like you are using old drivers or old dvb-core =
module that doesn't support the new ioctls
Did you load the modules with
insmod ./dvb-core.ko
insmod ./dvb-usb.ko
insmod ./lnbp22.ko
insmod ./stb0899.ko
insmod ./stb6100.ko
insmod ./dvb-usb-pctv452e.ko
to be sure that no old/other modules were used?

>=20
> @Dominik
> By any chance do you live in austria and can visit me ^^.
No, sorry I don't.
>=20
> Michael
>=20
>=20
>=20

Dominik


--nextPart1585903.XJFDyyvv8G
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhNlwEACgkQ6OXrfqftMKL1cQCfbBylXPK4CgjX9A508MSAYwZm
Mk0An0loUn02yN/LGuwo1rpbv0PV6pu7
=dxE/
-----END PGP SIGNATURE-----

--nextPart1585903.XJFDyyvv8G--


--===============0142904354==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0142904354==--
