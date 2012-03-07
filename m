Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54437 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2CGSwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 13:52:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 27/35] omap3isp: Introduce isp_video_check_external_subdevs()
Date: Wed, 07 Mar 2012 19:52:55 +0100
Message-ID: <1513668.GA27SF7oCM@avalon>
In-Reply-To: <20120307174946.GD1476@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain> <51199527.ynQze3IDdP@avalon> <20120307174946.GD1476@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 07 March 2012 19:49:46 Sakari Ailus wrote:
> On Wed, Mar 07, 2012 at 11:43:31AM +0100, Laurent Pinchart wrote:
> > On Tuesday 06 March 2012 18:33:08 Sakari Ailus wrote:
> > > isp_video_check_external_subdevs() will retrieve external subdev's
> > > bits-per-pixel and pixel rate for the use of other ISP subdevs at
> > > streamon
> > > time. isp_video_check_external_subdevs() is called after pipeline
> > > validation.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/video/omap3isp/ispvideo.c |   75
> > >  ++++++++++++++++++++++++++++
> > >  1 files changed, 75 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > > b/drivers/media/video/omap3isp/ispvideo.c index 4bc9cca..ef5c770 100644
> > > --- a/drivers/media/video/omap3isp/ispvideo.c
> > > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > > @@ -934,6 +934,77 @@ isp_video_dqbuf(struct file *file, void *fh, struct
> > > v4l2_buffer *b) file->f_flags & O_NONBLOCK);
> > > 
> > >  }
> > > 
> > > +static int isp_video_check_external_subdevs(struct isp_pipeline *pipe)
> > > +{
> > > +	struct isp_device *isp =
> > > +		container_of(pipe, struct isp_video, pipe)->isp;
> > 
> > Any reason not to pass isp_device * from the caller to this function ?
> 
> I didn't simply because it was unnecessary. Should I? "pipe" is needed in
> any case.

It will look simpler (in my opinion), and will probably generate less code, so 
I think you should.

> > > +	struct media_entity *ents[] = {
> > > +		&isp->isp_csi2a.subdev.entity,
> > > +		&isp->isp_csi2c.subdev.entity,
> > > +		&isp->isp_ccp2.subdev.entity,
> > > +		&isp->isp_ccdc.subdev.entity
> > > +	};
> > > +	struct media_pad *source_pad;
> > > +	struct media_entity *source = NULL;
> > > +	struct media_entity *sink;
> > > +	struct v4l2_subdev_format fmt;
> > > +	struct v4l2_ext_controls ctrls;
> > > +	struct v4l2_ext_control ctrl;
> > > +	int i;
> > 
> > i is allowed to be unsigned in this driver as well ;-)
> 
> unsigned... we meet again!
> 
> > > +	int ret = 0;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(ents); i++) {
> > > +		/* Is the entity part of the pipeline? */
> > > +		if (!(pipe->entities & (1 << ents[i]->id)))
> > > +			continue;
> > > +
> > > +		/* ISP entities have always sink pad == 0. Find source. */
> > > +		source_pad = media_entity_remote_source(&ents[i]->pads[0]);
> > > +
> > 
> > Don't you usually avoid blank lines between a variable assignment and
> > checking it for an error condition ?
> 
> We do. Fixed.
> 
> > > +		if (source_pad == NULL)
> > > +			continue;
> > > +
> > > +		source = source_pad->entity;
> > > +		sink = ents[i];
> > > +		break;
> > > +	}
> > > +
> > > +	if (!source || media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
> > > +		return 0;
> > > +
> > > +	pipe->external = media_entity_to_v4l2_subdev(source);
> > > +
> > > +	fmt.pad = source_pad->index;
> > > +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > > +	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
> > > +			       pad, get_fmt, NULL, &fmt);
> > > +	BUG_ON(ret < 0);
> > 
> > That's a bit harsh. I'd rather return an error.
> 
> This is a driver BUG(). At the very least it's WARN() and return an error...
> I think I'll do dev_warn("message") and return the error.

dev_warn + return error sounds good.

> I actually add the same for the case where source is NULL --- that's also a
> driver bug.
> 
> > > +
> > > +	pipe->external_bpp = omap3isp_video_format_info(
> > > +		fmt.format.code)->bpp;
> > 
> > Maybe you could teachs emacs that 78 characters fit in a 80-columns line ?
> > :-)
> That's 79, not 78. And I need to scroll to the end of the line you wrote to
> see it after it has been prefixed with "> ". :-D
> 
> I think I've been renaming things and as a result it did fit on a single
> line.
> 
> > > +
> > > +	memset(&ctrls, 0, sizeof(ctrls));
> > > +	memset(&ctrl, 0, sizeof(ctrl));
> > > +
> > > +	ctrl.id = V4L2_CID_PIXEL_RATE;
> > > +
> > > +	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> > 
> > You can leave ctrl_class to 0.
> 
> Fixed.
> 
> > > +	ctrls.count = 1;
> > > +	ctrls.controls = &ctrl;
> > > +
> > > +	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
> > > +	if (ret < 0) {
> > > +		dev_warn(isp->dev,
> > > +			 "no pixel rate control in subdev %s\n",
> > 
> > No need to split this either.
> 
> Fixed.

-- 
Regards,

Laurent Pinchart

