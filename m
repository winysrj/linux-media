Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:34105 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935859AbeFRTbr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 15:31:47 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 06/14] mtd: rawnand: marvell: remove the dmaengine compat need
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
        <20180617170217.24177-7-robert.jarzmik@free.fr>
        <3a2a8951-f380-af99-bf97-6ff722404410@zonque.org>
Date: Mon, 18 Jun 2018 21:31:27 +0200
In-Reply-To: <3a2a8951-f380-af99-bf97-6ff722404410@zonque.org> (Daniel Mack's
        message of "Sun, 17 Jun 2018 20:12:49 +0200")
Message-ID: <87h8lzriwg.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> On Sunday, June 17, 2018 07:02 PM, Robert Jarzmik wrote:
>> As the pxa architecture switched towards the dmaengine slave map, the
>> old compatibility mechanism to acquire the dma requestor line number and
>> priority are not needed anymore.
>>
>> This patch simplifies the dma resource acquisition, using the more
>> generic function dma_request_slave_channel().
>>
>> Signed-off-by: Signed-off-by: Daniel Mack <daniel@zonque.org>
>
> Something went wrong here, but you can simply fix that when applying the series
> :)
Indeed, fixed before applying to the pxa/for-next tree.

--
Robert
