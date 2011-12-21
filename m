Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48915 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1LUH0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 02:26:40 -0500
Message-ID: <4EF18A2D.5090101@iki.fi>
Date: Wed, 21 Dec 2011 09:26:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: linux-media@vger.kernel.org, Jyrki Kuoppala <jkp@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] qt1010: Fix tuner frequency selection for 546 to 578
 MHz range
References: <20111220105034.5150.54234.stgit@localhost>
In-Reply-To: <20111220105034.5150.54234.stgit@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
You can try to fix it like that, but it is not proper way. It is kinda 
of hack which can just work or not. Proper way is to fix that tuner 
driver correctly and if it was used with zl10353 demoed fix that driver 
too to support IIRC IF/RF agc settings.

regards
Antti

On 12/20/2011 12:50 PM, Carlos Corbacho wrote:
> The patch fixes frequency selection for some UHF frequencies e.g.
> channel 32 (562 MHz) on the qt1010 tuner. For those in the UK,
> this now means they can tune to the BBC channels (tested on a Compro
> Vista T750F).
>
> One example of problem reports of the bug this fixes can be read at
> http://www.freak-search.com/de/thread/330303/linux-dvb_tuning_problem_with_some_frequencies_qt1010,_dvb
>
> Based on an original patch by Jyrki Kuoppala<jkp@iki.fi>
>
> Signed-off-by: Carlos Corbacho<carlos@strangeworlds.co.uk>
> Cc: Jyrki Kuoppala<jkp@iki.fi>
> Cc: Mauro Carvalho Chehab<mchehab@infradead.org>
> ---
>   drivers/media/common/tuners/qt1010.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
> index 9f5dba2..8c57d8c 100644
> --- a/drivers/media/common/tuners/qt1010.c
> +++ b/drivers/media/common/tuners/qt1010.c
> @@ -200,7 +200,8 @@ static int qt1010_set_params(struct dvb_frontend *fe,
>   	if      (freq<  450000000) rd[15].val = 0xd0; /* 450 MHz */
>   	else if (freq<  482000000) rd[15].val = 0xd1; /* 482 MHz */
>   	else if (freq<  514000000) rd[15].val = 0xd4; /* 514 MHz */
> -	else if (freq<  546000000) rd[15].val = 0xd7; /* 546 MHz */
> +	else if (freq<  546000000) rd[15].val = 0xd6; /* 546 MHz */
> +	else if (freq<  578000000) rd[15].val = 0xd8; /* 578 MHz */
>   	else if (freq<  610000000) rd[15].val = 0xda; /* 610 MHz */
>   	else                       rd[15].val = 0xd0;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
