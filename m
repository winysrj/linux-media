Return-Path: <hverkuil@xs4all.nl>
Message-id: <557A9A39.8090004@xs4all.nl>
Date: Fri, 12 Jun 2015 10:37:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [RFC] media: New ioct VIDIOC_INITIAL_EXT_CTRLS
References: <1433935073-24104-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1433935073-24104-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo!

On 06/10/2015 01:17 PM, Ricardo Ribalda Delgado wrote:
> Integer controls provide a way to get their default/initial value, but
> any other control (p_u32, p_u8.....) provide no other way to get the
> initial value than unloading the module and loading it back.
> 
> *What is the actual problem?
> I have a custom control with WIDTH integer values. Every value
> represents the calibrated FPN (fixed pattern noise) correction value for that column
> -Application A changes the FPN correction value
> -Application B wants to restore the calibrated value but it cant :(
> 
> *What is the proposed solution?
> -Add a new ioctl VIDIOC_INITIAL_EXT_CTRLS, with the same API as
> G_EXT_CTRLS, but that returns the initial value of a given control
> 
> *This code is not splited in different patches and there is no doc!
> Yes, at this point I want your feedback about the ioctl, and an initial
> piece of code could help the disscussion. Of course, once we agreed I
> will provide the documentation and a properly build patchset.
> 
> So, shoot me: What do you think?

Thanks for this RFC. I do have a few suggestions to improve this, but I agree
with the basic design.

> 
> THANKS!
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 ++
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 65 ++++++++++++++++++++++++---
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 20 +++++++++
>  drivers/media/v4l2-core/v4l2-subdev.c         |  3 ++
>  include/media/v4l2-ctrls.h                    |  2 +
>  include/media/v4l2-ioctl.h                    |  2 +
>  include/uapi/linux/videodev2.h                |  4 +-
>  7 files changed, 92 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index af635430524e..1e3272e28b2d 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -817,6 +817,7 @@ static int put_v4l2_edid32(struct v4l2_edid *kp, struct v4l2_edid32 __user *up)
>  #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
>  #define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
>  #define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
> +#define VIDIOC_INITIAL_EXT_CTRLS32    _IOWR('V', 104, struct v4l2_ext_controls32)
>  
>  #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
>  #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
> @@ -859,6 +860,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_TRY_FMT32: cmd = VIDIOC_TRY_FMT; break;
>  	case VIDIOC_G_EXT_CTRLS32: cmd = VIDIOC_G_EXT_CTRLS; break;
>  	case VIDIOC_S_EXT_CTRLS32: cmd = VIDIOC_S_EXT_CTRLS; break;
> +	case VIDIOC_INITIAL_EXT_CTRLS32: cmd = VIDIOC_INITIAL_EXT_CTRLS; break;
>  	case VIDIOC_TRY_EXT_CTRLS32: cmd = VIDIOC_TRY_EXT_CTRLS; break;
>  	case VIDIOC_DQEVENT32: cmd = VIDIOC_DQEVENT; break;
>  	case VIDIOC_OVERLAY32: cmd = VIDIOC_OVERLAY; break;
> @@ -937,6 +939,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_G_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
> +	case VIDIOC_INITIAL_EXT_CTRLS:
>  		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
>  		compatible_arg = 0;
>  		break;
> @@ -964,6 +967,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_G_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_TRY_EXT_CTRLS:
> +	case VIDIOC_INITIAL_EXT_CTRLS:

I'd call it VIDIOC_G_DEF_EXT_CTRLS. Since the default value is called default_value in QUERYCTRL,
I think it is more consistent to refer to the default value rather than the initial value.
And _G_ shows that you get this value.

>  		if (put_v4l2_ext_controls32(&karg.v2ecs, up))
>  			err = -EFAULT;
>  		break;
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b462165a7f0c..465f73acc644 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1449,6 +1449,40 @@ static const struct v4l2_ctrl_type_ops std_type_ops = {
>  	.validate = std_validate,
>  };
>  
> +/* Helper function: copy the initial value back to the caller */
> +static int init_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
> +{
> +	int idx;
> +	int ret;
> +	long size;
> +	union v4l2_ctrl_ptr ptr;
> +
> +	if (!ctrl->is_ptr){

Space before {

> +		ptr.p = &c->value;
> +		ctrl->type_ops->init(ctrl, 0, ptr);
> +		return 0;
> +	}
> +
> +	size = ctrl->elem_size * ctrl->elems;
> +	if (c->size < size){

Ditto

> +		c->size = size;
> +		return -ENOSPC;
> +	}
> +
> +	ptr.p = kzalloc(size, GFP_KERNEL);
> +	if (!ptr.p)
> +		return -ENOMEM;
> +
> +	for (idx=0; idx<ctrl->elems; idx++)

spaces around - and <

> +		ctrl->type_ops->init(ctrl, idx, ptr);
> +
> +	ret = copy_to_user(c->ptr, ptr.p, size);
> +
> +	kfree(ptr.p);
> +
> +	return ret ? -EFAULT : 0;
> +}

This isn't quite right. First of all string types are pointers but are still handled by
the init(ctrl, 0, ptr) function (i.e. idx is 0, not the index of the character).

And secondly this can be simplified a lot by using ctrl->p_new: this has already been
allocated with the right size and is unused for a get operation, so it can be safely
used without having to allocate memory.

I think this is sufficient (untested!):

static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
{
	int idx;

	for (idx = 0; idx < ctrl->elems; idx++)
		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
	return ptr_to_user(c, ctrl, ctrl->p_new);
}

> +
>  /* Helper function: copy the given control value back to the caller */
>  static int ptr_to_user(struct v4l2_ext_control *c,
>  		       struct v4l2_ctrl *ctrl,
> @@ -2806,10 +2840,10 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
>  	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
>  }
>  
> -
> -
>  /* Get extended controls. Allocates the helpers array if needed. */
> -int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
> +static int v4l2_g_ext_ctrls_initial(struct v4l2_ctrl_handler *hdl,

I wouldn't rename this function. Adding the bool is enough.

> +				    struct v4l2_ext_controls *cs,
> +				    bool initial_value)
>  {
>  	struct v4l2_ctrl_helper helper[4];
>  	struct v4l2_ctrl_helper *helpers = helper;
> @@ -2840,10 +2874,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  			ret = -EACCES;
>  
>  	for (i = 0; !ret && i < cs->count; i++) {
> -		int (*ctrl_to_user)(struct v4l2_ext_control *c,
> -				    struct v4l2_ctrl *ctrl) = cur_to_user;
> +		int (*ctrl_to_user)(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl);
>  		struct v4l2_ctrl *master;
>  
> +		ctrl_to_user =  initial_value ? init_to_user : cur_to_user;

Two spaces after = instead of one.

I'd recommend using def_to_user instead of init (and make similar changes anywhere else
where you use init or initial).

> +
>  		if (helpers[i].mref == NULL)
>  			continue;
>  
> @@ -2853,8 +2888,9 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  		v4l2_ctrl_lock(master);
>  
>  		/* g_volatile_ctrl will update the new control values */
> -		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
> -			(master->has_volatiles && !is_cur_manual(master))) {
> +		if ((!(master->flags & V4L2_CTRL_FLAG_VOLATILE) ||

Why add the ! before this check? Typo?

> +		     (master->has_volatiles && !is_cur_manual(master))) &&
> +		     !initial_value) {
>  			for (j = 0; j < master->ncontrols; j++)
>  				cur_to_new(master->cluster[j]);
>  			ret = call_op(master, g_volatile_ctrl);
> @@ -2879,6 +2915,10 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  		kfree(helpers);
>  	return ret;
>  }
> +
> +int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs){
> +	return v4l2_g_ext_ctrls_initial(hdl, cs, false);
> +}
>  EXPORT_SYMBOL(v4l2_g_ext_ctrls);
>  
>  int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
> @@ -2887,6 +2927,17 @@ int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
>  }
>  EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
>  
> +int v4l2_initial_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs){
> +	return v4l2_g_ext_ctrls_initial(hdl, cs, true);
> +}
> +EXPORT_SYMBOL(v4l2_initial_ext_ctrls);
> +
> +int v4l2_subdev_initial_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
> +{
> +	return v4l2_initial_ext_ctrls(sd->ctrl_handler, cs);
> +}
> +EXPORT_SYMBOL(v4l2_subdev_initial_ext_ctrls);
> +
>  /* Helper function to get a single control */
>  static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
>  {
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 8712168a3b0a..e68d9ec8832a 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1812,6 +1812,25 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  					-EINVAL;
>  }
>  
> +static int v4l_initial_ext_ctrls(const struct v4l2_ioctl_ops *ops,
> +				struct file *file, void *fh, void *arg)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct v4l2_ext_controls *p = arg;
> +	struct v4l2_fh *vfh =
> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
> +
> +	p->error_idx = p->count;
> +	if (vfh && vfh->ctrl_handler)
> +		return v4l2_initial_ext_ctrls(vfh->ctrl_handler, p);
> +	if (vfd->ctrl_handler)
> +		return v4l2_initial_ext_ctrls(vfd->ctrl_handler, p);
> +	if (ops->vidioc_initial_ext_ctrls == NULL)
> +		return -ENOTTY;
> +	return check_ext_ctrls(p, 0) ? ops->vidioc_initial_ext_ctrls(file, fh, p) :
> +					-EINVAL;
> +}
> +
>  static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> @@ -2285,6 +2304,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>  	IOCTL_INFO_FNC(VIDIOC_G_SLICED_VBI_CAP, v4l_g_sliced_vbi_cap, v4l_print_sliced_vbi_cap, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
>  	IOCTL_INFO_FNC(VIDIOC_LOG_STATUS, v4l_log_status, v4l_print_newline, 0),
>  	IOCTL_INFO_FNC(VIDIOC_G_EXT_CTRLS, v4l_g_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
> +	IOCTL_INFO_FNC(VIDIOC_INITIAL_EXT_CTRLS, v4l_initial_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>  	IOCTL_INFO_FNC(VIDIOC_S_EXT_CTRLS, v4l_s_ext_ctrls, v4l_print_ext_controls, INFO_FL_PRIO | INFO_FL_CTRL),
>  	IOCTL_INFO_FNC(VIDIOC_TRY_EXT_CTRLS, v4l_try_ext_ctrls, v4l_print_ext_controls, INFO_FL_CTRL),
>  	IOCTL_INFO_STD(VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes, v4l_print_frmsizeenum, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 19a034e79be4..6ed308df9d2f 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -206,6 +206,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_G_EXT_CTRLS:
>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
>  
> +	case VIDIOC_INITIAL_EXT_CTRLS:
> +		return v4l2_initial_ext_ctrls(vfh->ctrl_handler, arg);
> +
>  	case VIDIOC_S_EXT_CTRLS:
>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>  
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index ec63d8c44f4e..6521f54718ca 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -815,6 +815,7 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
>  int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  						struct v4l2_control *ctrl);
>  int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
> +int v4l2_initial_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
>  int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
>  int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  						struct v4l2_ext_controls *c);
> @@ -824,6 +825,7 @@ int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
>  int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
>  int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
> +int v4l2_subdev_initial_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
>  int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
>  int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
>  int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 8537983b9b22..16a289bc46b1 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -166,6 +166,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_control *a);
>  	int (*vidioc_g_ext_ctrls)      (struct file *file, void *fh,
>  					struct v4l2_ext_controls *a);
> +	int (*vidioc_initial_ext_ctrls)(struct file *file, void *fh,
> +					struct v4l2_ext_controls *a);
>  	int (*vidioc_s_ext_ctrls)      (struct file *file, void *fh,
>  					struct v4l2_ext_controls *a);
>  	int (*vidioc_try_ext_ctrls)    (struct file *file, void *fh,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2b26d23f9b04..9b84f1755d5f 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -2204,8 +2204,10 @@ struct v4l2_create_buffers {
>  
>  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
>  
> +#define VIDIOC_INITIAL_EXT_CTRLS	_IOWR('V', 104, struct v4l2_ext_controls)
> +
>  /* Reminder: when adding new ioctls please add support for them to
> -   drivers/media/video/v4l2-compat-ioctl32.c as well! */
> +   drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
>  
>  #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
>  
> 

Regards,

	Hans
