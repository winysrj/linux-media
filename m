Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:25415 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZASDhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 22:37:20 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2431993rvb.1
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 19:37:19 -0800 (PST)
From: Brendon Higgins <blhiggins@gmail.com>
To: linux-media@vger.kernel.org
Subject: Regression since 2.6.25 kernel: Crash of userspace program leaves DVB device unusable
Date: Mon, 19 Jan 2009 13:37:26 +1000
References: <200901031200.56314.blhiggins@gmail.com>
In-Reply-To: <200901031200.56314.blhiggins@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1843588.5EXkndx9Al";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901191337.31272.blhiggins@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1843588.5EXkndx9Al
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I wrote to linux-dvb (2009-01-03 12:00 pm):
> I've been coming up against a problem that seems to be with the DVB drive=
rs
> that occurs when a program using them, usually VDR in my case, terminates
> uncleanly (segfault, general protection fault). Linux 2.6.25 doesn't have
> this problem, but 2.6.26, 2.6.27, and 2.6.28 do, though 2.6.28 manifests
> slightly differently to the others. I'll focus on what 2.6.28 does. I have
> a DViCO FusionHDTV DVB-T Plus, running on an amd64 Debian Testing (mostly)
> dual-core machine.
>
> After VDR crashes it attemps to restart itself. This was fine on 2.6.25,
> but on later kernels the crash seems to leave the device in some unusable
> state, where no program can subsequently use it - the device files
> (/dev/dvb) no longer exist. (In 2.6.2[67], the files existed, but accessi=
ng
> /dev/dvb/adapter0/dvr0 resulted in "No such device".) I had figured out
> that in order to get the device working again it is necessary to "rmmod
> cx88_dvb cx8802; modprobe cx88_dvb". This worked in 2.6.2[67] without
> trouble, but in 2.6.28, it's as if the cx88_dvb module gets lost somehow.
> It doesn't appear in lsmod, however:
> phi:~# modprobe cx88_dvb
> FATAL: Error inserting cx88_dvb
> (/lib/modules/2.6.28/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such
> device
> phi:~# rmmod cx88_dvb cx8802
> ERROR: Module cx88_dvb does not exist in /proc/modules
> phi:~# modprobe cx88_dvb
>
> Note that probing it works only *after* cx8802 was unloaded. As before, n=
ow
> the device is accessible.
>
> So it seems something is wrong in the cx8802 module. Something is not bei=
ng
> cleaned up after a userspace program crashes while using it, leaving the
> DVB system in a broken state.
>
> I'd very much like this to not be the case, since on my system a VDR crash
> is somewhat inevitable, and the automatic restart *was* very handy, back =
in
> 2.6.25.

Deafening silence. Does nobody have a clue? Or care? I just noticed I poste=
d=20
to the linux-dvb list which has been deprecated, so I'm quoting it here in=
=20
its entirety in case relevent people missed it. Is there anything else I ca=
n=20
do?

Peace,
Brendon

--nextPart1843588.5EXkndx9Al
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklz9XYACgkQCTfPD0Uw3q8WlwCfZrzWDYBiT75VdrS/ViQDg2i4
AhcAnRZNxtqhzwWi8T8wNqzkSQwkYATE
=JgnE
-----END PGP SIGNATURE-----

--nextPart1843588.5EXkndx9Al--
