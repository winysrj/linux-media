Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:51166 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab2IIW0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 18:26:32 -0400
Date: Sun, 9 Sep 2012 23:26:30 +0100
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] [media] rc-core: prevent divide by zero bug in
 s_tx_carrier()
Message-ID: <20120909222629.GA28355@pequod.mess.org>
References: <20120909203142.GA12296@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909203142.GA12296@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 09, 2012 at 11:31:42PM +0300, Dan Carpenter wrote:
> Several of the drivers use carrier as a divisor in their s_tx_carrier()
> functions.  We should do a sanity check here like we do for
> LIRC_SET_REC_CARRIER.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Ben Hutchings pointed out that my first patch was not a complete
>     fix.
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 6ad4a07..28dc0f0 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -211,6 +211,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  		if (!dev->s_tx_carrier)
>  			return -EINVAL;

This should be ENOSYS.

>  
> +		if (val <= 0)
> +			return -EINVAL;
> +

1) val is unsigned so it would never be less than zero.

2) A value of zero means disabling carrier modulation, which is used by 
   the mceusb driver.

So the check belongs in the individual drivers, as in the original patch.


Sean
