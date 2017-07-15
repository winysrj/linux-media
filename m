Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47957 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdGOJyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 05:54:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] uvcvideo: skip non-extension unit controls on Oculus Rift Sensors
Date: Sat, 15 Jul 2017 12:54:15 +0300
Message-ID: <1988392.8ZGCFRfgf9@avalon>
In-Reply-To: <20170714201424.23592-3-philipp.zabel@gmail.com>
References: <20170714201424.23592-1-philipp.zabel@gmail.com> <20170714201424.23592-3-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Friday 14 Jul 2017 22:14:24 Philipp Zabel wrote:
> The Oculus Rift Sensors (DK2 and CV1) allow to configure their sensor chips
> directly via I2C commands using extension unit controls. The processing and
> camera unit controls do not function at all.

Do the processing and camera units they report controls that don't work when 
exercised ? Who in a sane state of mind could have designed such a terrible 
product ?

If I understand you correctly, this device requires userspace code that knows 
how to program the sensor (and possibly other chips). If that's the case, is 
there an open-source implementation of that code publicly available ?

> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 86cb16a2e7f4..573e1f8735bf 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -2165,6 +2165,10 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  {
>  	struct uvc_entity *entity;
>  	unsigned int i;
> +	const struct usb_device_id xu_only[] = {
> +		{ USB_DEVICE(0x2833, 0x0201) },
> +		{ USB_DEVICE(0x2833, 0x0211) },
> +	};
> 
>  	/* Walk the entities list and instantiate controls */
>  	list_for_each_entry(entity, &dev->entities, list) {
> @@ -2172,6 +2176,16 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  		unsigned int bControlSize = 0, ncontrols;
>  		__u8 *bmControls = NULL;
> 
> +		/* Oculus Sensors only handle extension unit controls */
> +		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT) {
> +			for (i = 0; i < ARRAY_SIZE(xu_only); i++) {
> +				if (usb_match_one_id(dev->intf, &xu_only[i]))
> +					break;
> +			}
> +			if (i != ARRAY_SIZE(xu_only))
> +				continue;
> +		}
> +
>  		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
>  			bmControls = entity->extension.bmControls;
>  			bControlSize = entity->extension.bControlSize;

-- 
Regards,

Laurent Pinchart
