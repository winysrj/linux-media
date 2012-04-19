Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2DSK7p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 06:59:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SKp5S-0004IW-OD
	for linux-media@vger.kernel.org; Thu, 19 Apr 2012 12:59:42 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 12:59:42 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 12:59:42 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: HVR-950Q: (AssemblePSIP) Error: offset>181, pes length & current
 cannot be queried
Date: Thu, 19 Apr 2012 06:59:30 -0400
Message-ID: <jmor6j$hju$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0E2E6DACD23CBF157B1D828F"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0E2E6DACD23CBF157B1D828F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I was recording 3 programs last night using Mythtv (0.25) with my
HVR-950Q.  All three recordings stopped dead after Mythtv reported:

Apr 18 20:32:04 pvr mythbackend[1857]: E DVBRead mpeg/mpegstreamdata.cpp:=
362 (AssemblePSIP) Error: offset>181, pes length & current cannot be quer=
ied

It also later reported:

Apr 18 20:59:59 pvr mythbackend[1857]: W DeviceReadBuffer DeviceReadBuffe=
r.cpp:525 (Poll) DevRdB(/dev/dvb/adapter0/frontend0): Poll took an unusua=
lly long time 1674946 ms

The only messages on the kernel message buffering during that whole
time were:

Apr 18 20:00:00 pvr kernel: [ 1659.927835] xc5000: waiting for firmware u=
pload (dvb-fe-xc5000-1.6.114.fw)...
Apr 18 20:00:00 pvr kernel: [ 1659.938474] xc5000: firmware read 12401 by=
tes.
Apr 18 20:00:00 pvr kernel: [ 1659.942973] xc5000: firmware uploading...
Apr 18 20:00:07 pvr kernel: [ 1666.608017] xc5000: firmware upload comple=
te...
Apr 18 20:59:59 pvr kernel: [ 5259.143919] xc5000: waiting for firmware u=
pload (dvb-fe-xc5000-1.6.114.fw)...
Apr 18 20:59:59 pvr kernel: [ 5259.170733] xc5000: firmware read 12401 by=
tes.
Apr 18 20:59:59 pvr kernel: [ 5259.175227] xc5000: firmware uploading...
Apr 18 21:00:06 pvr kernel: [ 5265.872024] xc5000: firmware upload comple=
te...

I am using (Ubuntu) Linux kernel 3.2.0-18-generic

Any ideas what happened?

Cheers,
b.


--------------enig0E2E6DACD23CBF157B1D828F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+P8BIACgkQl3EQlGLyuXCrlwCgrS7tLcxxevaG6NoQ88RRB9uh
AjYAoJeUSFRgEQ0yttg+kAibs5ZvNM+x
=mMBU
-----END PGP SIGNATURE-----

--------------enig0E2E6DACD23CBF157B1D828F--

