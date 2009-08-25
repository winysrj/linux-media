Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33438 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZHYTok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 15:44:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use skip_top_lines in soc-camera
Date: Tue, 25 Aug 2009 21:47:49 +0200
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange> <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com> <200908252117.45230.hverkuil@xs4all.nl>
In-Reply-To: <200908252117.45230.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908252147.49843.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 25 August 2009 21:17:45 Hans Verkuil wrote:
> On Tuesday 25 August 2009 21:00:19 Aguirre Rodriguez, Sergio Alberto wrote:
> > Guennadi,
> >
> > Some comments I came across embedded below:
> >
> > <snip>
> >
> > > +
> > > +/**
> > > + * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
> > > + * @enum_framesizes: enumerate supported framesizes
> > > + * @enum_frameintervals: enumerate supported frame format intervals
> > > + * @skip_top_lines: number of lines at the top of the image to be
> > > skipped. This
> > > + *		    is needed for some sensors, that corrupt several top
> > > lines.
> > > + */
> > > +struct v4l2_subdev_sensor_ops {
> > >  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
> > > v4l2_frmsizeenum *fsize);
> > >  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> > > v4l2_frmivalenum *fival);
> > > +	int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> > >  };
> >
> > 1. I honestly find a bit misleading the skip_top_lines name, since that
> > IMO could be misunderstood that the called function will DO skip lines in
> > the sensor, which is not the intended response...
> >
> > How about g_skip_top_lines, or get_skip_top_lines, or something that
> > clarifies it's a "get information" abstraction interface?
>
> Good point. g_skip_top_lines is a better choice.
>
> > 2. Why enumeration mechanisms are not longer needed for a video device?
> > (You're removing them from video_ops)
>
> Because these ops are closely related to sensor devices. They do not
> normally apply to generic video devices. The addition of this new operation
> is a good moment to move all sensor-specific ops to this new sensor_ops
> struct.
>
> > 3. Wouldn't it be better to report a valid region, instead of just the
> > top lines? I think that should be already covered by the driver reporting
> > the valid size regions on enumeration, no?
>
> This has nothing to do with a valid region. No matter what region you
> capture, the first X lines will always be corrupt for some sensors.
> Something that clearly needs to be clarified in the comments.

Could such sensors corrupt the bottom Y lines too, and maybe some columns on 
the sides ? In that case a "non-corrupted" region would make sense (but would 
be more difficult to handle).

-- 
Regards,

Laurent Pinchart
