Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:46521 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab0I3MrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 08:47:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [git:v4l-dvb/v2.6.37] V4L/DVB: V4L2: add a generic function to find the nearest discrete format to the required one
Date: Thu, 30 Sep 2010 14:47:07 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <E1P1Hj6-0007m4-4n@www.linuxtv.org> <201009301429.10897.hverkuil@xs4all.nl>
In-Reply-To: <201009301429.10897.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301447.08813.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 30 September 2010 14:29:10 Hans Verkuil wrote:
> On Thursday, September 30, 2010 13:50:00 Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following
> > patch were queued at the http://git.linuxtv.org/media-tree.git tree:
> > 
> > Subject: V4L/DVB: V4L2: add a generic function to find the nearest
> > discrete format to the required one Author:  Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de>
> > Date:    Fri Aug 27 13:41:44 2010 -0300
> > 
> > Many video drivers implement a fixed set of frame formats and thus face a
> > task of finding the best match for a user-requested format. Implementing
> > this in a generic function has also an advantage, that different drivers
> > with similar supported format sets will select the same format for the
> > user, which improves consistency across drivers.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> >  drivers/media/video/v4l2-common.c |   24 ++++++++++++++++++++++++
> >  include/linux/videodev2.h         |    8 ++++++++
> >  2 files changed, 32 insertions(+), 0 deletions(-)
> 
> <snip>
> 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index b06479f..957d5b0 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -397,6 +397,14 @@ struct v4l2_frmsize_discrete {
> > 
> >  	__u32			height;		/* Frame height [pixel] */
> >  
> >  };
> > 
> > +struct v4l2_discrete_probe {
> > +	const struct v4l2_frmsize_discrete	*sizes;
> > +	int					num_sizes;
> > +};
> > +
> > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > v4l2_discrete_probe *probe, +						       s32 width, s32 
height);
> > +
> > 
> >  struct v4l2_frmsize_stepwise {
> >  
> >  	__u32			min_width;	/* Minimum frame width [pixel] */
> >  	__u32			max_width;	/* Maximum frame width [pixel] */
> 
> ??? What is this doing in videodev2.h? This belongs in v4l2-common.h!
> Both the return pointer and the probe pointer can be const as well.
> 
> I'll make a patch for this since I've forgotten to adjust several
> videobuf_queue_*_init functions as well in my bkl patch :-(

And when did that get merged ? We haven't reached any agreement on this API 
change. It's pretty useless in its current form and will just contribute to 
the V4L2 kernel API bloat.

-- 
Regards,

Laurent Pinchart
