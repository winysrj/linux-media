Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:49376 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3HAPNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 11:13:05 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQU00AXFY7LXW40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Aug 2013 11:13:03 -0400 (EDT)
Date: Thu, 01 Aug 2013 12:12:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] This brings the genpix line of devices snr reporting in
 line with other drivers
Message-id: <20130801121258.14d9311a@samsung.com>
In-reply-to: <1374592326-13427-1-git-send-email-updatelee@gmail.com>
References: <1374592326-13427-1-git-send-email-updatelee@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Jul 2013 09:12:06 -0600
Chris Lee <updatelee@gmail.com> escreveu:

> Signed-off-by: Chris Lee <updatelee@gmail.com>


Hi Chris,

Please better describe your patches. It is not clear what you're
wanting to do on them.

A good patch should contain a detailed explanation about it,
describing the changes with some detail. Please don't be shy in it.

In this specific case, I'm seeing that you're doing some changes at
SNR, but it is not clear if the change is just extending the range
of a SNR relative measurement, or if you need that change to put
the unit as 0.1dB (that's the default unit that most DVBv3 stats
do).

Also, while you are there, the better is to add support on this
driver for DVBv5 stats, were the units of each statistics is properly
docummented.

For this reason, I'll this this patch and your next ones as
"Changes requested" at patchwork. Please re-submit them when ready.

Thanks!
Mauro

> 
> ---
>  drivers/media/usb/dvb-usb/gp8psk-fe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
> index 67957dd..5864f37 100644
> --- a/drivers/media/usb/dvb-usb/gp8psk-fe.c
> +++ b/drivers/media/usb/dvb-usb/gp8psk-fe.c
> @@ -45,7 +45,7 @@ static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
>  	if (time_after(jiffies,st->next_status_check)) {
>  		gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0,0,&st->lock,1);
>  		gp8psk_usb_in_op(st->d, GET_SIGNAL_STRENGTH, 0,0,buf,6);
> -		st->snr = (buf[1]) << 8 | buf[0];
> +		st->snr = ((buf[1]) << 8 | buf[0]) << 4;
>  		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
>  	}
>  	return 0;


-- 

Cheers,
Mauro
