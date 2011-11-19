Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1KSTTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Nov 2011 14:19:51 -0500
Message-ID: <4EC80176.5000802@redhat.com>
Date: Sat, 19 Nov 2011 20:20:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ezequiel <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org, moinejf@free.fr
Subject: Re: [PATCH] [media] gspca: replaced static allocation by video_device_alloc/video_device_release
References: <20111119185015.GA3048@localhost>
In-Reply-To: <20111119185015.GA3048@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/19/2011 07:50 PM, Ezequiel wrote:
> Pushed video_device initialization into a separate function.
> Replaced static allocation of struct video_device by
> video_device_alloc/video_device_release usage.

NACK! I see a video_device_release call here, but not a
video_device_alloc, also you're messing with quite sensitive code
here (because a usb device can be unplugged at any time, including
when the /dev/video node is open by a process), and changing it
from static to dynamic allocation my have more consequences
then you see at first (I did not analyze all the code paths
for the proposed change, since the last time I audited them for
the current static allocation of the videodevice struct code took
me hours).

Also static allocation (as part of the driver struct) in general is
better then dynamic as it needs less code and helps avoiding memory
fragmentation.

All in all I cannot help but feel that you're diving into a piece
of code with some drive by shooting style patch without knowing
the code in question at all, please don't do that!

Regards,

Hans



>
> Signed-off-by: Ezequiel Garcia<elezegarcia@gmail.com>
> ---
>
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> index 881e04c..1f27f05 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -1292,10 +1292,12 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
>
>   static void gspca_release(struct video_device *vfd)
>   {
> -	struct gspca_dev *gspca_dev = container_of(vfd, struct gspca_dev, vdev);
> +	struct gspca_dev *gspca_dev = video_get_drvdata(vfd);
>
>   	PDEBUG(D_PROBE, "%s released",
> -		video_device_node_name(&gspca_dev->vdev));
> +		video_device_node_name(gspca_dev->vdev));
> +
> +	video_device_release(vfd);
>
>   	kfree(gspca_dev->usb_buf);
>   	kfree(gspca_dev);
> @@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
>   static int dev_open(struct file *file)
>   {
>   	struct gspca_dev *gspca_dev;
> +	struct video_device *vdev;
>
>   	PDEBUG(D_STREAM, "[%s] open", current->comm);
> -	gspca_dev = (struct gspca_dev *) video_devdata(file);
> +	vdev = video_devdata(file);
> +	gspca_dev = video_get_drvdata(vdev);
>   	if (!gspca_dev->present)
>   		return -ENODEV;
>
> @@ -1318,10 +1322,10 @@ static int dev_open(struct file *file)
>   #ifdef GSPCA_DEBUG
>   	/* activate the v4l2 debug */
>   	if (gspca_debug&  D_V4L2)
> -		gspca_dev->vdev.debug |= V4L2_DEBUG_IOCTL
> +		gspca_dev->vdev->debug |= V4L2_DEBUG_IOCTL
>   					| V4L2_DEBUG_IOCTL_ARG;
>   	else
> -		gspca_dev->vdev.debug&= ~(V4L2_DEBUG_IOCTL
> +		gspca_dev->vdev->debug&= ~(V4L2_DEBUG_IOCTL
>   					| V4L2_DEBUG_IOCTL_ARG);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
