Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35778 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbeDLP1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:27:35 -0400
Date: Thu, 12 Apr 2018 16:26:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Nicolas Pitre <nico@fluxnic.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 08/15] ASoC: pxa: remove the dmaengine compat need
Message-ID: <20180412152632.GG9929@sirena.org.uk>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
 <20180402142656.26815-9-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Content-Disposition: inline
In-Reply-To: <20180402142656.26815-9-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2018 at 04:26:49PM +0200, Robert Jarzmik wrote:
> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.

Acked-by: Mark Brown <broonie@kernel.org>

If there's no dependency I'm happy to take this for 4.18.

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlrPeqcACgkQJNaLcl1U
h9BSZAf/TjOZQziPXrBJ727QgQKnwF8+6GXuQPc3HlwShDoJ9qAWnzcOSwzJ8fkE
dcG2858Zo0M7NCqcoOokOhM4wKUOn3aCE78wDsjEPX/PohKdI3uHZXBLbSrFaSF8
y1TYjHDRCKqYTTfaG4bNfONcAb+ymbxjGD4ZOsrkV82pl8tCA+zCT5g6C8PrqshL
GwwmmJQHGK0CU477p0+QN/EsW/B9VNLNsqpeFS9WAlZcTuA004mW/3YYf8hwpk0i
pFqD2AXnmrDVsynBm78eKaAtqMRUkd0I/iWRWqFf7DtVVx6Foo8877fCdcVLYgYI
mArYZJIh+YC/f25ftES/xWmAqIokOQ==
=INfO
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
