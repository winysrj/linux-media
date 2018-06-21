Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:39777 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932466AbeFUIuR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 04:50:17 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mark Brown <broonie@kernel.org>, Daniel Mack <daniel@zonque.org>
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 09/14] ASoC: pxa: remove the dmaengine compat need
References: <20180617170217.24177-1-robert.jarzmik@free.fr>
        <20180617170217.24177-10-robert.jarzmik@free.fr>
        <1984a4a7-e33b-6349-31f3-6f85ff1582b8@zonque.org>
Date: Thu, 21 Jun 2018 10:50:03 +0200
In-Reply-To: <1984a4a7-e33b-6349-31f3-6f85ff1582b8@zonque.org> (Daniel Mack's
        message of "Sun, 17 Jun 2018 20:17:09 +0200")
Message-ID: <87muvoo75w.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> Hi Mark,
>
> I prepared a series of patches for 4.18 that conflict with this one. Instead of
> letting other people resolve this down the road, I'd prefer if this one went
> through the ASoC tree, if you don't mind.
>
> I've talked to Robert off-list, and he's fine with this approach.
That's right.

I'll tentativaly queue this patch to my pxa/for-next tree. As soon as I hear
that Mark queued it up in his tree, I'll drop it from mine.

Cheers.

--
Robert
