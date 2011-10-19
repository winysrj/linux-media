Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50970 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1JSGC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 02:02:59 -0400
Received: by gyb13 with SMTP id 13so1328033gyb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 23:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318435964-9986-1-git-send-email-m.szyprowski@samsung.com>
References: <1318435964-9986-1-git-send-email-m.szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Oct 2011 23:02:39 -0700
Message-ID: <CAMm-=zAYq7xMWORXA4GrkXZA=isXjXEmAqNrkw_SZJyei1Qmbg@mail.gmail.com>
Subject: Re: [PATCH] media: vb2: add a check for uninitialized buffer
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,
I think there is a typo in this patch:

On Wed, Oct 12, 2011 at 09:12, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> __buffer_in_use() might be called for empty/uninitialized buffer in the
> following scenario: REQBUF(n, USER_PTR), QUERYBUF(). This patch fixes
> kernel ops in such case.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
>
> ---
>  drivers/media/video/videobuf2-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index d8affb8..cdbbab7 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -284,14 +284,14 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>  {
>        unsigned int plane;
>        for (plane = 0; plane < vb->num_planes; ++plane) {
> +               void mem_priv = vb->planes[plane].mem_priv;

Shouldn't this be void * instead of just void?

>                /*
>                 * If num_users() has not been provided, call_memop
>                 * will return 0, apparently nobody cares about this
>                 * case anyway. If num_users() returns more than 1,
>                 * we are not the only user of the plane's memory.
>                 */
> -               if (call_memop(q, plane, num_users,
> -                               vb->planes[plane].mem_priv) > 1)
> +               if (mem_priv && call_memop(q, plane, num_users, mem_priv) > 1)
>                        return true;
>        }
>        return false;
> --
> 1.7.1.569.g6f426
>
>


-- 
Best regards,
Pawel Osciak
