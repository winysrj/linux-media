Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeEHJzG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 05:55:06 -0400
Date: Tue, 8 May 2018 06:54:57 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 16/28] videobuf2-core: embed media_request_object
Message-ID: <20180508065457.095df1c2@vento.lan>
In-Reply-To: <20180503145318.128315-17-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
        <20180503145318.128315-17-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  3 May 2018 16:53:06 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Make vb2_buffer a request object.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/videobuf2-core.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 224c4820a044..3d54654c3cd4 100644
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
> @@ -238,6 +239,7 @@ struct vb2_queue;
>   * @num_planes:		number of planes in the buffer
>   *			on an internal driver queue.
>   * @timestamp:		frame timestamp in ns.
> + * @req_obj:		used to bind this buffer to a request
>   */
>  struct vb2_buffer {
>  	struct vb2_queue	*vb2_queue;
> @@ -246,6 +248,7 @@ struct vb2_buffer {
>  	unsigned int		memory;
>  	unsigned int		num_planes;
>  	u64			timestamp;
> +	struct media_request_object	req_obj;
>  
>  	/* private: internal use only
>  	 *

Hmm... this has a side effect of embedding a kref at struct vb2_buffer.
One struct can have just one kref.

I guess this is likely ok, but this is a big struct. I don't like
the idea of having a hidden kref indirectly embedded there, as the
lifetime of this struct will now be controlled outside vb2, with
looks weird.

Thanks,
Mauro
