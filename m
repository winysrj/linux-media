Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751389AbeEPKqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 06:46:20 -0400
Date: Wed, 16 May 2018 13:46:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 12/28] v4l2-ctrls: add core request support
Message-ID: <20180516104618.56fqtmxjutzldhw5@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516101934.dekzi6zlyzqbs5t6@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 16, 2018 at 01:19:34PM +0300, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, May 03, 2018 at 04:53:02PM +0200, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Integrate the request support. This adds the v4l2_ctrl_request_complete
> > and v4l2_ctrl_request_setup functions to complete a request and (as a
> > helper function) to apply a request to the hardware.
> > 
> > It takes care of queuing requests and correctly chaining control values
> > in the request queue.
> > 
> > Note that when a request is marked completed it will copy control values
> > to the internal request state. This can be optimized in the future since
> > this is sub-optimal when dealing with large compound and/or array controls.
> > 
> > For the initial 'stateless codec' use-case the current implementation is
> > sufficient.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c | 331 ++++++++++++++++++++++++++-
> >  include/media/v4l2-ctrls.h           |  23 ++
> >  2 files changed, 348 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index da4cc1485dc4..56b986185463 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -3429,6 +3602,152 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
> >  }
> >  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
> >  
> > +void v4l2_ctrl_request_complete(struct media_request *req,
> > +				struct v4l2_ctrl_handler *main_hdl)
> > +{
> > +	struct media_request_object *obj;
> > +	struct v4l2_ctrl_handler *hdl;
> > +	struct v4l2_ctrl_ref *ref;
> > +
> > +	if (!req || !main_hdl)
> > +		return;
> > +
> > +	obj = media_request_object_find(req, &req_ops, main_hdl);
> > +	if (!obj)
> > +		return;
> > +	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
> > +
> > +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> > +		struct v4l2_ctrl *ctrl = ref->ctrl;
> > +		struct v4l2_ctrl *master = ctrl->cluster[0];
> > +		unsigned int i;
> > +
> > +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> > +			ref->req = ref;
> > +
> > +			v4l2_ctrl_lock(master);
> > +			/* g_volatile_ctrl will update the current control values */
> > +			for (i = 0; i < master->ncontrols; i++)
> > +				cur_to_new(master->cluster[i]);
> > +			call_op(master, g_volatile_ctrl);
> > +			new_to_req(ref);
> > +			v4l2_ctrl_unlock(master);
> > +			continue;
> > +		}
> > +		if (ref->req == ref)
> > +			continue;
> > +
> > +		v4l2_ctrl_lock(ctrl);
> > +		if (ref->req)
> > +			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
> > +		else
> > +			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
> > +		v4l2_ctrl_unlock(ctrl);
> > +	}
> > +
> > +	WARN_ON(!hdl->request_is_queued);
> > +	list_del_init(&hdl->requests_queued);
> > +	hdl->request_is_queued = false;
> > +	media_request_object_complete(obj);
> > +	media_request_object_put(obj);
> > +}
> > +EXPORT_SYMBOL(v4l2_ctrl_request_complete);
> > +
> > +void v4l2_ctrl_request_setup(struct media_request *req,
> > +			     struct v4l2_ctrl_handler *main_hdl)
> 
> Drivers are expected to use this function internally to make use of the
> control values in the request. Is that your thinking as well?
> 
> The problem with this implementation is that once a driver eventually gets
> a callback (s_ctrl), the callback doesn't have the information on the
> request. That means the driver has no means to associate the control value
> to the request anymore --- and that is against the very purpose of the
> function.
> 
> Instead, I'd add a new argument to the callback function --- the request
> --- or add another callback function to be used for applying control values
> for requests. Or alternatively, provide an easy way to enumerate the
> controls and their values in a control handler. For the driver must store

To address this fully --- using S_EXT_CTRLS on uAPI to the control handler
should likely be prevented as long as there are request objects related to
that handler. Or at least request objects that are not completed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
