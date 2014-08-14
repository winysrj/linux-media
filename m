Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2782 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaHNH2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 03:28:04 -0400
Message-ID: <53EC64CD.8020709@xs4all.nl>
Date: Thu, 14 Aug 2014 09:27:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: panpan liu <panpan1.liu@samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@redhat.com
CC: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] videobuf2-core: modify the num of users
References: <1408000262-2774-1-git-send-email-panpan1.liu@samsung.com>
In-Reply-To: <1408000262-2774-1-git-send-email-panpan1.liu@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got a few questions:

On 08/14/2014 09:11 AM, panpan liu wrote:
> If num_users returns 1 or more than 1, that means we are not the
> only user of the plane's memory.

Why do think this is wrong? When the buffer is allocated the refcount is set to 1,
so anyone mapping that buffer will increase the refcount making it 'in use'.

Seems perfectly OK to me.

So if your patch solves a problem for you, then I'd like to know what that problem
is. You might be solving it in the wrong place.

>
> Signed-off-by: panpan liu <panpan1.liu@samsung.com>
> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index c359006..d3a4b8f 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -625,7 +625,7 @@ static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>   		 * case anyway. If num_users() returns more than 1,
>   		 * we are not the only user of the plane's memory.

And even if there was a bug, then your patch is incomplete because you didn't update
the comment.

>   		 */
> -		if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
> +		if (mem_priv && call_memop(vb, num_users, mem_priv) >= 1)
>   			return true;
>   	}
>   	return false;
>

Regards,

	Hans
