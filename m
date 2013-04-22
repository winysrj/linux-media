Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58269 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab3DVM4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:56:37 -0400
Date: Mon, 22 Apr 2013 13:56:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Message-ID: <20130422125631.GK30351@opensource.wolfsonmicro.com>
References: <3775187.HOcoQVPfEE@avalon>
 <20130417135503.GL13687@opensource.wolfsonmicro.com>
 <20130417113639.1c98f574@redhat.com>
 <1905734.rpqfOCmvCu@avalon>
 <20130422100320.GC30351@opensource.wolfsonmicro.com>
 <5175310F.6080002@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6K2R/cS9K4qvcBNq"
Content-Disposition: inline
In-Reply-To: <5175310F.6080002@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6K2R/cS9K4qvcBNq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 22, 2013 at 09:46:07AM -0300, Mauro Carvalho Chehab wrote:
> Em 22-04-2013 07:03, Mark Brown escreveu:

> >Yes, you understood me perfectly - to a good approximation the matching
> >up should be done by whatever the chip is soldered down to.

> That doesn't make any sense to me. I2C devices can be used anywere,
> as they can be soldered either internally on an USB webcam without
> any regulators or any other platform code on it or could be soldered
> to some platform-specific bus.

If it's running on Linux on a visible I2C bus it ought to be shown as an
I2C bus on Linux and the thing doing that plumbing ought to be worrying
about hooking up anything the driver needs.

> Also, what best describes "soldered" here is the binding between
> an I2C driver and the I2C adapter. The I2C adapter is a platform
> driver on embedded devices, where, on an usual USB camera, it
> is just a USB->I2C bridge.

Sure, but there's no meaningful difference between these things as far
as plumbing things together goes.

> Also, requiring that simple USB cameras to have regulators will
> prevent its usual usage, as non-platform distros don't set config
> REGULATOR, and it shouldn't.

No problem there, the regulator API stubs itself out if it's not
enabled.

--6K2R/cS9K4qvcBNq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdTNyAAoJELSic+t+oim9IF8P/ir01tbik8ELEb1HNl+De6BD
Y5YGTB4lMMfI83+UeJanSgMj/kUq0Ler3B62egf5JWcaYKoK4DyCjT1f12mdXWfR
1ATMA7a9rMGTj2WkgjjkIh++iLh04YLHM3LVK9+53Ff1i3pyTFhU8FoiqrM9Tfni
13EHIVhPBDteLKUdQDsf5f5zPrDzlq5sjhFrcQIcXZO3PoFFMfudfBBPtpVtdnhD
Gtwlc2KtcxRG2fZPqf6VKZ2x24wbxoh68Vv+OjW9RHui9w+gEEiA52oBaYOWO5tb
p1mpcz99cUTgH9pcM9bZwDtNjC2Whzf4OQ841BuPBO23LIYndO4ptAE2r+r2tIbK
dhvKOjLTgo1lcm9tLpiZG70jk1u1GeOvPihEAOb69w7Toqbl4v5CcqrAN8/QG+tm
QI9ymoVvCheBZSQ7GCK5VrS1vZlXvpqW2qup4f9U5HM8mo/aX75xejzLNq6yjngm
P/Ra+vmVUl7TlqI+Qlbxa+n3HJpiTjRxnC60QU4udCjyc972FGOibzJxC6qMj1Yr
t+JMVucpuWDwyokU4QXuAYoqjQEw0/rYmz3dtzZqi5CSaokKYdwuTrxbI9/G77DN
nHhpyUa8dn5C/6Fl85tuF+jOPmAcxKe91t0QtTA552QwpNGP9sS9Dx25kUo8jNp5
S6YPUOpYKrr7+4HqimLI
=LbwW
-----END PGP SIGNATURE-----

--6K2R/cS9K4qvcBNq--
