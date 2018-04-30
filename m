Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:38056 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752255AbeD3RtC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 13:49:02 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc: linaro-mm-sig@lists.linaro.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 01/17] dma-fence: Some kerneldoc polish for dma-fence.h
In-Reply-To: <20180427061724.28497-2-daniel.vetter@ffwll.ch>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch> <20180427061724.28497-2-daniel.vetter@ffwll.ch>
Date: Mon, 30 Apr 2018 10:49:00 -0700
Message-ID: <877eoozisz.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> +	/**
> +	 * @fill_driver_data:
> +	 *
> +	 * Callback to fill in free-form debug info Returns amount of bytes
> +	 * filled, or negative error on failure.

Maybe this "Returns" should be on a new line?  Or at least a '.' in
between.

Other than that,

Reviewed-by: Eric Anholt <eric@anholt.net>

Thanks!

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlrnVwwACgkQtdYpNtH8
nujHLQ/9GWSWC/uQFB5pmZxSPU0b2w4fJcjCTLCSTRAP9sNBXYTvbAVzPL2hsiJ8
/e+yUJRs7UEPEmNe0eLcvuvL3H15B2gSTYPBjrT1tNl0I4bi+nJ1K1F1C2ogMqEg
Dw2upTlnqxoy/weuBTKwlDA61S5NYveNfo9vZsHGU9Lm24tXiNXfCzA+XPh+XiIB
6W1Tj7P2pEz21fFopCyXoneNVDoLxouYS0PaO4ViEws4O2OJPZRBOOYVR8uPE23A
6H3kAVyoNtXGY3/irJMX/Dqge089dfZJvIWDE7Hm8C+1r5zIZomyBJt/8coxDEVc
zTwOAZSSHNu+/PC098gdUiyRXovH6pXRoJtryaJ9Pboutk7X+00XxLSVLuvuewGe
Er3WY37ZrPFCISlPepOaUPtMdbjhtHhZyIwyoARDwbXeFg/XjsrleoNZln5LVrtj
3LHpN3NYmm89wOXFkQYwxN8+1jlakJPJ7RYd/8TuO55c0B2o3gfoBbDLE5jUzGwj
UgvxTo/EymJBrWwAq9TYoZNKG2FI07abZeq/4Nz0puQdnY8E1xs4F6jGcrVpBSwm
89YFjVC6fCadZbnFsg89zVQtOLkF2+nPGVSK/Uvnf9b+Ay7RaQWfeNhpnVcDtOtw
5jf6Fb+lj0WyLWnlkVXsz7x1Q/BD9GOxCEpe/rlr2Lueo6oIkn8=
=pKnJ
-----END PGP SIGNATURE-----
--=-=-=--
