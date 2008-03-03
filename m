Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JWBWR-0003PV-97
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:20:09 +0100
Date: Mon, 3 Mar 2008 15:13:58 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303141358.GF12328@paradigm.rfc822.org>
References: <47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com> <47CC0201.5010701@gmail.com>
	<20080303134823.GB12328@paradigm.rfc822.org>
	<47CC055C.5030705@gmail.com>
	<20080303140316.GD12328@paradigm.rfc822.org>
	<47CC0896.3050308@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CC0896.3050308@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1873081303=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1873081303==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 06:17:58PM +0400, Manu Abraham wrote:
> >You mean tune and then check if there is a SIGNAL and possibly a LOCK? I
> >do that yes ... But first comes the tune - On an uninitialized state of
> >a demod/tuner i would not expect to see any signal.
>=20
> How do you expect to look for a signal level when using a rotor, for a=20
> real life example ?

In case of a rotor i expect the diseq commands to go out - tune the
frontend for the right modulation and frequency and then monitor the
signal level while turning the dish.

This needs tuning - right ?

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzAemUaz2rXW+gJcRAte+AKDRvokHHSTLBo1nGD+vDXBiBkN+UwCg4FUO
OdoblyOGLKCcNDyiQU815jI=
=ktG8
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--


--===============1873081303==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1873081303==--
