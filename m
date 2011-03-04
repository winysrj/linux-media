Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2686 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1CDPJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 10:09:23 -0500
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2-ctrls: Add transaction support
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 4 Mar 2011 16:09:19 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041609.20053.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, March 04, 2011 14:36:40 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 04 March 2011 10:47:11 Hans Verkuil wrote:
> > Hi Laurent,
> > 
> > I'm afraid this approach won't work. See below for the details.
> > 
> > On Thursday, March 03, 2011 16:13:33 Laurent Pinchart wrote:
> > > Some hardware supports controls transactions. For instance, the MT9T001
> > > sensor can optionally shadow registers that influence the output image,
> > > allowing the host to explicitly control the shadow process.
> > > 
> > > To support such hardware, drivers need to be notified when a control
> > > transation is about to start and when it has finished. Add begin() and
> > > commit() callback functions to the v4l2_ctrl_handler structure to
> > > support such notifications.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/video/v4l2-ctrls.c |   42
> > >  +++++++++++++++++++++++++++++++++++-- include/media/v4l2-ctrls.h      
> > >  |    8 +++++++
> > >  2 files changed, 47 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/v4l2-ctrls.c
> > > b/drivers/media/video/v4l2-ctrls.c index 2412f08..d0e6265 100644
> > > --- a/drivers/media/video/v4l2-ctrls.c
> > > +++ b/drivers/media/video/v4l2-ctrls.c
> > > @@ -1264,13 +1264,22 @@ EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
> > > 
> > >  int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
> > >  {
> > >  
> > >  	struct v4l2_ctrl *ctrl;
> > > 
> > > +	unsigned int count = 0;
> > > 
> > >  	int ret = 0;
> > >  	
> > >  	if (hdl == NULL)
> > >  	
> > >  		return 0;
> > >  	
> > >  	mutex_lock(&hdl->lock);
> > > 
> > > -	list_for_each_entry(ctrl, &hdl->ctrls, node)
> > > +	list_for_each_entry(ctrl, &hdl->ctrls, node) {
> > > 
> > >  		ctrl->done = false;
> > > 
> > > +		count++;
> > > +	}
> > > +
> > > +	if (hdl->begin) {
> > > +		ret = hdl->begin(hdl, count == 1);
> > 
> > Note that count can be 0! In any case, rather then adding a counter you can
> > use list_empty() and list_is_singular().
> 
> OK.
> 
> > > +		if (ret)
> > > +			goto done;
> > > +	}
> > > 
> > >  	list_for_each_entry(ctrl, &hdl->ctrls, node) {
> > >  	
> > >  		struct v4l2_ctrl *master = ctrl->cluster[0];
> > > 
> > > @@ -1298,6 +1307,11 @@ int v4l2_ctrl_handler_setup(struct
> > > v4l2_ctrl_handler *hdl)
> > > 
> > >  			if (master->cluster[i])
> > >  			
> > >  				master->cluster[i]->done = true;
> > >  	
> > >  	}
> > > 
> > > +
> > > +	if (hdl->commit)
> > > +		hdl->commit(hdl, ret != 0);
> > > +
> > 
> > > +done:
> > I understand that you assume that all controls registered to a handler can
> > be used in a transaction. But isn't it possible that only a subset of the
> > controls is shadowed? And so only certain controls can be in a
> > transaction?
> > 
> > >  	mutex_unlock(&hdl->lock);
> > >  	return ret;
> > >  
> > >  }
> > > 
> > > @@ -1717,6 +1731,12 @@ static int try_or_set_ext_ctrls(struct
> > > v4l2_ctrl_handler *hdl,
> > > 
> > >  			return -EBUSY;
> > >  	
> > >  	}
> > > 
> > > +	if (set && hdl->begin) {
> > > +		ret = hdl->begin(hdl, cs->count == 1);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > 
> > You are assuming that all controls here are owned by the given control
> > handler. That's not necessarily the case though as a control handler can
> > inherit controls from another handler. So the cs array is an array of
> > controls where each control can be owned by a different handler.
> 
> Right. That will indeed be an issue.
> 
> > >  	for (i = 0; !ret && i < cs->count; i++) {
> > >  	
> > >  		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
> > >  		struct v4l2_ctrl *master = ctrl->cluster[0];
> > > 
> > > @@ -1747,6 +1767,10 @@ static int try_or_set_ext_ctrls(struct
> > > v4l2_ctrl_handler *hdl,
> > > 
> > >  		v4l2_ctrl_unlock(ctrl);
> > >  		cluster_done(i, cs, helpers);
> > >  	
> > >  	}
> > > 
> > > +
> > > +	if (set && hdl->commit)
> > > +		hdl->commit(hdl, ret == 0);
> > > +
> > 
> > If you rollback a transaction, then you also have a problem: if some of the
> > controls of the transaction succeeded then try_or_set_control_cluster()
> > will have set the current control value to the new value (since the 'set'
> > succeeded).
> > 
> > But if you rollback the transaction, then that means that the old value
> > isn't restored for such controls.
> > 
> > I don't see an easy solution for that offhand.
> > 
> > I really wonder whether you are not reinventing the control cluster here.
> > 
> > If you put all shadowed controls in a cluster, then it will behave exactly
> > the same as a transaction.
> > 
> > Yes, that might mean that all controls of a subdev are in a single cluster.
> > But so what? That's the way to atomically handle controls that in some
> > manner are related.
> 
> More and more sensors start to support control transactions. The MT9V034 even 
> supports two sets of control-related registers, with a single command to 
> switch between them. We need a way to support that in the control framework. 
> Putting all controls into a cluster seems like a dirty hack to workaround the 
> problem. The control framework will be less useful then.
> 
> If this is the only possible solution, then I would rename cluster to 
> something else, as the controls are definitely not a cluster. We could have a 
> flag that ask the control framework to handle all controls as if they're a big 
> cluster, and call s_ctrl only once per transaction.
> 
> It won't provide a way to configure two sets of controls and quickly swicth 
> between them though. This might need to be supported at some point.

I think the problem here is the term 'transaction'. That suggests atomicity. And
the only way to do that is with a cluster.

But what you really want is just to know when a bunch of controls is set for a
handler and when it is done. You don't need to rollback.

The control framework will do all reasonable checks for control values before
it attempts to change any control. So any failures to set a control are generally
due to hardware problems. If the applications tries to set 10 controls but the
fifth control fails, then the first four will be kept and are not rolled back.
How many controls succeeded are reported to the application via the error_idx
field.

So if those 10 controls are shadowed, then you just want to know when to start
setting the shadow controls and when it is done so you can commit them all at once.
So no rollback is necessary.

This is much easier to implement and drivers don't have to worry about rollback
either.

I hope my explanation is understandable. There is also a long comment block just
before the prepare_ext_ctrls() function in v4l2-ctrls.c that goes into more
detail on how the control framework handles extended controls.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
