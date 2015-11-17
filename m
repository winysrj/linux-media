Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55091 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbKQLLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 06:11:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Bondarenko <anton.bondarenko.sama@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Xiubo Li <Xiubo.Lee@gmail.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Sergey Lapin <slapin@ossfans.org>, Timur Tabi <timur@tabi.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Tomas Cech <sleep_walker@suse.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Harald Welte <laforge@openezx.org>,
	openezx-devel@lists.openezx.org,
	Russell King <linux@arm.linux.org.uk>,
	Vinod Koul <vinod.koul@intel.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Schmidt <stefan@openezx.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Nicolin Chen <nicoleotsuka@gmail.com>,
	Mark Brown <broonie@kernel.org>, linux-fbdev@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-mmc@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
	linux-spi@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
	dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] [media] move media platform data to linux/platform_data/media
Date: Tue, 17 Nov 2015 11:58:52 +0100
Message-ID: <17824361.38HLxMaChG@wuerfel>
In-Reply-To: <564B04CF.1090507@gmail.com>
References: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com> <7319142.Cp8MurgLWk@wuerfel> <564B04CF.1090507@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 November 2015 11:43:27 Anton Bondarenko wrote:
> On 17.11.2015 10:23, Arnd Bergmann wrote:
> > On Tuesday 17 November 2015 07:15:59 Mauro Carvalho Chehab wrote:
> >> Now that media has its own subdirectory inside platform_data,
> >> let's move the headers that are already there to such subdir.
> >>
> >>
> >
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Why does dma-imx.h also moved? It's the generic file, not a media specific.

You are right, I missed that when I looked at the patch. That part
of the patch needs to be taken out.

	Arnd
