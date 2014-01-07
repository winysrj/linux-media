Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45157 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaAGPiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 10:38:01 -0500
Message-id: <52CC1F55.70503@samsung.com>
Date: Tue, 07 Jan 2014 16:37:57 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vb2: Check if there are buffers before streamon
References: <1389102935-4266-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1389102935-4266-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2014-01-07 14:55, Ricardo Ribalda Delgado wrote:
> This patch adds a test preventing streamon() if there is no buffer
> ready.
>
> Without this patch, a user could call streamon() before
> preparing any buffer. This leads to a situation where if he calls
> close() before calling streamoff() the device is kept streaming.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 098df28..6f20e5a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return 0;
>   	}
>   
> +	if (!q->num_buffers) {
> +		dprintk(1, "streamon: no frames have been requested\n");

I think that "streamon: error - no buffers have been allocated\n" 
message is a bit
more descriptive and it matches the definitions used elsewhere in the 
debug messages.
Please don't mix buffers and frames.

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

