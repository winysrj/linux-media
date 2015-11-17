Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:60729 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbKQUqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 15:46:34 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Acked-by\: Arnd Bergmann" <arnd@arndb.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
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
Subject: Re: [PATCH] [media] move media platform data to linux/platform_data/media
References: <4d99e49726942dc4d6a6ee1debf6665b2b47908b.1447751746.git.mchehab@osg.samsung.com>
	<20151117103708.GL31303@sirena.org.uk>
Date: Tue, 17 Nov 2015 21:46:08 +0100
In-Reply-To: <20151117103708.GL31303@sirena.org.uk> (Mark Brown's message of
	"Tue, 17 Nov 2015 10:37:08 +0000")
Message-ID: <87wptg8icv.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Brown <broonie@kernel.org> writes:

> On Tue, Nov 17, 2015 at 07:15:59AM -0200, Mauro Carvalho Chehab wrote:
>> Now that media has its own subdirectory inside platform_data,
>> let's move the headers that are already there to such subdir.
>
> Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
