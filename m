Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:37168 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3KBVVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 17:21:17 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVN00J8XNBG2V60@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 02 Nov 2013 17:21:16 -0400 (EDT)
Date: Sat, 02 Nov 2013 19:21:12 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: CrazyCat <crazycat69@narod.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] tda18271-fe: Fix dvb-c standard selection
Message-id: <20131102192112.1bc7bbc0@samsung.com>
In-reply-to: <5275690A.3080108@narod.ru>
References: <5275690A.3080108@narod.ru>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 02 Nov 2013 23:05:14 +0200
CrazyCat <crazycat69@narod.ru> escreveu:

> Fix dvb-c standard selection - qam8 for ANNEX_AC
> 
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
> index 4995b89..6a385c8 100644
> --- a/drivers/media/tuners/tda18271-fe.c
> +++ b/drivers/media/tuners/tda18271-fe.c
> @@ -960,16 +960,12 @@ static int tda18271_set_params(struct dvb_frontend *fe)
>   		break;
>   	case SYS_DVBC_ANNEX_B:
>   		bw = 6000000;
> -		/* falltrough */
> +		map = &std_map->qam_6;
> +		break;
>   	case SYS_DVBC_ANNEX_A:
>   	case SYS_DVBC_ANNEX_C:
> -		if (bw <= 6000000) {
> -			map = &std_map->qam_6;
> -		} else if (bw <= 7000000) {
> -			map = &std_map->qam_7;
> -		} else {
> -			map = &std_map->qam_8;
> -		}
> +		bw = 8000000;
> +		map = &std_map->qam_8;

This is wrong, as it breaks for 6MHz-spaced channels, like what's used
in Brazil and Japan.

What happens here is that, if the tuner uses a too wide lowpass filter,
the interference will be higher at the demod, and it may not be able
to decode.

As the bandwidth is already estimated by the DVB frontend core, the
tuners should be adjusted to get the closest filter for a given
bandwidth.

So, the driver is correct (and it is tested under 6MHz spaced channels).

>   		break;
>   	default:
>   		tda_warn("modulation type not supported!\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
