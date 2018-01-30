Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45417 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbeA3OgA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 09:36:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 09/13] v4l2-compat-ioctl32.c: fix ctrl_is_pointer
Date: Tue, 30 Jan 2018 16:36:16 +0200
Message-ID: <1760924.PskEPEVaW2@avalon>
In-Reply-To: <20180130102701.13664-10-hverkuil@xs4all.nl>
References: <20180130102701.13664-1-hverkuil@xs4all.nl> <20180130102701.13664-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 30 January 2018 12:26:57 EET Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> ctrl_is_pointer just hardcoded two known string controls, but that
> caused problems when using e.g. custom controls that use a pointer
> for the payload.
> 
> Reimplement this function: it now finds the v4l2_ctrl (if the driver
> uses the control framework) or it calls vidioc_query_ext_ctrl (if the
> driver implements that directly).
> 
> In both cases it can now check if the control is a pointer control
> or not.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: <stable@vger.kernel.org>      # for v4.15 and up
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 57 ++++++++++++++++-------
>  1 file changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> 7dff9b4aeb19..30c5be1f0549 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -18,6 +18,8 @@
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-subdev.h>
>  #include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-ioctl.h>
> 
>  static long native_ioctl(struct file *file, unsigned int cmd, unsigned long
> arg) @@ -601,24 +603,39 @@ struct v4l2_ext_control32 {
>  	};
>  } __attribute__ ((packed));
> 
> -/* The following function really belong in v4l2-common, but that causes
> -   a circular dependency between modules. We need to think about this, but
> -   for now this will do. */
> -
> -/* Return non-zero if this control is a pointer type. Currently only
> -   type STRING is a pointer type. */
> -static inline int ctrl_is_pointer(u32 id)
> +/* Return true if this control is a pointer type. */
> +static inline bool ctrl_is_pointer(struct file *file, u32 id)
>  {
> -	switch (id) {
> -	case V4L2_CID_RDS_TX_PS_NAME:
> -	case V4L2_CID_RDS_TX_RADIO_TEXT:
> -		return 1;
> -	default:
> -		return 0;
> +	struct video_device *vdev = video_devdata(file);
> +	struct v4l2_fh *fh = NULL;
> +	struct v4l2_ctrl_handler *hdl = NULL;
> +	struct v4l2_query_ext_ctrl qec = { id };
> +	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
> +
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags))
> +		fh = file->private_data;
> +
> +	if (fh && fh->ctrl_handler)
> +		hdl = fh->ctrl_handler;
> +	else if (vdev->ctrl_handler)
> +		hdl = vdev->ctrl_handler;
> +
> +	if (hdl) {
> +		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, id);
> +
> +		return ctrl && ctrl->is_ptr;
>  	}
> +
> +	if (!ops->vidioc_query_ext_ctrl)
> +		return false;
> +
> +	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&
> +		(qec.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD);

Don't the subdev control ioctls go through this code path as well ? Unless I'm 
mistaken neither ctrl_handler nor ioctl_ops will be set for the video_device 
used to implement the subdev device node, so this will crash.

>  }
> 
> -static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct
> v4l2_ext_controls32 __user *up) +static int get_v4l2_ext_controls32(struct
> file *file,
> +				   struct v4l2_ext_controls *kp,
> +				   struct v4l2_ext_controls32 __user *up)
>  {
>  	struct v4l2_ext_control32 __user *ucontrols;
>  	struct v4l2_ext_control __user *kcontrols;
> @@ -651,7 +668,7 @@ static int get_v4l2_ext_controls32(struct
> v4l2_ext_controls *kp, struct v4l2_ext return -EFAULT;
>  		if (get_user(id, &kcontrols->id))
>  			return -EFAULT;
> -		if (ctrl_is_pointer(id)) {
> +		if (ctrl_is_pointer(file, id)) {
>  			void __user *s;
> 
>  			if (get_user(p, &ucontrols->string))
> @@ -666,7 +683,9 @@ static int get_v4l2_ext_controls32(struct
> v4l2_ext_controls *kp, struct v4l2_ext return 0;
>  }
> 
> -static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct
> v4l2_ext_controls32 __user *up) +static int put_v4l2_ext_controls32(struct
> file *file,
> +				   struct v4l2_ext_controls *kp,
> +				   struct v4l2_ext_controls32 __user *up)
>  {
>  	struct v4l2_ext_control32 __user *ucontrols;
>  	struct v4l2_ext_control __user *kcontrols =
> @@ -698,7 +717,7 @@ static int put_v4l2_ext_controls32(struct
> v4l2_ext_controls *kp, struct v4l2_ext /* Do not modify the pointer when
> copying a pointer control.
>  		   The contents of the pointer was changed, not the pointer
>  		   itself. */
> -		if (ctrl_is_pointer(id))
> +		if (ctrl_is_pointer(file, id))
>  			size -= sizeof(ucontrols->value64);
>  		if (copy_in_user(ucontrols, kcontrols, size))
>  			return -EFAULT;
> @@ -912,7 +931,7 @@ static long do_video_ioctl(struct file *file, unsigned
> int cmd, unsigned long ar case VIDIOC_G_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
> -		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
> +		err = get_v4l2_ext_controls32(file, &karg.v2ecs, up);
>  		compatible_arg = 0;
>  		break;
>  	case VIDIOC_DQEVENT:
> @@ -939,7 +958,7 @@ static long do_video_ioctl(struct file *file, unsigned
> int cmd, unsigned long ar case VIDIOC_G_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
> -		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
> +		if (put_v4l2_ext_controls32(file, &karg.v2ecs, up))
>  			err = -EFAULT;
>  		break;
>  	case VIDIOC_S_EDID:


-- 
Regards,

Laurent Pinchart
