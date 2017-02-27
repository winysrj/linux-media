Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdB0IVk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 03:21:40 -0500
Date: Mon, 27 Feb 2017 09:21:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Man Choy <manchoyy@gmail.com>
Cc: bhumirks@gmail.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm2048: Fix checkpatch checks
Message-ID: <20170227082131.GA18819@kroah.com>
References: <1487389982-26131-1-git-send-email-manchoyy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487389982-26131-1-git-send-email-manchoyy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 18, 2017 at 11:52:37AM +0800, Man Choy wrote:
> Fix following checks:
> 
> CHECK: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> +       BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
> 
> CHECK: spaces preferred around that '+' (ctx:VxV)
> +       BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
>                      ^
> 
> CHECK: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> +       BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
> 
> CHECK: spaces preferred around that '+' (ctx:VxV)
> +       BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
>                      ^
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 37bd439..d5ee279 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -1534,7 +1534,7 @@ static int bcm2048_parse_rt_match_c(struct bcm2048_device *bdev, int i,
>  	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
>  		return 0;
>  
> -	BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
> +	WARN_ON((index + 2) >= BCM2048_MAX_RDS_RT);

Ick, no to all of these!  What happens if this is true, the code will
crash, right?  You have to properly recover from this, don't just throw
the message out to userspace and then keep on going.

You can't just do a search/replace for this, otherwise it would have
been done already :)

thanks,

greg k-h
