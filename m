Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41869 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbbGTNib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:38:31 -0400
Message-ID: <55ACF994.3010101@xs4all.nl>
Date: Mon, 20 Jul 2015 15:37:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/12/2015 06:46 PM, Ricardo Ribalda Delgado wrote:
> This ioctl returns the default value of one or more extended controls.
> It has the same interface as VIDIOC_EXT_CTRLS.
> 
> It is needed due to the fact that QUERYCTRL was not enough to
> provide the initial value of pointer type controls.

This was discussed on irc, and both Sakari and Laurent didn't like having to add
a new ioctl.

After some discussion I came up with an alternative and I'd like to have some
feedback on that.

The key change is in struct v4l2_ext_controls where the __u32 ctrl_class field
is changed to:

	union {
		__u32 ctrl_class;
		__u32 which;
	};

And two new defines are added:

#define V4L2_CTRL_WHICH_CUR_VAL        0
#define V4L2_CTRL_WHICH_DEF_VAL        0x0f000000

The 'which' field tells you which controls are get/set/tried.

V4L2_CTRL_WHICH_CUR_VAL: the current value of the controls
V4L2_CTRL_WHICH_DEF_VAL: the default value of the controls
V4L2_CTRL_CLASS_*: the current value of the controls belonging to the specified class.
	Note: this is deprecated usage and is only there for backwards compatibility.
	Which is also why I don't think there is a need to add V4L2_CTRL_WHICH_
	aliases for these defines.

And in the future, if the 'request' patch series for per-frame configuration is
merged, we can specify the request ID here to get/set/try the controls values
of the specified request ID.

This can also be extended to things like 'WHICH_MIN_VAL/MAX_VAL' if we want to.

An attempt to set/try controls for WHICH_DEF_VAL will return -EACCES since
the default value is a read-only value that you cannot change.

Renaming 'ctrl_class' to 'which' makes this something that can be documented
without looking like a hack and it avoids having to make a new ioctl.

Comments are welcome!

Regards,

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++++
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 21 +++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-subdev.c         |  3 +++
>  include/media/v4l2-ioctl.h                    |  2 ++
>  include/uapi/linux/videodev2.h                |  1 +
>  5 files changed, 31 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af635430524e..b7ab852b642f 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -817,6 +817,7 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
>  #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
>  #define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
>  #define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
> +#define VIDIOC_G_DEF_EXT_CTRLS32 _IOWR('V', 104, struct v4l2_ext_controls32)
>  
>  #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
>  #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
> @@ -858,6 +859,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_ENUMINPUT32: cmd = VIDIOC_ENUMINPUT; break;
>  	case VIDIOC_TRY_FMT32: cmd = VIDIOC_TRY_FMT; break;
>  	case VIDIOC_G_EXT_CTRLS32: cmd = VIDIOC_G_EXT_CTRLS; break;
> +	case VIDIOC_G_DEF_EXT_CTRLS32: cmd = VIDIOC_G_DEF_EXT_CTRLS; break;
>  	case VIDIOC_S_EXT_CTRLS32: cmd = VIDIOC_S_EXT_CTRLS; break;
>  	case VIDIOC_TRY_EXT_CTRLS32: cmd = VIDIOC_TRY_EXT_CTRLS; break;
>  	case VIDIOC_DQEVENT32: cmd = VIDIOC_DQEVENT; break;
> @@ -935,6 +937,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		break;
>  
>  	case VIDIOC_G_EXT_CTRLS:
> +	case VIDIOC_G_DEF_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
>  		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
> @@ -962,6 +965,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	   contain information on which control failed. */
>  	switch (cmd) {
>  	case VIDIOC_G_EXT_CTRLS:
> +	case VIDIOC_G_DEF_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
>  		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index a675ccc8f27a..5ed03b8588ec 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1991,6 +1991,25 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  					-EINVAL;
>  }
>  
> +static int v4l_g_def_ext_ctrls(const struct v4l2_ioctl_ops *ops,
> +				struct file *file, void *fh, void *arg)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct v4l2_ext_controls *p = arg;
> +	struct v4l2_fh *vfh =
> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
> +
> +	p->error_idx = p->count;
> +	if (vfh && vfh->ctrl_handler)
> +		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p, true);
> +	if (vfd->ctrl_handler)
> +		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p, true);
> +	if (ops->vidioc_g_def_ext_ctrls == NULL)
> +		return -ENOTTY;
> +	return check_ext_ctrls(p, 0) ?
> +		ops->vidioc_g_def_ext_ctrls(file, fh, p) : -EINVAL;
> +}
> +
>  static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> @@ -2435,6 +2454,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>  	IOCTL_INFO_FNC(VIDIOC_G_SLICED_VBI_CAP, v4l_g_sliced_vbi_cap, v4l_print_sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
>  	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
>  	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
> +	IOCTL_INFO_FNC(VIDIOC_G_DEF_EXT_CTRLS, v4l_g_def_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>  	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
>  	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>  	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
> @@ -2643,6 +2663,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>  
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_G_EXT_CTRLS:
> +	case VIDIOC_G_DEF_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS: {
>  		struct v4l2_ext_controls *ctrls = parg;
>  
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 90ed61e6df34..8d75620e4603 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -205,6 +205,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_G_EXT_CTRLS:
>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg, false);
>  
> +	case VIDIOC_G_DEF_EXT_CTRLS:
> +		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg, true);
> +
>  	case VIDIOC_S_EXT_CTRLS:
>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 8fbbd76d78e8..16d7eeec9ff6 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -160,6 +160,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_control *a);
>  	int (*vidioc_g_ext_ctrls)      (struct file *file, void *fh,
>  					struct v4l2_ext_controls *a);
> +	int (*vidioc_g_def_ext_ctrls)  (struct file *file, void *fh,
> +					struct v4l2_ext_controls *a);
>  	int (*vidioc_s_ext_ctrls)      (struct file *file, void *fh,
>  					struct v4l2_ext_controls *a);
>  	int (*vidioc_try_ext_ctrls)    (struct file *file, void *fh,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3d5fc72d53a7..b9468a3b833e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -2269,6 +2269,7 @@ struct v4l2_create_buffers {
>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>  
>  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> +#define VIDIOC_G_DEF_EXT_CTRLS	_IOWR('V', 104, struct v4l2_ext_controls)
>  
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> 

