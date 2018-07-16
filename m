Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbeGPRNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 13:13:50 -0400
Date: Mon, 16 Jul 2018 18:45:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        tglx@linutronix.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2nd REPOST 0/5] media: use irqsave() in USB's complete
 callback
Message-ID: <20180716164534.GB17550@kroah.com>
References: <20180710161833.2435-1-bigeasy@linutronix.de>
 <20180716163023.3t7bg4ajks34pzo2@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180716163023.3t7bg4ajks34pzo2@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 16, 2018 at 06:30:24PM +0200, Sebastian Andrzej Siewior wrote:
> On 2018-07-10 18:18:28 [+0200], To linux-media@vger.kernel.org wrote:
> > This is the second repost of the "please use _irqsave() primitives in the
> > completion callback in order to get rid of local_irq_save() in
> > __usb_hcd_giveback_urb()" series for the media subsystem. I saw no
> > feedback from Mauro so far.
> > 
> > The other patches were successfully routed through their subsystems so
> > far and pop up in linux-next (except for the ath9k but it is merged in
> > its ath9k tree so it is okay).
> 
> I posted this series on 2018-07-01 and reposted it on 2018-07-10 (as
> part of this thread). Greg would you mind routing this series through
> your tree?  I haven't seen a reply from Mauro and these five patches are
> the only missing piece to get rid of local_irq_save() in
> __usb_hcd_giveback_urb().

I don't have them anymore, and these really should go through the media
tree, not mine.

thanks,

greg k-h
