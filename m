Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:38635 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754535AbdHYJxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:53:18 -0400
Message-ID: <1503654425.6909.16.camel@v3.sk>
Subject: Re: [PATCH 3/3] media: add V4L2_CAP_VDEV_CENTERED flag on
 vdev-centric drivers
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 25 Aug 2017 11:47:05 +0200
In-Reply-To: <e0dfe1dc52d5c91bc75ffdb011a6714494409761.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
         <e0dfe1dc52d5c91bc75ffdb011a6714494409761.1503653839.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-08-25 at 06:40 -0300, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Those devices are controlled via their V4L2 device. Add a
> flag to indicate them as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

for the usbtv driver.

> ---
>  drivers/media/usb/usbtv/usbtv-video.c          |  2 +-

> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 8135614f395a..724dbcb8de9b 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -520,7 +520,7 @@ static int usbtv_querycap(struct file *file, void *priv,
>  	strlcpy(cap->driver, "usbtv", sizeof(cap->driver));
>  	strlcpy(cap->card, "usbtv", sizeof(cap->card));
>  	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VDEV_CENTERED;
>  	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	return 0;
> 
