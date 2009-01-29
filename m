Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:46210 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZA2Kqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:46:55 -0500
Message-ID: <49818912.7000109@gmail.com>
Date: Thu, 29 Jan 2009 14:46:42 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Roel Kluin via Mercurial <roel.kluin@gmail.com>,
	akpm@linux-foundation.org, mchehab@redhat.com
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] DVB: negative internal->sub_range
 won't get noticed
References: <E1LST8y-0003o5-Qw@www.linuxtv.org>
In-Reply-To: <E1LST8y-0003o5-Qw@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please revert this patch as it is incorrect. A correct version is
available at http://jusst.de/hg/v4l-dvb which is undergoing tests.
http://jusst.de/hg/v4l-dvb/rev/368dc6078295

Why did you have to hastily apply this patch, especially when i
mentioned this earlier ?

Regards,
Manu


Patch from Roel Kluin wrote:
> The patch number 10393 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Roel Kluin  <roel.kluin@gmail.com>
> DVB: negative internal->sub_range won't get noticed
> 
> 
> internal->sub_range is unsigned, a negative won't get noticed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> ---
> 
>  linux/drivers/media/dvb/frontends/stb0899_algo.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff -r 6ca70bcb4972 -r d3bfc53d0b67 linux/drivers/media/dvb/frontends/stb0899_algo.c
> --- a/linux/drivers/media/dvb/frontends/stb0899_algo.c	Wed Jan 14 16:17:59 2009 +0000
> +++ b/linux/drivers/media/dvb/frontends/stb0899_algo.c	Sun Jan 18 23:31:26 2009 +0000
> @@ -467,12 +467,13 @@ static void next_sub_range(struct stb089
>  
>  	if (internal->sub_dir > 0) {
>  		old_sub_range = internal->sub_range;
> -		internal->sub_range = MIN((internal->srch_range / 2) -
> +		if (internal->tuner_offst + internal->sub_range / 2 >=
> +				internal->srch_range / 2)
> +			internal->sub_range = 0;
> +		else
> +			internal->sub_range = MIN((internal->srch_range / 2) -
>  					  (internal->tuner_offst + internal->sub_range / 2),
>  					   internal->sub_range);
> -
> -		if (internal->sub_range < 0)
> -			internal->sub_range = 0;
>  
>  		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
>  	}
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/d3bfc53d0b678da495fd2b559e154c5e95584079
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 

