Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:39675 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbcKPQV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:21:57 -0500
Message-ID: <1479312671.14443.3.camel@v3.sk>
Subject: Re: [PATCH] [media] usbtv: don't do DMA on stack
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Federico Simoncelli <fsimonce@redhat.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Nikola =?ISO-8859-1?Q?Forr=F3?= <nikola.forro@gmail.com>,
        Insu Yun <wuninsu@gmail.com>
Date: Wed, 16 Nov 2016 17:11:11 +0100
In-Reply-To: <9c5e1833f754f55e9ccc05549a90c5fa439ce63e.1479309351.git.mchehab@s-opensource.com>
References: <9c5e1833f754f55e9ccc05549a90c5fa439ce63e.1479309351.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-11-16 at 13:15 -0200, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/usb/usbtv/usbtv-video.c:716 usbtv_s_ctrl() error:
> doing dma on the stack (data)
> 	drivers/media/usb/usbtv/usbtv-video.c:758 usbtv_s_ctrl() error:
> doing dma on the stack (data)
> 
> We should not do it, as it won't work on Kernels 4.9 and upper.
> So, alloc a buffer for it.
> 
> Fixes: c53a846c48f2 ("[media] usbtv: add video controls")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/usbtv/usbtv-video.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c
> b/drivers/media/usb/usbtv/usbtv-video.c
> index 86ffbf8780f2..d3b6d3dfaa09 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -704,10 +704,14 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct usbtv *usbtv = container_of(ctrl->handler, struct
> usbtv,
>  								ctrl
> );
> -	u8 data[3];
> +	u8 *data;
>  	u16 index, size;
>  	int ret;
>  
> +	data = kmalloc(3, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
>  	/*
>  	 * Read in the current brightness/contrast registers. We
> need them
>  	 * both, because the values are for some reason interleaved.
> @@ -717,6 +721,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  			usb_sndctrlpipe(usbtv->udev, 0),
> USBTV_CONTROL_REG,
>  			USB_DIR_OUT | USB_TYPE_VENDOR |
> USB_RECIP_DEVICE,
>  			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
> +		if (ret < 0)
> +			goto error;
>  	}
>  
>  	switch (ctrl->id) {
> @@ -752,6 +758,7 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  		}
>  		break;
>  	default:
> +		kfree(data);
>  		return -EINVAL;
>  	}
>  
> @@ -759,12 +766,13 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
>  			USBTV_CONTROL_REG,
>  			USB_DIR_OUT | USB_TYPE_VENDOR |
> USB_RECIP_DEVICE,
>  			0, index, (void *)data, size, 0);
> -	if (ret < 0) {
> +
> +error:
> +	if (ret < 0)
>  		dev_warn(usbtv->dev, "Failed to submit a control
> request.\n");
> -		return ret;
> -	}
>  
> -	return 0;
> +	kfree(data);
> +	return ret;
>  }
>  
>  static const struct v4l2_ctrl_ops usbtv_ctrl_ops = {

Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>

Thank you,
Lubo
