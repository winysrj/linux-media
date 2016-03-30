Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57174 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbcC3Qwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 12:52:42 -0400
Date: Wed, 30 Mar 2016 09:51:43 -0700
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
Message-ID: <20160330165143.GI2350@sirena.org.uk>
References: <1459352394-22810-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vFj1JTFBn4Zx1dEI"
Content-Disposition: inline
In-Reply-To: <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 4/7] scatterlist: add sg_alloc_table_from_buf() helper
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vFj1JTFBn4Zx1dEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 30, 2016 at 05:39:51PM +0200, Boris Brezillon wrote:
> sg_alloc_table_from_buf() provides an easy solution to create an sg_table
> from a virtual address pointer. This function takes care of dealing with
> vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
> DMA transfer size).

This seems nice.  Should we also have a further helper on top of this
which will get constraints from a dmaengine, it seems like it'd be a
common need?

--vFj1JTFBn4Zx1dEI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW/AQeAAoJECTWi3JdVIfQXMQH/itp9i02iTaWPExL/pifGygB
ANPSpKL+b509PVUNxywH9hJm0YJcusKDqNWSlPOzpxkgDmkE/q2/cW8rSOmBxfuU
84BuVdYgIj6Un+AcDSDye5PCDprYogC1QE6dzP9941txqwoiSVP9E3d4ePGs1gFR
iOTBfhr5scHnSgwNK59PzVxPfjdMJjUnVX13Wc4w5CxgI62Gl1X+o9us/PKBkJGi
muMm7iEN5P7WdmP5gYnmi38F+fl3Lizq8qZx9P0TksoyQnvIo09lqAmTn1kxFmX4
YGQN6qK4qXKAvkmLv7jP8rnqZ7iie5fTbDmHVh0ksqU6T9aeDepLUb1wmRQkEiI=
=4yoo
-----END PGP SIGNATURE-----

--vFj1JTFBn4Zx1dEI--
