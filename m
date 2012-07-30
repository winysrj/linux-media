Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2G3B0C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jul 2012 21:26:02 -0400
Message-ID: <5015E2A6.4020809@redhat.com>
Date: Sun, 29 Jul 2012 22:25:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] Fix VIDIOC_TRY_EXT_CTRLS regression
References: <201207181534.59499.hverkuil@xs4all.nl>
In-Reply-To: <201207181534.59499.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-07-2012 10:34, Hans Verkuil escreveu:
> Hi all,
> 
> This patch fixes an omission in the new v4l2_ioctls table: VIDIOC_TRY_EXT_CTRLS
> must get the INFO_FL_CTRL flag, just like all the other control related ioctls.
> 
> Otherwise the ioctl core won't know it also has to check whether v4l2_fh->ctrl_handler
> is non-zero before it can decide that this ioctl is not implemented.
> 
> Caught by v4l2-compliance while I was testing the mem2mem_testdev driver.

Missing SOB. It seems Steven asked for this fix. Did he test? If so, it would be
nice to get his tested-by:.

Regards,
Mauro
> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 70e0efb..17dff31 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1900,7 +1900,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>   	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
>   	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>   	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
> -	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, 0),
> +	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>   	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
>   	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals, v4l_print_frmivalenum, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
>   	IOCTL_INFO_STD(VIDIOC_G_ENC_INDEX, vidioc_g_enc_index, v4l_print_enc_idx, 0),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

