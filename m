Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JWB7g-0008FS-LF
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:54:32 +0100
Date: Mon, 3 Mar 2008 14:48:23 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303134823.GB12328@paradigm.rfc822.org>
References: <47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com> <47CC0201.5010701@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CC0201.5010701@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1110174978=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1110174978==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 05:49:53PM +0400, Manu Abraham wrote:
> Basically you seem to get the wrong end, (it's one whole line, no corners
> to it) since you think that it all starts with a tune operation. No, a tu=
ne
> operation is not the first operation that's to be done in many cases.

A tune operation might not be the first thing to do in a GUI based
operation where the user gets presented with a little capability show
and clickable channel lists etc ...

But there are application which simple want to tune with a user
defined configuration and simply want to tune or to get an error
and let the user sort it out. I dont care about the capabilities
of a frontend or stats - i want to tune - And when i open the
frontend and issue an ioctl which passes a struct with ALL INFORMATIONS
NECESSARY TO TUNE i expect it to do exactly that - to tune and not
to bail out with an error because i didnt ask for capabilites via
GET_INFO ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzAGnUaz2rXW+gJcRAgAPAJ9I2aaNxolwx1q9LAEk2JOlMzcEvgCg0VxV
Ta4Yy6ciYy8bpXck2ioiC/o=
=1iD5
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--


--===============1110174978==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1110174978==--
