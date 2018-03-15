Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34099 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbeCOKwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 06:52:02 -0400
Date: Thu, 15 Mar 2018 11:52:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Suman Anna <s-anna@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] media: omap3isp: fix unbalanced dma_iommu_mapping
Message-ID: <20180315105200.GA27057@amd>
References: <20180314154136.16468-1-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20180314154136.16468-1-s-anna@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-03-14 10:41:36, Suman Anna wrote:
> The OMAP3 ISP driver manages its MMU mappings through the IOMMU-aware
> ARM DMA backend. The current code creates a dma_iommu_mapping and
> attaches this to the ISP device, but never detaches the mapping in
> either the probe failure paths or the driver remove path resulting
> in an unbalanced mapping refcount and a memory leak. Fix this properly.
>=20
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> v2 Changes:
>  - Dropped the error_attach label, and returned directly from the
>    first error path (comments from Sakari)
>  - Added Sakari's Acked-by
> v1: https://patchwork.kernel.org/patch/10276759/
>=20
> Pavel,
> I dropped your Tested-by from v2 since I modified the patch, can you
> recheck the new patch again? Thanks.

I updated to new -next version and re-ran the test.

Tested-by: Pavel Machek <pavel@ucw.cz>
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqqUFAACgkQMOfwapXb+vKlrwCeKHhgwusf0xhYT9HB1cZ5aNCb
L0UAnRm2HvW0qtnYBT+v2dPNM1obgJS5
=9aI2
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
