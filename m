Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65128 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbeDJJjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 05:39:02 -0400
Date: Tue, 10 Apr 2018 06:38:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
Message-ID: <20180410063856.32e44ce9@vento.lan>
In-Reply-To: <20180409142026.19369-3-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:19:59 +0200
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
> ---
>  include/uapi/linux/media.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c7e9a5cba24e..f8769e74f847 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -342,11 +342,19 @@ struct media_v2_topology {
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

Why use a struct here? Just declare it as:

	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)

> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
>  
>  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
>  

Thanks,
Mauro
