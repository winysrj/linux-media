Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:42836 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab0D0WFY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 18:05:24 -0400
Message-ID: <4BD75F98.9000804@linuxtv.org>
Date: Wed, 28 Apr 2010 00:05:12 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	randy.dunlap@oracle.com, pboettcher@dibcom.fr
Subject: Re: [patch 02/11] dib7000p: reduce large stack usage
References: <201004272111.o3RLBKix019982@imap1.linux-foundation.org>
In-Reply-To: <201004272111.o3RLBKix019982@imap1.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

akpm@linux-foundation.org wrote:
> diff -puN drivers/media/dvb/frontends/dib7000p.c~dib7000p-reduce-large-stack-usage drivers/media/dvb/frontends/dib7000p.c
> --- a/drivers/media/dvb/frontends/dib7000p.c~dib7000p-reduce-large-stack-usage
> +++ a/drivers/media/dvb/frontends/dib7000p.c
> @@ -1324,46 +1324,54 @@ EXPORT_SYMBOL(dib7000p_pid_filter);
>  
>  int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
>  {
> -	struct dib7000p_state st = { .i2c_adap = i2c };
> +	struct dib7000p_state *dpst;
>  	int k = 0;
>  	u8 new_addr = 0;
>  
> +	dpst = kzalloc(sizeof(struct dib7000p_state), GFP_KERNEL);
> +	if (!dpst)
> +		return -ENODEV;

I think ENOMEM would be appropriate here.

The same applies to patch 01/11.

Regards,
Andreas
