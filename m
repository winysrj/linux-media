Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0GJOIb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 10:08:31 -0400
Message-ID: <4C387EEE.3000108@redhat.com>
Date: Sat, 10 Jul 2010 11:08:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v2 7/7] v4l: subdev: Generic ioctl support
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278689512-30849-8-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-07-2010 12:31, Laurent Pinchart escreveu:
> Instead of returning an error when receiving an ioctl call with an
> unsupported command, forward the call to the subdev core::ioctl handler.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |    5 +++++
>  drivers/media/video/v4l2-subdev.c            |    2 +-
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 89bd881..581e7db 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -365,6 +365,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
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
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 31bec67..ce47772 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -120,7 +120,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
>  
>  	default:
> -		return -ENOIOCTLCMD;
> +		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
>  	}
>  
>  	return 0;

Hmm... private ioctls at subdev... I'm not sure if I like this idea. I prefer to merge this patch
only after having a driver actually needing it, after discussing why not using a standard ioctl
for that driver.

Cheers,
Mauro.
