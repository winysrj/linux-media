Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0L3Jr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 04:47:59 -0500
Message-ID: <4D1C554C.2030201@gmail.com>
Date: Thu, 30 Dec 2010 10:47:56 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sungchun Kang <sungchun.kang@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH] [media] s5p-fimc: fimc_stop_capture bug fix
References: <1293687328-26239-1-git-send-email-sungchun.kang@samsung.com>
In-Reply-To: <1293687328-26239-1-git-send-email-sungchun.kang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/30/2010 06:35 AM, Sungchun Kang wrote:
> When is called fimc_stop_capture, it seems that wait_event_timeout
> used improperly. It should be wake up by irq handler.
>
> Reviewed-by Jonghun Han<jonghun.han@samsung.com>
> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
> ---
> This patch is depended on:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc
>
>   drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> index 4e4441f..821f927 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -187,7 +187,7 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
>   	spin_unlock_irqrestore(&fimc->slock, flags);
>
>   	wait_event_timeout(fimc->irq_queue,
> -			   test_bit(ST_CAPT_SHUT,&fimc->state),

just wondering, how this one sneaked in...it looks like a need to take
a long holiday.. ;)

Starting from the new year I am going to setup a fixed branch
v4l/fimc-for-next at git://git.infradead.org/users/kmpark/linux-2.6-samsung
so there is a common up to date tree available.
Until then please base your work on
git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2

I will apply this patch in the next week.

> +			   !test_bit(ST_CAPT_SHUT,&fimc->state),
>   			   FIMC_SHUTDOWN_TIMEOUT);
>
>   	ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);

Thanks,
Sylwester
