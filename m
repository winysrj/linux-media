Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60902 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcCaRYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 13:24:43 -0400
Date: Thu, 31 Mar 2016 10:23:53 -0700
From: Mark Brown <broonie@kernel.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Vignesh R <vigneshr@ti.com>,
	linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Message-ID: <20160331172353.GJ2350@sirena.org.uk>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459427384-21374-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HHj6mHPeUinss9N+"
Content-Disposition: inline
In-Reply-To: <1459427384-21374-4-git-send-email-boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 3/4] spi: use sg_alloc_table_from_buf()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HHj6mHPeUinss9N+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 31, 2016 at 02:29:43PM +0200, Boris Brezillon wrote:
> Replace custom implementation of sg_alloc_table_from_buf() by a call to
> sg_alloc_table_from_buf().

Acked-by: Mark Brown <broonie@kernel.org>

--HHj6mHPeUinss9N+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW/V0aAAoJECTWi3JdVIfQuGEH+wdaKEhHxJuIIwseLFy64w88
sFhI2BJSaVk6ppdvYIdf67ku24WUoLyYEApHSGXfhntu00xAlzBh8YZjvg6F41Yg
7Ql/wnd5YumDVMT72a9Cv1OlJ+dsUdBJuQl7/A952W53l4IR2AcBDrJ/zBWQDtOc
bbohxZsXJP+Qou2Q9x8OebYsFr3p2Hw3XjteAVB6jwA9gINwDDLj05HgRCKbotHe
5bMQ3pj2I1ruS4wN44SWj7YOMvLzR3nE4xVOdHV+iaFhcVTkaYn7fuWi1fdSRChk
tCB1auoxNjAIsfnsvj6nnzAOcW/kPwKzOKIgz58DZPFkgiRKDM9wuDnN2AlMPBI=
=uMgt
-----END PGP SIGNATURE-----

--HHj6mHPeUinss9N+--
