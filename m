Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1IAFTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 01:19:51 -0400
Date: Thu, 1 Sep 2011 07:19:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 16/21] [staging] tm6000: Select interface on first open.
Message-ID: <20110901051945.GD18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-17-git-send-email-thierry.reding@avionic-design.de>
 <4E5E934A.7000500@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Content-Disposition: inline
In-Reply-To: <4E5E934A.7000500@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 04-08-2011 04:14, Thierry Reding escreveu:
> > Instead of selecting the default interface setting when preparing
> > isochronous transfers, select it on the first call to open() to make
> > sure it is available earlier.
>=20
> Hmm... I fail to see what this is needed earlier. The ISOC endpont is used
> only when the device is streaming.
>=20
> Did you get any bug related to it? If so, please describe it better.

I'm not sure whether this really fixes a bug, but it seems a little wrong to
me to selecting the interface so late in the process when in fact the device
is already being configured before (video standard, audio mode, firmware
upload, ...).

Thinking about it, this may actually be part of the fix for the "device han=
gs
sometimes for inexplicable reasons" bug that this whole patch series seems =
to
fix.

Thierry

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fFfAACgkQZ+BJyKLjJp9ytQCeJxGjPNnYF/nZRgkAPHRvnRD5
g2QAoIWpGarT2k4+/hF+4F3bFMlMFhWO
=C0Xe
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
