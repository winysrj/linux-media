Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbeIJUww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:52:52 -0400
Date: Mon, 10 Sep 2018 12:58:03 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        tglx@linutronix.de
Subject: Re: [PATCH 0/3] media: use irqsave() in USB's complete callback +
 remove local_irq_save
Message-ID: <20180910125803.12e501a0@coco.lan>
In-Reply-To: <20180910133758.GC8309@kroah.com>
References: <20180910092000.14693-1-bigeasy@linutronix.de>
        <20180910062557.46bfa38b@coco.lan>
        <20180910093030.l4waocm34cwux54j@linutronix.de>
        <20180910133758.GC8309@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Sep 2018 15:37:58 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Mon, Sep 10, 2018 at 11:30:30AM +0200, Sebastian Andrzej Siewior wrote:
> > On 2018-09-10 06:25:57 [-0300], Mauro Carvalho Chehab wrote:  
> > > Em Mon, 10 Sep 2018 11:19:57 +0200
> > > Sebastian Andrzej Siewior <bigeasy@linutronix.de> escreveu:
> > >   
> > > > I've been looking at my queue and compared to v4.19-rc3. As it turns
> > > > out, everything was merged except for
> > > > 
> > > > 	media: em28xx-audio: use irqsave() in USB's complete
> > > > 	media: tm6000: use irqsave() in USB's complete callback
> > > > 
> > > > I haven't seen any reply to those two patches (like asking for changes)
> > > > so I assume that those two just fell through the cracks.
> > > > 
> > > > The last one is the final removal of the local_irq_save() statement once
> > > > all drivers were audited & fixed.  
> > > 
> > > I suspect that it is better to merge it via sound tree, due to
> > > patch 3/3.  
> > 
> > Sound? Sound like alsa? Or did you mean USB?

Yeah, it makes more sense to merge at via USB tree. Feel free to add it there.

Regards,
Mauro
