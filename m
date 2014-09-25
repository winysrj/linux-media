Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37679 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbaIYOAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 10:00:37 -0400
Message-ID: <54242002.8020408@osg.samsung.com>
Date: Thu, 25 Sep 2014 08:00:34 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>
CC: Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [patch] [media] xc5000: use after free in release()
References: <20140925114008.GC3708@mwanda>
In-Reply-To: <20140925114008.GC3708@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2014 05:40 AM, Dan Carpenter wrote:
> I moved the call to hybrid_tuner_release_state(priv) after
> "priv->firmware" dereference.
> 
> Fixes: 5264a522a597 ('[media] media: tuner xc5000 - release firmwware from xc5000_release()')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index e44c8ab..803a0e6 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -1333,9 +1333,9 @@ static int xc5000_release(struct dvb_frontend *fe)
>  
>  	if (priv) {
>  		cancel_delayed_work(&priv->timer_sleep);
> -		hybrid_tuner_release_state(priv);
>  		if (priv->firmware)
>  			release_firmware(priv->firmware);
> +		hybrid_tuner_release_state(priv);
>  	}
>  
>  	mutex_unlock(&xc5000_list_mutex);
> 

Thanks for catching it.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
