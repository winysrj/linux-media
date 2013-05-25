Return-path: <linux-media-owner@vger.kernel.org>
Received: from brandt2.jaunorange.com ([46.4.243.167]:41981 "EHLO ptaff.ca"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab3EYRS7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 13:18:59 -0400
Received: from nestor.ptaff.ca (modemcable021.216-19-135.mc.videotron.ca [135.19.216.21])
	by ptaff.ca (Postfix) with ESMTP id C4A261BC3CD6
	for <linux-media@vger.kernel.org>; Sat, 25 May 2013 13:18:57 -0400 (EDT)
Date: Sat, 25 May 2013 13:18:53 -0400
From: Patrice Levesque <video4linux.wayne@ptaff.ca>
To: linux-media@vger.kernel.org
Subject: Re: InstantFM
Message-ID: <20130525171852.GV4308@ptaff.ca>
Reply-To: Patrice Levesque <video4linux.wayne@ptaff.ca>
References: <51993390.6080202@theo.to>
 <5199C8FA.9060704@redhat.com>
 <519A4464.7060006@theo.to>
 <519A6DBB.60608@theo.to>
 <519B23A7.90504@redhat.com>
 <519B649C.9040903@theo.to>
 <519C7E8B.9090406@redhat.com>
 <20130522140525.GF4308@ptaff.ca>
 <519DD31D.5080802@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HzaOE8X7KzPzAQEl"
Content-Disposition: inline
In-Reply-To: <519DD31D.5080802@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HzaOE8X7KzPzAQEl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> This, as well as the "Invalid freq '127150000'" and the "get_baseline:
> min=3D65535.000000 max=3D65535.000000" messages seem to indicate that only
> FFFF is being read from all the registers of the tuner chip, so
> somehow the communication between the usb micro-controller and the
> si470x tuner chip is not working.

A disconnect-connect of the USB device reset its internal state and now
I can confirm the device properly works with the 3.9.3-gentoo kernel,
using the 3.103 version of xawtv.

Under the same kernel, the 3.95-r2 xawtv version shipped with gentoo
fails to detect signal: =E2=80=9Cradio -i -d=E2=80=9D outputs no channel an=
d shows
=E2=80=9Cget_baseline: min=3D0.000000 max=3D0.000000=E2=80=9D.


Thanks for your good work on this, you know who you are,



--=20
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
        Patrice Levesque
         http://ptaff.ca/
        video4linux.wayne@ptaff.ca
    --------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------
 --=3D=3D=3D=3D|=3D=3D=3D=3D--
--

--HzaOE8X7KzPzAQEl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBCAAGBQJRoPJ8AAoJEPFsbcakB4r7BjAIAMSXGsymJNzd8Ed3+0D7iGHq
u8r0YQDVSXyP9BkTiqPZVjAhsfIIhWfh1V/3b2zX5hOjmjtmprccaGJAYTenPyyk
UdD44aywoGZidhNw4ZdVItqAFOYY2LzElpx98Ow0fKFs+FW9oINf5L7MRhsiPgki
Z4RH2Ic1zPU8iPsEWVWeQ29GRBJcwb+HIIRtLB5LuLJHnMTQ+HSfouDZD9qb78lv
gRkMCLeFx2MTZ1z/hiEaPNia4+QEBAs9lrSCfj9xRcRc59VWLlkEtmbGVpujZYMC
t94GG5cN9jczEbaJnBwjJqgohUHQZfYwZ2Zuv6KNdRr9qpeck/YQIsiilY8ys18=
=uz4z
-----END PGP SIGNATURE-----

--HzaOE8X7KzPzAQEl--
