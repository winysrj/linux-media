Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab1F0VKw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 17:10:52 -0400
Message-ID: <4E08F1D9.6080903@redhat.com>
Date: Mon, 27 Jun 2011 18:10:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 08/18] v4l2-ctrls: add v4l2_ctrl_auto_cluster to
 simplify autogain/gain scenarios
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <79b139274f67e1e17b56ab49ece643e9cb106e99.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <79b139274f67e1e17b56ab49ece643e9cb106e99.1307458245.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-06-2011 12:05, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> It is a bit tricky to handle autogain/gain type scenerios correctly. Such
> controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set on
> the autofoo controls. In addition, the manual controls should be marked
> inactive when the automatic mode is on, and active when the manual mode is on.
> This also requires specialized volatile handling.
> 
> The chances of drivers doing all these things correctly are pretty remote.
> So a new v4l2_ctrl_auto_cluster function was added that takes care of these
> issues.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   69 +++++++++++++++++++++++++++++++------
>  include/media/v4l2-ctrls.h       |   45 ++++++++++++++++++++++++
>  2 files changed, 102 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index a46d5c1..c39ab0c 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -39,6 +39,20 @@ struct ctrl_helper {
>  	bool handled;
>  };
>  
> +/* Small helper function to determine if the autocluster is set to manual
> +   mode. In that case the is_volatile flag should be ignored. */
> +static bool is_cur_manual(const struct v4l2_ctrl *master)
> +{
> +	return master->is_auto && master->cur.val == master->manual_mode_value;
> +}
> +
> +/* Same as above, but this checks the against the new value instead of the
> +   current value. */
> +static bool is_new_manual(const struct v4l2_ctrl *master)
> +{
> +	return master->is_auto && master->val == master->manual_mode_value;
> +}
> +
>  /* Returns NULL or a character pointer array containing the menu for
>     the given control ID. The pointer array ends with a NULL pointer.
>     An empty string signifies a menu entry that is invalid. This allows
> @@ -643,7 +657,7 @@ static int ctrl_is_volatile(struct v4l2_ext_control *c,
>  }
>  
>  /* Copy the new value to the current value. */
> -static void new_to_cur(struct v4l2_ctrl *ctrl)
> +static void new_to_cur(struct v4l2_ctrl *ctrl, bool update_inactive)
>  {
>  	if (ctrl == NULL)
>  		return;
> @@ -659,6 +673,11 @@ static void new_to_cur(struct v4l2_ctrl *ctrl)
>  		ctrl->cur.val = ctrl->val;
>  		break;
>  	}
> +	if (update_inactive) {
> +		ctrl->flags &= ~V4L2_CTRL_FLAG_INACTIVE;
> +		if (!is_cur_manual(ctrl->cluster[0]))
> +			ctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
> +	}
>  }
>  
>  /* Copy the current value to the new value */
> @@ -1166,7 +1185,7 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
>  	int i;
>  
>  	/* The first control is the master control and it must not be NULL */
> -	BUG_ON(controls[0] == NULL);
> +	BUG_ON(ncontrols == 0 || controls[0] == NULL);
>  
>  	for (i = 0; i < ncontrols; i++) {
>  		if (controls[i]) {
> @@ -1177,6 +1196,28 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_cluster);
>  
> +void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
> +			    u8 manual_val, bool set_volatile)
> +{
> +	struct v4l2_ctrl *master = controls[0];
> +	u32 flag;
> +	int i;
> +
> +	v4l2_ctrl_cluster(ncontrols, controls);
> +	WARN_ON(ncontrols <= 1);
> +	master->is_auto = true;
> +	master->manual_mode_value = manual_val;
> +	master->flags |= V4L2_CTRL_FLAG_UPDATE;
> +	flag = is_cur_manual(master) ? 0 : V4L2_CTRL_FLAG_INACTIVE;
> +
> +	for (i = 1; i < ncontrols; i++)

Hmm... the first control _should_ be the autogain one. This is documented at the ABI
description, but it would be good to have a comment about there at the *.h file.

> +		if (controls[i]) {
> +			controls[i]->is_volatile = set_volatile;
> +			controls[i]->flags |= flag;
> +		}
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_auto_cluster);
> +
>  /* Activate/deactivate a control. */
>  void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
>  {
> @@ -1595,7 +1636,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  						ctrl_is_volatile);
>  
>  		/* g_volatile_ctrl will update the new control values */
> -		if (has_volatiles) {
> +		if (has_volatiles && !is_cur_manual(master)) {
>  			for (j = 0; j < master->ncontrols; j++)
>  				cur_to_new(master->cluster[j]);
>  			ret = call_op(master, g_volatile_ctrl);
> @@ -1633,7 +1674,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
>  
>  	v4l2_ctrl_lock(master);
>  	/* g_volatile_ctrl will update the current control values */
> -	if (ctrl->is_volatile) {
> +	if (ctrl->is_volatile && !is_cur_manual(master)) {
>  		for (i = 0; i < master->ncontrols; i++)
>  			cur_to_new(master->cluster[i]);
>  		ret = call_op(master, g_volatile_ctrl);
> @@ -1678,6 +1719,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
>     Must be called with ctrl->handler->lock held. */
>  static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
>  {
> +	bool update_flag;
>  	bool try = !set;
>  	int ret = 0;
>  	int i;
> @@ -1717,14 +1759,17 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
>  		ret = call_op(master, try_ctrl);
>  
>  	/* Don't set if there is no change */
> -	if (!ret && set && cluster_changed(master)) {
> -		ret = call_op(master, s_ctrl);
> -		/* If OK, then make the new values permanent. */
> -		if (!ret)
> -			for (i = 0; i < master->ncontrols; i++)
> -				new_to_cur(master->cluster[i]);
> -	}
> -	return ret;
> +	if (ret || !set || !cluster_changed(master))
> +		return ret;
> +	ret = call_op(master, s_ctrl);
> +	/* If OK, then make the new values permanent. */
> +	if (ret)
> +		return ret;
> +
> +	update_flag = is_cur_manual(master) != is_new_manual(master);
> +	for (i = 0; i < master->ncontrols; i++)
> +		new_to_cur(master->cluster[i], update_flag && i > 0);
> +	return 0;
>  }
>  
>  /* Try or set controls. */
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 97d0638..56323e3 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -65,6 +65,15 @@ struct v4l2_ctrl_ops {
>    *		control's current value cannot be cached and needs to be
>    *		retrieved through the g_volatile_ctrl op. Drivers can set
>    *		this flag.
> +  * @is_auto:   If set, then this control selects whether the other cluster
> +  *		members are in 'automatic' mode or 'manual' mode. This is
> +  *		used for autogain/gain type clusters. Drivers should never
> +  *		set this flag directly.
> +  * @manual_mode_value: If the is_auto flag is set, then this is the value
> +  *		of the auto control that determines if that control is in
> +  *		manual mode. So if the value of the auto control equals this
> +  *		value, then the whole cluster is in manual mode. Drivers should
> +  *		never set this flag directly.
>    * @ops:	The control ops.
>    * @id:	The control ID.
>    * @name:	The control name.
> @@ -105,6 +114,8 @@ struct v4l2_ctrl {
>  	unsigned int is_new:1;
>  	unsigned int is_private:1;
>  	unsigned int is_volatile:1;
> +	unsigned int is_auto:1;
> +	unsigned int manual_mode_value:5;
>  
>  	const struct v4l2_ctrl_ops *ops;
>  	u32 id;
> @@ -363,6 +374,40 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
>  void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
>  
>  
> +/** v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging to
> +  * that cluster and set it up for autofoo/foo-type handling.
> +  * @ncontrols:	The number of controls in this cluster.
> +  * @controls:	The cluster control array of size @ncontrols. The first control
> +  *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
> +  * @manual_val: The value for the first control in the cluster that equals the
> +  *		manual setting.
> +  * @set_volatile: If true, then all controls except the first auto control will
> +  *		have is_volatile set to true. If false, then is_volatile will not
> +  *		be touched.
> +  *
> +  * Use for control groups where one control selects some automatic feature and
> +  * the other controls are only active whenever the automatic feature is turned
> +  * off (manual mode). Typical examples: autogain vs gain, auto-whitebalance vs
> +  * red and blue balance, etc.
> +  *
> +  * The behavior of such controls is as follows:
> +  *
> +  * When the autofoo control is set to automatic, then any manual controls
> +  * are set to inactive and any reads will call g_volatile_ctrl (if the control
> +  * was marked volatile).
> +  *
> +  * When the autofoo control is set to manual, then any manual controls will
> +  * be marked active, and any reads will just return the current value without
> +  * going through g_volatile_ctrl.
> +  *
> +  * In addition, this function will set the V4L2_CTRL_FLAG_UPDATE flag
> +  * on the autofoo control and V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
> +  * if autofoo is in auto mode.
> +  */
> +void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
> +			u8 manual_val, bool set_volatile);
> +
> +
>  /** v4l2_ctrl_find() - Find a control with the given ID.
>    * @hdl:	The control handler.
>    * @id:	The control ID to find.

