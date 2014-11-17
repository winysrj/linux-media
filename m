Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36919 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751679AbaKQJhg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 04:37:36 -0500
Date: Mon, 17 Nov 2014 11:31:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 07/11] v4l2-ctrls: implement 'ignore after use'
 support.
Message-ID: <20141117093142.GM8907@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-8-git-send-email-hverkuil@xs4all.nl>
 <20141115211051.GI8907@valkosipuli.retiisi.org.uk>
 <5469B98B.9060304@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469B98B.9060304@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 17, 2014 at 10:02:03AM +0100, Hans Verkuil wrote:
> On 11/15/2014 10:10 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > A few comments below.
> > 
> > On Sun, Sep 21, 2014 at 04:48:25PM +0200, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Sometimes you want to apply a value every time v4l2_ctrl_apply_store
> >> is called, and sometimes you want to apply that value only once.
> >>
> >> This adds support for that feature.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ctrls.c | 75 ++++++++++++++++++++++++++++--------
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 14 +++----
> >>  include/media/v4l2-ctrls.h           | 12 ++++++
> >>  3 files changed, 79 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> index e5dccf2..21560b0 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> @@ -1475,6 +1475,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
> >>  static int cur_to_user(struct v4l2_ext_control *c,
> >>  		       struct v4l2_ctrl *ctrl)
> >>  {
> >> +	c->flags = 0;
> >>  	return ptr_to_user(c, ctrl, ctrl->p_cur);
> >>  }
> >>  
> >> @@ -1482,8 +1483,13 @@ static int cur_to_user(struct v4l2_ext_control *c,
> >>  static int store_to_user(struct v4l2_ext_control *c,
> >>  		       struct v4l2_ctrl *ctrl, unsigned store)
> >>  {
> >> +	c->flags = 0;
> >>  	if (store == 0)
> >>  		return ptr_to_user(c, ctrl, ctrl->p_new);
> >> +	if (test_bit(store - 1, ctrl->cluster[0]->ignore_store_after_use))
> >> +		c->flags |= V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE;
> >> +	if (test_bit(store - 1, ctrl->cluster[0]->ignore_store))
> >> +		c->flags |= V4L2_EXT_CTRL_FL_IGN_STORE;
> >>  	return ptr_to_user(c, ctrl, ctrl->p_stores[store - 1]);
> >>  }
> >>  
> >> @@ -1491,6 +1497,7 @@ static int store_to_user(struct v4l2_ext_control *c,
> >>  static int new_to_user(struct v4l2_ext_control *c,
> >>  		       struct v4l2_ctrl *ctrl)
> >>  {
> >> +	c->flags = 0;
> >>  	return ptr_to_user(c, ctrl, ctrl->p_new);
> >>  }
> >>  
> >> @@ -1546,6 +1553,8 @@ static int user_to_ptr(struct v4l2_ext_control *c,
> >>  static int user_to_new(struct v4l2_ext_control *c,
> >>  		       struct v4l2_ctrl *ctrl)
> >>  {
> >> +	ctrl->cluster[0]->new_ignore_store_after_use =
> >> +		c->flags & V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE;
> >>  	return user_to_ptr(c, ctrl, ctrl->p_new);
> >>  }
> >>  
> >> @@ -1597,8 +1606,11 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
> >>  /* Helper function: copy the new control value to the store */
> >>  static void new_to_store(struct v4l2_ctrl *ctrl)
> >>  {
> >> +	if (ctrl == NULL)
> >> +		return;
> >> +
> >>  	/* has_changed is set by cluster_changed */
> >> -	if (ctrl && ctrl->has_changed)
> >> +	if (ctrl->has_changed)
> >>  		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_stores[ctrl->store - 1]);
> >>  }
> >>  
> >> @@ -2328,6 +2340,12 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
> >>  
> >>  	for (i = 0; i < ncontrols; i++) {
> >>  		if (controls[i]) {
> >> +			/*
> >> +			 * All controls in a cluster must have the same
> >> +			 * V4L2_CTRL_FLAG_CAN_STORE flag value.
> >> +			 */
> >> +			WARN_ON((controls[0]->flags & controls[i]->flags) &
> >> +					V4L2_CTRL_FLAG_CAN_STORE);
> >>  			controls[i]->cluster = controls;
> >>  			controls[i]->ncontrols = ncontrols;
> >>  			if (controls[i]->flags & V4L2_CTRL_FLAG_VOLATILE)
> >> @@ -2850,6 +2868,10 @@ static int extend_store(struct v4l2_ctrl *ctrl, unsigned stores)
> >>  	unsigned s, idx;
> >>  	union v4l2_ctrl_ptr *p;
> >>  
> >> +	/* round up to the next multiple of 4 */
> >> +	stores = (stores + 3) & ~3;
> > 
> > You said it, round_up(). :-)
> > 
> > The comment becomes redundant as a result, too.
> > 
> > The above may also overflow. 
> 
> Will fix.

I just realised round_up() will naturally also overflow, but it'll overflow
"correctly" to zero. So the upper limit check must be before this. The
change then effectually only makes the comment unnecessary.

> > 
> >> +	if (stores > V4L2_CTRLS_MAX_STORES)
> >> +		return -EINVAL;
> >>  	p = kcalloc(stores, sizeof(union v4l2_ctrl_ptr), GFP_KERNEL);
> >>  	if (p == NULL)
> >>  		return -ENOMEM;
> >> @@ -2868,6 +2890,7 @@ static int extend_store(struct v4l2_ctrl *ctrl, unsigned stores)
> >>  		memcpy(p, ctrl->p_stores, ctrl->nr_of_stores * sizeof(union v4l2_ctrl_ptr));
> >>  	kfree(ctrl->p_stores);
> >>  	ctrl->p_stores = p;
> >> +	bitmap_set(ctrl->ignore_store, ctrl->nr_of_stores, stores - ctrl->nr_of_stores);
> >>  	ctrl->nr_of_stores = stores;
> >>  	return 0;
> >>  }
> >> @@ -3081,21 +3104,33 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
> >>  
> >>  	ret = call_op(master, try_ctrl);
> >>  
> >> -	/* Don't set if there is no change */
> >> -	if (ret || !set || !cluster_changed(master))
> >> -		return ret;
> >> -	ret = call_op(master, s_ctrl);
> >> -	if (ret)
> >> +	if (ret || !set)
> >>  		return ret;
> >>  
> >> -	/* If OK, then make the new values permanent. */
> >> -	update_flag = is_cur_manual(master) != is_new_manual(master);
> >> -	for (i = 0; i < master->ncontrols; i++) {
> >> -		if (store)
> >> -			new_to_store(master->cluster[i]);
> >> +	/* Don't set if there is no change */
> >> +	if (cluster_changed(master)) {
> >> +		ret = call_op(master, s_ctrl);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >> +		/* If OK, then make the new values permanent. */
> >> +		update_flag = is_cur_manual(master) != is_new_manual(master);
> >> +		for (i = 0; i < master->ncontrols; i++) {
> >> +			if (store)
> >> +				new_to_store(master->cluster[i]);
> >> +			else
> >> +				new_to_cur(fh, master->cluster[i], ch_flags |
> >> +						((update_flag && i > 0) ?
> >> +						 V4L2_EVENT_CTRL_CH_FLAGS : 0));
> >> +		}
> >> +	}
> >> +
> >> +	if (store) {
> >> +		if (master->new_ignore_store_after_use)
> >> +			set_bit(store - 1, master->ignore_store_after_use);
> >>  		else
> >> -			new_to_cur(fh, master->cluster[i], ch_flags |
> >> -				((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
> >> +			clear_bit(store - 1, master->ignore_store_after_use);
> >> +		clear_bit(store - 1, master->ignore_store);
> > 
> > How about allowing the user to forget a control in store as well?
> 
> Yeah, that's one thing I need to add. I need to think about this some more how this
> can be done cleanly.

Ack.

> > 
> >>  	}
> >>  	return 0;
> >>  }
> >> @@ -3401,8 +3436,18 @@ int v4l2_ctrl_apply_store(struct v4l2_ctrl_handler *hdl, unsigned store)
> >>  			continue;
> >>  		if (master->handler != hdl)
> >>  			v4l2_ctrl_lock(master);
> >> -		for (i = 0; i < master->ncontrols; i++)
> >> -			store_to_new(master->cluster[i], store);
> >> +		for (i = 0; i < master->ncontrols; i++) {
> >> +			struct v4l2_ctrl *ctrl = master->cluster[i];
> >> +
> >> +			if (!ctrl || (store && test_bit(store - 1, master->ignore_store)))
> >> +				continue;
> >> +			store_to_new(ctrl, store);
> >> +		}
> >> +
> >> +		if (store && !test_bit(store - 1, master->ignore_store)) {
> >> +			if (test_bit(store - 1, master->ignore_store_after_use))
> > 
> > How about:
> > 
> > if (store && test_bit() && test_bit())
> 
> OK.
> 
> > 
> >> +				set_bit(store - 1, master->ignore_store);
> >> +		}
> >>  
> >>  		/* For volatile autoclusters that are currently in auto mode
> >>  		   we need to discover if it will be set to manual mode.
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> index 628852c..9d3b4f2 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -562,12 +562,14 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
> >>  	pr_cont("class=0x%x, count=%d, error_idx=%d",
> >>  			p->ctrl_class, p->count, p->error_idx);
> >>  	for (i = 0; i < p->count; i++) {
> >> -		if (p->controls[i].size)
> >> -			pr_cont(", id/val=0x%x/0x%x",
> >> -				p->controls[i].id, p->controls[i].value);
> >> +		if (!p->controls[i].size)
> >> +			pr_cont(", id/flags/val=0x%x/0x%x/0x%x",
> >> +				p->controls[i].id, p->controls[i].flags,
> >> +				p->controls[i].value);
> >>  		else
> >> -			pr_cont(", id/size=0x%x/%u",
> >> -				p->controls[i].id, p->controls[i].size);
> >> +			pr_cont(", id/flags/size=0x%x/0x%x/%u",
> >> +				p->controls[i].id, p->controls[i].flags,
> >> +				p->controls[i].size);
> >>  	}
> >>  	pr_cont("\n");
> >>  }
> >> @@ -888,8 +890,6 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
> >>  
> >>  	/* zero the reserved fields */
> >>  	c->reserved[0] = c->reserved[1] = 0;
> >> -	for (i = 0; i < c->count; i++)
> >> -		c->controls[i].reserved2[0] = 0;
> >>  
> >>  	/* V4L2_CID_PRIVATE_BASE cannot be used as control class
> >>  	   when using extended controls.
> >> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> >> index 713980a..3005d88 100644
> >> --- a/include/media/v4l2-ctrls.h
> >> +++ b/include/media/v4l2-ctrls.h
> >> @@ -36,6 +36,9 @@ struct v4l2_subscribed_event;
> >>  struct v4l2_fh;
> >>  struct poll_table_struct;
> >>  
> >> +/* Must be a multiple of 4 */
> >> +#define V4L2_CTRLS_MAX_STORES VIDEO_MAX_FRAME
> >> +
> >>  /** union v4l2_ctrl_ptr - A pointer to a control value.
> >>   * @p_s32:	Pointer to a 32-bit signed value.
> >>   * @p_s64:	Pointer to a 64-bit signed value.
> >> @@ -123,6 +126,8 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
> >>    * @call_notify: If set, then call the handler's notify function whenever the
> >>    *		control's value changes.
> >>    * @can_store: If set, then this control supports configuration stores.
> >> +  * @new_ignore_store_after_use: If set, then the new control had the
> >> +  *		V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE flag set.
> >>    * @manual_mode_value: If the is_auto flag is set, then this is the value
> >>    *		of the auto control that determines if that control is in
> >>    *		manual mode. So if the value of the auto control equals this
> >> @@ -143,6 +148,10 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
> >>    * @nr_of_dims:The number of dimensions in @dims.
> >>    * @nr_of_stores: The number of allocated configuration stores of this control.
> >>    * @store:	The configuration store that the control op operates on.
> >> +  * @ignore_store: If the bit for the corresponding store is 1, then don't apply that
> >> +  *		store's value.
> >> +  * @ignore_store_after_use: If the bit for the corresponding store is 1, then set the
> >> +  *		bit in @ignore_store after the store's value has been applied.
> >>    * @menu_skip_mask: The control's skip mask for menu controls. This makes it
> >>    *		easy to skip menu items that are not valid. If bit X is set,
> >>    *		then menu item X is skipped. Of course, this only works for
> >> @@ -183,6 +192,7 @@ struct v4l2_ctrl {
> >>  	unsigned int has_volatiles:1;
> >>  	unsigned int call_notify:1;
> >>  	unsigned int can_store:1;
> >> +	unsigned int new_ignore_store_after_use:1;
> >>  	unsigned int manual_mode_value:8;
> >>  
> >>  	const struct v4l2_ctrl_ops *ops;
> >> @@ -197,6 +207,8 @@ struct v4l2_ctrl {
> >>  	u32 nr_of_dims;
> >>  	u16 nr_of_stores;
> >>  	u16 store;
> >> +	DECLARE_BITMAP(ignore_store, V4L2_CTRLS_MAX_STORES);
> >> +	DECLARE_BITMAP(ignore_store_after_use, V4L2_CTRLS_MAX_STORES);
> > 
> > I'd store this information next to the value itself. The reason is that
> > stores are typically accessed one at a time, and thus keeping data related
> > to a single store in a single contiguous location reduces cache misses.
> 
> Hmm, sounds like overengineering to me. If I can do that without sacrificing
> readability, then I can more it around. It's likely that these datastructures
> will change anyway.

The controls are accessed very often in practice so this kind of things
count. There's already a lot of code which gets executed in order to set a
single control that's relevant only in some cases, such as clusters.

I think it'd probably be more readable as well if information related to a
store was located in a single place. As a bonus you wouldn't need to set a
global maximum for the number of stores one may have.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
