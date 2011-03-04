Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2394 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab1CDJrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:47:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2-ctrls: Add transaction support
Date: Fri, 4 Mar 2011 10:47:11 +0100
Cc: linux-media@vger.kernel.org
References: <1299165213-14014-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1299165213-14014-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041047.11882.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

I'm afraid this approach won't work. See below for the details.

On Thursday, March 03, 2011 16:13:33 Laurent Pinchart wrote:
> Some hardware supports controls transactions. For instance, the MT9T001
> sensor can optionally shadow registers that influence the output image,
> allowing the host to explicitly control the shadow process.
> 
> To support such hardware, drivers need to be notified when a control
> transation is about to start and when it has finished. Add begin() and
> commit() callback functions to the v4l2_ctrl_handler structure to
> support such notifications.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   42 +++++++++++++++++++++++++++++++++++--
>  include/media/v4l2-ctrls.h       |    8 +++++++
>  2 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 2412f08..d0e6265 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1264,13 +1264,22 @@ EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
>  int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
>  {
>  	struct v4l2_ctrl *ctrl;
> +	unsigned int count = 0;
>  	int ret = 0;
>  
>  	if (hdl == NULL)
>  		return 0;
>  	mutex_lock(&hdl->lock);
> -	list_for_each_entry(ctrl, &hdl->ctrls, node)
> +	list_for_each_entry(ctrl, &hdl->ctrls, node) {
>  		ctrl->done = false;
> +		count++;
> +	}
> +
> +	if (hdl->begin) {
> +		ret = hdl->begin(hdl, count == 1);

Note that count can be 0! In any case, rather then adding a counter you can
use list_empty() and list_is_singular().

> +		if (ret)
> +			goto done;
> +	}
>  
>  	list_for_each_entry(ctrl, &hdl->ctrls, node) {
>  		struct v4l2_ctrl *master = ctrl->cluster[0];
> @@ -1298,6 +1307,11 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
>  			if (master->cluster[i])
>  				master->cluster[i]->done = true;
>  	}
> +
> +	if (hdl->commit)
> +		hdl->commit(hdl, ret != 0);
> +
> +done:

I understand that you assume that all controls registered to a handler can
be used in a transaction. But isn't it possible that only a subset of the controls
is shadowed? And so only certain controls can be in a transaction?

>  	mutex_unlock(&hdl->lock);
>  	return ret;
>  }
> @@ -1717,6 +1731,12 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  			return -EBUSY;
>  	}
>  
> +	if (set && hdl->begin) {
> +		ret = hdl->begin(hdl, cs->count == 1);
> +		if (ret)
> +			return ret;
> +	}
> +

You are assuming that all controls here are owned by the given control handler.
That's not necessarily the case though as a control handler can inherit controls
from another handler. So the cs array is an array of controls where each control
can be owned by a different handler.

>  	for (i = 0; !ret && i < cs->count; i++) {
>  		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
>  		struct v4l2_ctrl *master = ctrl->cluster[0];
> @@ -1747,6 +1767,10 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  		v4l2_ctrl_unlock(ctrl);
>  		cluster_done(i, cs, helpers);
>  	}
> +
> +	if (set && hdl->commit)
> +		hdl->commit(hdl, ret == 0);
> +

If you rollback a transaction, then you also have a problem: if some of the
controls of the transaction succeeded then try_or_set_control_cluster() will
have set the current control value to the new value (since the 'set' succeeded).

But if you rollback the transaction, then that means that the old value isn't
restored for such controls.

I don't see an easy solution for that offhand.

I really wonder whether you are not reinventing the control cluster here.

If you put all shadowed controls in a cluster, then it will behave exactly the
same as a transaction.

Yes, that might mean that all controls of a subdev are in a single cluster.
But so what? That's the way to atomically handle controls that in some manner
are related.

Regards,

	Hans

>  	return ret;
>  }
>  
> @@ -1842,8 +1866,20 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
>  	ctrl->val = *val;
>  	ctrl->is_new = 1;
>  	ret = try_or_set_control_cluster(master, false);
> -	if (!ret)
> -		ret = try_or_set_control_cluster(master, true);
> +	if (ret)
> +		goto done;
> +
> +	if (master->handler->begin) {
> +		ret = master->handler->begin(master->handler, true);
> +		if (ret)
> +			goto done;
> +	}
> +
> +	ret = try_or_set_control_cluster(master, true);
> +	if (master->handler->commit)
> +		master->handler->commit(master->handler, ret != 0);
> +
> +done:
>  	*val = ctrl->cur.val;
>  	v4l2_ctrl_unlock(ctrl);
>  	return ret;
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 97d0638..29acffc 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -157,6 +157,12 @@ struct v4l2_ctrl_ref {
>    * @buckets:	Buckets for the hashing. Allows for quick control lookup.
>    * @nr_of_buckets: Total number of buckets in the array.
>    * @error:	The error code of the first failed control addition.
> +  * @begin:	Begin a control set transaction. Called before the first control
> +  *		in a group is set. The single argument is true if the group
> +  *		contains a single control, and false otherwise.
> +  * @commit:	End a control set transaction. Called after the last control
> +  * 		in a group is set. The rollback argument is true if an error
> +  * 		occured when setting the controls, and false otherwise.
>    */
>  struct v4l2_ctrl_handler {
>  	struct mutex lock;
> @@ -166,6 +172,8 @@ struct v4l2_ctrl_handler {
>  	struct v4l2_ctrl_ref **buckets;
>  	u16 nr_of_buckets;
>  	int error;
> +	int (*begin)(struct v4l2_ctrl_handler *hdl, bool single);
> +	void (*commit)(struct v4l2_ctrl_handler *hdl, bool rollback);
>  };
>  
>  /** struct v4l2_ctrl_config - Control configuration structure.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
