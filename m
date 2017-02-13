Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46074 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbdBMSTD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 13:19:03 -0500
Date: Mon, 13 Feb 2017 18:18:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, labbott@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        akpm@linux-foundation.org, hverkuil@xs4all.nl
Message-ID: <20170213181842.tn3nf7ogrwnzje2p@sirena.org.uk>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w7ltkgfh4mxuyxeu"
Content-Disposition: inline
In-Reply-To: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
Subject: Re: [RFC simple allocator v2 0/2] Simple allocator
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--w7ltkgfh4mxuyxeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 03:45:04PM +0100, Benjamin Gaignard wrote:

> An other question is: do we have others memory regions that could be interested
> by this new framework ? I have in mind that some title memory regions could use
> it or replace ION heaps (system, carveout, etc...).
> Maybe it only solve CMA allocation issue, in this case there is no need to create
> a new framework but only a dedicated ioctl.

The software defined networking people seemed to think they had a use
case for this as well.  They're not entirely upstream of course but
still...

--w7ltkgfh4mxuyxeu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlih+IEACgkQJNaLcl1U
h9B0TAf/YJyoTsVgif9t2twY1AYqEt76E+AWmeQkhHy/gh9sh964a6D21qjGQuAx
0VmMErfMto6kt9hcgG6OZ/nw3+nMKk6nYOMKNbHo2WL2becaE7Rdnt8b8L794VU/
ZW8WDOhHqMeXMvHelX8b5xjp+xjd/P1Uq1516OTU4phJsA9NoRpHskUY5BhA0XBg
HR6u3AoqDsvd8b0DSrvbk/BzqA/GF8/Q+1JHBL89yW+dEhtFiT2vm8zHKQJBfnf9
iIVxH+pMcDt7TikRiI0FS15S5yjISOJw2S+xa7qSDp3g4CLRaUVyB0jyQ/D/rU9M
SL7QezfW63mfXq9X9vOrZ4PkKtqr0w==
=b56e
-----END PGP SIGNATURE-----

--w7ltkgfh4mxuyxeu--
