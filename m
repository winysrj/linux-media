Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51512 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751098AbdHNTyG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 15:54:06 -0400
Date: Mon, 14 Aug 2017 22:54:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-compat-ioctl32.c: make ctrl_is_pointer generic
Message-ID: <20170814195402.rqetxrafcd5g43ud@valkosipuli.retiisi.org.uk>
References: <3814fe88-647e-dc2d-2b5f-fcb1c925228b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3814fe88-647e-dc2d-2b5f-fcb1c925228b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Aug 11, 2017 at 03:26:03PM +0200, Hans Verkuil wrote:
> The ctrl_is_pointer used a hard-coded list of control IDs that besides being
> outdated also wouldn't work for custom driver controls.
> 
> Replaced by calling queryctrl and checking if the V4L2_CTRL_FLAG_HAS_PAYLOAD
> flag was set.

I think the approach is good, this scales much better.

Considering that running a 32-bit user space on a 64-bit kernel is an
entirely possible production setup, I'm worried of the overhead that this
brings to accessing controls.

How about just looking up the control and then checking ctrl->is_ptr?
Wouldn't it yield the same result?

> 
> Note that get_v4l2_ext_controls32() will set the v4l2_ext_control 'size' field
> to 0 if the control has no payload before passing it to the kernel. This
> helps in put_v4l2_ext_controls32() since that function can just look at the
> 'size' field instead of having to call queryctrl again. The reason we set
> 'size' explicitly for non-pointer controls is that 'size' is ignored by the
> kernel in that case. That makes 'size' useless as an indicator of a pointer
> type in the put function since it can be any value. But setting it to 0 here
> turns it into a useful indicator.
> 
> Also added proper checks for the compat_alloc_user_space return value which
> can be NULL, this was never done for some reason.
> 
> Tested with a 32-bit build of v4l2-ctl and the vivid driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af8b4c5b0efa..a16338cc216e 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -17,7 +17,9 @@
>  #include <linux/module.h>
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
>  #include <media/v4l2-ioctl.h>
> 
>  static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> @@ -67,6 +69,8 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
>  			return -EFAULT;
>  		uclips = compat_ptr(p);
>  		kclips = compat_alloc_user_space(n * sizeof(struct v4l2_clip));
> +		if (kclips == NULL)
> +			return -EFAULT;
>  		kp->clips = kclips;
>  		while (--n >= 0) {
>  			if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
> @@ -473,6 +477,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		 * by passing a very big num_planes value */
>  		uplane = compat_alloc_user_space(kp->length *
>  						 sizeof(struct v4l2_plane));
> +		if (uplane == NULL)
> +			return -EFAULT;
>  		kp->m.planes = (__force struct v4l2_plane *)uplane;
> 
>  		for (num_planes = 0; num_planes < kp->length; num_planes++) {
> @@ -668,24 +674,38 @@ struct v4l2_ext_control32 {
>  	};
>  } __attribute__ ((packed));
> 
> -/* The following function really belong in v4l2-common, but that causes
> -   a circular dependency between modules. We need to think about this, but
> -   for now this will do. */
> 
> -/* Return non-zero if this control is a pointer type. Currently only
> -   type STRING is a pointer type. */
> -static inline int ctrl_is_pointer(u32 id)
> +/* Return non-zero if this control is a pointer type. */
> +static inline int ctrl_is_pointer(struct file *file, u32 id)
>  {
> -	switch (id) {
> -	case V4L2_CID_RDS_TX_PS_NAME:
> -	case V4L2_CID_RDS_TX_RADIO_TEXT:
> -		return 1;
> -	default:
> +	struct video_device *vfd = video_devdata(file);
> +	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
> +	void *fh = file->private_data;
> +	struct v4l2_fh *vfh =
> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
> +	struct v4l2_queryctrl qctrl = { id };
> +	int err;
> +
> +	if (!test_bit(_IOC_NR(VIDIOC_QUERYCTRL), vfd->valid_ioctls))
> +		err = -ENOTTY;
> +	else if (vfh && vfh->ctrl_handler)
> +		err = v4l2_queryctrl(vfh->ctrl_handler, &qctrl);
> +	else if (vfd->ctrl_handler)
> +		err = v4l2_queryctrl(vfd->ctrl_handler, &qctrl);
> +	else if (ops->vidioc_queryctrl)
> +		err = ops->vidioc_queryctrl(file, fh, &qctrl);
> +	else
> +		err = -ENOTTY;
> +
> +	if (err)
>  		return 0;
> -	}
> +
> +	return qctrl.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD;
>  }
> 
> -static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
> +static int get_v4l2_ext_controls32(struct file *file,
> +				   struct v4l2_ext_controls *kp,
> +				   struct v4l2_ext_controls32 __user *up)
>  {
>  	struct v4l2_ext_control32 __user *ucontrols;
>  	struct v4l2_ext_control __user *kcontrols;
> @@ -713,15 +733,28 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
>  		return -EFAULT;
>  	kcontrols = compat_alloc_user_space(kp->count *
>  					    sizeof(struct v4l2_ext_control));
> +	if (kcontrols == NULL)
> +		return -EFAULT;
>  	kp->controls = (__force struct v4l2_ext_control *)kcontrols;
>  	for (n = 0; n < kp->count; n++) {
>  		u32 id;
> +		int ret;
> 
>  		if (copy_in_user(kcontrols, ucontrols, sizeof(*ucontrols)))
>  			return -EFAULT;
>  		if (get_user(id, &kcontrols->id))
>  			return -EFAULT;
> -		if (ctrl_is_pointer(id)) {
> +		ret = ctrl_is_pointer(file, id);
> +		if (ret < 0)
> +			return ret;
> +		/*
> +		 * Convert the pointer if this is a pointer control.
> +		 * Otherwise set kcontrols->size to 0 as an additional
> +		 * safety measure. This also allows us to reliably use
> +		 * kcontrols->size as an indicator of a pointer control
> +		 * in put_v4l2_ext_controls32().
> +		 */
> +		if (ret) {
>  			void __user *s;
> 
>  			if (get_user(p, &ucontrols->string))
> @@ -729,6 +762,8 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
>  			s = compat_ptr(p);
>  			if (put_user(s, &kcontrols->string))
>  				return -EFAULT;
> +		} else if (put_user(0, &kcontrols->size)) {
> +			return -EFAULT;
>  		}
>  		ucontrols++;
>  		kcontrols++;
> @@ -762,14 +797,12 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
> 
>  	while (--n >= 0) {
>  		unsigned size = sizeof(*ucontrols);
> -		u32 id;
> +		u32 payload_size;
> 
> -		if (get_user(id, &kcontrols->id))
> +		if (get_user(payload_size, &kcontrols->size))
>  			return -EFAULT;
> -		/* Do not modify the pointer when copying a pointer control.
> -		   The contents of the pointer was changed, not the pointer
> -		   itself. */
> -		if (ctrl_is_pointer(id))
> +		/* If payload_size != 0, then this is a pointer control */
> +		if (payload_size)
>  			size -= sizeof(ucontrols->value64);
>  		if (copy_in_user(ucontrols, kcontrols, size))
>  			return -EFAULT;
> @@ -983,7 +1016,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_G_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
> -		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
> +		err = get_v4l2_ext_controls32(file, &karg.v2ecs, up);
>  		compatible_arg = 0;
>  		break;
>  	case VIDIOC_DQEVENT:

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
