Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42628 "EHLO
        mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdFBRPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 13:15:06 -0400
Date: Fri, 2 Jun 2017 18:14:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Message-ID: <20170602171452.jvfef7empzj3fx2i@sirena.org.uk>
References: <20170601205850.24993-1-tiwai@suse.de>
 <20170601205850.24993-15-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tdjhx3ffwhmgfcws"
Content-Disposition: inline
In-Reply-To: <20170601205850.24993-15-tiwai@suse.de>
Subject: Re: [PATCH v2 14/27] ASoC: blackfin: Convert to the new PCM ops
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tdjhx3ffwhmgfcws
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2017 at 10:58:37PM +0200, Takashi Iwai wrote:
> Replace the copy and the silence ops with the new PCM ops.
> In AC97 and I2S-TDM mode, we need to convert back to frames, but
> otherwise the conversion is pretty straightforward.

Acked-by: Mark Brown <broonie@kernel.org>

--tdjhx3ffwhmgfcws
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlkxnQsACgkQJNaLcl1U
h9ABJwf/TL3p/jIZ54JN6muP/+eOVAx9L3So2W7/omgSr7cZuWoioomH7jk0G3Rf
YwNHJ5X573TXzxxgq9FYT7zrS8wBAkEqheVVlPqgQI22t1uUdc33CtTNSrGA9UUY
QEPnNFAIDm9DSEHYd6YWzRlpMVQdlIC8cHhGweorxbdld7jGs/PvX8YN9xdS8k8J
HOc/6TAEEEZXEQdcsqp6RxlwlsrdjJjB7gvOw3ndpldSsmS1qW2GC7K5hyATId7j
gEkZ4iJmjOLlF4qfPvV+M/BU313gj1GVS1SgGIfoCa75nwJFEsiSSvPViufK4z0y
0wVaKRHxSNawKgGqbRhKT6ZHp/mAUw==
=GKa8
-----END PGP SIGNATURE-----

--tdjhx3ffwhmgfcws--
