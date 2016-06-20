Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:55228 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbcFTMku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 08:40:50 -0400
Subject: Re: [PATCH v2 4/4] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl
References: <1466425809-23469-1-git-send-email-ricardo.ribalda@gmail.com>
 <1466425809-23469-4-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <5767E3C7.3060603@cisco.com>
Date: Mon, 20 Jun 2016 14:38:31 +0200
MIME-Version: 1.0
In-Reply-To: <1466425809-23469-4-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 02:30 PM, Ricardo Ribalda Delgado wrote:
> According to the doc, V4L2_BUF_FLAG_DONE is cleared after DQBUF:
>
> V4L2_BUF_FLAG_DONE 0x00000004  ... After calling the VIDIOC_QBUF or
> VIDIOC_DQBUF it is always cleared ...
>
> Unfortunately, it seems that videobuf2 keeps it set after DQBUF. This
> can be tested with vivid and dev_debug:
>
> [257604.338082] video1: VIDIOC_DQBUF: 71:33:25.00260479 index=3,
> type=vid-cap, flags=0x00002004, field=none, sequence=163,
> memory=userptr, bytesused=460800, offset/userptr=0x344b000,
> length=460800
>
> This patch forces FLAG_DONE to 0 after calling DQBUF.

Can you change this to be patch 1/4? That makes it much easier to backport to
older kernels. I'm not sure if I'll actually do that, but putting this patch
at the end makes it harder than it needs to be.

Regards,

	Hans

>
> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-v4l2.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index ba3467468e55..9cfbb6e4bc28 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -654,6 +654,12 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
>
>   	ret = vb2_core_dqbuf(q, NULL, b, nonblocking);
>
> +	/*
> +	 *  After calling the VIDIOC_DQBUF V4L2_BUF_FLAG_DONE must be
> +	 *  cleared.
> +	 */
> +	b->flags &= ~V4L2_BUF_FLAG_DONE;
> +
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(vb2_dqbuf);
>

