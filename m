Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57498 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbcC3Sfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 14:35:36 -0400
Date: Wed, 30 Mar 2016 11:34:39 -0700
From: Mark Brown <broonie@kernel.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Richard Weinberger <richard@nod.at>
Message-ID: <20160330183439.GS2350@sirena.org.uk>
References: <1459352394-22810-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
 <20160330165143.GI2350@sirena.org.uk>
 <20160330201831.38e1d6bd@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hrnpeiJmytOBrElT"
Content-Disposition: inline
In-Reply-To: <20160330201831.38e1d6bd@bbrezillon>
Subject: Re: [PATCH v2 4/7] scatterlist: add sg_alloc_table_from_buf() helper
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hrnpeiJmytOBrElT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 30, 2016 at 08:18:31PM +0200, Boris Brezillon wrote:

> BTW, do you see other things that should be added in sg_constraints?

It looked to do everything SPI does which is everything I know about.

--hrnpeiJmytOBrElT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW/Bw8AAoJECTWi3JdVIfQl3EH/15ijZIt2W6NXfjF6Bj/TzuD
wIKY7hkWCM164li50lCiJDa1fvF2dzo+TrwBAK1WOs36W0yiJmSwM25aDJjFJYGw
/xWLjBsjVl57ng+hDVxFw7xfHUt/Z24k8YWEViZUa8dBwgSat2rKdYrPfJoCg3mq
ktaqy8xcvOXzfqf6nU9t5tSHzE70OEaG6XG7iS+RCL9bF3B2FAxMJm5wf+6Sg8mL
t1ulSVczwgTtUJ0YI97H+KPFKxPJIfX8OLC4MGcqamuahFMs12qSVz8NtW1rg8Vr
vKekQEF+YwB3E070ZepBde9CRaTTxkY6shf51A6lW2kXP/b7c7pgIklyVEWSxyE=
=uI64
-----END PGP SIGNATURE-----

--hrnpeiJmytOBrElT--
