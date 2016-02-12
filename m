Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56235 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbcBLJzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:55:49 -0500
Subject: Re: [PATCH 06/11] [media] v4l2-mc: use usb_make_path() to provide bus
 info
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	no To-header on input <""@pop.xs4all.nl>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
 <9b8fed2b73514df87fced36481f84a0a745b674d.1455269986.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BDAC21.9000005@xs4all.nl>
Date: Fri, 12 Feb 2016 10:55:45 +0100
MIME-Version: 1.0
In-Reply-To: <9b8fed2b73514df87fced36481f84a0a745b674d.1455269986.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2016 10:45 AM, Mauro Carvalho Chehab wrote:
> Report the bus info on the same way as VIDIOC_QUERYCAP. Also,
> currently, it is reporting just PORT/DEV.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 649972e87621..ab5e42a86cc5 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -79,7 +79,7 @@ struct media_device * __v4l2_mc_usb_media_device_init(struct usb_device *udev,
>  		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
>  	if (udev->serial)
>  		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
> -	strcpy(mdev->bus_info, udev->devpath);
> +	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
>  	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
>  	mdev->driver_version = LINUX_VERSION_CODE;
>  
> 

Please fold this in patch 02/11 and you can disregard my comment about
strcpy vs strlcpy.

Regards,

	Hans
