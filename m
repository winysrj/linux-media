Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16393 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0JVHZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:25:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Date: Fri, 22 Oct 2010 09:25:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [patch 2/3] V4L/DVB: s5p-fimc: make it compile
In-reply-to: <20101021192400.GK5985@bicker>
To: 'Dan Carpenter' <error27@gmail.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-id: <000b01cb71ba$58902ad0$09b08070$%nawrocki@samsung.com>
Content-language: en-us
Content-transfer-encoding: 8BIT
References: <20101021192400.GK5985@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Thursday, October 21, 2010 9:24 PM
> To: Mauro Carvalho Chehab
> Cc: Kyungmin Park; Sylwester Nawrocki; Marek Szyprowski; Pawel Osciak;
> linux-media@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 2/3] V4L/DVB: s5p-fimc: make it compile
> 
> The work_queue was partially removed in f93000ac11: "[media] s5p-fimc:
> mem2mem driver refactoring and cleanup" but this bit was missed.  Also
> we need to include sched.h otherwise the compile fails with:
> 
> drivers/media/video/s5p-fimc/fimc-core.c:
> 	In function ‘fimc_capture_handler’:
> drivers/media/video/s5p-fimc/fimc-core.c:286:
> 	error: ‘TASK_NORMAL’ undeclared (first use in this function)
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Compile tested only.                                       :P
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h
> b/drivers/media/video/s5p-fimc/fimc-core.h
> index e3a7c6a..1c1437c 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -14,6 +14,7 @@
>  /*#define DEBUG*/
> 
>  #include <linux/types.h>
> +#include <linux/sched.h>
>  #include <media/videobuf-core.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mem2mem.h>
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
> b/drivers/media/video/s5p-fimc/fimc-core.c
> index 8335045..cf9bc8e 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -1593,12 +1593,6 @@ static int fimc_probe(struct platform_device
> *pdev)
>  		goto err_clk;
>  	}
> 
> -	fimc->work_queue = create_workqueue(dev_name(&fimc->pdev->dev));
> -	if (!fimc->work_queue) {
> -		ret = -ENOMEM;
> -		goto err_irq;
> -	}
> -

This code is properly removed in my original patch. But it has been added
again during a merge conflict solving. Unfortunately I cannot identify the
merge commit today in linux-next. 
As for sched.h, it needs a separate patch so I could handle it and add you
as reported by it is OK.

Regards,
Sylwester

>  	ret = fimc_register_m2m_device(fimc);
>  	if (ret)
>  		goto err_irq;

