Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56114 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcFXN0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 09:26:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] uvcvideo: initialise the entity function field
Date: Fri, 24 Jun 2016 16:26:29 +0300
Message-ID: <2830501.QdemJ557Im@avalon>
In-Reply-To: <Pine.LNX.4.64.1606241326030.23461@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange> <Pine.LNX.4.64.1606241326030.23461@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Friday 24 Jun 2016 13:28:55 Guennadi Liakhovetski wrote:
> Since a recent commit:
> 
> [media] media-device: move media entity register/unregister functions
> 
> drivers have to set entity function before registering an entity. Fix
> the uvcvideo driver to comply with this.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/usb/uvc/uvc_entity.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_entity.c
> b/drivers/media/usb/uvc/uvc_entity.c index ac386bb..d93f413 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -88,6 +88,11 @@ static int uvc_mc_init_entity(struct uvc_video_chain
> *chain, if (ret < 0)
>  			return ret;
> 
> +		if (UVC_ENTITY_TYPE(entity) == UVC_ITT_CAMERA)
> +			entity->subdev.entity.function = 
MEDIA_ENT_F_CAM_SENSOR;
> +		else
> +			entity->subdev.entity.function = MEDIA_ENT_F_IO_V4L;
> +

I've discussed this some time ago with Hans (over IRC if I recall correctly). 
We need to define new functions, as not all UVC entities map to the existing 
ones. MEDIA_ENT_F_CAM_SENSOR should be fine for UVC_ITT_CAMERA, but 
MEDIA_ENT_F_IO_V4L isn't right as a default.

>  		ret = v4l2_device_register_subdev(&chain->dev->vdev,
>  						  &entity->subdev);
>  	} else if (entity->vdev != NULL) {

-- 
Regards,

Laurent Pinchart

