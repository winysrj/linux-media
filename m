Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbeGCJVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 05:21:36 -0400
Date: Tue, 3 Jul 2018 06:21:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv15 01/35] uapi/linux/media.h: add request API
Message-ID: <20180703062131.46cb4179@coco.lan>
In-Reply-To: <20180604114648.26159-2-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
        <20180604114648.26159-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  4 Jun 2018 13:46:14 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Define the public request API.
> 
> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> and two ioctls that operate on a request in order to queue the
> contents of the request to the driver and to re-initialize the
> request.

It would be better if you had added the documentation stuff here...
I can't review this patch without first reviewing the documentation
for the new ioctls...

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/uapi/linux/media.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c7e9a5cba24e..0f0117742fa7 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -342,11 +342,23 @@ struct media_v2_topology {
>  
>  /* ioctls */
>  
> +struct __attribute__ ((packed)) media_request_alloc {
> +	__s32 fd;
> +};
> +
>  #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
> +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
> +
> +/*
> + * These ioctls are called on the request file descriptor as returned
> + * by MEDIA_IOC_REQUEST_ALLOC.
> + */
> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
>  
>  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
>  



Thanks,
Mauro
