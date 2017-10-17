Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35699 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbdJQSeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 14:34:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH 6/6 v5]  uvcvideo: handle control pipe protocol STALLs
Date: Tue, 17 Oct 2017 21:34:30 +0300
Message-ID: <1657168.naMi6CNRro@avalon>
In-Reply-To: <1501245205-15802-7-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-7-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Friday, 28 July 2017 15:33:25 EEST Guennadi Liakhovetski wrote:
> When a command ends up in a STALL on the control pipe, use the Request
> Error Code control to provide a more precise error information to the
> user.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 59 ++++++++++++++++++++++++++++++++----
>  1 file changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 006691e..887561b 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -34,15 +34,59 @@ static int __uvc_query_ctrl(struct uvc_device *dev, __u8
> query, __u8 unit, __u8 intfnum, __u8 cs, void *data, __u16 size,
>  			int timeout)
>  {
> -	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
> +	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE, tmp, error;

Please don't declare multiple variables per line, especially not after an 
assignment.

>  	unsigned int pipe;
> +	int ret;
> 
>  	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
>  			      : usb_sndctrlpipe(dev->udev, 0);
>  	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
> 
> -	return usb_control_msg(dev->udev, pipe, query, type, cs << 8,
> +	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
>  			unit << 8 | intfnum, data, size, timeout);
> +

No need for a blank line here.

> +	if (ret != -EPIPE)
> +		return ret;
> +
> +	tmp = *(u8 *)data;

Ouch, borrowing the passed data buffer sounds error-prone :-/ Wouldn't it be 
better to kmalloc a buffer on demand, or possible allocate one in the 
uvc_device structure and serialize the following code ? As it should be 
invoked very infrequently that might not be a big issue.

> +	pipe = usb_rcvctrlpipe(dev->udev, 0);
> +	type = USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN;
> +	ret = usb_control_msg(dev->udev, pipe, UVC_GET_CUR, type,
> +			      UVC_VC_REQUEST_ERROR_CODE_CONTROL << 8,
> +			      unit << 8 | intfnum, data, 1, timeout);
> +	error = *(u8 *)data;
> +	*(u8 *)data = tmp;
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!ret)
> +		return -EINVAL;
> +
> +	uvc_trace(UVC_TRACE_CONTROL, "Control error %u\n", error);
> +
> +	switch (error) {
> +	case 0:
> +		/* Cannot happen - we received a STALL */
> +		return -EPIPE;
> +	case 1: /* Not ready */
> +		return -EAGAIN;
> +	case 2: /* Wrong state */
> +		return -EILSEQ;
> +	case 3: /* Power */
> +		return -EREMOTE;
> +	case 4: /* Out of range */
> +		return -ERANGE;
> +	case 5: /* Invalid unit */
> +	case 6: /* Invalid control */
> +	case 7: /* Invalid Request */
> +	case 8: /* Invalid value within range */
> +	default: /* reserved or unknown */
> +		break;
> +	}
> +
> +	return -EINVAL;

You can move this line to the default case.

What's your use case for this patch ? What error do you need to report, who do 
you report it to, and how is it handled ?

>  }
> 
>  static const char *uvc_query_name(__u8 query)
> @@ -80,7 +124,7 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query,
> __u8 unit, uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
>  			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
>  			unit, ret, size);
> -		return -EIO;
> +		return ret < 0 ? ret : -EIO;
>  	}
> 
>  	return 0;
> @@ -203,13 +247,15 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> *stream, uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
>  			"compliance - GET_DEF(PROBE) not supported. "
>  			"Enabling workaround.\n");
> -		ret = -EIO;
> +		if (ret >= 0)
> +			ret = -EIO;
>  		goto out;
>  	} else if (ret != size) {
>  		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : "
>  			"%d (exp. %u).\n", query, probe ? "probe" : "commit",
>  			ret, size);
> -		ret = -EIO;
> +		if (ret >= 0)
> +			ret = -EIO;
>  		goto out;
>  	}
> 
> @@ -290,7 +336,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
>  			"%d (exp. %u).\n", probe ? "probe" : "commit",
>  			ret, size);
> -		ret = -EIO;
> +		if (ret >= 0)
> +			ret = -EIO;
>  	}
> 
>  	kfree(data);

-- 
Regards,

Laurent Pinchart
