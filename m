Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JVURh-00074e-EV
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 17:20:21 +0100
Date: Sat, 1 Mar 2008 17:14:19 +0100
From: Florian Lohoff <flo@rfc822.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080301161419.GB12800@paradigm.rfc822.org>
MIME-Version: 1.0
Subject: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1194625081=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1194625081==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
i was wondering why i have a problem in my application that i need to
run scan once after loading the module, otherwise my DVBFE_SET_PARAMS
fails - I couldnt explain it until i looked into the kernel code - In
the dvb_frontend.c i see this code:

1738         case DVBFE_SET_PARAMS: {
1739                 struct dvb_frontend_tune_settings fetunesettings;
1740                 enum dvbfe_delsys delsys =3D fepriv->fe_info.delivery;
=2E..
1783                 } else {
1784                         /* default values */
1785                         switch (fepriv->fe_info.delivery) {
=2E..
1817                         default:
1818                                 up(&fepriv->sem);
1819                                 return -EINVAL;
1820                         }

Should the code use fepriv->feparam.delivery instead of
fepriv->fe_info.delivery to sense the right delivery system ?

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyYDbUaz2rXW+gJcRAoSrAJwOHH/v6RsLcL0+s5p1UlakHUdJUwCfa65Y
kwyGaCKuMOxtEXH5GQ4iYYQ=
=cK6b
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--


--===============1194625081==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1194625081==--
