Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab1LFONU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 09:13:20 -0500
Date: Tue, 6 Dec 2011 15:13:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: Re: [PATCH 2/2] [media] tm6000: Fix bad indentation.
Message-ID: <20111206141316.GB12258@avionic-0098.adnet.avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de>
 <1323178776-12305-2-git-send-email-thierry.reding@avionic-design.de>
 <4EDE1F99.6080200@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <4EDE1F99.6080200@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Antti Palosaari wrote:
> That question is related to that kind of indentation generally, not
> only that patch.
>=20
> On 12/06/2011 03:39 PM, Thierry Reding wrote:
> >Function parameters on subsequent lines should never be aligned with the
> >function name but rather be indented.
> [...]
> >  			usb_set_interface(dev->udev,
> >-			dev->isoc_in.bInterfaceNumber,
> >-			0);
> >+					dev->isoc_in.bInterfaceNumber, 0);
>=20
> Which kind of indentation should be used when function params are
> slitted to multiple lines?

I don't think this is documented anywhere and there are no hard rules with
regard to this. I guess anything is fine as long as it is indented at all.

> In that case two tabs are used (related to function indentation).
> example:
> 	ret=3D function(param1,
> 			param2);

I usually use that because it is my text editor's default.

> Other generally used is only one tab (related to function indentation).
> example:
> 	ret=3D function(param1,
> 		param2);

I think that's okay as well.

> And last generally used is multiple tabs + spaces until same
> location where first param is meet (related to function
> indentation). I see that bad since use of tabs, with only spaces I
> see it fine. And this many times leads situation param level are
> actually different whilst originally idea was to put those same
> level.
> example:
> 	ret=3D function(param1,
> 		      param2);

Whether this works or not always depends on the tab-width. I think most
variations are okay here. Some people like to align them, other people
don't.

Thierry

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7eIvwACgkQZ+BJyKLjJp/EPwCfUHG1vCG0PgRggqLHQ8bO0F9q
HgIAn22T3yvpiLGLRLw1+0EowKAXKVxo
=26tN
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
