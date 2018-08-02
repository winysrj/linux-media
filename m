Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbeHBTj4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 15:39:56 -0400
Date: Thu, 2 Aug 2018 14:47:43 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org, tglx@linutronix.de,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2nd REPOST 0/5] media: use irqsave() in USB's complete
 callback
Message-ID: <20180802144743.38fc779b@coco.lan>
In-Reply-To: <20180710161833.2435-1-bigeasy@linutronix.de>
References: <20180710161833.2435-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Jul 2018 18:18:28 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> escreveu:

> This is the second repost of the "please use _irqsave() primitives in the
> completion callback in order to get rid of local_irq_save() in
> __usb_hcd_giveback_urb()" series for the media subsystem. I saw no
> feedback from Mauro so far.
> 
> The other patches were successfully routed through their subsystems so
> far and pop up in linux-next (except for the ath9k but it is merged in
> its ath9k tree so it is okay).

Sorry for the long wait... has been busy those days with two international
trips to the opposite side of the world.

I'm handling those today.

Thanks,
Mauro
