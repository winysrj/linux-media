Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59683 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcIBImC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 04:42:02 -0400
Date: Fri, 2 Sep 2016 09:41:59 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any
 transmitting time for tx only devices
Message-ID: <20160902084158.GA25342@gofer.mess.org>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160901171629.15422-6-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 02, 2016 at 02:16:27AM +0900, Andi Shyti wrote:
> Transmitters do not need to wait until the data has been sent
> (and of course received). Return before waiting.
> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/ir-lirc-codec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index c327730..d8953fb 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -153,7 +153,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  	}
>  
>  	ret = dev->tx_ir(dev, txbuf, count);
> -	if (ret < 0)
> +	if (ret < 0 || dev->driver_type == RC_DRIVER_IR_RAW_TX)

Just because a driver only does transmit doesn't mean its transmit ABI
should change.

Now this bit of code is pretty horrible. It ensures that the call to write()
takes at least as long as the length of the transmit IR by sleeping. That's
not much of a guarantee that the IR has been sent.

Note that in the case of ir-spi, since your spi transfer is sync no sleep
should be introduced here.

The gap calculation in lirc checks that if the call to write() took _longer_
than expected wait before sending the next IR code (when either multiple
IR codes or repeats are specified). Introducing the sleep in the kernel
here does not help at all, lirc already ensures that it waits as long as
the IR is long (see schedule_repeat_timer in lirc).

This change was introduced in 3.10, commit f8e00d5. 


Sean
