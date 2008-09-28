Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <blhiggins@gmail.com>) id 1Kjlhm-0000ST-HH
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 04:08:15 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1387413rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 19:08:06 -0700 (PDT)
From: Brendon Higgins <blhiggins@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sun, 28 Sep 2008 12:07:50 +1000
MIME-Version: 1.0
Message-Id: <200809281208.00856.blhiggins@gmail.com>
Subject: [linux-dvb] DVB driver in 2.6.26 seem to stop sending data
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0719496234=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0719496234==
Content-Type: multipart/signed;
  boundary="nextPart1376015.Ir8yQjTION";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1376015.Ir8yQjTION
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi list,

I'm having a problem with the DVB drivers in Linux 2.6.26, compared to 2.6.=
25=20
for which there is no problem. I hope someone can help. Everything seems fi=
ne=20
when I boot and VDR starts running, until after a while (not sure how long,=
=20
perhaps some hours) DVB output seems to stop.

What I find when I come back to watch VDR is that it seems to be receiving =
no=20
data. Interestingly, VDR does not complain about it, it just displays a bla=
ck=20
screen (I'm using dxr3 output), but the UI still works, and I can change=20
channels (every channel is also black). Stream info says 0 kbps for both au=
dio=20
and video.

Restarting VDR does not solve the problem - there is still no data. I'm not=
=20
sure which of the myriad of modules I'd have to rmmod and then re-modprobe =
(if=20
that might even work), so I end up having to reboot the machine. Once I=20
reboot, DVB output is back to normal, until after some time the cycle start=
s=20
again.

I'm trying to get an idea why I'm having this problem, and I'm at a loss wh=
ere=20
to start. The problem means I have to stick with 2.6.25. Has anyone else se=
en=20
this sort of thing, or suggestions where I should look (if I'm asking the=20
wrong place, let me know)? Any help appreciated.

Some info:
AMD64 dual core
VDR 1.6.0
Debian Testing (mostly)
DVICO Fusion HDTV DVB-T plus
01:06.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and=20
Audio Decoder (rev 05)
01:06.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=20
Decoder [MPEG Port] (rev 05)

Peace,
Brendon

--nextPart1376015.Ir8yQjTION
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkje5vcACgkQCTfPD0Uw3q8ywQCgnVIfm2/5jpICPPUJxOSjoCVx
z8gAnRG9s5qf1ylsfMA7modzEaNiU73Z
=7sDd
-----END PGP SIGNATURE-----

--nextPart1376015.Ir8yQjTION--


--===============0719496234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0719496234==--
