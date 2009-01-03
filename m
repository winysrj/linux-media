Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <blhiggins@gmail.com>) id 1LIvp4-0004xa-W4
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 03:01:08 +0100
Received: by wf-out-1314.google.com with SMTP id 27so8059251wfd.17
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 18:01:02 -0800 (PST)
From: Brendon Higgins <blhiggins@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 3 Jan 2009 12:00:49 +1000
MIME-Version: 1.0
Message-Id: <200901031200.56314.blhiggins@gmail.com>
Subject: [linux-dvb] Regression since 2.6.25 kernel: Crash of userspace
	program leaves DVB device unusable
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1664375707=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1664375707==
Content-Type: multipart/signed;
  boundary="nextPart2502377.KBZWmvxvTV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2502377.KBZWmvxvTV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I've been coming up against a problem that seems to be with the DVB drivers=
=20
that occurs when a program using them, usually VDR in my case, terminates=20
uncleanly (segfault, general protection fault). Linux 2.6.25 doesn't have t=
his=20
problem, but 2.6.26, 2.6.27, and 2.6.28 do, though 2.6.28 manifests slightl=
y=20
differently to the others. I'll focus on what 2.6.28 does. I have a DViCO=20
=46usionHDTV DVB-T Plus, running on an amd64 Debian Testing (mostly) dual-c=
ore=20
machine.

After VDR crashes it attemps to restart itself. This was fine on 2.6.25, bu=
t on=20
later kernels the crash seems to leave the device in some unusable state,=20
where no program can subsequently use it - the device files (/dev/dvb) no=20
longer exist. (In 2.6.2[67], the files existed, but accessing=20
/dev/dvb/adapter0/dvr0 resulted in "No such device".) I had figured out tha=
t in=20
order to get the device working again it is necessary to "rmmod cx88_dvb=20
cx8802; modprobe cx88_dvb". This worked in 2.6.2[67] without trouble, but i=
n=20
2.6.28, it's as if the cx88_dvb module gets lost somehow. It doesn't appear=
 in=20
lsmod, however:
phi:~# modprobe cx88_dvb
=46ATAL: Error inserting cx88_dvb=20
(/lib/modules/2.6.28/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such=
=20
device
phi:~# rmmod cx88_dvb cx8802
ERROR: Module cx88_dvb does not exist in /proc/modules
phi:~# modprobe cx88_dvb

Note that probing it works only *after* cx8802 was unloaded. As before, now=
=20
the device is accessible.

So it seems something is wrong in the cx8802 module. Something is not being=
=20
cleaned up after a userspace program crashes while using it, leaving the DV=
B=20
system in a broken state.

I'd very much like this to not be the case, since on my system a VDR crash =
is=20
somewhat inevitable, and the automatic restart *was* very handy, back in=20
2.6.25.

Peace,
Brendon


--nextPart2502377.KBZWmvxvTV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklextIACgkQCTfPD0Uw3q/OJQCgjGNYprqgLQYXn4Ry+3j94AxU
3SIAn2knhH3DZomJke7uw6QU1k5Jdyv7
=E0O5
-----END PGP SIGNATURE-----

--nextPart2502377.KBZWmvxvTV--


--===============1664375707==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1664375707==--
