Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1357 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2I0Gog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 02:44:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 API PATCH 2/4] v4l2-ctrls: add a notify callback.
Date: Thu, 27 Sep 2012 08:44:25 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com> <598b270f69d510c29436b51ef5cc0034afe77101.1347620872.git.hans.verkuil@cisco.com> <1779382.8Ng3nlM3Km@avalon>
In-Reply-To: <1779382.8Ng3nlM3Km@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209270844.25497.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed September 26 2012 12:50:11 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 14 September 2012 13:15:34 Hans Verkuil wrote:
> > Sometimes platform/bridge drivers need to be notified when a control from
> > a subdevice changes value. In order to support this a notify callback was
> > added.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  Documentation/video4linux/v4l2-controls.txt |   22 ++++++++++++++--------
> >  drivers/media/v4l2-core/v4l2-ctrls.c        |   25 ++++++++++++++++++++++++
> >  include/media/v4l2-ctrls.h                  |   25 ++++++++++++++++++++++++
> >  3 files changed, 64 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/video4linux/v4l2-controls.txt
> > b/Documentation/video4linux/v4l2-controls.txt index 43da22b..cecaff8 100644
> > --- a/Documentation/video4linux/v4l2-controls.txt
> > +++ b/Documentation/video4linux/v4l2-controls.txt
> > @@ -687,14 +687,20 @@ a control of this type whenever the first control
> > belonging to a new control class is added.
> > 
> > 
> > -Proposals for Extensions
> > -========================
> > +Adding Notify Callbacks
> > +=======================
> > +
> > +Sometimes the platform or bridge driver needs to be notified when a control
> > +from a sub-device driver changes. You can set a notify callback by calling
> > +this function:
> > 
> > -Some ideas for future extensions to the spec:
> > +void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl,
> > +	void (*notify)(struct v4l2_ctrl *ctrl, void *priv), void *priv);
> > 
> > -1) Add a V4L2_CTRL_FLAG_HEX to have values shown as hexadecimal instead of
> > -decimal. Useful for e.g. video_mute_yuv.
> > +Whenever the give control changes value the notify callback will be called
> > +with a pointer to the control and the priv pointer that was passed with
> > +v4l2_ctrl_notify. Note that the control's handler lock is held when the
> > +notify function is called.
> > 
> > -2) It is possible to mark in the controls array which controls have been
> > -successfully written and which failed by for example adding a bit to the
> > -control ID. Not sure if it is worth the effort, though.
> > +There can be only one notify function per control handler. Any attempt
> > +to set another notify function will cause a WARN_ON.
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > b/drivers/media/v4l2-core/v4l2-ctrls.c index f400035..43061e1 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -1160,6 +1160,8 @@ static void new_to_cur(struct v4l2_fh *fh, struct
> > v4l2_ctrl *ctrl, send_event(fh, ctrl,
> >  			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) |
> >  			(update_inactive ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
> > +		if (ctrl->call_notify && changed && ctrl->handler->notify)
> > +			ctrl->handler->notify(ctrl, ctrl->handler->notify_priv);
> >  	}
> >  }
> > 
> > @@ -2628,6 +2630,29 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl,
> > s64 val) }
> >  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
> > 
> > +void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify,
> > void *priv)
> > +{
> > +	if (ctrl == NULL)
> > +		return;
> 
> Isn't the caller supposed not to set ctrl to NULL ? A crash is easier to 
> notice than a silent failure during development.

The reason why I do this (not only here, but in other places in the control
framework as well), is that it simplifies driver development if you have a
driver that adds controls based on the chip version. In cases like that you
only have to look at the chip version when adding the controls, but after
that you can use almost all functions without having to check the control
pointer every time. I.e., if the control wasn't added, then the control
pointer would be NULL and all these functions would be nops.

> > +	if (notify == NULL) {
> > +		ctrl->call_notify = 0;
> > +		return;
> > +	}
> > +	/* Only one notifier is allowed. Should we ever need to support
> > +	   multiple notifiers, then some sort of linked list of notifiers
> > +	   should be implemented. But I don't see any real reason to implement
> > +	   that now. If you think you need multiple notifiers, then contact
> > +	   the linux-media mailinglist. */
> > +	if (WARN_ON(ctrl->handler->notify &&
> > +			(ctrl->handler->notify != notify ||
> > +			 ctrl->handler->notify_priv != priv)))
> > +		return;
> 
> I'm not sure whether I like that. It feels a bit hackish. Wouldn't it be 
> better to register the notifier with the handler explictly just once and then 
> enable/disable notifications on a per-control basis ?

I thought about that, but I prefer this method because it allows me to switch
to per-control notifiers in the future. In addition, different controls can have
different handlers. If you have to set the notifier for handlers, then the
driver needs to figure out which handlers are involved for the controls it wants
to be notified on. It's much easier to do it like this.

Regards,

	Hans

> > +	ctrl->handler->notify = notify;
> > +	ctrl->handler->notify_priv = priv;
> > +	ctrl->call_notify = 1;
> > +}
> > +EXPORT_SYMBOL(v4l2_ctrl_notify);
> > +
> >  static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned
> > elems) {
> >  	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index 6890f5e..4484fd3 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -53,6 +53,8 @@ struct v4l2_ctrl_ops {
> >  	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
> >  };
> > 
> > +typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
> > +
> >  /** struct v4l2_ctrl - The control structure.
> >    * @node:	The list node.
> >    * @ev_subs:	The list of control event subscriptions.
> > @@ -72,6 +74,8 @@ struct v4l2_ctrl_ops {
> >    *		set this flag directly.
> >    * @has_volatiles: If set, then one or more members of the cluster are
> > volatile. *		Drivers should never touch this flag.
> > +  * @call_notify: If set, then call the handler's notify function whenever
> > the +  *		control's value changes.
> >    * @manual_mode_value: If the is_auto flag is set, then this is the value
> >    *		of the auto control that determines if that control is in
> >    *		manual mode. So if the value of the auto control equals this
> > @@ -119,6 +123,7 @@ struct v4l2_ctrl {
> >  	unsigned int is_private:1;
> >  	unsigned int is_auto:1;
> >  	unsigned int has_volatiles:1;
> > +	unsigned int call_notify:1;
> >  	unsigned int manual_mode_value:8;
> > 
> >  	const struct v4l2_ctrl_ops *ops;
> > @@ -177,6 +182,10 @@ struct v4l2_ctrl_ref {
> >    *		control is needed multiple times, so this is a simple
> >    *		optimization.
> >    * @buckets:	Buckets for the hashing. Allows for quick control lookup.
> > +  * @notify:	A notify callback that is called whenever the control 
> changes
> > value. +  *		Note that the handler's lock is held when the notify 
> function
> > +  *		is called!
> > +  * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
> >    * @nr_of_buckets: Total number of buckets in the array.
> >    * @error:	The error code of the first failed control addition.
> >    */
> > @@ -187,6 +196,8 @@ struct v4l2_ctrl_handler {
> >  	struct list_head ctrl_refs;
> >  	struct v4l2_ctrl_ref *cached;
> >  	struct v4l2_ctrl_ref **buckets;
> > +	v4l2_ctrl_notify_fnc notify;
> > +	void *notify_priv;
> >  	u16 nr_of_buckets;
> >  	int error;
> >  };
> > @@ -488,6 +499,20 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl
> > *ctrl) mutex_unlock(ctrl->handler->lock);
> >  }
> > 
> > +/** v4l2_ctrl_notify() - Function to set a notify callback for a control.
> > +  * @ctrl:	The control.
> > +  * @notify:	The callback function.
> > +  * @priv:	The callback private handle, passed as argument to the callback.
> > +  *
> > +  * This function sets a callback function for the control. If @ctrl is
> > NULL, +  * then it will do nothing. If @notify is NULL, then the notify
> > callback will +  * be removed.
> > +  *
> > +  * There can be only one notify. If another already exists, then a WARN_ON
> > +  * will be issued and the function will do nothing.
> > +  */
> > +void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify,
> > void *priv); +
> >  /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from
> > within a driver. * @ctrl:	The control.
> >    *
> 
