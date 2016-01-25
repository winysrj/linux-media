Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46219 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbcAYQ0T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 11:26:19 -0500
Date: Mon, 25 Jan 2016 14:26:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 4/5] staging: media: lirc: place operator on previous
 line
Message-ID: <20160125142612.587c85f8@recife.lan>
In-Reply-To: <1450443929-15305-4-git-send-email-sudipm.mukherjee@gmail.com>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
	<1450443929-15305-4-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Dec 2015 18:35:28 +0530
Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:

> checkpatch complains about the logical operator, which should be on the
> previous line.

IMHO, this is a matter of personal taste. I prefer to keep the operator
on the next line, as it makes clearer to see why the logic was broken.

Anyway, this patch doesn't apply.

> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/staging/media/lirc/lirc_parallel.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
> index e09894d..0156114 100644
> --- a/drivers/staging/media/lirc/lirc_parallel.c
> +++ b/drivers/staging/media/lirc/lirc_parallel.c
> @@ -157,9 +157,9 @@ static unsigned int init_lirc_timer(void)
>  			count++;
>  		level = newlevel;
>  		do_gettimeofday(&now);
> -	} while (count < 1000 && (now.tv_sec < tv.tv_sec
> -			     || (now.tv_sec == tv.tv_sec
> -				 && now.tv_usec < tv.tv_usec)));
> +	} while (count < 1000 && (now.tv_sec < tv.tv_sec ||
> +				  (now.tv_sec == tv.tv_sec &&
> +				   now.tv_usec < tv.tv_usec)));
>  
>  	timeelapsed = (now.tv_sec + 1 - tv.tv_sec) * 1000000
>  		     + (now.tv_usec - tv.tv_usec);
> @@ -279,8 +279,8 @@ static void lirc_lirc_irq_handler(void *blah)
>  		level = newlevel;
>  
>  		/* giving up */
> -		if (signal > timeout
> -		    || (check_pselecd && (in(1) & LP_PSELECD))) {
> +		if (signal > timeout ||
> +		    (check_pselecd && (in(1) & LP_PSELECD))) {
>  			signal = 0;
>  			pr_notice("timeout\n");
>  			break;
