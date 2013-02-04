Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40597 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3BCPjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:39:46 -0500
Received: by mail-pb0-f43.google.com with SMTP id jt11so2808468pbb.30
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:39:45 -0800 (PST)
Message-ID: <510F3C67.8020604@gmail.com>
Date: Sun, 03 Feb 2013 23:43:19 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 11/18] tlg2300: fix querycap
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <1e895ca6d25da9d6af707d661eefcf73d215d569.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1e895ca6d25da9d6af707d661eefcf73d215d569.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-video.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 312809a..8ab2894 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -142,17 +142,23 @@ static int get_audio_std(v4l2_std_id v4l2_std)
>  static int vidioc_querycap(struct file *file, void *fh,
>  			struct v4l2_capability *cap)
>  {
> +	struct video_device *vdev = video_devdata(file);
> +	struct poseidon *p = video_get_drvdata(vdev);
>  	struct front_face *front = fh;
> -	struct poseidon *p = front->pd;
>  
>  	logs(front);
>  
>  	strcpy(cap->driver, "tele-video");
>  	strcpy(cap->card, "Telegent Poseidon");
>  	usb_make_path(p->udev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
> -				V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
> -				V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
> +	cap->device_caps = V4L2_CAP_TUNER | V4L2_CAP_AUDIO |
> +			V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> +	if (vdev->vfl_type == VFL_TYPE_VBI)
> +		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
> +	else
> +		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
> +		V4L2_CAP_RADIO | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE;
>  	return 0;
>  }
>  
Acked-by: Huang Shijie <shijie8@gmail.com>
