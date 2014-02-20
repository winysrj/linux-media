Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3234 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaBTKZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 05:25:24 -0500
Message-ID: <5305D7FA.9090402@xs4all.nl>
Date: Thu, 20 Feb 2014 11:24:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Cong Ding <dinggnu@gmail.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stv0900: remove an unneeded check
References: <20140206092402.GA31780@elgon.mountain>
In-Reply-To: <20140206092402.GA31780@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/14 10:24, Dan Carpenter wrote:
> No need to check "lock" twice here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
> index 0a40edfad739..4ce1d260b3eb 100644
> --- a/drivers/media/dvb-frontends/stv0900_sw.c
> +++ b/drivers/media/dvb-frontends/stv0900_sw.c
> @@ -1081,7 +1081,7 @@ static int stv0900_wait_for_lock(struct stv0900_internal *intp,
>  	lock = stv0900_get_demod_lock(intp, demod, dmd_timeout);
>  
>  	if (lock)
> -		lock = lock && stv0900_get_fec_lock(intp, demod, fec_timeout);
> +		lock = stv0900_get_fec_lock(intp, demod, fec_timeout);
>  
>  	if (lock) {
>  		lock = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

