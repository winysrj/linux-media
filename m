Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbeIKUkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:40:20 -0400
Subject: Re: [PATCH v2 13/13] udmabuf: add documentation
To: Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20180911134216.9760-1-kraxel@redhat.com>
 <20180911134216.9760-14-kraxel@redhat.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ae4524da-abdb-e5b5-7658-3a0e9a6a071e@infradead.org>
Date: Tue, 11 Sep 2018 08:40:26 -0700
MIME-Version: 1.0
In-Reply-To: <20180911134216.9760-14-kraxel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/11/18 6:42 AM, Gerd Hoffmann wrote:
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  include/uapi/linux/udmabuf.h         | 50 +++++++++++++++++++++++++++++++++---
>  Documentation/driver-api/dma-buf.rst |  8 ++++++
>  2 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/udmabuf.h b/include/uapi/linux/udmabuf.h
> index 46b6532ed8..f30b37cb5c 100644
> --- a/include/uapi/linux/udmabuf.h
> +++ b/include/uapi/linux/udmabuf.h
> @@ -5,8 +5,38 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  
> +/**
> + * DOC: udmabuf
> + *
> + * udmabuf is a device driver which allows userspace create dmabufs.

                                                        to create

> + * The memory used for these dmabufs must be backed by memfd.  The
> + * memfd must have F_SEAL_SHRINK and it must not have F_SEAL_WRITE.
> + *
> + * The driver has two ioctls, one to create a dmabuf from a single
> + * memory block and one to create a dmabuf from a list of memory
> + * blocks.
> + *
> + * UDMABUF_CREATE - _IOW('u', 0x42, udmabuf_create)
> + *
> + * UDMABUF_CREATE_LIST - _IOW('u', 0x43, udmabuf_create_list)
> + */
> +
> +#define UDMABUF_CREATE       _IOW('u', 0x42, struct udmabuf_create)
> +#define UDMABUF_CREATE_LIST  _IOW('u', 0x43, struct udmabuf_create_list)
> +
>  #define UDMABUF_FLAGS_CLOEXEC	0x01
>  
> +/**
> + * struct udmabuf_create - create a dmabuf from a single memory block.
> + *
> + * @memfd: The file handle.
> + * @offset: Start of the buffer (from memfd start).
> + * Must be page aligned.
> + * @size: Size of the buffer.  Must be rounded to page size.

      @flags: ???

> + *
> + * flags:
> + * UDMABUF_FLAGS_CLOEXEC: set CLOEXEC flag for the dmabuf.
> + */
>  struct udmabuf_create {
>  	__u32 memfd;
>  	__u32 flags;
> @@ -14,6 +44,14 @@ struct udmabuf_create {
>  	__u64 size;
>  };
>  
> +/**
> + * struct udmabuf_create_item - one memory block list item.
> + *
> + * @memfd: The file handle.
> + * @offset: Start of the buffer (from memfd start).
> + * Must be page aligned.
> + * @size: Size of the buffer.  Must be rounded to page size.
> + */
>  struct udmabuf_create_item {
>  	__u32 memfd;
>  	__u32 __pad;
> @@ -21,13 +59,19 @@ struct udmabuf_create_item {
>  	__u64 size;
>  };
>  
> +/**
> + * struct udmabuf_create_list - create a dmabuf from a memory block list.
> + *
> + * @count: The number of list elements.
> + * @list: The memory block list
> + *
> + * flags:

      @flags:

> + * UDMABUF_FLAGS_CLOEXEC: set CLOEXEC flag for the dmabuf.
> + */
>  struct udmabuf_create_list {
>  	__u32 flags;
>  	__u32 count;
>  	struct udmabuf_create_item list[];
>  };


thanks.
-- 
~Randy
