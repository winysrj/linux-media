Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56780 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932180AbeEWKSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 06:18:01 -0400
Subject: Re: [PATCH v14 24/36] videobuf2-v4l2: Lock the media request for
 update for QBUF
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
 <20180521085501.16861-25-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <18882843-3bec-4286-3668-16ffda5aed9c@xs4all.nl>
Date: Wed, 23 May 2018 12:17:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180521085501.16861-25-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/05/18 10:54, Sakari Ailus wrote:
> Lock the media request for updating on QBUF IOCTL using
> media_request_lock_for_update().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 0a68b19b40da7..8b390960ca671 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -398,12 +398,13 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  	if (IS_ERR(req)) {
>  		dprintk(1, "%s: invalid request_fd\n", opname);
>  		return PTR_ERR(req);
> -	}
> -
> -	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE) {
> -		dprintk(1, "%s: request is not idle\n", opname);
> -		media_request_put(req);
> -		return -EBUSY;
> +	} else {
> +		ret = media_request_lock_for_update(req);
> +		if (ret) {
> +			media_request_put(req);
> +			dprintk(1, "%s: request %d busy\n", opname, b->request_fd);
> +			return PTR_ERR(req);
> +		}
>  	}
>  
>  	*p_req = req;
> @@ -683,8 +684,10 @@ int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
>  	if (ret)
>  		return ret;
>  	ret = vb2_core_qbuf(q, b->index, b, req);
> -	if (req)
> +	if (req) {
> +		media_request_unlock_for_update(req);
>  		media_request_put(req);
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vb2_qbuf);
> 

The media_request_(un)lock_for_update calls shouldn't be done here, instead they
should happen in videobuf2-core.c in vb2_core_qbuf, right before and after the
call to media_request_object_bind().

The atomic_read in the original patch in vb2_queue_or_prepare_buf() was there as
an early sanity check. The call to media_request_object_bind() is where the real
check for the request state takes place.

Regards,

	Hans
