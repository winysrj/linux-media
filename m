Return-path: <linux-media-owner@vger.kernel.org>
Received: from drsnuggles.stderr.nl ([94.142.244.14]:59633 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JOQhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 12:37:05 -0400
Date: Mon, 15 Oct 2012 18:37:01 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20121015163701.GG5873@login.drsnuggles.stderr.nl>
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl> <20121015110111.GD17159@login.drsnuggles.stderr.nl> <20121015123232.GA25969@hercules> <20121015144411.GB5873@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Content-Disposition: inline
In-Reply-To: <20121015144411.GB5873@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Luis,

seems we're not the only ones working on this, there's a partially
overlapping patch in v3.6.2 for the ite-cir driver only:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=434f4d3f1209d4e4c8b0d577d1c809f349c4f0da

Gr.

Matthijs

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlB8O60ACgkQz0nQ5oovr7x7UgCfQts6TlibJcQMVDZtcHlXmWdf
pzQAoInH/QkELiokZlYIREJ02AlnDhuc
=d+yU
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
