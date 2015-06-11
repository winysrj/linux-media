Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51962 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbbFKJ15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 05:27:57 -0400
From: Fabien DESSENNE <fabien.dessenne@st.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 11 Jun 2015 11:26:22 +0200
Subject: RE: [PATCH 2/2] [media] bdisp-debug: don't try to divide by s64
Message-ID: <15ED7CB7B68B4D4C96C7D27A1A23941201B9F8D862@SAFEX1MAIL2.st.com>
References: <bc5e66bd2591424f0e08d5478a36a8074fe739f5.1433969944.git.mchehab@osg.samsung.com>
 <ec9ffbdae3dc024959c02a7f351e40f841c2d3f0.1433969944.git.mchehab@osg.samsung.com>
In-Reply-To: <ec9ffbdae3dc024959c02a7f351e40f841c2d3f0.1433969944.git.mchehab@osg.samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please check my comments below.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> Sent: mercredi 10 juin 2015 22:59
> To: Linux Media Mailing List
> Cc: Mauro Carvalho Chehab; Mauro Carvalho Chehab; Fabien DESSENNE
> Subject: [PATCH 2/2] [media] bdisp-debug: don't try to divide by s64
> 
> There are several warnings there, on some architectures, related to dividing
> a s32 by a s64 value:
> 
> drivers/media/platform/sti/bdisp/bdisp-debug.c:594: warning: comparison
> of distinct pointer types lacks a cast
> drivers/media/platform/sti/bdisp/bdisp-debug.c:594: warning: right shift
> count >= width of type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:594: warning: passing
> argument 1 of '__div64_32' from incompatible pointer type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:595: warning: comparison
> of distinct pointer types lacks a cast
> drivers/media/platform/sti/bdisp/bdisp-debug.c:595: warning: right shift
> count >= width of type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:595: warning: passing
> argument 1 of '__div64_32' from incompatible pointer type  CC [M]
> drivers/media/tuners/mt2060.o
> drivers/media/platform/sti/bdisp/bdisp-debug.c:596: warning: comparison
> of distinct pointer types lacks a cast
> drivers/media/platform/sti/bdisp/bdisp-debug.c:596: warning: right shift
> count >= width of type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:596: warning: passing
> argument 1 of '__div64_32' from incompatible pointer type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:597: warning: comparison
> of distinct pointer types lacks a cast
> drivers/media/platform/sti/bdisp/bdisp-debug.c:597: warning: right shift
> count >= width of type
> drivers/media/platform/sti/bdisp/bdisp-debug.c:597: warning: passing
> argument 1 of '__div64_32' from incompatible pointer type
> 
> That doesn't make much sense. What the driver is actually trying to do is to
> divide one second by a value. So, check the range before dividing. That
> warrants the right result and will remove the warnings on non-64 bits archs.
> 
> Also fixes this warning:
> drivers/media/platform/sti/bdisp/bdisp-debug.c:588: warning: comparison
> of distinct pointer types lacks a cast
> 
> by using div64_s64() instead of calling do_div() directly.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c
> b/drivers/media/platform/sti/bdisp/bdisp-debug.c
> index 7c3a632746ba..3f6f411aafdd 100644
> --- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
> +++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
> @@ -572,6 +572,8 @@ static int bdisp_dbg_regs(struct seq_file *s, void
> *data)
>  	return 0;
>  }
> 
> +#define SECOND 1000000
> +
>  static int bdisp_dbg_perf(struct seq_file *s, void *data)  {
>  	struct bdisp_dev *bdisp = s->private;
> @@ -585,16 +587,27 @@ static int bdisp_dbg_perf(struct seq_file *s, void
> *data)
>  	}
> 
>  	avg_time_us = bdisp->dbg.tot_duration;

When using div64_s64 the above line can be deleted, see my next comment.

> -	do_div(avg_time_us, request->nb_req);
> -
> -	avg_fps = 1000000;
> -	min_fps = 1000000;
> -	max_fps = 1000000;
> -	last_fps = 1000000;
> -	do_div(avg_fps, avg_time_us);
> -	do_div(min_fps, bdisp->dbg.min_duration);
> -	do_div(max_fps, bdisp->dbg.max_duration);
> -	do_div(last_fps, bdisp->dbg.last_duration);
> +	div64_s64(avg_time_us, request->nb_req);

The operation result is returned by div64_s64(different from do_div that updates the 1st parameter).
The expected syntax is:
avg_time_us = div64_s64(bdisp->dbg.tot_duration, request->nb_req);

> +
> +	if (avg_time_us > SECOND)
> +		avg_fps = 0;
> +	else
> +		avg_fps = SECOND / (s32)avg_time_us;
> +
> +	if (bdisp->dbg.min_duration > SECOND)
> +		min_fps = 0;
> +	else
> +		min_fps = SECOND / (s32)bdisp->dbg.min_duration);

It probably builds better without the last unexpected parenthesis ;)

> +
> +	if (bdisp->dbg.max_duration > SECOND)
> +		max_fps = 0;
> +	else
> +		max_fps = SECOND / (s32)bdisp->dbg.max_duration;
> +
> +	if (bdisp->dbg.last_duration > SECOND)
> +		last_fps = 0;
> +	else
> +		last_fps = SECOND / (s32)bdisp->dbg.last_duration;
> 
>  	seq_printf(s, "HW processing (%d requests):\n", request->nb_req);
>  	seq_printf(s, " Average: %5lld us  (%3d fps)\n",
> --
> 2.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
