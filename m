Return-path: <linux-media-owner@vger.kernel.org>
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:58585 "EHLO
        6.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933070AbcLNWfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 17:35:04 -0500
Received: from player797.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 42E1B6944C
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 17:37:29 +0100 (CET)
Subject: Re: [PATCH] v4l: vsp1: Add VIDIOC_EXPBUF support
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <1481539062-23179-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org
From: "jacopo@jmondi.org" <jacopo@jmondi.org>
Message-ID: <6b290217-aa29-cf12-df1d-9efe9901f057@jmondi.org>
Date: Wed, 14 Dec 2016 17:37:26 +0100
MIME-Version: 1.0
In-Reply-To: <1481539062-23179-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
   Yes, thanks you, I'm now able to use that ioctl and export dmabuf 
file descriptors

On 12/12/2016 11:37, Laurent Pinchart wrote:
> Use the vb2 ioctl handler directly.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Tested-by: Jacopo Mondi <jacopo@jmondi.org>

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 1 +
>  1 file changed, 1 insertion(+)
>
> Jacopo,
>
> Does this fix your issue ?
>
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index fd3acf1a98a6..0113a55b19c9 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1021,6 +1021,7 @@ static const struct v4l2_ioctl_ops vsp1_video_ioctl_ops = {
>  	.vidioc_querybuf		= vb2_ioctl_querybuf,
>  	.vidioc_qbuf			= vb2_ioctl_qbuf,
>  	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>  	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>  	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
>  	.vidioc_streamon		= vsp1_video_streamon,
>

