Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JWBft-0004u6-Bk
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:29:55 +0100
Date: Mon, 3 Mar 2008 15:23:43 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303142343.GG12328@paradigm.rfc822.org>
References: <47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com> <47CC0201.5010701@gmail.com>
	<20080303134823.GB12328@paradigm.rfc822.org>
	<47CC055C.5030705@gmail.com>
	<20080303140316.GD12328@paradigm.rfc822.org>
	<47CC0896.3050308@gmail.com>
	<20080303141358.GF12328@paradigm.rfc822.org>
	<47CC0A32.1040807@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CC0A32.1040807@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1246466912=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1246466912==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 06:24:50PM +0400, Manu Abraham wrote:
> >On Mon, Mar 03, 2008 at 06:17:58PM +0400, Manu Abraham wrote:
> >>>You mean tune and then check if there is a SIGNAL and possibly a LOCK?=
 I
> >>>do that yes ... But first comes the tune - On an uninitialized state of
> >>>a demod/tuner i would not expect to see any signal.
> >>How do you expect to look for a signal level when using a rotor, for a=
=20
> >>real life example ?
> >
> >In case of a rotor i expect the diseq commands to go out - tune the
> >frontend for the right modulation and frequency and then monitor the
> >signal level while turning the dish.
> >
> >This needs tuning - right ?
>=20
> No, this is fed from the AGC1 path1 integrator and the AGC1 path2=20
> integrator.

Okay - you say turning the dish does not need tuning - so i issue
the DISEQ ioctls and start reading the signal level - whats the point
and what is this an argument for?

- How can this excuse ignoring the delivery in the DVBFE_SET_PARAMS?
- How can this justify setting the delivery system in DVBFE_GET_INFO ?

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzAnvUaz2rXW+gJcRAsxPAJ9hwV2WFg2isOGlUxw6rxoPkZak4wCfazfW
T2/IRvypKVwKW3yEoIIGBlo=
=NTcW
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--


--===============1246466912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1246466912==--
