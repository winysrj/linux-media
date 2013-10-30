Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:35371 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab3J3QCh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 12:02:37 -0400
Date: Wed, 30 Oct 2013 17:02:34 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
Message-ID: <20131030160234.GE3663@katana>
References: <1382386335-3879-1-git-send-email-crope@iki.fi>
 <52658CA7.5080104@iki.fi>
 <20131030151620.GB3663@katana>
 <52712787.3010408@iki.fi>
 <20131030154553.GC3663@katana>
 <52712AF4.5020503@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
In-Reply-To: <52712AF4.5020503@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >Well, I intentionally asked for revert not bisect. Removing the #ifdef
> >can easily be done by hand if needed and will just need one recompile to
> >make sure.
>=20
> Yes, but compiling whole Kernel is always pain. I dont certainly
> want to do that just for testing some patches.

Well, if you ask for support for debugging, you should be prepared to do
exactly that.

> Jean jsut pointed out on IRC that this patch likely fixes the issue:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D47b6e477ed4ecacddd1f82d04d686026e08dc3db

Yup, he is right. You have ACPI enabled.

> As that patch is already applied to 3.12 it should be fine. I was
> running media master which is based 3.12-rc2.

Asking you to build the latest kernel might have been another thing I'd
ask you to do.


--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScS2aAAoJEBQN5MwUoCm2JPcQAJ+pyryL4Ou5evYfKYNcs2Ss
bvjO0BfsDTuW45iXk4jtQrhhfGEG86s6CAu4JwGamf3ArbgMSEbResvh0/stk2SC
C62Yppnm2nwlvB7OjBv1bMlY8m+5IhgLiiXTMdSZXCliSRuJE0Ju+C58kA7CFUS5
5cvtI895hwL4/ShIH1zPgHSlXxY1qYMW7DYbLIaUcCU9/pXNe2uM1b/EviWhf3ZW
dt3HN41uaKEZXoBUydaQVhPMFXtxvONfjxWYjdaceBCk0o9Sto86yxYgj22ymME7
rJIDqpcuR5t3YO2vElA7RpTyGwpYcEjXS3k/ByOdMBDdJY1TEZKz8+ygGcHPyiyJ
GBvYMl7Vxb6gmApxUMeuHpPHGh9efIOuEfNkLr5R6OMRXNBBp8unPPeLla7AfdTc
Udt19WqAxF+lHywDZa06yjo8eMTJAeOP8ZLuKwHaODfWBlcHFO1W2EicMC9olNWo
ETdJXzwUh7rp6i0mSRecWoVxEfD+kaZ5uoJcnNQcHtLHDf4746M5R29ms2ZREEjL
/VAdy6kjNFV0lG2Tavj5oqjxccGY3kt16H/fnQ3Hk7xwdRlOiLz2qcUfxL8APu/E
1gdk2VYMQWaeI15er3+HZrFqnijWvYkWM1FEJLLcnqaHJ7qghi41MLPLltkFt0AC
wk9l6K+SDxQHVBmXV90A
=W77T
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--
