Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40600 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbeEROtc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:49:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 02/28] uapi/linux/media.h: add request API
Date: Fri, 18 May 2018 17:49:54 +0300
Message-ID: <1827320.6V9tvRbKos@avalon>
In-Reply-To: <20180503145318.128315-3-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl> <20180503145318.128315-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday, 3 May 2018 17:52:52 EEST Hans Verkuil wrote:
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
>  include/uapi/linux/media.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c7e9a5cba24e..32883d4d22b2 100644
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
> +#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct
> media_request_alloc)
> +
> +/*
> + * These ioctls are called from the request file descriptor as returned

Maybe s/from/on/ ?

> + * by MEDIA_IOC_REQUEST_ALLOC.
> + */
> +#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
> +#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
> 
>  #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)

This matches the documentation in patch 22/28, so as such,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

However, please note that I've sent comments to that patch that might result 
in changes to the API, in which case my Reviewed-by wouldn't be applicable 
anymore.

-- 
Regards,

Laurent Pinchart
