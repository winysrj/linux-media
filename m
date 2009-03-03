Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1LebhA-0002fT-RZ
	for linux-dvb@linuxtv.org; Tue, 03 Mar 2009 21:58:33 +0100
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Tue, 3 Mar 2009 21:57:48 +0100
References: <200806071633.04876.dkuhlen@gmx.net> <49ABF434.1050100@inode.at>
In-Reply-To: <49ABF434.1050100@inode.at>
MIME-Version: 1.0
Message-Id: <200903032157.48932.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Pinnacle PCTV Dual Sat Pro PCI (4000i) update
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0099345074=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0099345074==
Content-Type: multipart/signed;
  boundary="nextPart1258469.vhf2hj2NCK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1258469.vhf2hj2NCK
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Monday 02 March 2009, Ernst Peinlich wrote:
> Dominik Kuhlen schrieb:
> > Hi,
> >
=2D---snip----
> hi,
> any news ?
Unfortunately not. Current status is still: both tuner working, nothing mor=
e.

I started writing a virtual pctv4000i device for qemu and tried to=20
reverse engineer from "the other side".
If someone is interested I could post the current driver and/or the "virtua=
l device".

BTW: i have a strange effect with my driver:
I can load and unload it as often as I like. It always works like a charm.
But if I try to shutdown my PC the kernel panics in the power-down call :(


Dominik

--nextPart1258469.vhf2hj2NCK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJrZnM6OXrfqftMKIRAkfbAKCjGyoM9HHYnMCvHl+kgxmijxelfACfRkAo
Mwp8IJUI0qrLslsef8HykZU=
=kbv5
-----END PGP SIGNATURE-----

--nextPart1258469.vhf2hj2NCK--


--===============0099345074==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0099345074==--
