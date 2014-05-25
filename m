Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:54685 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYSaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 14:30:05 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N65000FR7E30C70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 25 May 2014 14:30:03 -0400 (EDT)
Date: Sun, 25 May 2014 15:29:57 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: CrazyCat <crazycat69@narod.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] technisat-sub2: Fix stream curruption on high bitrate
Message-id: <20140525152957.23be9b06.m.chehab@samsung.com>
In-reply-to: <3539618.frtlsOTgfg@ubuntu>
References: <3539618.frtlsOTgfg@ubuntu>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Em Wed, 16 Apr 2014 23:22:01 +0300
CrazyCat <crazycat69@narod.ru> escreveu:

> Fix stream curruption on high bitrate (>60mbit).

Could you please better document this patch? 

I would be expecting a better description of the problem you faced,
the version of the board you have (assuming that different versions
might have different minimal intervals) and an lsusb -v output from
the board you faced issues, showing what the endpoint descriptors
say about that.

Btw, if those tables are ok, can't we just retrieve the information
directly from the descriptors, instead of hardcoding it, e. g
filling it with:

       interval = 1 << (ep->bInterval - 1);

at the board probing time, just like we did at changeset 1b3fd2d34266?

Regards,
Mauro

> 
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
>  drivers/media/usb/dvb-usb/technisat-usb2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
> index 420198f..4604c084 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -711,7 +711,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
>  					.isoc = {
>  						.framesperurb = 32,
>  						.framesize = 2048,
> -						.interval = 3,
> +						.interval = 1,
>  					}
>  				}
>  			},
