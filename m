Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54754 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754955AbdKQMQH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 07:16:07 -0500
Date: Fri, 17 Nov 2017 10:15:59 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 03/11] [media] vb2: add 'ordered_in_driver' property to
 queues
Message-ID: <20171117101559.455cced3@vento.lan>
In-Reply-To: <20171115171057.17340-4-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
        <20171115171057.17340-4-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Nov 2017 15:10:49 -0200
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> We use ordered_in_driver property to optimize for the case where
> the driver can deliver the buffers in an ordered fashion. When it
> is ordered we can use the same fence context for all fences, but
> when it is not we need to a new context for each out-fence.
> 
> So the ordered_in_driver flag will help us with identifying the queues
> that can be optimized and use the same fence context.
> 
> v4: make the property a vector for optimization and not a mandatory thing
> that drivers need to set if they want to use explicit synchronization.
> 
> v3: improve doc (Hans Verkuil)
> 
> v2: rename property to 'ordered_in_driver' to avoid confusion
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/media/videobuf2-core.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index ef9b64398c8c..38b9c8dd42c6 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -440,6 +440,12 @@ struct vb2_buf_ops {
>   * @fileio_read_once:		report EOF after reading the first buffer
>   * @fileio_write_immediately:	queue buffer after each write() call
>   * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
> + * @ordered_in_driver: if the driver can guarantee that the queue will be
> + *		ordered or not, i.e., the buffers are dequeued from the driver
> + *		in the same order they are queued to the driver. The default
> + *		is not ordered unless the driver sets this flag. Setting it
> + *		when ordering can be guaranted helps to optimize explicit
> + *		fences.
>   * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
>   *              has not been called. This is a vb1 idiom that has been adopted
>   *              also by vb2.
> @@ -510,6 +516,7 @@ struct vb2_queue {
>  	unsigned			fileio_read_once:1;
>  	unsigned			fileio_write_immediately:1;
>  	unsigned			allow_zero_bytesused:1;
> +	unsigned			ordered_in_driver:1;

As this may depend on the format, it is probably a good idea to set
this flag either via a function argument or by a function that
would be meant to update it, as video format changes.

>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
>  
>  	struct mutex			*lock;


-- 
Thanks,
Mauro
