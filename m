Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:36388 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaHNH0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 03:26:31 -0400
Received: by mail-yk0-f177.google.com with SMTP id 79so685504ykr.8
        for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 00:26:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1408000262-2774-1-git-send-email-panpan1.liu@samsung.com>
References: <1408000262-2774-1-git-send-email-panpan1.liu@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 14 Aug 2014 16:25:51 +0900
Message-ID: <CAMm-=zC5dHBarzoz+EdRd8oUU4WiJ1O-aKgZFybkveFroHVo1g@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-core: modify the num of users
To: panpan liu <panpan1.liu@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 14, 2014 at 4:11 PM, panpan liu <panpan1.liu@samsung.com> wrote:
> If num_users returns 1 or more than 1, that means we are not the
> only user of the plane's memory.
>
> Signed-off-by: panpan liu <panpan1.liu@samsung.com>

NACK.

Please read the function documentation and how it is used. If the
number of users is 1, we are the only user and should be able to free
the queue. This will make us unable to do so.

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index c359006..d3a4b8f 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -625,7 +625,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>                  * case anyway. If num_users() returns more than 1,
>                  * we are not the only user of the plane's memory.
>                  */
> -               if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
> +               if (mem_priv && call_memop(vb, num_users, mem_priv) >= 1)
>                         return true;
>         }
>         return false;
> --
> 1.7.9.5

-- 
Thanks,
Pawel Osciak
