Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nef2.ens.fr ([129.199.96.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <george@phare.normalesup.org>) id 1LadAJ-0000Jj-8g
	for linux-dvb@linuxtv.org; Fri, 20 Feb 2009 22:44:12 +0100
Received: from phare.normalesup.org (phare.normalesup.org [129.199.129.80])
	by nef2.ens.fr (8.13.6/1.01.28121999) with ESMTP id n1KLhTL4072922
	for <linux-dvb@linuxtv.org>; Fri, 20 Feb 2009 22:43:29 +0100 (CET)
Date: Fri, 20 Feb 2009 22:43:29 +0100
From: Nicolas George <nicolas.george@normalesup.org>
To: linux-dvb@linuxtv.org
Message-ID: <20090220214329.GA8551@phare.normalesup.org>
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy T USB XXS: remote does not work with
	1.20 firmware
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0071151246=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0071151246==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

I am trying to get the remote controller with a Terratec Cinergy T USB XXS.
With the firmware dvb-usb-dib0700-1.10.fw, the remote sends codes (not
perfectly, but I can see where I am going).

On the other hand, with dvb-usb-dib0700-1.20.fw, the remote does not detect
anything. After some tracking, I found that in dib0700_rc_query_v1_20 (from
dib0700_devices.c), the status from usb_bulk_msg is always -110
(-ETIMEDOUT).

Is there some way I can help fixing things? I do not mind using the old
firmware, but I would like to help improving things.

Regards,

--=20
  Nicolas George

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmfJAEACgkQsGPZlzblTJP5fACfXNH9WfkNUnspa4hMhz6nIQCv
l3gAn0Y/sKhSbopD8WbGvXJrtzGG9ZKQ
=jP++
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--


--===============0071151246==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0071151246==--
