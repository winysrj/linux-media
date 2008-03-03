Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JW6Vk-0005Vp-23
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 09:59:06 +0100
Date: Mon, 3 Mar 2008 09:52:49 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303085249.GA6419@paradigm.rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CB44A8.5060103@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0934719023=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0934719023==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 04:22:00AM +0400, Manu Abraham wrote:
> This won't work. params will contain data only after you have=20
> successfully issued
> SET_PARAMS not before. For SET_PARAMS to work, you need the delivery syst=
em
> cached for the operation.

As i already wrote - SET_PARAMS is _NOT_ enough. Please try yourself.=20
Unload/Load the module and simple issue a DVBFE_SET_PARAMS (NOT
GET_INFO) and it doesnt tune/lock at least for STB0899 and it also
complains in the dmesg with:

	stb0899_search: Unsupported delivery system 0
	stb0899_read_status: Unsupported delivery system 0
	stb0899_search: Unsupported delivery system 0
	stb0899_read_status: Unsupported delivery system 0
	stb0899_search: Unsupported delivery system 0
	stb0899_read_status: Unsupported delivery system 0

although i set

	dvbfe_params.delivery=3DDVBFE_DELSYS_DVBS2;

> Do you see the same bug with szap too ?=20
> (http://abraham.manu.googlepages.com/szap.c)

Its not a bug in szap - its a bug in the API - There is a delivery in
the dvbfe_param and i set it correctly - and it gets ignored. Running
zap before running my program causes it to work because zap runs
an GET_INFO ioctl which _SETS_ a delivery mode.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHy7xhUaz2rXW+gJcRAuGBAJ48liGYeNf1kWKylex979S20GBKDACfSuWF
vHJlbplFMvg54adjmPsc5bw=
=To0f
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--


--===============0934719023==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0934719023==--
