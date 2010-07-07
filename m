Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3706 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0GGMin (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:38:43 -0400
Message-ID: <690d11b2397d9a97dee2a2bd29bee1af.squirrel@webmail.xs4all.nl>
In-Reply-To: <1278503608-9126-7-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1278503608-9126-7-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 7 Jul 2010 14:38:39 +0200
Subject: Re: [RFC/PATCH 6/6] v4l: subdev: Generic ioctl support
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Instead of returning an error when receiving an ioctl call with an
> unsupported command, forward the call to the subdev core::ioctl handler.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |    5 +++++
>  drivers/media/video/v4l2-subdev.c            |    2 +-
>  2 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/video4linux/v4l2-framework.txt
> b/Documentation/video4linux/v4l2-framework.txt
> index 2f5162c..3a1d6b3 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -355,6 +355,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
>  	To properly support events, the poll() file operation is also
>  	implemented.
>
> +Private ioctls
> +
> +	All ioctls not in the above list are passed directly to the sub-device
> +	driver through the core::ioctl operation.
> +
>
>  I2C sub-device drivers
>  ----------------------
> diff --git a/drivers/media/video/v4l2-subdev.c
> b/drivers/media/video/v4l2-subdev.c
> index 7191a4b..c32b2c4 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
>  		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
>
>  	default:
> -		return -ENOIOCTLCMD;
> +		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
>  	}
>
>  	return 0;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Nice to see how everything fits together :-)

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

