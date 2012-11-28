Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40477 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2K1XTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 18:19:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Tdqv7-0000zp-Ph
	for linux-media@vger.kernel.org; Thu, 29 Nov 2012 00:19:57 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 00:19:57 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 00:19:57 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: ivtv driver inputs randomly "block"
Date: Wed, 28 Nov 2012 18:19:36 -0500
Message-ID: <50B69C08.7050401@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org> <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com> <50B60D54.4010302@interlinx.bc.ca> <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD3E80407E8982D8BD1C761D9"
In-Reply-To: <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD3E80407E8982D8BD1C761D9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-28 08:13 AM, Ezequiel Garcia wrote:
>=20
> Try again with
> modprobe ivtv ivtv_debug=3D10

OK.  Happened again.  The kernel log for the whole day since starting
the module with debug this morning can be found at
http://brian.interlinx.bc.ca/ivtv-dmesg.txt.bz2.

Associated with that log there was a successful recording from 09:00:00
until 10:00:00 then another successful recording from 14:00:00 until
15:00:00 and then failed recordings starting at 15:00:00 until 18:00:00.

The log cuts off just short of 18:00:00 but there's nothing different
about the pattern from the end of the log until 18:00:04 from the
previous 3 hours or so.

It seems that the problem lies in amongst the start of these lines from
the log, as my best guess:

Nov 28 15:00:05 cmurrell kernel: [868297.536049] ivtv0 encoder MPG: VIDIO=
C_ENCODER_CMD cmd=3D0, flags=3D0
Nov 28 15:00:07 cmurrell kernel: [868300.039324] ivtv0:  ioctl: V4L2_ENC_=
CMD_STOP
Nov 28 15:00:07 cmurrell kernel: [868300.039330] ivtv0:  info: close stop=
ping capture
Nov 28 15:00:07 cmurrell kernel: [868300.039334] ivtv0:  info: Stop Captu=
re
Nov 28 15:00:09 cmurrell kernel: [868302.140151] ivtv0 encoder MPG: VIDIO=
C_ENCODER_CMD cmd=3D1, flags=3D1
Nov 28 15:00:09 cmurrell kernel: [868302.148093] ivtv0:  ioctl: V4L2_ENC_=
CMD_START
Nov 28 15:00:09 cmurrell kernel: [868302.148101] ivtv0:  info: Start enco=
der stream encoder MPG
Nov 28 15:00:09 cmurrell kernel: [868302.188580] ivtv0:  info: Setup VBI =
API header 0x0000bd03 pkts 1 buffs 4 ln 24 sz 1456
Nov 28 15:00:09 cmurrell kernel: [868302.188655] ivtv0:  info: Setup VBI =
start 0x002fea04 frames 4 fpi 1
Nov 28 15:00:09 cmurrell kernel: [868302.191952] ivtv0:  info: PGM Index =
at 0x00180150 with 400 elements
Nov 28 15:00:10 cmurrell kernel: [868302.544052] ivtv0 encoder MPG: VIDIO=
C_ENCODER_CMD cmd=3D0, flags=3D0
Nov 28 15:00:12 cmurrell kernel: [868305.047260] ivtv0:  ioctl: V4L2_ENC_=
CMD_STOP
Nov 28 15:00:12 cmurrell kernel: [868305.047265] ivtv0:  info: close stop=
ping capture
Nov 28 15:00:12 cmurrell kernel: [868305.047270] ivtv0:  info: Stop Captu=
re
=2E..

FWIW, the recording software here is MythTV completely up to date on the
0.25-fixes branch.

Thoughts?

b.



--------------enigD3E80407E8982D8BD1C761D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC2nAkACgkQl3EQlGLyuXDSqACfa4QSDmYDQT1UNUgIH2/2I1kJ
AeMAoKr03+nSRNUlbqaFZZHbGU4J77IP
=oT5l
-----END PGP SIGNATURE-----

--------------enigD3E80407E8982D8BD1C761D9--

