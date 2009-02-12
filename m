Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.88-198-47-201.clients.your-server.de ([88.198.47.201]
	helo=butterbrot.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <floe@butterbrot.org>) id 1LXXN3-0006vU-NX
	for linux-dvb@linuxtv.org; Thu, 12 Feb 2009 09:56:34 +0100
Received: from [192.168.178.34] (unknown [82.135.95.20])
	(using SSLv3 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by butterbrot.org (Postfix) with ESMTPSA id EE1C6154100
	for <linux-dvb@linuxtv.org>; Thu, 12 Feb 2009 09:57:44 +0100 (CET)
From: Florian Echtler <floe@butterbrot.org>
To: linux-dvb@linuxtv.org
Date: Thu, 12 Feb 2009 09:55:55 +0100
Message-Id: <1234428955.5072.7.camel@bernd>
Mime-Version: 1.0
Subject: [linux-dvb] Looking for external DVB-C device..
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1711989408=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1711989408==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hZpuKysA8rPLNjMvY1xd"


--=-hZpuKysA8rPLNjMvY1xd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello everyone,

I've been browsing the wiki and the rest of the web for some time,
looking for a device which has the following features:

- DVB-C support in Germany
- Linux support (of course)
- external device via USB 2.0
- ability to record raw MPEG stream
- CI module

AFAICT, the only thing which comes close is the Anysee E30C Plus,
although the CI isn't (yet) supported. Is there any other option?

And by the way, I'm curious how the communication with the CI actually
works in Linux. Is that handled inside the driver, or does the end user
application have to do anything about it? IIRC, once the communication
has been set up, the decryption is done by the CAM - is that correct?

Many thanks, Yours, Florian


--=-hZpuKysA8rPLNjMvY1xd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmT5BsACgkQ7CzyshGvatgdrACg8BBMVq2GrTsDoOJTJxnJbuNL
gBgAn35pTfloSY8UwEzm1H0E3ooLCDQs
=VPxA
-----END PGP SIGNATURE-----

--=-hZpuKysA8rPLNjMvY1xd--



--===============1711989408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1711989408==--
