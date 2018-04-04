Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:46725 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbeDDTtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 15:49:35 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        driverdevel <devel@driverdev.osuosl.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/15] ARM: pxa: switch to DMA slave maps
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
        <CAPDyKFot9dAST2jQL5s8E4U=bCHxkio=uwpqPd6S0N4FWJRB-w@mail.gmail.com>
Date: Wed, 04 Apr 2018 21:49:26 +0200
In-Reply-To: <CAPDyKFot9dAST2jQL5s8E4U=bCHxkio=uwpqPd6S0N4FWJRB-w@mail.gmail.com>
        (Ulf Hansson's message of "Tue, 3 Apr 2018 17:08:42 +0200")
Message-ID: <874lkq4urd.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On 2 April 2018 at 16:26, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
>> Hi,
>>
>> This serie is aimed at removing the dmaengine slave compat use, and transfer
>> knowledge of the DMA requestors into architecture code.
>> As this looks like a patch bomb, each maintainer expressing for his tree either
>> an Ack or "I want to take through my tree" will be spared in the next iterations
>> of this serie.
>
> Perhaps an option is to send this hole series as PR for 3.17 rc1, that
> would removed some churns and make this faster/easier? Well, if you
> receive the needed acks of course.
For 3.17-rc1 it looks a bit optimistic with the review time ... If I have all
acks, I'll queue it into my pxa tree. If at least one maintainer withholds his
ack, the end of the serie (phase 3) won't be applied until it is sorted out.

Cheers.

--
Robert
