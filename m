Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49667 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbBWXGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 18:06:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
Date: Tue, 24 Feb 2015 01:07:49 +0200
Message-ID: <1805679.hlRzVeq61B@avalon>
In-Reply-To: <54EAED82.5040804@xs4all.nl>
References: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com> <54EAED82.5040804@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 23 February 2015 10:06:10 Hans Verkuil wrote:
> On 02/17/2015 04:08 PM, Ricardo Ribalda Delgado wrote:
> > Volatile controls can change their value outside the v4l-ctrl framework.
> > We should ignore the cached written value of the ctrl when evaluating if
> > we should run s_ctrl.
> 
> I've been thinking some more about this (also due to some comments Laurent
> made on irc), and I think this should be done differently.
> 
> What you want to do here is to signal that setting this control will execute
> some action that needs to happen even if the same value is set twice.
> 
> That's not really covered by VOLATILE. Interestingly, the WRITE_ONLY flag is
> to be used for just that purpose, but this happens to be a R/W control, so
> that can't be used either.
> 
> What is needed is the following:
> 
> 1) Add a new flag: V4L2_CTRL_FLAG_ACTION.
> 2) Any control that sets FLAG_WRITE_ONLY should OR it with FLAG_ACTION (to
>    keep the current meaning of WRITE_ONLY).
> 3) Any control with FLAG_ACTION set should return changed == true in
>    cluster_changed.
> 4) Any control with FLAG_VOLATILE set should set ctrl->has_changed to false
>    to prevent generating the CH_VALUE control (that's a real bug).
> 
> Your control will now set FLAG_ACTION and FLAG_VOLATILE and it will do the
> right thing.

I'm not sure about Ricardo's use case, is it the one we've discussed on #v4l ? 
If so, and if I recall correctly, the idea was to perform an action with a 
parameter, and didn't require volatility.

> Basically what was missing was a flag to explicitly signal this 'writing
> executes an action' behavior. Trying to shoehorn that into the volatile
> flag or the write_only flag is just not right. It's a flag in its own right.

Just for the sake of exploring all options, what did you think about the idea 
of making button controls accept a value ?

Your proposal is interesting as well, but I'm not sure about the 
V4L2_CTRL_FLAG_ACTION name. Aren't all controls supposed to have an action of 
some sort ? That's nitpicking of course.

Also, should the action flag be automatically set for button controls ? Button 
controls would in a way become type-less controls with the action flag set, 
that's interesting. I suppose type-less controls without the action flag don't 
make sense.

> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > ---
> > v4: Hans Verkuil:
> > 
> > explicity set has_changed to false. and add comment
> > 
> >  drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)

-- 
Regards,

Laurent Pinchart

