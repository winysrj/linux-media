Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:47728 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3BCPsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:48:39 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so2310175dak.25
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:48:39 -0800 (PST)
Message-ID: <510F3E6E.2060505@gmail.com>
Date: Sun, 03 Feb 2013 23:51:58 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 15/18] tlg2300: remove empty vidioc_try_fmt_vid_cap,
 add missing g_std.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <2e32299585af78c94bfb4c8df2d61d790935cefb.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <2e32299585af78c94bfb4c8df2d61d790935cefb.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-video.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 849c4bb..4c045b3 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -705,12 +705,6 @@ static int vidioc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  	return 0;
>  }
>  
> -static int vidioc_try_fmt(struct file *file, void *fh,
> -		struct v4l2_format *f)
> -{
> -	return 0;
> -}
> -
>  /*
>   * VLC calls VIDIOC_S_STD before VIDIOC_S_FMT, while
>   * Mplayer calls them in the reverse order.
> @@ -866,6 +860,14 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
>  	return set_std(front->pd, norm);
>  }
>  
> +static int vidioc_g_std(struct file *file, void *fh, v4l2_std_id *norm)
> +{
> +	struct front_face *front = fh;
> +	logs(front);
> +	*norm = front->pd->video_data.context.tvnormid;
> +	return 0;
> +}
> +
>  static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
>  {
>  	struct front_face *front = fh;
> @@ -1495,7 +1497,6 @@ static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
>  	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt,
>  	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt,
>  	.vidioc_g_fmt_vbi_cap	= vidioc_g_fmt_vbi, /* VBI */
> -	.vidioc_try_fmt_vid_cap = vidioc_try_fmt,
>  
>  	/* Input */
>  	.vidioc_g_input		= vidioc_g_input,
> @@ -1510,6 +1511,7 @@ static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
>  	/* Tuner ioctls */
>  	.vidioc_g_tuner		= vidioc_g_tuner,
>  	.vidioc_s_tuner		= vidioc_s_tuner,
> +	.vidioc_g_std		= vidioc_g_std,
>  	.vidioc_s_std		= vidioc_s_std,
>  	.vidioc_g_frequency	= vidioc_g_frequency,
>  	.vidioc_s_frequency	= vidioc_s_frequency,
Acked-by: Huang Shijie <shijie8@gmail.com>
