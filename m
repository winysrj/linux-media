Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52271 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbeGPQ6g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:58:36 -0400
Date: Mon, 16 Jul 2018 18:30:24 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: tglx@linutronix.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2nd REPOST 0/5] media: use irqsave() in USB's complete
 callback
Message-ID: <20180716163023.3t7bg4ajks34pzo2@linutronix.de>
References: <20180710161833.2435-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180710161833.2435-1-bigeasy@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-10 18:18:28 [+0200], To linux-media@vger.kernel.org wrote:
> This is the second repost of the "please use _irqsave() primitives in the
> completion callback in order to get rid of local_irq_save() in
> __usb_hcd_giveback_urb()" series for the media subsystem. I saw no
> feedback from Mauro so far.
> 
> The other patches were successfully routed through their subsystems so
> far and pop up in linux-next (except for the ath9k but it is merged in
> its ath9k tree so it is okay).

I posted this series on 2018-07-01 and reposted it on 2018-07-10 (as
part of this thread). Greg would you mind routing this series through
your tree?  I haven't seen a reply from Mauro and these five patches are
the only missing piece to get rid of local_irq_save() in
__usb_hcd_giveback_urb().

Sebastian
