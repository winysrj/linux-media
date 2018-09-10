Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbeIJOTO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:19:14 -0400
Date: Mon, 10 Sep 2018 06:25:57 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        tglx@linutronix.de
Subject: Re: [PATCH 0/3] media: use irqsave() in USB's complete callback +
 remove local_irq_save
Message-ID: <20180910062557.46bfa38b@coco.lan>
In-Reply-To: <20180910092000.14693-1-bigeasy@linutronix.de>
References: <20180910092000.14693-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Sep 2018 11:19:57 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> escreveu:

> I've been looking at my queue and compared to v4.19-rc3. As it turns
> out, everything was merged except for
> 
> 	media: em28xx-audio: use irqsave() in USB's complete
> 	media: tm6000: use irqsave() in USB's complete callback
> 
> I haven't seen any reply to those two patches (like asking for changes)
> so I assume that those two just fell through the cracks.
> 
> The last one is the final removal of the local_irq_save() statement once
> all drivers were audited & fixed.

I suspect that it is better to merge it via sound tree, due to
patch 3/3.

So, for patches 1 and 2:

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks,
Mauro
