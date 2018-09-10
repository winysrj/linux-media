Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38785 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeIJOXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 10:23:40 -0400
Date: Mon, 10 Sep 2018 11:30:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        tglx@linutronix.de
Subject: Re: [PATCH 0/3] media: use irqsave() in USB's complete callback +
 remove local_irq_save
Message-ID: <20180910093030.l4waocm34cwux54j@linutronix.de>
References: <20180910092000.14693-1-bigeasy@linutronix.de>
 <20180910062557.46bfa38b@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180910062557.46bfa38b@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-09-10 06:25:57 [-0300], Mauro Carvalho Chehab wrote:
> Em Mon, 10 Sep 2018 11:19:57 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> escreveu:
> 
> > I've been looking at my queue and compared to v4.19-rc3. As it turns
> > out, everything was merged except for
> > 
> > 	media: em28xx-audio: use irqsave() in USB's complete
> > 	media: tm6000: use irqsave() in USB's complete callback
> > 
> > I haven't seen any reply to those two patches (like asking for changes)
> > so I assume that those two just fell through the cracks.
> > 
> > The last one is the final removal of the local_irq_save() statement once
> > all drivers were audited & fixed.
> 
> I suspect that it is better to merge it via sound tree, due to
> patch 3/3.

Sound? Sound like alsa? Or did you mean USB?

> So, for patches 1 and 2:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thank you. It would be nice if this would hit Linus in this cycle :)

> Thanks,
> Mauro

Sebastian
