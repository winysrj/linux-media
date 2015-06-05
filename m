Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43786 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbbFEOzk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:55:40 -0400
Date: Fri, 5 Jun 2015 15:55:38 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Himangi Saraogi <himangi774@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 08/11] [media] ir: Fix IR_MAX_DURATION enforcement
Message-ID: <20150605145538.GA3076@gofer.mess.org>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
 <3de7135934d936e630a39a047bdf731a51713dd4.1433514004.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3de7135934d936e630a39a047bdf731a51713dd4.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 05, 2015 at 11:27:41AM -0300, Mauro Carvalho Chehab wrote:
> Don't assume that IR_MAX_DURATION is a bitmask. It isn't.

The patch is right, but note that IR_MAX_DURATION is 0xffffffff, and in
all these cases it is being compared to a u32, so it is always false.

Should these statements simply be removed? None of the other drivers
do these checks.


Sean

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index c83292ad1b34..ec74244a3853 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -322,7 +322,7 @@ static u32 redrat3_us_to_len(u32 microsec)
>  	u32 result;
>  	u32 divisor;
>  
> -	microsec &= IR_MAX_DURATION;
> +	microsec = (microsec > IR_MAX_DURATION) ? IR_MAX_DURATION : microsec;
>  	divisor = (RR3_CLK_CONV_FACTOR / 1000);
>  	result = (u32)(microsec * divisor) / 1000;
>  
> @@ -380,7 +380,8 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
>  		if (i == 0)
>  			trailer = rawir.duration;
>  		/* cap the value to IR_MAX_DURATION */
> -		rawir.duration &= IR_MAX_DURATION;
> +		rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
> +				 IR_MAX_DURATION : rawir.duration;
>  
>  		dev_dbg(dev, "storing %s with duration %d (i: %d)\n",
>  			rawir.pulse ? "pulse" : "space", rawir.duration, i);
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index bf4a44272f0e..5a17cb88ff27 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -152,7 +152,8 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
>  				sz->signal_last.tv_usec);
>  			rawir.duration -= sz->sum;
>  			rawir.duration = US_TO_NS(rawir.duration);
> -			rawir.duration &= IR_MAX_DURATION;
> +			rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
> +					 IR_MAX_DURATION : rawir.duration;
>  		}
>  		sz_push(sz, rawir);
>  
> @@ -165,7 +166,8 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
>  	rawir.duration += SZ_RESOLUTION / 2;
>  	sz->sum += rawir.duration;
>  	rawir.duration = US_TO_NS(rawir.duration);
> -	rawir.duration &= IR_MAX_DURATION;
> +	rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
> +			 IR_MAX_DURATION : rawir.duration;
>  	sz_push(sz, rawir);
>  }
