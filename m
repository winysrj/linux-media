Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1DPABR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 20:01:17 -0400
Subject: Re: [PATCH] [media] lmedm04: Do not unlock mutex if
 mutex_lock_interruptible failed
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1302900017-10437-1-git-send-email-khoroshilov@ispras.ru>
References: <1302900017-10437-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 01:01:08 +0100
Message-ID: <1302912068.2177.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-04-16 at 00:40 +0400, Alexey Khoroshilov wrote:
> There are a couple of places where mutex_unlock() is called even 
> if mutex_lock_interruptible() failed. The patch fixes the issue.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/dvb/dvb-usb/lmedm04.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index f2db012..40907df 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -591,9 +591,10 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	else {
>  		deb_info(1, "STM Steam Off");
>  		/* mutex is here only to avoid collision with I2C */
> -		ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
> +		if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
> +			return -EAGAIN;
>  
> -		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
> +		ret = lme2510_usb_talk(adap->dev, clear_reg_3,
>  				sizeof(clear_reg_3), rbuf, rlen);
>  		st->stream_on = 0;
>  		st->i2c_talk_onoff = 1;

Unfortunately dvb-usb does not provide -EAGAIN on streaming_ctrl
stopping and returns 0 instead.

This code is deliberate even if the i2c_mutex is unlocked, the code must
be executed, and is protected by on going i2c_mutex by the usb_mutex.

This patch produces a intermittent stall on channel change.

Regards


Malcolm



