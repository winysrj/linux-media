Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12715 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750874AbdBJHLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 02:11:37 -0500
Subject: Re: [PATCH] media: s5p_mfc - remove unneeded io_modes initialzation in
 s5p_mfc_open()
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <b1804acf-159f-fb01-030e-ed3eb742a9e7@samsung.com>
Date: Fri, 10 Feb 2017 08:11:32 +0100
MIME-version: 1.0
In-reply-to: <20170209221117.26381-1-shuahkh@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <CGME20170209221122epcas4p138d5e06079a506356e8ba9dae37825c2@epcas4p1.samsung.com>
 <20170209221117.26381-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2017 23:11, Shuah Khan wrote:
> Remove unneeded io_modes initialzation in s5p_mfc_open(). It gets done
> right below in vdev == dev->vfd_dec conditional.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
--
Regards
Andrzej
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index bb0a588..20beaa2 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -866,7 +866,6 @@ static int s5p_mfc_open(struct file *file)
>  	/* Init videobuf2 queue for OUTPUT */
>  	q = &ctx->vq_src;
>  	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> -	q->io_modes = VB2_MMAP;
>  	q->drv_priv = &ctx->fh;
>  	q->lock = &dev->mfc_mutex;
>  	if (vdev == dev->vfd_dec) {


