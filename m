Return-path: <linux-media-owner@vger.kernel.org>
Received: from cain.gsoft.com.au ([203.31.81.10]:61987 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0DOGOS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 02:14:18 -0400
From: "Daniel O'Connor" <darius@dons.net.au>
Reply-To: darius@dons.net.au
To: linux-media@vger.kernel.org
Subject: DViCo Dual Fusion Express (cx23885) remote control issue
Date: Thu, 15 Apr 2010 15:19:48 +0930
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1992100.QXPzcsqgJZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004151519.58012.darius@dons.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1992100.QXPzcsqgJZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
I recently upgraded my Myth box from Ubuntu 8.04 to 9.10 (runs=20
2.6.31-20-generic). Previously I used the drivers from=20
http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/ however the card=20
worked out of the box (once I got the later firmware) and so I presumed=20
they had been merged.

However one thing that wasn't working was the IR receiver so I checked=20
out the latest v4l-dvb code and built it (after disabling the 1394=20
based ones as they broke the build) and then installed and rebooted and it
detected the IR OK, ie

Apr 13 14:40:05 mythtv kernel: [    7.601716] input: i2c IR (FusionHDTV) as=
 /devices/virtual/input/input6
Apr 13 14:40:05 mythtv kernel: [    7.632093] ir-kbd-i2c: i2c IR (FusionHDT=
V) detected at i2c-0/0-006b/ir0 [cx23885[0]]

And it works with lirc etc etc..

However I came to use it this morning and it now doesn't find it even if
I load the module from where it was built..
[mythtv 15:13] ~/v4l-dvb >sudo rmmod ir_kbd_i2c
[mythtv 15:13] ~/v4l-dvb >lsmod |grep ir_kbd_i2c
[mythtv 15:13] ~/v4l-dvb >sudo insmod /home/myth/v4l-dvb/v4l/ir-kbd-i2c.ko

I haven't delved much further yet (planning to printf my way through
the probe routines) as I am a Linux kernel noob (plenty of FreeBSD
experience though!).

If any one has any suggestions or patches I'd be happy to try them
out :)

Thanks.

=2D-=20
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C

--nextPart1992100.QXPzcsqgJZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (FreeBSD)

iD8DBQBLxqkF5ZPcIHs/zowRAq8uAJ9NNGQZAycx5coHrqxrbq7f39l0uQCfSbJg
UzrDD0qSYWGEBLty+CwTMK8=
=NzpC
-----END PGP SIGNATURE-----

--nextPart1992100.QXPzcsqgJZ--
