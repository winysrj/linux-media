Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40266 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbcF2W4q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:56:46 -0400
Date: Wed, 29 Jun 2016 23:46:46 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH 15/15] include: lirc: add set length and frequency ioctl
 options
Message-ID: <20160629224646.GA30214@gofer.mess.org>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
 <1467206444-9935-16-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467206444-9935-16-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 29, 2016 at 10:20:44PM +0900, Andi Shyti wrote:
> The Lirc framework works mainly with receivers, but there is
> nothing that prevents us from using it for transmitters as well.

The lirc interface already provides for transmitting IR.

> For that we need to have more control on the device frequency to
> set (which is a new concept fro LIRC) and we also need to provide
> to userspace, as feedback, the values of the used frequency and
> length.

Please can you elaborate on what exactly you mean by frequency and
length.

The carrier frequency can already be set with LIRC_SET_SEND_CARRIER.

> Add the LIRC_SET_LENGTH, LIRC_GET_FREQUENCY and
> LIRC_SET_FREQUENCY ioctl commands in order to allow the above
> mentioned operations.

You're also adding ioctls without any drivers implementing them
unless I missed something.

> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  include/uapi/linux/lirc.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
> index 4b3ab29..94a0d8c 100644
> --- a/include/uapi/linux/lirc.h
> +++ b/include/uapi/linux/lirc.h
> @@ -106,6 +106,7 @@
>  
>  /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
>  #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
> +#define LIRC_SET_LENGTH                _IOW('i', 0x00000010, __u32)

The LIRC_GET_LENGTH is specific to LIRCCODE encoding. Why are you
adding it here?

>  
>  #define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
>  #define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
> @@ -165,4 +166,7 @@
>  
>  #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
>  
> +#define LIRC_GET_FREQUENCY             _IOR('i', 0x00000024, __u32)
> +#define LIRC_SET_FREQUENCY             _IOW('i', 0x00000025, __u32)
> +
>  #endif
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
