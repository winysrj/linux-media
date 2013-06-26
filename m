Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:62895 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FZJ63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 05:58:29 -0400
Received: by mail-ve0-f181.google.com with SMTP id db10so11033941veb.40
        for <linux-media@vger.kernel.org>; Wed, 26 Jun 2013 02:58:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371760096-19256-2-git-send-email-hverkuil@xs4all.nl>
References: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
	<1371760096-19256-2-git-send-email-hverkuil@xs4all.nl>
Date: Wed, 26 Jun 2013 17:58:28 +0800
Message-ID: <CAHG8p1DuOeBKNhDrzbnriAjVfX6J3FgS=U84V1eiYD6gZRQeUg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 2/3] bfin_capture: fix compiler warning
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/6/21 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> media-git/drivers/media/platform/blackfin/bfin_capture.c: In function ‘bcap_probe’:
> media-git/drivers/media/platform/blackfin/bfin_capture.c:1007:16: warning: ignoring return value of ‘vb2_queue_init’, declared with attribute warn_unused_result [-Wunused-result]
>   vb2_queue_init(q);
>                   ^
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 6652e71..7f838c6 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -1004,7 +1004,9 @@ static int bcap_probe(struct platform_device *pdev)
>         q->mem_ops = &vb2_dma_contig_memops;
>         q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>
> -       vb2_queue_init(q);
> +       ret = vb2_queue_init(q);
> +       if (ret)
> +               goto err_free_handler;
>
>         mutex_init(&bcap_dev->mutex);
>         init_completion(&bcap_dev->comp);

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
