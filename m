Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hydra.gt.owl.de ([195.71.99.218])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <flo@rfc822.org>) id 1JWBJL-0001PP-Dk
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:06:37 +0100
Date: Mon, 3 Mar 2008 15:00:26 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080303140026.GC12328@paradigm.rfc822.org>
References: <20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com>
	<20080303134444.GA12328@paradigm.rfc822.org>
	<47CC0364.3010600@gmail.com>
MIME-Version: 1.0
In-Reply-To: <47CC0364.3010600@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1072960963=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1072960963==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2008 at 05:55:48PM +0400, Manu Abraham wrote:
> I already mentioned this in my previous email. Please read the previous=
=20
> mails and or the old discussions.

Would you point the mail to me where you did - I cant find any - You
said that for GET_PARAMS you need the space to store it. I ask you to
point out why the kernel code decides to ignore it on SET_PARAMS.

> Your 2nd option won't work at all. It is completely broken when you have
> to query statistics, before a SET_PARAMS.

What statistics can i possibly ask for when i didnt set any parameters?
Why not return EAGAIN if i ask for stats which are not there - that
would be a sane way to respond to it instead of garbling the tuner state
on a GET_INFO ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzAR6Uaz2rXW+gJcRApiPAKCHdwh0MIeaL5A5kBpnwOhOlzSvpACdEQco
piUoyt3NGCjsSA2CmUw972s=
=SwIH
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--


--===============1072960963==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1072960963==--
