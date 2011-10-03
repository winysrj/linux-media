Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:50339 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JCUdy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Oct 2011 16:33:54 -0400
Date: Mon, 3 Oct 2011 15:28:49 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] pvrusb2: implement VIDIOC_QUERYSTD
In-Reply-To: <1317667657-4081-2-git-send-email-mchehab@redhat.com>
Message-ID: <alpine.DEB.1.10.1110031528260.11111@cnc.isely.net>
References: <1317667657-4081-1-git-send-email-mchehab@redhat.com> <1317667657-4081-2-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-By: Mike Isely <isely@pobox.com>

  -Mike

On Mon, 3 Oct 2011, Mauro Carvalho Chehab wrote:

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    7 +++++++
>  drivers/media/video/pvrusb2/pvrusb2-hdw.h  |    3 +++
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    7 +++++++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index e98d382..5a6f24d 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -2993,6 +2993,13 @@ static void pvr2_subdev_set_control(struct pvr2_hdw *hdw, int id,
>  		pvr2_subdev_set_control(hdw, id, #lab, (hdw)->lab##_val); \
>  	}
>  
> +int pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw, v4l2_std_id *std)
> +{
> +	v4l2_device_call_all(&hdw->v4l2_dev, 0,
> +			     video, querystd, std);
> +	return 0;
> +}
> +
>  /* Execute whatever commands are required to update the state of all the
>     sub-devices so that they match our current control values. */
>  static void pvr2_subdev_update(struct pvr2_hdw *hdw)
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.h b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> index d7753ae..6654658 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.h
> @@ -214,6 +214,9 @@ struct pvr2_stream *pvr2_hdw_get_video_stream(struct pvr2_hdw *);
>  int pvr2_hdw_get_stdenum_value(struct pvr2_hdw *hdw,struct v4l2_standard *std,
>  			       unsigned int idx);
>  
> +/* Get the detected video standard */
> +int pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw, v4l2_std_id *std);
> +
>  /* Enable / disable retrieval of CPU firmware or prom contents.  This must
>     be enabled before pvr2_hdw_cpufw_get() will function.  Note that doing
>     this may prevent the device from running (and leaving this mode may
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index e27f8ab..0d029da 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -227,6 +227,13 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		break;
>  	}
>  
> +	case VIDIOC_QUERYSTD:
> +	{
> +		v4l2_std_id *std = arg;
> +		ret = pvr2_hdw_get_detected_std(hdw, std);
> +		break;
> +	}
> +
>  	case VIDIOC_G_STD:
>  	{
>  		int val = 0;
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
