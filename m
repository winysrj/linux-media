Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:36872 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754363AbeFUHhN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 03:37:13 -0400
Date: Thu, 21 Jun 2018 09:37:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 22/27] media: ttusbir: use usb_fill_int_urb()
Message-ID: <20180621073706.vaicw7y3e4fwq3sk@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
 <20180620110105.19955-23-bigeasy@linutronix.de>
 <20180620205049.dh6ewnlxbphfg7wi@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180620205049.dh6ewnlxbphfg7wi@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-20 21:50:49 [+0100], Sean Young wrote:
> On Wed, Jun 20, 2018 at 01:01:00PM +0200, Sebastian Andrzej Siewior wrote:
> > Using usb_fill_int_urb() helps to find code which initializes an
> > URB. A grep for members of the struct (like ->complete) reveal lots
> > of other things, too.
> 
> The reason I didn't use usb_fill_int_urb() is that is not an interrupt
> urb, it's a iso urb. I'm not sure what affect the interval handling
> in usb_fill_int_urb() will have on this.

It is wrong, I had false memory on regarding ISO/FS. There will be a
respin a of the usb_fill* patches once we have usb_fill_iso_urb().

Mauro, could you please consider only the !fill patches from the series:
  [PATCH 04/27] media: cx231xx: use irqsave() in USB's complete callback
  [PATCH 07/27] media: em28xx-audio: use GFP_KERNEL for memory allocation during init
  [PATCH 08/27] media: em28xx-audio: use irqsave() in USB's complete callback
  [PATCH 10/27] media: go7007: use irqsave() in USB's complete callback
  [PATCH 14/27] media: gspca: sq930x: use GFP_KERNEL in sd_dq_callback()
  [PATCH 19/27] media: tm6000: use irqsave() in USB's complete callback
  [PATCH 23/27] media: usbtv: use irqsave() in USB's complete callback
  [PATCH 25/27] media: usbvision: remove time_in_irq

> Sean

Sebastian
