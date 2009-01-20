Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:37288 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbZATWWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:22:18 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Thierry Merle <thierry.merle@free.fr>
Subject: Re: [PATCH 4/5] uvcvideo: use usb_make_path to report bus info
Date: Tue, 20 Jan 2009 23:22:13 +0100
Cc: linux-media@vger.kernel.org
References: <49764412.8030305@free.fr> <4976450C.2040601@free.fr>
In-Reply-To: <4976450C.2040601@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901202322.13802.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Tuesday 20 January 2009, Thierry Merle wrote:
> usb_make_path reports canonical bus info. Use it when reporting bus info
> in VIDIOC_QUERYCAP.
>
> Signed-off-by: Thierry MERLE <thierry.merle@free.fr>
>
> diff -r 72ba48adaacd -r 43bb285afc52
> linux/drivers/media/video/uvc/uvc_v4l2.c ---
> a/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Jan 20 22:06:58 2009 +0100
> +++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Jan 20 22:13:45 2009
> +0100 @@ -494,8 +494,7 @@
>  		memset(cap, 0, sizeof *cap);
>  		strncpy(cap->driver, "uvcvideo", sizeof cap->driver);
>  		strncpy(cap->card, vdev->name, 32);
> -		strncpy(cap->bus_info, video->dev->udev->bus->bus_name,
> -			sizeof cap->bus_info);
> +		usb_make_path(video->dev->udev, cap->bus_info, sizeof(cap->bus_info));

This overflows the 80 columns limit, could you please split the statement ?

+		usb_make_path(video->dev->udev, cap->bus_info,
+			      sizeof(cap->bus_info));

>  		cap->version = DRIVER_VERSION_NUMBER;
>  		if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

and thanks for the patch.
