Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbeHNWF5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 18:05:57 -0400
Date: Tue, 14 Aug 2018 16:17:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 02/35] uapi/linux/media.h: add request API
Message-ID: <20180814161715.4e3d7ed1@coco.lan>
In-Reply-To: <20180814142047.93856-3-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:14 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Define the public request API.
> 
> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> and two ioctls that operate on a request in order to queue the
> contents of the request to the driver and to re-initialize the
> request.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  include/uapi/linux/media.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 36f76e777ef9..e5d0c5c611b5 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -369,6 +369,14 @@ struct media_v2_topology {
>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
> +#define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
> +
> +/*
> + * These ioctls are called on the request file descriptor as returned
> + * by MEDIA_IOC_REQUEST_ALLOC.
> + */
> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
>  
>  #ifndef __KERNEL__
>  



Thanks,
Mauro
