Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9422 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaAHJZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 04:25:53 -0500
Message-id: <52CD199E.9010001@samsung.com>
Date: Wed, 08 Jan 2014 10:25:50 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vb2: Check if there are buffers before streamon
References: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-01-08 09:01, Ricardo Ribalda Delgado wrote:
> This patch adds a test preventing streamon() if there is no buffer
> ready.
>
> Without this patch, a user could call streamon() before
> preparing any buffer. This leads to a situation where if he calls
> close() before calling streamoff() the device is kept streaming.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> v2: Comment by Marek Szyprowski:
> Reword error message
>
> v3: Comment by Marek Szyprowski:
> Actualy do the reword :)
>
>   drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 098df28..6409e0a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return 0;
>   	}
>   
> +	if (!q->num_buffers) {
> +		dprintk(1, "streamon: no buffers have been allocated\n");
> +		return -EINVAL;
> +	}
> +
>   	/*
>   	 * If any buffers were queued before streamon,
>   	 * we can now pass them to driver for processing.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

