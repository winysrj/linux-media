Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59021 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753744AbeDJNxL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 09:53:11 -0400
Date: Tue, 10 Apr 2018 10:53:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 21/29] videobuf2-core: add
 vb2_core_request_has_buffers
Message-ID: <20180410105306.09086ff9@vento.lan>
In-Reply-To: <20180409142026.19369-22-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-22-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:18 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new helper function that returns true if a media_request
> contains buffers.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 12 ++++++++++++
>  include/media/videobuf2-core.h                  |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 4f6c0b2d7d1a..13c9d9e243dd 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1339,6 +1339,18 @@ static const struct media_request_object_ops vb2_core_req_ops = {
>  	.release = vb2_req_release,
>  };
>  
> +bool vb2_core_request_has_buffers(struct media_request *req)
> +{
> +	struct media_request_object *obj;
> +
> +	list_for_each_entry(obj, &req->objects, list) {
> +		if (obj->ops == &vb2_core_req_ops)
> +			return true;
> +	}
> +	return false;

-ENOLOCK

> +}
> +EXPORT_SYMBOL_GPL(vb2_core_request_has_buffers);
> +
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
>  			 struct media_request *req)
>  {
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 72663c2a3ba3..e23dc028aee7 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -1158,4 +1158,6 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb);
>   */
>  int vb2_verify_memory_type(struct vb2_queue *q,
>  		enum vb2_memory memory, unsigned int type);
> +
> +bool vb2_core_request_has_buffers(struct media_request *req);
>  #endif /* _MEDIA_VIDEOBUF2_CORE_H */



Thanks,
Mauro
