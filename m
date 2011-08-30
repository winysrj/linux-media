Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51794 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab1H3Lop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 07:44:45 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QyMkD-0006Qs-EM
	for linux-media@vger.kernel.org; Tue, 30 Aug 2011 13:44:41 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 13:44:41 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 13:44:41 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: AVerTV Hybrid Volar MAX (H826)	 wiki entry
Date: Tue, 30 Aug 2011 07:44:27 -0400
Message-ID: <j3iies$svi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA9ED6F658AE8E7D6F55EB2C6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA9ED6F658AE8E7D6F55EB2C6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I was looking at the wiki for the supported status of the AVerMedia
AVerTV Hybrid Volar MAX (H826).  The wiki says it's not supported.  But
the wiki also says it's a PCIe card, which it's clearly not:
http://www.avermedia-usa.com/AVerTV/Product/ProductDetail.aspx?Id=3D431

Additionally in the AP & Driver tab of that page
(http://www.avermedia-usa.com/AVerTV/Product/ProductDetail.aspx?Id=3D431&=
tab=3DAPDriver)
there is a Linux driver which appears to have (granted, non-GPL) source
included with it.  But surely given source to a working driver, a
cleanroom GPL driver could be developed and supported, yes?  Maybe that
source is just "supporting" source for a binary blob.  I didn't look
that closely.

In any case, I am just wondering what the real supported status of that
device is given that the wiki is incorrect about at least some details
of the device.

Even if it's not supported, somebody with more understanding of this
device than I (I've just read a product page) ought to fix the wiki.  In
fixing it, I think it's only fair to point to the vendor supplied
driver, even if it's not open source and/or not a compatible open source
license.

Cheers,
b.



--------------enigA9ED6F658AE8E7D6F55EB2C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5czRsACgkQl3EQlGLyuXDp3wCdGWPFskGkN+zlCXaNGgnnXRI8
5qwAniXfKcUtmO/hpOVcmTssQ2drCKoK
=Gx4b
-----END PGP SIGNATURE-----

--------------enigA9ED6F658AE8E7D6F55EB2C6--

