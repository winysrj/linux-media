Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JW8u3-0004YD-PJ
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 12:32:20 +0100
Date: Mon, 3 Mar 2008 12:26:10 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303112610.GC6419@paradigm.rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CBDC63.9030207@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0762010607=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0762010607==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 03:09:23PM +0400, Manu Abraham wrote:
> >As i already wrote - SET_PARAMS is _NOT_ enough. Please try yourself.=20
> >Unload/Load the module and simple issue a DVBFE_SET_PARAMS (NOT
> >GET_INFO) and it doesnt tune/lock at least for STB0899 and it also
> >complains in the dmesg with:
> >
> >	stb0899_search: Unsupported delivery system 0
> >	stb0899_read_status: Unsupported delivery system 0
> >	stb0899_search: Unsupported delivery system 0
> >	stb0899_read_status: Unsupported delivery system 0
> >	stb0899_search: Unsupported delivery system 0
> >	stb0899_read_status: Unsupported delivery system 0
> >
> >although i set
> >
> >	dvbfe_params.delivery=3DDVBFE_DELSYS_DVBS2;
>=20
> Yep, it isn't supposed to work that way with simply issuing SET_PARAMS.

Okay - So either=20

- remove the "delivery" in the dvbfe_params because it is unnecessary,
  confusing and broken, and rename the GET_INFO call to SET_DELIVERY
  or something which implies that its not a _GET_ call

or=20

- make SET_PARAMS the call to honor delivery in dvbfe_params and remove
  the setting of the delivery of GET_INFO

I'd prefere the 2nd option because currently the usage and naming
is an incoherent mess which should better not get more adopters ..

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHy+BSUaz2rXW+gJcRAkCOAKCK138ec+ExHOypGym8EoWnDlKO2QCfSGMg
qNehhLQemJiaBj47hXOXGnc=
=JVbn
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--


--===============0762010607==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0762010607==--
