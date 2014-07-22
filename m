Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:35100 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGVQLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 12:11:07 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9400L7RFMGGK60@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jul 2014 12:11:04 -0400 (EDT)
Date: Tue, 22 Jul 2014 13:10:59 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Luis Alves <ljalvs@gmail.com>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH] si2157: Fix DVB-C bandwidth.
Message-id: <20140722131059.4ad26777.m.chehab@samsung.com>
In-reply-to: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
References: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 12:09:48 +0100
Luis Alves <ljalvs@gmail.com> escreveu:

> This patch fixes DVB-C reception.
> Without setting the bandwidth to 8MHz the received stream gets corrupted.
> 
> Regards,
> Luis
> 
> Signed-off-by: Luis Alves <ljalvs@gmail.com>
> ---
>  drivers/media/tuners/si2157.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 6c53edb..e2de428 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -245,6 +245,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
>  			break;
>  	case SYS_DVBC_ANNEX_A:
>  			delivery_system = 0x30;
> +			bandwidth = 0x08;

Hmm... this patch looks wrong, as it will break DVB-C support where
the bandwidth is lower than 6MHz.

The DVB core sets c->bandwidth_hz for DVB-C based on the rolloff and
the symbol rate. If this is not working for you, then something else
is likely wrong.

I suggest you to add a printk() there to show what's the value set
at c->bandwidth_hz and what's the symbol rate that you're using.

On DVB-C, the rolloff is fixed (1.15 for annex A and 1.13 for Annex C).
Not sure if DVB-C2 allows selecting a different rolloff factor, nor
if si2157 works with DVB-C2.

>  			break;
>  	default:
>  			ret = -EINVAL;
