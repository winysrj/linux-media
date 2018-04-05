Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38571 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeDEGuF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 02:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoFz_HgYPOMGuOTpehrTR3DtWE3uZbcnVwUwVhDy02Mow@mail.gmail.com>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
 <CAPDyKFot9dAST2jQL5s8E4U=bCHxkio=uwpqPd6S0N4FWJRB-w@mail.gmail.com>
 <874lkq4urd.fsf@belgarion.home> <20180404215623.2bf07406@bbrezillon> <CAPDyKFoFz_HgYPOMGuOTpehrTR3DtWE3uZbcnVwUwVhDy02Mow@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 5 Apr 2018 08:50:03 +0200
Message-ID: <CAK8P3a1Y0X-2QQm+adXO8xNr7Z6SU6rDjZs8JhRskX-UrseyRw@mail.gmail.com>
Subject: Re: [PATCH 00/15] ARM: pxa: switch to DMA slave maps
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Boris Brezillon <boris.brezillon@bootlin.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Daniel Mack <daniel@zonque.org>,
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
        Mark Brown <broonie@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>, dmaengine@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 5, 2018 at 8:29 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 4 April 2018 at 21:56, Boris Brezillon <boris.brezillon@bootlin.com> wrote:
>> On Wed, 04 Apr 2018 21:49:26 +0200
>> Robert Jarzmik <robert.jarzmik@free.fr> wrote:
>>
>>> Ulf Hansson <ulf.hansson@linaro.org> writes:
>>>
>>> > On 2 April 2018 at 16:26, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
>>> >> Hi,
>>> >>
>>> >> This serie is aimed at removing the dmaengine slave compat use, and transfer
>>> >> knowledge of the DMA requestors into architecture code.
>>> >> As this looks like a patch bomb, each maintainer expressing for his tree either
>>> >> an Ack or "I want to take through my tree" will be spared in the next iterations
>>> >> of this serie.
>>> >
>>> > Perhaps an option is to send this hole series as PR for 3.17 rc1, that
>>> > would removed some churns and make this faster/easier? Well, if you
>>> > receive the needed acks of course.
>>> For 3.17-rc1 it looks a bit optimistic with the review time ... If I have all
>>
>> Especially since 3.17-rc1 has been released more than 3 years ago :-),
>> but I guess you meant 4.17-rc1.
>
> Yeah, I realize that I was a bit lost in time yesterday. Even more
> people have been having fun about it (me too). :-)

I occasionally still type 2.6.17 when I mean 4.17.

       Arnd
