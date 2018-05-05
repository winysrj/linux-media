Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeEELPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 07:15:02 -0400
Date: Sat, 5 May 2018 08:14:57 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com, crope@iki.fi
Subject: Re: [PATCH v5 4/5] dvb-usb-v2/gl861: use usleep_range() for short
 delay
Message-ID: <20180505081457.2fa21529@vento.lan>
In-Reply-To: <20180408172138.9974-5-tskd08@gmail.com>
References: <20180408172138.9974-1-tskd08@gmail.com>
        <20180408172138.9974-5-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 02:21:37 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> As the kernel doc "timers-howto.txt" reads,
> short delay with msleep() can take much longer.
> In a case of raspbery-pi platform where CONFIG_HZ_100 was set,
> it actually affected the init of Friio devices
> since it issues lots of i2c transactions with short delay.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
> Changes since v4:
> - none
> 
>  drivers/media/usb/dvb-usb-v2/gl861.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
> index ecff0062bfb..cdd7bfcb883 100644
> --- a/drivers/media/usb/dvb-usb-v2/gl861.c
> +++ b/drivers/media/usb/dvb-usb-v2/gl861.c
> @@ -45,7 +45,7 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
>  		return -EINVAL;
>  	}
>  
> -	msleep(1); /* avoid I2C errors */
> +	usleep_range(1000, 2000); /* avoid I2C errors */

Actually, this change is puntual and applies even without patch 3/5.

So, I'll apply this one too.

So, next time, just patches 3 and 5 will be needed.


>  
>  	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), req, type,
>  			       value, index, rbuf, rlen, 2000);



Thanks,
Mauro
