Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35346 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967113AbeEXN7C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 09:59:02 -0400
Date: Thu, 24 May 2018 14:58:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 08/13] ASoC: pxa: remove the dmaengine compat need
Message-ID: <20180524135836.GR4828@sirena.org.uk>
References: <20180524070703.11901-1-robert.jarzmik@free.fr>
 <20180524070703.11901-9-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="brdEIFGMNIjz5YJG"
Content-Disposition: inline
In-Reply-To: <20180524070703.11901-9-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--brdEIFGMNIjz5YJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 24, 2018 at 09:06:58AM +0200, Robert Jarzmik wrote:
> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.

Acked-by: Mark Brown <broonie@kernel.org>

--brdEIFGMNIjz5YJG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlsGxQsACgkQJNaLcl1U
h9AOOQf+ICndtAhAUcJYotu2F1wfe6zK/SmwQs2RaAzNMRnQTNmdgQDHaITOBSE0
juDyVbEzdIjDwHmu3lB6bZ+mj3MDpGeJ1DPvvi6aI+pkDH/J16XMXXTchXyo3NI0
db1lLlmXYiTbnsVGU2bO6hMCG588Us7ZyHzt2pxD0f9LqNzy3f617uD3fSQZSzrd
a5JyJZMHQfoIhO58gKX7fQ+JVum/7BFb2S4eFv/DZPZsU9Gy96h0viVcyImmE+ri
qS4cfZJlV/PC7m4GYIP8V23Dl6rj8wsh7YvKUUtat6tIqGRkZtHFEo6BCQedA3Ka
+7F7zfmpLYaC8VeKI0Fp8fxfDYF0Jg==
=gxiC
-----END PGP SIGNATURE-----

--brdEIFGMNIjz5YJG--
