Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57689 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2BJV5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 16:57:10 -0500
Received: by bkcjm19 with SMTP id jm19so3185923bkc.19
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 13:57:08 -0800 (PST)
Message-ID: <4F3592AB.4000607@googlemail.com>
Date: Fri, 10 Feb 2012 22:56:59 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigF7B9576FE9ED128F40EB3BA0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF7B9576FE9ED128F40EB3BA0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I'm happy to announce the release of v4l-utils-0.8.6. It contains mostly
backports from the development branch. The most interesting addition is
the new upside down table matching algorithm targeted at ASUS notebooks.
It will hopefully reduce the upside down table update frequency for
those machines.

Full changelog:

v4l-utils-0.8.6
---------------
* libv4l changes (0.9.x backports)
  * Add support for libjpeg >=3D v7
  * Add new matching algorithm for upside down table (gjasny)
  * Add some more laptop models to the upside down devices table
(hdegoede, gjasny)
  * Retry with another frame on JPEG header decode errors (hdegoede)
  * Improved JL2005BCD support (Theodore Kilgore, hdegoede)
  * Set errno to EIO if getting 4 consecutive EAGAIN convert errors
(hdegoede)
  * Make software autowhitebalance converge faster (hdegoede)
  * Add quirk support for forced tinyjpeg fallback (hdegoede)

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.6.tar.bz2

You can always find the latest developments and the stable branch here:
http://git.linuxtv.org/v4l-utils.git

Thanks,
Gregor

PS: Ubuntu users, you can this version for Oneiric and Precise via the
ppa:libv4l/stable PPA.


--------------enigF7B9576FE9ED128F40EB3BA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJPNZKxAAoJEBmaZPrftQD/hMgQAIhGA34TVB+/IhTOIycapDTh
SYLS/0jqaOeRRguWPcme+mjl7cj179xRKebi+9nIi8nIE+4caL+6lRpZ6WdkeThf
RJ6UpzYxw466JRVltfeu38c0YHBPVr9B33Cf9Qh0kucjFhiEYOOKgR2HCkagSyq3
jmbUMZk4QNA+AWfi97fUNlHZybe3YCS5Hzc2uYKDLMd9zN22bkp5CoFaBZ3WUf/Y
eCMhSH1DYw/bgzTDTw2f1kBRtTmOp7IZIYpKohgOYs6jC8yzuUwaHn6URCXGhgjQ
ErO0IpU9hdITBUdLJMFmbnlUK8iixQX81oMW2chun1L7iv3W7nFYwfwSFapf6wgt
WyUiixhCrSq3NSPRAazq/xJZwVfnvkz+cCV3IjdCujOR8kxpVwsdffFaJi4gshUj
Bbqby7PUyzo21bWbPEnwktpFj2lHr38QMEPWoGT7WRQm2wJcbS3TPLh0hm1wMPiw
8sRz8lE4sluY+YMOoCihAxzQJWh5kEHr3S570D0gYCfRU4hUy412EncXIc9NCSqg
6prqH12P2oG9xlYr4M7Knc6kTwQ1ANVeP6hmwSuod75PpoVFtwMLq4MCX8A6+KmH
K5ztsCJ/tguO+/4C1k/vgZcDWXpInjWQs8wMux+zEZI+l7q63vwR4mIVeT1fizGg
rWJnmaS+0AHkDd6pBlV2
=daWs
-----END PGP SIGNATURE-----

--------------enigF7B9576FE9ED128F40EB3BA0--
