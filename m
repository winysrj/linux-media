Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47354
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbcGVTS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 15:18:56 -0400
Date: Fri, 22 Jul 2016 16:18:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Abylay Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [dvbv5-scan] wait no more than timeout when scanning
Message-ID: <20160722161851.034752e7@recife.lan>
In-Reply-To: <1469210077-12313-1-git-send-email-aospan@netup.ru>
References: <1469210077-12313-1-git-send-email-aospan@netup.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Abylay,

Em Fri, 22 Jul 2016 13:54:37 -0400
Abylay Ospan <aospan@netup.ru> escreveu:

> some frontends (mentioned on lgdt3306a) wait timeout inside code like:
> for (i = 20; i > 0; i--) {
>   msleep(50);
> 
> If there is no-LOCK then dvbv5-scan spent a lot of time (doing 40x calls).
> This patch introduce timeout which 4 sec * multiply. So we do not wait more
> than 4 sec (or so) if no-LOCK.
> 
> Signed-off-by: Abylay Ospan <aospan@netup.ru>
> ---
>  utils/dvb/dvbv5-scan.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
> index 689bc0b..1fc33d7 100644
> --- a/utils/dvb/dvbv5-scan.c
> +++ b/utils/dvb/dvbv5-scan.c
> @@ -182,12 +182,23 @@ static int print_frontend_stats(struct arguments *args,
>  	return 0;
>  }
>  
> +/* return timestamp in msec */
> +uint64_t get_timestamp()
> +{
> +	struct timeval now;
> +	gettimeofday(&now, 0);
> +	return now.tv_sec * 1000 + now.tv_usec/1000;

This is not good, as gettimeofday() is not monotonic, and may be affected
by clock adjustments.

IMHO, the best would be to adjust the do_timeout() to handle
args->timeout_multiply.

Regards,
Mauro

> +}
> +
>  static int check_frontend(void *__args,
>  			  struct dvb_v5_fe_parms *parms)
>  {
>  	struct arguments *args = __args;
>  	int rc, i;
>  	fe_status_t status;
> +	uint64_t start = get_timestamp();
> +	/* msec timeout by default 4 sec * multiply */ 
> +	uint64_t timeout = args->timeout_multiply * 4 * 1000;
>  
>  	args->n_status_lines = 0;
>  	for (i = 0; i < args->timeout_multiply * 40; i++) {
> @@ -203,6 +214,10 @@ static int check_frontend(void *__args,
>  		print_frontend_stats(args, parms);
>  		if (status & FE_HAS_LOCK)
>  			break;
> +
> +		if ((get_timestamp() - start) > timeout)
> +			break;
> +
>  		usleep(100000);

It would also make sense to remove the usleep here and
use something else that would be checking timeout_flag,
like:

	for (i = 1; i < 100; i++) {
		if (timeout_flag)
			break;
		usleep(1000);
	}


-- 
Thanks,
Mauro
