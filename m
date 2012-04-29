Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab2D2PWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 11:22:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SOVxT-0000ry-PK
	for linux-media@vger.kernel.org; Sun, 29 Apr 2012 17:22:43 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 17:22:43 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 17:22:43 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: can't rmmod au0828; modprobe au0828 and have a working device
Date: Sun, 29 Apr 2012 11:22:32 -0400
Message-ID: <jnjmbo$qhq$1@dough.gmane.org>
References: <jmov7j$hrc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig67E99524D0FA210B8855B19B"
In-Reply-To: <jmov7j$hrc$1@dough.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig67E99524D0FA210B8855B19B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-04-19 08:08 AM, Brian J. Murrell wrote:
> I have an HVR-950Q:
>=20
> [44847.234403] tveeprom 0-0050: Hauppauge model 72001, rev B3F0, serial=
# *******
> [44847.294643] tveeprom 0-0050: MAC address is **:**:**:**:**:**
> [44847.343417] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, =
type 76)
> [44847.402873] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (=
eeprom 0x88)
> [44847.465471] tveeprom 0-0050: audio processor is AU8522 (idx 44)
> [44847.515481] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
> [44847.567162] tveeprom 0-0050: has no radio, has IR receiver, has no I=
R transmitter
> [44847.630272] hauppauge_eeprom: hauppauge eeprom: model=3D72001
>=20
> I cannot seem to get it to work after removing the au0828 xc5000 au8522=

> modules and then modprobing the au0828 module.

To follow-up on this, it seems that if I remove and insert the au0828
enough times, it will be functional again.  Race perhaps?

It seems when it's inserted and doesn't work, the following is logged in
the kernel message buffer:

xc5000: Device not found at addr 0x61 (0xffff)

and when it's inserted successfully:

xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously

It also seems that the module will become non-functional just as if I
had removed and inserted it, all on it's own without any removal insertio=
n.

b.


--------------enig67E99524D0FA210B8855B19B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+dXLgACgkQl3EQlGLyuXBHTACdGLIAeOiX8CFLKp1/89y9Rn45
tFwAnjKWjj9wM3KHfncJm1z8v9MQIExH
=jMTh
-----END PGP SIGNATURE-----

--------------enig67E99524D0FA210B8855B19B--

