Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35746 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbbKQKlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 05:41:16 -0500
Date: Tue, 17 Nov 2015 10:37:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Acked-by: Arnd Bergmann" <arnd@arndb.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Stefan Schmidt <stefan@openezx.org>,
	Harald Welte <laforge@openezx.org>,
	Tomas Cech <sleep_walker@suse.com>,
	Sergey Lapin <slapin@ossfans.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Timur Tabi <timur@tabi.org>,
	Nicolin Chen <nicoleotsuka@gmail.com>,
	Xiubo Li <Xiubo.Lee@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, dmaengine@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Message-ID: <20151117103708.GL31303@sirena.org.uk>
References: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AQNmCumFClRcGgHG"
Content-Disposition: inline
In-Reply-To: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] move media platform data to
 linux/platform_data/media
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AQNmCumFClRcGgHG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 17, 2015 at 07:15:59AM -0200, Mauro Carvalho Chehab wrote:
> Now that media has its own subdirectory inside platform_data,
> let's move the headers that are already there to such subdir.

Acked-by: Mark Brown <broonie@kernel.org>

--AQNmCumFClRcGgHG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWSwNTAAoJECTWi3JdVIfQ4KQH/jRi+u9vkGEn+1iMaGVdyCee
J9U0tvtwOAlMOWV4MZJ6mINHE6nw6FQwEly8DLanBOkj9MtPKoiHejzPT9KPG5zl
8895O9NAhgLh4DFi8rsoMsBx1lwK3YM0mXgdmRQxlkOkMcJd/7AsApobMen5IbwN
q/7pMetyDSg9nRAcUQgRu2uJJLJpWmkDP/LgRCfYQDJtqQPDE/x9mEf1fAZ1QJ44
gFxTJqlb6VUKa0K7puMfcNLmSaedJYx7DanpbiRGobzT+Zdi6dv+99nOcJsPqp3b
kRRC2FU6gIrzJIO7kyUssJSxzPehZGP/LP8SSU0lHL3BZ5+VIsNemzMAJv+hsiA=
=fW+n
-----END PGP SIGNATURE-----

--AQNmCumFClRcGgHG--
