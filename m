Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:26543 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbeK1XQB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 18:16:01 -0500
Date: Wed, 28 Nov 2018 14:14:25 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: hverkuil-cisco@xs4all.nl
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for v4.20 1/5] vb2: don't call __vb2_queue_cancel if
 vb2_start_streaming failed
Message-ID: <20181128121425.ft6ab4jn2gtpyj5f@kekkonen.localdomain>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
 <20181128083747.18530-2-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128083747.18530-2-hverkuil-cisco@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 28, 2018 at 09:37:43AM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> vb2_start_streaming() already rolls back the buffers, so there is no
> need to call __vb2_queue_cancel(). Especially since __vb2_queue_cancel()
> does too much, such as zeroing the q->queued_count value, causing vb2
> to think that no buffers have been queued.
> 
> It appears that this call to __vb2_queue_cancel() is a left-over from
> before commit b3379c6201bb3.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Fixes: b3379c6201bb3 ('vb2: only call start_streaming if sufficient buffers are queued')
> Cc: <stable@vger.kernel.org>      # for v4.16 and up

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 0ca81d495bda..77e2bfe5e722 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1941,10 +1941,8 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
>  		if (ret)
>  			return ret;
>  		ret = vb2_start_streaming(q);
> -		if (ret) {
> -			__vb2_queue_cancel(q);
> +		if (ret)
>  			return ret;
> -		}
>  	}
>  
>  	q->streaming = 1;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
