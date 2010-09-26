Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:45119 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab0IZRfj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 13:35:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 5/9] v4l: Create v4l2 subdev file handle structure
Date: Sun, 26 Sep 2010 19:35:49 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-6-git-send-email-laurent.pinchart@ideasonboard.com> <201009261925.27051.hverkuil@xs4all.nl>
In-Reply-To: <201009261925.27051.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261935.50428.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sunday 26 September 2010 19:25:26 Hans Verkuil wrote:
> On Sunday, September 26, 2010 18:13:28 Laurent Pinchart wrote:
> > From: Stanimir Varbanov <svarbanov@mm-sol.com>
> > 
> > Used for storing subdev information per file handle and hold V4L2 file
> > handle.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Antti Koskipaa <antti.koskipaa@nokia.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/v4l2-subdev.c |   82
> >  +++++++++++++++++++++++++------------ include/media/v4l2-subdev.h      
> >  |   25 +++++++++++
> >  2 files changed, 80 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-subdev.c
> > b/drivers/media/video/v4l2-subdev.c index 731dc12..d2891c1 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -30,38 +30,66 @@
> > 
> >  #include <media/v4l2-fh.h>
> >  #include <media/v4l2-event.h>
> > 
> > +static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev
> > *sd) +{
> > +	/* Allocate probe format and crop in the same memory block */
> > +	fh->probe_fmt = kzalloc((sizeof(*fh->probe_fmt) +
> > +				sizeof(*fh->probe_crop)) * sd->entity.num_pads,
> > +				GFP_KERNEL);
> > +	if (fh->probe_fmt == NULL)
> > +		return -ENOMEM;
> 
> I really don't like the name 'probe' for this. I remember discussing it
> with you, Laurent, but I can't remember the word I came up with.
> 
> Can you remember what it was?

I remember a discussion, but we haven't agreed on a name. Do you dislike both 
"probe" and "active", or "probe" only ?

(BTW the name comes from the UVC spec, where a similar mechanism is used)

-- 
Regards,

Laurent Pinchart
