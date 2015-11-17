Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54197 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbKQJ23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 04:28:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Xiubo Li <Xiubo.Lee@gmail.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Sergey Lapin <slapin@ossfans.org>, Timur Tabi <timur@tabi.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Tomas Cech <sleep_walker@suse.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Harald Welte <laforge@openezx.org>,
	openezx-devel@lists.openezx.org,
	Russell King <linux@arm.linux.org.uk>,
	Vinod Koul <vinod.koul@intel.com>,
	Takashi Iwai <tiwai@suse.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linuxppc-dev@lists.ozlabs.org,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Nicolin Chen <nicoleotsuka@gmail.com>,
	Mark Brown <broonie@kernel.org>, linux-fbdev@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Stefan Schmidt <stefan@openezx.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-mmc@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
	linux-spi@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
	dmaengine@vger.kernel.org, alsa-devel@alsa-project.org,
	Shawn Guo <shawnguo@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] [media] move media platform data to linux/platform_data/media
Date: Tue, 17 Nov 2015 10:23:37 +0100
Message-ID: <7319142.Cp8MurgLWk@wuerfel>
In-Reply-To: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
References: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 November 2015 07:15:59 Mauro Carvalho Chehab wrote:
> Now that media has its own subdirectory inside platform_data,
> let's move the headers that are already there to such subdir.
> 
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
