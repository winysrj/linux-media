Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2408 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2GWSAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:00:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2] v4l2-ctrls: Add v4l2_ctrl_[gs]_ctrl_int64()
Date: Mon, 23 Jul 2012 20:00:41 +0200
Cc: linux-media@vger.kernel.org
References: <1343052160-24229-1-git-send-email-laurent.pinchart@ideasonboard.com> <201207231705.35789.hverkuil@xs4all.nl> <3976016.Ryl9sFuTOd@avalon>
In-Reply-To: <3976016.Ryl9sFuTOd@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207232000.41823.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 19:16:03 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 23 July 2012 17:05:35 Hans Verkuil wrote:
> > On Mon July 23 2012 16:02:40 Laurent Pinchart wrote:
> > > These helper functions get and set a 64-bit control's value from within
> > > a driver. They are similar to v4l2_ctrl_[gs]_ctrl() but operate on
> > > 64-bit integer controls instead of 32-bit controls.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> [snip]
> 
> > > -static int get_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
> > > +static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
> > > 
> > >  {
> > >  
> > >  	struct v4l2_ctrl *master = ctrl->cluster[0];
> > >  	int ret = 0;
> > >  	int i;
> > > 
> > > +	/* String controls are not supported. The new_to_user() and
> > > +	 * cur_to_user() calls below would need to be fixed not to access
> > > +	 * userspace memory.
> > 
> > Just one small suggestion: change this comment to:
> > 
> > 	/* String controls are not supported. The new_to_user() and
> > 	 * cur_to_user() calls below would need to be modified not to access
> > 	 * userspace memory when called from get_ctrl().
> > 	 */
> > 
> > And a similar change in the comment with set_ctrl.
> > 
> > The word 'fixed' suggested that new_to_user etc. were broken, which isn't
> > the case. We are just using it in a special situation.
> 
> OK. Fixed.
> 
> > With the above change to get/set_ctrl you can add my
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thank you. I'll resubmit the patch (along with a driver patch that uses it). 
> Would you like to push it through your tree ?

You take it. I assume you have a driver that needs it, so it's better if it
goes in together with that driver.

Regards,

	Hans
