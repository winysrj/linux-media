Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52321 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcGDVGx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 17:06:53 -0400
Date: Mon, 4 Jul 2016 22:06:50 +0100
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: nuvoton: decrease size of raw event fifo
Message-ID: <20160704210650.GA29388@gofer.mess.org>
References: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
 <20160704201338.GA28620@gofer.mess.org>
 <fa0d5ad8-961d-60f2-f2e4-eeb7407e0210@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa0d5ad8-961d-60f2-f2e4-eeb7407e0210@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 04, 2016 at 10:51:50PM +0200, Heiner Kallweit wrote:
> Am 04.07.2016 um 22:13 schrieb Sean Young:
> > On Wed, May 18, 2016 at 10:29:41PM +0200, Heiner Kallweit wrote:
> >> This chip has a 32 byte HW FIFO only. Therefore the default fifo size
> >> of 512 raw events is not needed and can be significantly decreased.
> >>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > 
> > The 32 byte hardware queue is read from an interrupt handler and added
> > to the kfifo. The kfifo is read by the decoders in a seperate kthread
> > (in ir_raw_event_thread). If we have a long IR (e.g. nec which has 
> > 66 edges) and the kthread is not scheduled in time (e.g. high load), will
> > we not end up with an overflow in the kfifo and unable to decode it?
> > 
> The interrupt handler is triggered latest when 24 bytes have been read.
> (at least that's how the chip gets configured at the moment)
> This gives the decoder thread at least 8 bytes time to process the
> kfifo. This should be sufficient even under high load.

No, it gives the interrupt handler at least 8 bytes time to read the
hardware fifo (and add it to the kfifo). There are no guarantees about
when the decoder kthread runs (which reads the kfifo).

To put it another way, in the nuvoton interrupt handler, you call 
ir_raw_event_handle() which does a wake_up_process(). That puts the
decoder process (it has a pid) in a runnable state and it will run at
some future time.


Sean
