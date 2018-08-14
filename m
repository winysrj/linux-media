Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57984 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbeHNWmE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 18:42:04 -0400
Date: Tue, 14 Aug 2018 16:53:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 24/35] videobuf2-core: embed media_request_object
Message-ID: <20180814165315.317851df@coco.lan>
In-Reply-To: <20180814142047.93856-25-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-25-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:36 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Make vb2_buffer a request object.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I had already sent a reviewed-by to this. Anyway:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>


> ---
>  include/media/videobuf2-core.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 2eb24961183e..413b8b2dc485 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -17,6 +17,7 @@
>  #include <linux/poll.h>
>  #include <linux/dma-buf.h>
>  #include <linux/bitops.h>
> +#include <media/media-request.h>
>  
>  #define VB2_MAX_FRAME	(32)
>  #define VB2_MAX_PLANES	(8)
> @@ -236,6 +237,8 @@ struct vb2_queue;
>   * @num_planes:		number of planes in the buffer
>   *			on an internal driver queue.
>   * @timestamp:		frame timestamp in ns.
> + * @req_obj:		used to bind this buffer to a request. This
> + *			request object has a refcount.
>   */
>  struct vb2_buffer {
>  	struct vb2_queue	*vb2_queue;
> @@ -244,6 +247,7 @@ struct vb2_buffer {
>  	unsigned int		memory;
>  	unsigned int		num_planes;
>  	u64			timestamp;
> +	struct media_request_object	req_obj;
>  
>  	/* private: internal use only
>  	 *



Thanks,
Mauro
