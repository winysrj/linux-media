Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39627 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1KYM6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 07:58:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC/PATCH 1/3] v4l: Introduce integer menu controls
Date: Fri, 25 Nov 2011 13:58:27 +0100
Cc: linux-media@vger.kernel.org, snjw23@gmail.com, hverkuil@xs4all.nl
References: <20111124161228.GA29342@valkosipuli.localdomain> <201111251343.13776.laurent.pinchart@ideasonboard.com> <20111125125650.GE29342@valkosipuli.localdomain>
In-Reply-To: <20111125125650.GE29342@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251358.27725.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 25 November 2011 13:56:50 Sakari Ailus wrote:
> On Fri, Nov 25, 2011 at 01:43:12PM +0100, Laurent Pinchart wrote:
> > On Friday 25 November 2011 13:02:02 Sakari Ailus wrote:
> > > On Fri, Nov 25, 2011 at 11:28:46AM +0100, Laurent Pinchart wrote:
> > > > On Thursday 24 November 2011 17:12:50 Sakari Ailus wrote:
> > > ...
> > > 
> > > > > @@ -1440,12 +1458,13 @@ struct v4l2_ctrl
> > > > > *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl, u32 flags;
> > > > > 
> > > > >  	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def,
> > > > >  	&flags);
> > > > > 
> > > > > -	if (type != V4L2_CTRL_TYPE_MENU) {
> > > > > +	if (type != V4L2_CTRL_TYPE_MENU
> > > > > +	    && type != V4L2_CTRL_TYPE_INTEGER_MENU) {
> > > > > 
> > > > >  		handler_set_err(hdl, -EINVAL);
> > > > >  		return NULL;
> > > > >  	
> > > > >  	}
> > > > >  	return v4l2_ctrl_new(hdl, ops, id, name, type,
> > > > > 
> > > > > -				    0, max, mask, def, flags, qmenu, NULL);
> > > > > +			     0, max, mask, def, flags, qmenu, NULL, NULL);
> > > > 
> > > > You pass NULL to the v4l2_ctrl_new() qmenu_int argument, which will
> > > > make the function fail for integer menu controls. Do you expect
> > > > standard integer menu controls to share a list of values ? If not,
> > > > what about modifying v4l2_ctrl_new_std_menu() to take a list of
> > > > values (or alternatively forbidding the function from being used for
> > > > integer menu controls) ?
> > > 
> > > We currently have no integer menu controls, let alone one which would
> > > have a set of standard values. We need same functionality as in
> > > v4l2_ctrl_get_menu() for integer menus when we add the first
> > > standardised integer menu control. I think it could be added at that
> > > time, or I could implement a v4l2_ctrl_get_integer_menu() which would
> > > do nothing.
> > > 
> > > What do you think?
> > 
> > I was just wondering if we will ever have a standard menu control with
> > standard integer items. If that never happens, v4l2_ctrl_new_std_menu()
> > needs to either take a qmenu_int array, or reject integer menu controls
> > completely. I would thus delay adding the V4L2_CTRL_TYPE_INTEGER_MENU
> > check to the function as it wouldn't work anyway (or, alternatively, we
> > would add the qmenu_int argument now).
> 
> Either one, yes. I think I'll add a separate patch adding standard integer
> menus and remove the check from this one.
> 
> There'll definitely be a need for them. For example, there are bit rate
> menus in the standard menu type controls that ideally should be integers.

Sure, but I doubt that the bit rates themselves will be standard.

> We won't change them but there will be others. Or I'd be very surprised if
> there were not!

-- 
Regards,

Laurent Pinchart
