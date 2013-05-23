Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:49202 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088Ab3EWKjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:39:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
Date: Thu, 23 May 2013 12:39:32 +0200
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <1368692074-483-3-git-send-email-a.hajda@samsung.com> <20130516223451.GA2077@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130516223451.GA2077@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231239.32156.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 17 May 2013 00:34:51 Sakari Ailus wrote:
> Hi Andrzej,
> 
> Thanks for the patchset!
> 
> On Thu, May 16, 2013 at 10:14:33AM +0200, Andrzej Hajda wrote:
> > This patch adds managed version of initialization
> > function for v4l2 control handler.
> > 
> > Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> > Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > v3:
> > 	- removed managed cleanup
> > v2:
> > 	- added missing struct device forward declaration,
> > 	- corrected few comments
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
> >  include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
> >  2 files changed, 48 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index ebb8e48..f47ccfa 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
> >  }
> >  EXPORT_SYMBOL(v4l2_ctrl_handler_free);
> >  
> > +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
> > +{
> > +	struct v4l2_ctrl_handler **hdl = res;
> > +
> > +	v4l2_ctrl_handler_free(*hdl);
> 
> v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
> existence of hdl. By default hdl->lock is in the handler, but it may also be
> elsewhere, e.g. in a driver-specific device struct such as struct
> smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
> anything guarantees that hdl->mutex still exists at the time the device is
> removed.

If it is a driver-managed lock, then the driver should also be responsible for
that lock during the life-time of the control handler. I think that is a fair
assumption.

> I have to say I don't think it's neither meaningful to acquire that mutex in
> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
> anyway: reference counting would be needed to prevent bad things from
> happening, in case the drivers wouldn't take care of that.

It's probably not meaningful today, but it might become meaningful in the
future. And in any case, not taking the lock when manipulating internal
lists is very unexpected even though it might work with today's use cases.

Regards,

	Hans
