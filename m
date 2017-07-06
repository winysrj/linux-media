Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45217 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751009AbdGFJIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 05:08:06 -0400
Subject: Re: [PATCH 08/12] [media] vb2: add 'ordered' property to queues
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-9-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6175ff4-ff79-c458-12ea-8d90fd4e8432@xs4all.nl>
Date: Thu, 6 Jul 2017 11:08:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-9-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> For explicit synchronization (and soon for HAL3/Request API) we need
> the v4l2-driver to guarantee the ordering which the buffer were queued
> by userspace. This is already true for many drivers, but we never had
> the need to say it.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/media/videobuf2-core.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index aa43e43..a8b800e 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -491,6 +491,9 @@ struct vb2_buf_ops {
>   * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>   *		last decoded buffer was already dequeued. Set for capture queues
>   *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
> + * @ordered: if the driver can guarantee that the queue will be ordered or not.
> + *		The default is not ordered unless the driver sets this flag. It
> + *		is mandatory for using explicit fences.

This needs to be clarified both here and in the commit log.

1) what is meant with 'ordered'? I assume FIFO is meant.
2) is it the order in which buffers are queued in the driver, or the order
in which buffers are queued in userspace? With in-fences it is ordered
in the driver but not in userspace since the in-fence will block a buffer
from being queued to the driver until the fence callback is called.
3) does this apply to in-fences or out-fences or both? It appears that this
only applies to out-fences.

>   * @fileio:	file io emulator internal data, used only if emulator is active
>   * @threadio:	thread io internal data, used only if thread is active
>   */
> @@ -541,6 +544,7 @@ struct vb2_queue {
>  	unsigned int			is_output:1;
>  	unsigned int			copy_timestamp:1;
>  	unsigned int			last_buffer_dequeued:1;
> +	unsigned int			ordered:1;
>  
>  	struct vb2_fileio_data		*fileio;
>  	struct vb2_threadio_data	*threadio;
> 

Regards,

	Hans
