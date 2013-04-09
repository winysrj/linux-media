Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3830 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab3DIGOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 02:14:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [media] dt3155v4l: unlock on error path
Date: Tue, 9 Apr 2013 08:14:18 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20130409051540.GA1516@longonot.mountain>
In-Reply-To: <20130409051540.GA1516@longonot.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304090814.18641.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue April 9 2013 07:15:40 Dan Carpenter wrote:
> We should unlock here and do some cleanup before returning.
> 
> We can't actually hit this return path with the current code, so this
> patch is a basically a cleanup and doesn't change how the code works.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

I have a patch pending that will actually fix the locking problem
(http://git.linuxtv.org/hverkuil/media_tree.git/commit/b7926f8ac185fe914a5a97d0206d7a3e8eb3e688)

I plan on working some more on this driver on Friday or the weekend and
post a full patch series of fixes and improvements. I recently managed to
get hold of a dt3155 card, so I can actually test the code.

Regards,

	Hans

> 
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index 073b3b3..3da17bc 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -398,7 +398,7 @@ dt3155_open(struct file *filp)
>  		pd->field_count = 0;
>  		ret = vb2_queue_init(pd->q);
>  		if (ret < 0)
> -			return ret;
> +			goto err_free_q;
>  		INIT_LIST_HEAD(&pd->dmaq);
>  		spin_lock_init(&pd->lock);
>  		/* disable all irqs, clear all irq flags */
> @@ -407,11 +407,11 @@ dt3155_open(struct file *filp)
>  		ret = request_irq(pd->pdev->irq, dt3155_irq_handler_even,
>  						IRQF_SHARED, DT3155_NAME, pd);
>  		if (ret)
> -			goto err_request_irq;
> +			goto err_free_q;
>  	}
>  	pd->users++;
>  	return 0; /* success */
> -err_request_irq:
> +err_free_q:
>  	kfree(pd->q);
>  	pd->q = NULL;
>  err_alloc_queue:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
