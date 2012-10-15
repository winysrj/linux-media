Return-path: <linux-media-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:60732 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2JOOoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 10:44:17 -0400
Date: Mon, 15 Oct 2012 16:44:11 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20121015144411.GB5873@login.drsnuggles.stderr.nl>
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl> <20121015110111.GD17159@login.drsnuggles.stderr.nl> <20121015123232.GA25969@hercules>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20121015123232.GA25969@hercules>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Luis,

> Your diagnosis seem to be correct and I have already tried to address
> this:
>=20
> https://lkml.org/lkml/2012/8/25/84
Oh, w00ps, seems I missed that patch, stupid of me...

> I've submitted a patch to try to fix it but got no comments yet.  My
> patch moves the request_irq() invocation further down the
> initialisation code, after the rc_register_device() (which I believe
> is the correct thing to do).

I applied your patch and ran a diff against my four patches. If I disregard
the label changes, there's still three changes between our patches I can
see:
 - You move the rc_register_device calls only above the request_irq
   call, while I also included the request_region call. I don't think
   this should cause any realy difference.
 - You didn't remove the "dev->hw_io =3D -1" and "dev->irq =3D -1" lines in
   ene_ir.c, which I think are no longer needed now there are different
   multiple cleanup labels.
 - You did not move up the "...->rdev =3D rdev" line in fintek-cir.c,
   nuvoton-cir.c and ite-cir.c, which I think means the bug is not
   completely solved for these drivers with your patch.


As for the last point, I did a test run with your patch and could no
longer reproduce the issue (though I'm pretty confident the original
really was nvt->rdev being NULL). I suspect this means that moving the
rc_register_device() up to before the request_irq, prevents the bug from
triggering because either rc_register_device() did something to trigger
a (pending) interrupt, or it just took long enough for an interrupt to
occur.

In either case, I believe there is still a race condition between the
first interrupt and the initialization of of nvt->rdev, which could be
fixed by also moving the rdev initialization a bit further up. Or am I
missing some point here?

Gr.

Matthijs

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlB8ITsACgkQz0nQ5oovr7w6yQCgn4oQ/bOAe14DCO2+Wb70sW0B
q5kAoLhaGiyrgXK7aqSjwrN8ed6ms0v+
=2I4s
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
