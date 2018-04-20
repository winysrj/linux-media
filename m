Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60805 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754989AbeDTNnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:43:42 -0400
Subject: Re: [PATCH v2 03/10] videobuf2-core: Add helper to get buffer private
 data from media request
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154124.17512-4-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <581bb769-acad-1050-3060-f3f11802be89@xs4all.nl>
Date: Fri, 20 Apr 2018 15:43:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180419154124.17512-4-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 17:41, Paul Kocialkowski wrote:
> When calling media operation driver callbacks related to media requests,
> only a pointer to the request itself is provided, which is insufficient
> to retrieve the driver's context. Since the driver context is usually
> set as vb2 queue private data and given that the core can determine
> which objects attached to the request are buffers, it is possible to
> extract the associated private data for the first buffer found.
> 
> This is required in order to access the current m2m context from m2m
> drivers' private data in the context of media request operation
> callbacks. More specifically, this allows scheduling m2m device runs
> from the newly-introduced request complete operation.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 15 +++++++++++++++
>  include/media/videobuf2-core.h                  |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 13c9d9e243dd..6fa46bfc620f 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1351,6 +1351,21 @@ bool vb2_core_request_has_buffers(struct media_request *req)
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_request_has_buffers);
>  
> +void *vb2_core_request_find_buffer_priv(struct media_request *req)
> +{
> +	struct media_request_object *obj;
> +	struct vb2_buffer *vb;
> +
> +	obj = media_request_object_find(req, &vb2_core_req_ops, NULL);

This increases the object refcount but it is never decreased here.

> +	if (!obj)
> +		return NULL;
> +
> +	vb = container_of(obj, struct vb2_buffer, req_obj);
> +
> +	return vb2_get_drv_priv(vb->vb2_queue);

You need to add a media_request_object_put(obj); before returning here.

Regards,

	Hans

> +}
> +EXPORT_SYMBOL_GPL(vb2_core_request_find_buffer_priv);
> +
>  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb,
>  			 struct media_request *req)
>  {
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 032bd1bec555..65c0cf6afb55 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -1153,4 +1153,5 @@ int vb2_verify_memory_type(struct vb2_queue *q,
>  		enum vb2_memory memory, unsigned int type);
>  
>  bool vb2_core_request_has_buffers(struct media_request *req);
> +void *vb2_core_request_find_buffer_priv(struct media_request *req);
>  #endif /* _MEDIA_VIDEOBUF2_CORE_H */
> 
