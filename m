Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57193 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbeDDT41 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 15:56:27 -0400
Date: Wed, 4 Apr 2018 21:56:23 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
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
Message-ID: <20180404215623.2bf07406@bbrezillon>
In-Reply-To: <874lkq4urd.fsf@belgarion.home>
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
        <CAPDyKFot9dAST2jQL5s8E4U=bCHxkio=uwpqPd6S0N4FWJRB-w@mail.gmail.com>
        <874lkq4urd.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 04 Apr 2018 21:49:26 +0200
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Ulf Hansson <ulf.hansson@linaro.org> writes:
> 
> > On 2 April 2018 at 16:26, Robert Jarzmik <robert.jarzmik@free.fr> wrote:  
> >> Hi,
> >>
> >> This serie is aimed at removing the dmaengine slave compat use, and transfer
> >> knowledge of the DMA requestors into architecture code.
> >> As this looks like a patch bomb, each maintainer expressing for his tree either
> >> an Ack or "I want to take through my tree" will be spared in the next iterations
> >> of this serie.  
> >
> > Perhaps an option is to send this hole series as PR for 3.17 rc1, that
> > would removed some churns and make this faster/easier? Well, if you
> > receive the needed acks of course.  
> For 3.17-rc1 it looks a bit optimistic with the review time ... If I have all

Especially since 3.17-rc1 has been released more than 3 years ago :-),
but I guess you meant 4.17-rc1.

> acks, I'll queue it into my pxa tree. If at least one maintainer withholds his
> ack, the end of the serie (phase 3) won't be applied until it is sorted out.
> 
> Cheers.
> 
> --
> Robert
