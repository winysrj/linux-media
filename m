Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753602AbeDKTdF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 15:33:05 -0400
Date: Wed, 11 Apr 2018 21:32:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Edgar Thier <info@edgarthier.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: uvcvideo: Prevent setting unavailable flags
In-Reply-To: <1521646988-803-1-git-send-email-kieran.bingham@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1804112131160.25028@axis700.grange>
References: <1521646988-803-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for the patch, it fixed a problem I was having with media master, 
working with a Logitech UVC 1.5 camera.

On Wed, 21 Mar 2018, Kieran Bingham wrote:

> The addition of an extra operation to use the GET_INFO command
> overwrites all existing flags from the uvc_ctrls table. This includes
> setting all controls as supporting  GET_MIN, GET_MAX, GET_RES, and
> GET_DEF regardless of whether they do or not.
> 
> Move the initialisation of these control capabilities directly to the
> uvc_ctrl_fill_xu_info() call where they were originally located in that
> use case, and ensure that the new functionality in uvc_ctrl_get_flags()
> will only set flags based on their reported capability from the GET_INFO
> call.
> 
> Fixes: 859086ae3636 ("media: uvcvideo: Apply flags from device to actual
> properties")
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Thanks
Guennadi

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index 1daf444371be..4042cbdb721b 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1607,14 +1607,12 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
>  	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
>  			     info->selector, data, 1);
>  	if (!ret)
> -		info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> -			    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
> -			    | (data[0] & UVC_CONTROL_CAP_GET ?
> -			       UVC_CTRL_FLAG_GET_CUR : 0)
> -			    | (data[0] & UVC_CONTROL_CAP_SET ?
> -			       UVC_CTRL_FLAG_SET_CUR : 0)
> -			    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> -			       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> +		info->flags |= (data[0] & UVC_CONTROL_CAP_GET ?
> +				UVC_CTRL_FLAG_GET_CUR : 0)
> +			    |  (data[0] & UVC_CONTROL_CAP_SET ?
> +				UVC_CTRL_FLAG_SET_CUR : 0)
> +			    |  (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> +				UVC_CTRL_FLAG_AUTO_UPDATE : 0);
>  
>  	kfree(data);
>  	return ret;
> @@ -1689,6 +1687,9 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
>  
>  	info->size = le16_to_cpup((__le16 *)data);
>  
> +	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF;
> +
>  	ret = uvc_ctrl_get_flags(dev, ctrl, info);
>  	if (ret < 0) {
>  		uvc_trace(UVC_TRACE_CONTROL,
> -- 
> 2.7.4
> 
