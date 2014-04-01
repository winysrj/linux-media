Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58250 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDALHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 07:07:34 -0400
Message-id: <533A9DF1.1000404@samsung.com>
Date: Tue, 01 Apr 2014 13:07:29 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vb2: Check if there are buffers before streamon
References: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

It seems the patch has been applied twice in linux-next/master:

$ git log --oneline -25 linux-next/master
drivers/media/v4l2-core/videobuf2-core.c
9cf3c31 [media] vb2: call buf_finish after the state check
3f1a9a3 [media] vb2: fix streamoff handling if streamon wasn't called
e4d2581 [media] vb2: replace BUG by WARN_ON
fb64dca [media] vb2: properly clean up PREPARED and QUEUED buffers
b3379c6 [media] vb2: only call start_streaming if sufficient buffers are
queued
a7afcac [media] vb2: don't init the list if there are still buffers
6ea3b98 [media] vb2: rename queued_count to owned_by_drv_count
256f316 [media] vb2: fix buf_init/buf_cleanup call sequences
9c0863b [media] vb2: call buf_finish from __queue_cancel
0647064 [media] vb2: change result code of buf_finish to void
b5b4541 [media] vb2: add debugging code to check for unbalanced ops
952c9ee [media] vb2: fix PREPARE_BUF regression
4e5a4d8 [media] vb2: fix read/write regression
>>>>> 249f5a5 [media] vb2: Check if there are buffers before streamon
c897df0 Merge tag 'v3.14-rc5' into patchwork
7ce6fd8 [media] v4l: Handle buffer timestamp flags correctly
872484c [media] v4l: Add timestamp source flags, mask and document them
c57ff79 [media] v4l: Timestamp flags will soon contain timestamp source,
not just type
ade4868 [media] v4l: Rename vb2_queue.timestamp_type as timestamp_flags
f134328 [media] vb2: fix timecode and flags handling for output buffers
>>>>> 548df78 [media] vb2: Check if there are buffers before streamon



Regards
Andrzej

On 01/08/2014 09:01 AM, Ricardo Ribalda Delgado wrote:
> This patch adds a test preventing streamon() if there is no buffer
> ready.
> 
> Without this patch, a user could call streamon() before
> preparing any buffer. This leads to a situation where if he calls
> close() before calling streamoff() the device is kept streaming.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> v2: Comment by Marek Szyprowski:
> Reword error message
> 
> v3: Comment by Marek Szyprowski:
> Actualy do the reword :)
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 098df28..6409e0a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  		return 0;
>  	}
>  
> +	if (!q->num_buffers) {
> +		dprintk(1, "streamon: no buffers have been allocated\n");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * If any buffers were queued before streamon,
>  	 * we can now pass them to driver for processing.
> 

