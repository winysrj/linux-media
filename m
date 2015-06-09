Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47934 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753518AbbFIIFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 04:05:30 -0400
Date: Tue, 9 Jun 2015 11:05:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	j.anaszewski@samsung.com, cooloney@gmail.com,
	s.nawrocki@samsung.com, mchehab@osg.samsung.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH v1.1 1/5] v4l: async: Add a pointer to of_node to struct
 v4l2_subdev, match it
Message-ID: <20150609080523.GC5904@valkosipuli.retiisi.org.uk>
References: <4071589.mUaJIGvIJX@avalon>
 <1433111079-22457-1-git-send-email-sakari.ailus@iki.fi>
 <1668366.2mMvbSMUnT@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668366.2mMvbSMUnT@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jun 02, 2015 at 05:47:12AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch. Please see below for one small comment.
> 
> On Monday 01 June 2015 01:24:39 Sakari Ailus wrote:
> > V4L2 async sub-devices are currently matched (OF case) based on the struct
> > device_node pointer in struct device. LED devices may have more than one
> > LED, and in that case the OF node to match is not directly the device's
> > node, but a LED's node.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > since v1:
> > 
> > - Move conditional setting of struct v4l2_subdev.of_node from
> >   v4l2_device_register_subdev() to v4l2_async_register_subdev.
> > 
> > - Remove the check for NULL struct v4l2_subdev.of_node from match_of() as
> >   it's no longer needed.
> > 
> > - Unconditionally state in the struct v4l2_subdev.of_node field comment that
> > the field contains (a pointer to) the sub-device's of_node.
> > 
> >  drivers/media/v4l2-core/v4l2-async.c | 34 +++++++++++++++++++++------------
> >  include/media/v4l2-subdev.h          |  2 ++
> >  2 files changed, 24 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-async.c
> > b/drivers/media/v4l2-core/v4l2-async.c index 85a6a34..b0badac 100644
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> 
> [snip]
> 
> > @@ -266,6 +273,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> >  {
> >  	struct v4l2_async_notifier *notifier;
> > 
> > +	if (!sd->of_node && sd->dev)
> > +		sd->of_node = sd->dev->of_node;
> > +
> 
> I think we don't need to take a reference to of_node here, as we assume 
> there's a reference to dev through the whole life of the subdev, and dev 
> should have a reference to of_node, but could you double-check ?
> 
> If that's indeed not a problem,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Good question.

I don't think a reference would be needed also because we are only
interested in the pointer value itself, the memory the pointer is pointing
to is never accessed.

As far as I can tell, there's no reference through the device.

I can add a comment on this if you like. Perhaps it'd be a good idea
actually, as you usually do take a reference in such cases.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
