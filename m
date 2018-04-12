Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:42091 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753032AbeDLQzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:55:47 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mark Brown <broonie@kernel.org>
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
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
        <20180402142656.26815-9-robert.jarzmik@free.fr>
        <20180412152632.GG9929@sirena.org.uk>
Date: Thu, 12 Apr 2018 18:55:28 +0200
In-Reply-To: <20180412152632.GG9929@sirena.org.uk> (Mark Brown's message of
        "Thu, 12 Apr 2018 16:26:32 +0100")
Message-ID: <87a7u82wlb.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Brown <broonie@kernel.org> writes:

> On Mon, Apr 02, 2018 at 04:26:49PM +0200, Robert Jarzmik wrote:
>> As the pxa architecture switched towards the dmaengine slave map, the
>> old compatibility mechanism to acquire the dma requestor line number and
>> priority are not needed anymore.
>
> Acked-by: Mark Brown <broonie@kernel.org>
>
> If there's no dependency I'm happy to take this for 4.18.
Thanks for the ack.

The patches 1 and 2 are the dependency here, so I'd rather push it through my
tree once the review is complete.

Cheers.

-- 
Robert
