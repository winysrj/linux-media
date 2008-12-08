Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8IYwIQ021708
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:34:58 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8IY6vc007642
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:34:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Mon, 8 Dec 2008 19:33:55 +0100
References: <1228759826-11929-1-git-send-email-jsagarribay@gmail.com>
In-Reply-To: <1228759826-11929-1-git-send-email-jsagarribay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081933.55462.hverkuil@xs4all.nl>
Cc: mchehab@infradead.org
Subject: Re: [PATCH] stkwebcam: Implement VIDIOC_ENUM_FRAMESIZES ioctl
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Monday 08 December 2008 19:10:26 Jaime Velasco Juan wrote:
> It is used at least by gstreamer.

Thanks Jaime!

But can you redo this against the v4l-dvb repository? 
(www.linuxtv.org/hg/v4l-dvb)

That already contains a proper v4l2_ioctl_ops function for this 
enum_framesizes ioctl. That way you do not need to use vidioc_default.

Thanks,

	Hans

> Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
> ---
>  drivers/media/video/stk-webcam.c |   29
> +++++++++++++++++++++++++++++ 1 files changed, 29 insertions(+), 0
> deletions(-)
>
> diff --git a/drivers/media/video/stk-webcam.c
> b/drivers/media/video/stk-webcam.c index e9eb6d7..4afa82f 100644
> --- a/drivers/media/video/stk-webcam.c
> +++ b/drivers/media/video/stk-webcam.c
> @@ -1262,6 +1262,34 @@ static int stk_vidioc_g_parm(struct file
> *filp, return 0;
>  }
>
> +static int stk_vidioc_enum_framesizes(struct file *filp,
> +		void *priv, struct v4l2_frmsizeenum *frms)
> +{
> +	if (frms->index >= ARRAY_SIZE(stk_sizes))
> +		return -EINVAL;
> +	switch (frms->pixel_format) {
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_RGB565X:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_SBGGR8:
> +		frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +		frms->discrete.width = stk_sizes[frms->index].w;
> +		frms->discrete.height = stk_sizes[frms->index].h;
> +		return 0;
> +	default: return -EINVAL;
> +	}
> +}
> +
> +static int stk_vidioc_default(struct file *filp,
> +		void *priv, int cmd, void *arg)
> +{
> +	if (cmd == (int)VIDIOC_ENUM_FRAMESIZES)
> +		return stk_vidioc_enum_framesizes(filp, priv,
> +				(struct v4l2_frmsizeenum *) arg);
> +	return -EINVAL;
> +}
> +
>  static struct file_operations v4l_stk_fops = {
>  	.owner = THIS_MODULE,
>  	.open = v4l_stk_open,
> @@ -1296,6 +1324,7 @@ static const struct v4l2_ioctl_ops
> v4l_stk_ioctl_ops = { .vidioc_g_ctrl = stk_vidioc_g_ctrl,
>  	.vidioc_s_ctrl = stk_vidioc_s_ctrl,
>  	.vidioc_g_parm = stk_vidioc_g_parm,
> +	.vidioc_default = stk_vidioc_default,
>  };
>
>  static void stk_v4l_dev_release(struct video_device *vd)



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
