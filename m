Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab1F0VUM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 17:20:12 -0400
Message-ID: <4E08F407.1090809@redhat.com>
Date: Mon, 27 Jun 2011 18:20:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 11/18] v4l2-ctrls: add v4l2_fh pointer to the set
 control functions.
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <5efc95cbe00dda4ee88523f173a3998257120bdd.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <5efc95cbe00dda4ee88523f173a3998257120bdd.1307458245.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-06-2011 12:05, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When an application changes a control you want to generate an event.
> However, you want to avoid sending such an event back to the application
> (file handle) that caused the change.

Why? 

I can see two usecases for an event-triggered control change:
	1) when two applications are used, and one changed a value that could
affect the other;
	2) as a way to implement async changes.

However, it seems, from your comments, that you're covering only case (1).

There are several reasons why we need to support case (2):

Some controls may be associated to a servo mechanism (like zoom, optical
focus, etc), or may require some time to happen (like charging a flash device).
So, it makes sense to have events back to the application that caused the change.

Kernel should not assume that the application that requested a change on a control
doesn't want to receive the notification back when the event actually happened.
This way, both cases will be covered.

Yet, I failed to see where, in the code, such restriction were imposed.

> 
> Add the filehandle to the various set control functions.
> 
> The filehandle isn't used yet, but the control event patches will need
> this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ctrls.c  |   45 ++++++++++++++++++++----------------
>  drivers/media/video/v4l2-ioctl.c  |    8 +++---
>  drivers/media/video/v4l2-subdev.c |    4 +-
>  include/media/v4l2-ctrls.h        |    8 ++++--
>  4 files changed, 36 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index c39ab0c..a38bdf9 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -657,7 +657,8 @@ static int ctrl_is_volatile(struct v4l2_ext_control *c,
>  }
>  
>  /* Copy the new value to the current value. */
> -static void new_to_cur(struct v4l2_ctrl *ctrl, bool update_inactive)
> +static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
> +						bool update_inactive)
>  {
>  	if (ctrl == NULL)
>  		return;
> @@ -1717,7 +1718,8 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
>  /* Core function that calls try/s_ctrl and ensures that the new value is
>     copied to the current value on a set.
>     Must be called with ctrl->handler->lock held. */
> -static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
> +static int try_or_set_control_cluster(struct v4l2_fh *fh,
> +					struct v4l2_ctrl *master, bool set)
>  {
>  	bool update_flag;
>  	bool try = !set;
> @@ -1768,12 +1770,13 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
>  
>  	update_flag = is_cur_manual(master) != is_new_manual(master);
>  	for (i = 0; i < master->ncontrols; i++)
> -		new_to_cur(master->cluster[i], update_flag && i > 0);
> +		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
>  	return 0;
>  }
>  
>  /* Try or set controls. */
> -static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
> +static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
> +				struct v4l2_ctrl_handler *hdl,
>  				struct v4l2_ext_controls *cs,
>  				struct ctrl_helper *helpers,
>  				bool set)
> @@ -1818,7 +1821,7 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  		ret = cluster_walk(i, cs, helpers, user_to_new);
>  
>  		if (!ret)
> -			ret = try_or_set_control_cluster(master, set);
> +			ret = try_or_set_control_cluster(fh, master, set);
>  
>  		/* Copy the new values back to userspace. */
>  		if (!ret)
> @@ -1831,7 +1834,7 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  }
>  
>  /* Try or try-and-set controls */
> -static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
> +static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  			     struct v4l2_ext_controls *cs,
>  			     bool set)
>  {
> @@ -1858,7 +1861,7 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  
>  	/* First 'try' all controls and abort on error */
>  	if (!ret)
> -		ret = try_or_set_ext_ctrls(hdl, cs, helpers, false);
> +		ret = try_or_set_ext_ctrls(NULL, hdl, cs, helpers, false);
>  	/* If this is a 'set' operation and the initial 'try' failed,
>  	   then set error_idx to count to tell the application that no
>  	   controls changed value yet. */
> @@ -1868,7 +1871,7 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  		/* Reset 'handled' state */
>  		for (i = 0; i < cs->count; i++)
>  			helpers[i].handled = false;
> -		ret = try_or_set_ext_ctrls(hdl, cs, helpers, true);
> +		ret = try_or_set_ext_ctrls(fh, hdl, cs, helpers, true);
>  	}
>  
>  	if (cs->count > ARRAY_SIZE(helper))
> @@ -1878,30 +1881,31 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  
>  int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(hdl, cs, false);
> +	return try_set_ext_ctrls(NULL, hdl, cs, false);
>  }
>  EXPORT_SYMBOL(v4l2_try_ext_ctrls);
>  
> -int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
> +int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> +					struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(hdl, cs, true);
> +	return try_set_ext_ctrls(fh, hdl, cs, true);
>  }
>  EXPORT_SYMBOL(v4l2_s_ext_ctrls);
>  
>  int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(sd->ctrl_handler, cs, false);
> +	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, false);
>  }
>  EXPORT_SYMBOL(v4l2_subdev_try_ext_ctrls);
>  
>  int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(sd->ctrl_handler, cs, true);
> +	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, true);
>  }
>  EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
>  
>  /* Helper function for VIDIOC_S_CTRL compatibility */
> -static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
> +static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
>  {
>  	struct v4l2_ctrl *master = ctrl->cluster[0];
>  	int ret;
> @@ -1916,15 +1920,16 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
>  
>  	ctrl->val = *val;
>  	ctrl->is_new = 1;
> -	ret = try_or_set_control_cluster(master, false);
> +	ret = try_or_set_control_cluster(NULL, master, false);
>  	if (!ret)
> -		ret = try_or_set_control_cluster(master, true);
> +		ret = try_or_set_control_cluster(fh, master, true);
>  	*val = ctrl->cur.val;
>  	v4l2_ctrl_unlock(ctrl);
>  	return ret;
>  }
>  
> -int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
> +int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> +					struct v4l2_control *control)
>  {
>  	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
>  
> @@ -1934,13 +1939,13 @@ int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
>  	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
>  		return -EACCES;
>  
> -	return set_ctrl(ctrl, &control->value);
> +	return set_ctrl(fh, ctrl, &control->value);
>  }
>  EXPORT_SYMBOL(v4l2_s_ctrl);
>  
>  int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
>  {
> -	return v4l2_s_ctrl(sd->ctrl_handler, control);
> +	return v4l2_s_ctrl(NULL, sd->ctrl_handler, control);
>  }
>  EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
>  
> @@ -1948,6 +1953,6 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
>  {
>  	/* It's a driver bug if this happens. */
>  	WARN_ON(!type_is_int(ctrl));
> -	return set_ctrl(ctrl, &val);
> +	return set_ctrl(NULL, ctrl, &val);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 9811b1e..32107de 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1481,11 +1481,11 @@ static long __video_do_ioctl(struct file *file,
>  		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
>  
>  		if (vfh && vfh->ctrl_handler) {
> -			ret = v4l2_s_ctrl(vfh->ctrl_handler, p);
> +			ret = v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
>  			break;
>  		}
>  		if (vfd->ctrl_handler) {
> -			ret = v4l2_s_ctrl(vfd->ctrl_handler, p);
> +			ret = v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
>  			break;
>  		}
>  		if (ops->vidioc_s_ctrl) {
> @@ -1530,9 +1530,9 @@ static long __video_do_ioctl(struct file *file,
>  			break;
>  		v4l_print_ext_ctrls(cmd, vfd, p, 1);
>  		if (vfh && vfh->ctrl_handler)
> -			ret = v4l2_s_ext_ctrls(vfh->ctrl_handler, p);
> +			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
>  		else if (vfd->ctrl_handler)
> -			ret = v4l2_s_ext_ctrls(vfd->ctrl_handler, p);
> +			ret = v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
>  		else if (check_ext_ctrls(p, 0))
>  			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
>  		break;
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index f396cc3..fd5dcca 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -164,13 +164,13 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_S_CTRL:
> -		return v4l2_s_ctrl(vfh->ctrl_handler, arg);
> +		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_G_EXT_CTRLS:
>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_S_EXT_CTRLS:
> -		return v4l2_s_ext_ctrls(vfh->ctrl_handler, arg);
> +		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_TRY_EXT_CTRLS:
>  		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 56323e3..e720f11 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -28,6 +28,7 @@
>  /* forward references */
>  struct v4l2_ctrl_handler;
>  struct v4l2_ctrl;
> +struct v4l2_fh;
>  struct video_device;
>  struct v4l2_subdev;
>  
> @@ -485,15 +486,16 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
>    */
>  int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
>  
> -
>  /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
>  int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
>  int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
>  int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
> -int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
> +int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> +						struct v4l2_control *ctrl);
>  int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
>  int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
> -int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
> +int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> +						struct v4l2_ext_controls *c);
>  
>  /* Helpers for subdevices. If the associated ctrl_handler == NULL then they
>     will all return -EINVAL. */

