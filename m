Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbeHNWng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 18:43:36 -0400
Date: Tue, 14 Aug 2018 16:54:47 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 28/35] videobuf2-v4l2: add vb2_request_queue/validate
 helpers
Message-ID: <20180814165447.63a779e4@coco.lan>
In-Reply-To: <20180814142047.93856-29-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-29-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The generic vb2_request_validate helper function checks if
> there are buffers in the request and if so, prepares (validates)
> all objects in the request.
> 
> The generic vb2_request_queue helper function queues all buffer
> objects in the validated request.

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 51 +++++++++++++++++++
>  include/media/videobuf2-v4l2.h                |  4 ++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 9c652afa62ab..364b1fea3826 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -1100,6 +1100,57 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
>  }
>  EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
>  
> +/*
> + * Note that this function is called during validation time and
> + * thus the req_queue_mutex is held to ensure no request objects
> + * can be added or deleted while validating. So there is no need
> + * to protect the objects list.
> + */
> +int vb2_request_validate(struct media_request *req)
> +{
> +	struct media_request_object *obj;
> +	int ret = 0;
> +
> +	if (!vb2_request_has_buffers(req))
> +		return -ENOENT;
> +
> +	list_for_each_entry(obj, &req->objects, list) {
> +		if (!obj->ops->prepare)
> +			continue;
> +
> +		ret = obj->ops->prepare(obj);
> +		if (ret)
> +			break;
> +	}
> +
> +	if (ret) {
> +		list_for_each_entry_continue_reverse(obj, &req->objects, list)
> +			if (obj->ops->unprepare)
> +				obj->ops->unprepare(obj);
> +		return ret;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vb2_request_validate);
> +
> +void vb2_request_queue(struct media_request *req)
> +{
> +	struct media_request_object *obj, *obj_safe;
> +
> +	/*
> +	 * Queue all objects. Note that buffer objects are at the end of the
> +	 * objects list, after all other object types. Once buffer objects
> +	 * are queued, the driver might delete them immediately (if the driver
> +	 * processes the buffer at once), so we have to use
> +	 * list_for_each_entry_safe() to handle the case where the object we
> +	 * queue is deleted.
> +	 */
> +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list)
> +		if (obj->ops->queue)
> +			obj->ops->queue(obj);
> +}
> +EXPORT_SYMBOL_GPL(vb2_request_queue);
> +
>  MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
>  MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
>  MODULE_LICENSE("GPL");
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 91a2b3e1a642..727855463838 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -303,4 +303,8 @@ void vb2_ops_wait_prepare(struct vb2_queue *vq);
>   */
>  void vb2_ops_wait_finish(struct vb2_queue *vq);
>  
> +struct media_request;
> +int vb2_request_validate(struct media_request *req);
> +void vb2_request_queue(struct media_request *req);
> +
>  #endif /* _MEDIA_VIDEOBUF2_V4L2_H */



Thanks,
Mauro
