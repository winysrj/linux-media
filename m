Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45522 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbcCBHyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 02:54:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media-device.h: fix compiler warning
Date: Wed, 02 Mar 2016 09:54:14 +0200
Message-ID: <1978984.NgLd87hx0T@avalon>
In-Reply-To: <56D00263.8040606@xs4all.nl>
References: <56D00263.8040606@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 26 February 2016 08:44:35 Hans Verkuil wrote:
> Fix these compiler warnings:
> 
> media-git/include/media/media-device.h: In function 'media_device_pci_init':
> media-git/include/media/media-device.h:610:9: warning: 'return' with a
> value, in function returning void return NULL;
>          ^
> media-git/include/media/media-device.h: In function
> '__media_device_usb_init': media-git/include/media/media-device.h:618:9:
> warning: 'return' with a value, in function returning void return NULL;
>          ^
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 49dda6c..44012fe 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -607,7 +607,6 @@ static inline void media_device_pci_init(struct
> media_device *mdev, struct pci_dev *pci_dev,
>  					 char *name)
>  {
> -	return NULL;
>  }
> 
>  static inline void __media_device_usb_init(struct media_device *mdev,
> @@ -615,7 +614,6 @@ static inline void __media_device_usb_init(struct
> media_device *mdev, char *board_name,
>  					   char *driver_name)
>  {
> -	return NULL;
>  }
> 
>  #endif /* CONFIG_MEDIA_CONTROLLER */

-- 
Regards,

Laurent Pinchart

