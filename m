Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61829 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3BCPvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:51:14 -0500
Received: by mail-pa0-f49.google.com with SMTP id kp6so863331pab.22
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:51:13 -0800 (PST)
Message-ID: <510F3F10.4000600@gmail.com>
Date: Sun, 03 Feb 2013 23:54:40 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 17/18] tlg2300: Remove logs() macro.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <31866c1c7df0f5f55ca0fcc422eb2bf2eec99cb8.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <31866c1c7df0f5f55ca0fcc422eb2bf2eec99cb8.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> ioctl debugging can now be done through the debug parameter in sysfs.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-common.h |    9 ---------
>  drivers/media/usb/tlg2300/pd-video.c  |   23 ++---------------------
>  2 files changed, 2 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
> index 3010496..9e23ad32 100644
> --- a/drivers/media/usb/tlg2300/pd-common.h
> +++ b/drivers/media/usb/tlg2300/pd-common.h
> @@ -268,13 +268,4 @@ void set_debug_mode(struct video_device *vfd, int debug_mode);
>  				log();\
>  		} while (0)
>  
> -#define logs(f) do { \
> -			if ((debug_mode & 0x4) && \
> -				(f)->type == V4L2_BUF_TYPE_VBI_CAPTURE) \
> -					log("type : VBI");\
> -								\
> -			if ((debug_mode & 0x8) && \
> -				(f)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) \
> -					log("type : VIDEO");\
> -		} while (0)
>  #endif
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 834428d..dab0ca3 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -120,9 +120,6 @@ static int vidioc_querycap(struct file *file, void *fh,
>  {
>  	struct video_device *vdev = video_devdata(file);
>  	struct poseidon *p = video_get_drvdata(vdev);
> -	struct front_face *front = fh;
> -
> -	logs(front);
>  
>  	strcpy(cap->driver, "tele-video");
>  	strcpy(cap->card, "Telegent Poseidon");
> @@ -205,7 +202,6 @@ static void submit_frame(struct front_face *front)
>   */
>  static void end_field(struct video_data *video)
>  {
> -	/* logs(video->front); */
>  	if (1 == video->field_count)
>  		submit_frame(video->front);
>  	else
> @@ -700,7 +696,6 @@ static int vidioc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  	struct front_face *front = fh;
>  	struct poseidon *pd = front->pd;
>  
> -	logs(front);
>  	f->fmt.pix = pd->video_data.context.pix;
>  	return 0;
>  }
> @@ -763,7 +758,6 @@ static int vidioc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  	struct front_face *front	= fh;
>  	struct poseidon *pd		= front->pd;
>  
> -	logs(front);
>  	/* stop VBI here */
>  	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != f->type)
>  		return -EINVAL;
> @@ -804,7 +798,6 @@ static int vidioc_g_fmt_vbi(struct file *file, void *fh,
>  		vbi_fmt->count[1] = V4L_PAL_VBI_LINES;
>  	}
>  	vbi_fmt->flags = V4L2_VBI_UNSYNC;
> -	logs(front);
>  	return 0;
>  }
>  
> @@ -856,22 +849,20 @@ out:
>  static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
>  {
>  	struct front_face *front = fh;
> -	logs(front);
> +
>  	return set_std(front->pd, norm);
>  }
>  
>  static int vidioc_g_std(struct file *file, void *fh, v4l2_std_id *norm)
>  {
>  	struct front_face *front = fh;
> -	logs(front);
> +
>  	*norm = front->pd->video_data.context.tvnormid;
>  	return 0;
>  }
>  
>  static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
>  {
> -	struct front_face *front = fh;
> -
>  	if (in->index >= POSEIDON_INPUTS)
>  		return -EINVAL;
>  	strcpy(in->name, pd_inputs[in->index].name);
> @@ -885,7 +876,6 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
>  	in->tuner	= 0;
>  	in->std		= V4L2_STD_ALL;
>  	in->status	= 0;
> -	logs(front);
>  	return 0;
>  }
>  
> @@ -895,7 +885,6 @@ static int vidioc_g_input(struct file *file, void *fh, unsigned int *i)
>  	struct poseidon *pd = front->pd;
>  	struct running_context *context = &pd->video_data.context;
>  
> -	logs(front);
>  	*i = context->sig_index;
>  	return 0;
>  }
> @@ -1023,7 +1012,6 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *tuner)
>  	tuner->rxsubchans = pd_audio_modes[index].v4l2_audio_sub;
>  	tuner->audmode = pd_audio_modes[index].v4l2_audio_mode;
>  	tuner->afc = 0;
> -	logs(front);
>  	return 0;
>  }
>  
> @@ -1051,7 +1039,6 @@ static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *a)
>  
>  	if (0 != a->index)
>  		return -EINVAL;
> -	logs(front);
>  	for (index = 0; index < POSEIDON_AUDIOMODS; index++)
>  		if (a->audmode == pd_audio_modes[index].v4l2_audio_mode)
>  			return pd_vidioc_s_tuner(pd, index);
> @@ -1099,7 +1086,6 @@ static int vidioc_s_frequency(struct file *file, void *fh,
>  
>  	if (freq->tuner)
>  		return -EINVAL;
> -	logs(front);
>  #ifdef CONFIG_PM
>  	pd->pm_suspend = pm_video_suspend;
>  	pd->pm_resume = pm_video_resume;
> @@ -1111,14 +1097,12 @@ static int vidioc_reqbufs(struct file *file, void *fh,
>  				struct v4l2_requestbuffers *b)
>  {
>  	struct front_face *front = file->private_data;
> -	logs(front);
>  	return videobuf_reqbufs(&front->q, b);
>  }
>  
>  static int vidioc_querybuf(struct file *file, void *fh, struct v4l2_buffer *b)
>  {
>  	struct front_face *front = file->private_data;
> -	logs(front);
>  	return videobuf_querybuf(&front->q, b);
>  }
>  
> @@ -1207,7 +1191,6 @@ static int vidioc_streamon(struct file *file, void *fh,
>  {
>  	struct front_face *front = fh;
>  
> -	logs(front);
>  	if (unlikely(type != front->type))
>  		return -EINVAL;
>  	return videobuf_streamon(&front->q);
> @@ -1218,7 +1201,6 @@ static int vidioc_streamoff(struct file *file, void *fh,
>  {
>  	struct front_face *front = file->private_data;
>  
> -	logs(front);
>  	if (unlikely(type != front->type))
>  		return -EINVAL;
>  	return videobuf_streamoff(&front->q);
> @@ -1416,7 +1398,6 @@ static int pd_video_release(struct file *file)
>  	struct poseidon *pd = front->pd;
>  	s32 cmd_status = 0;
>  
> -	logs(front);
>  	mutex_lock(&pd->lock);
>  
>  	if (front->type	== V4L2_BUF_TYPE_VIDEO_CAPTURE) {
Acked-by: Huang Shijie <shijie8@gmail.com>
