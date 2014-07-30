Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:63765 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaG3MHW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 08:07:22 -0400
MIME-Version: 1.0
In-Reply-To: <1406693390-31849-1-git-send-email-zhaowei.yuan@samsung.com>
References: <1406693390-31849-1-git-send-email-zhaowei.yuan@samsung.com>
Date: Wed, 30 Jul 2014 17:37:20 +0530
Message-ID: <CAK5sBcHRRwEjCAcB789EoQGpAGmyqb57sVFzd2RVY2SNb1FwxQ@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2: make allocation algorithm more robust and flexible
From: Sachin Kamat <spk.linux@gmail.com>
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	jtp.park@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	m.chehab@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zhaowei,

On Wed, Jul 30, 2014 at 9:39 AM, Zhaowei Yuan <zhaowei.yuan@samsung.com> wrote:
> Current algorithm relies on the fact that caller will align the
> size to PAGE_SIZE, otherwise order will be decreased to negative
> when remain size is less than PAGE_SIZE, it makes the function
> hard to be migrated.
> This patch sloves the hidden problem.
>
> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index adefc31..40d18aa 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -58,7 +58,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>
>                 order = get_order(size);
>                 /* Dont over allocate*/
> -               if ((PAGE_SIZE << order) > size)
> +               if (order > 0 && (PAGE_SIZE << order) > size)
>                         order--;

If size is not page aligned, then wouldn't decrementing the order
under-allocate the memory?

-- 
Regards,
Sachin.
