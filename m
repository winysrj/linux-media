Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53350 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752099AbdKCHXO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 03:23:14 -0400
Subject: Re: [RFC v4 09/17] [media] vb2: add 'ordered_in_vb2' property to
 queues
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20171020215012.20646-1-gustavo@padovan.org>
 <20171020215012.20646-10-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <47e06a32-e824-e110-7bf2-2d429df81a33@xs4all.nl>
Date: Fri, 3 Nov 2017 08:23:06 +0100
MIME-Version: 1.0
In-Reply-To: <20171020215012.20646-10-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/20/2017 11:50 PM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> By setting this member on vb2_queue the driver tell vb2 core that
> it requires the buffers queued in QBUF to be queued with same order to the
> driver.

As we discussed in Prague this appears to be an unnecessary flag. In fact,
as far as I can tell it isn't set at all in this patch series.

Regards,

	Hans

> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/media/videobuf2-core.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 6dd3f0181107..fc333e10e7d8 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -505,6 +505,9 @@ struct vb2_buf_ops {
>   *		the same order they are dequeued from the driver. The default
>   *		is not ordered unless the driver sets this flag. As of now it
>   *		is mandatory for using explicit fences.
> + * @ordered_in_vb2: set by the driver to tell vb2 te guarantee the order
> + *		of buffer queue from userspace with QBUF() until they are
> + *		queued to the driver.
>   * @fileio:	file io emulator internal data, used only if emulator is active
>   * @threadio:	thread io internal data, used only if thread is active
>   */
> @@ -558,6 +561,7 @@ struct vb2_queue {
>  	unsigned int			copy_timestamp:1;
>  	unsigned int			last_buffer_dequeued:1;
>  	unsigned int			ordered_in_driver:1;
> +	unsigned int			ordered_in_vb2:1;
>  
>  	struct vb2_fileio_data		*fileio;
>  	struct vb2_threadio_data	*threadio;
> 
