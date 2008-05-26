Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QFG6GV025262
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 11:16:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QFFV7D013359
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 11:15:31 -0400
Date: Mon, 26 May 2008 12:15:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Domenico Andreoli <cavokz@gmail.com>
Message-ID: <20080526121513.60a1ea21@gaivota>
In-Reply-To: <20080526145830.GA22459@ska.dandreoli.com>
References: <20080525020028.GA22425@ska.dandreoli.com>
	<20080526073959.5a624288@gaivota>
	<20080526145830.GA22459@ska.dandreoli.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Driver Developers <devel@driverdev.osuosl.org>,
	video4linux-list@redhat.com
Subject: Re: TW6800 based video capture boards
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


> > Just do your work and submit us the code. We'll analyze it and point for
> > issues, if needed ;) If you have any doubts about V4L2, I can help you.
> 
> The given driver is not a patch but a zip of the modified bt8xx directory
> taken from 2.6.18. Their changes do not integrate with existing bttv
> driver, which has been cannibalized as if one would use V4L only with
> their cards. You want a different kernel version, you unzip the driver
> in the new tree, easy.
> 
> These TW6800 chips must somewhat resemble Bt848/878, the given driver
> is based on bttv. Anyway they differ in many points, some are trivial
> changes while other are more substantial. My impression is that the
> design of TW6800 shares some points with the one of Bt848 but it is
> fundamentally a different beast.
> 
> If support to TW6800 has to be provided in the bttv driver, it seem the
> most logical choice at the first glance, the bttv's framework needs to
> be changed accordingly.

Since this is a different chipset, I think that the better is to have a
different driver for it, instead of "abusing" on bttv driver. This driver is
already very big and messy, due to the large amount of different boards
supported, and several board-specific code written directly inside bttv-driver
and bttv-cards.

> For instance, in bttv-gpio.c those few helper function work with
> registers at a different location, everything else is left as the
> original bttv driver. So supposing to provide and additional set of
> functions specific to TW6800 they should be called instead of the
> original generic bttv Bt848 ones ony for TW6800 cards at runtime. A
> new bttv_ops entry, if anything like this exists.
> 
> I have also some thoughts for bttv-risc.c. What is it? It is used
> to generate any RISC op-codes to be downloaded on the board? It seem
> responsible for DMA operations.

Yes, that's the idea. Those chips have a set of risc instructions that needed
to be loaded. Those risc code will command data send, via DMA, to the
motherboard.

bttv, cx88 and cx23885 drivers share the same risc code,
provided by btcx-risc.c. bttv-risc.c has some code that is specific for bttv.
 
> There is the biggest chunk of changes in bttv-driver.c but I still have
> to dig into it.
> 
> Finally, the bttv driver needs a restyle for V4L2, right? So it would
> be a shame to use it to fork the TW6800 support, wouldn't it? Which
> are the plans here?

True. We've recently removed V4L1 code from it, and turned it to use
video_ioctl2, but there are still several V4L1 style coding inside.

If you are willing to write a new driver, I suggest you to use a more modern
driver as a model. I would suggest you to take cx88 as a model.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
