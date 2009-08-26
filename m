Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40553 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756771AbZHZGOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 02:14:05 -0400
Date: Wed, 26 Aug 2009 08:14:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: Re: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use
 skip_top_lines in soc-camera
In-Reply-To: <200908252147.49843.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0908260810550.5167@axis700.grange>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
 <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
 <200908252117.45230.hverkuil@xs4all.nl> <200908252147.49843.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Aug 2009, Laurent Pinchart wrote:

> On Tuesday 25 August 2009 21:17:45 Hans Verkuil wrote:
> > On Tuesday 25 August 2009 21:00:19 Aguirre Rodriguez, Sergio Alberto wrote:
> > > Guennadi,
> > >
> > > Some comments I came across embedded below:
> > >
> > > <snip>
> > >
> > > > +
> > > > +/**
> > > > + * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
> > > > + * @enum_framesizes: enumerate supported framesizes
> > > > + * @enum_frameintervals: enumerate supported frame format intervals
> > > > + * @skip_top_lines: number of lines at the top of the image to be
> > > > skipped. This
> > > > + *		    is needed for some sensors, that corrupt several top
> > > > lines.
> > > > + */
> > > > +struct v4l2_subdev_sensor_ops {
> > > >  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
> > > > v4l2_frmsizeenum *fsize);
> > > >  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> > > > v4l2_frmivalenum *fival);
> > > > +	int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> > > >  };
> > >
> > > 1. I honestly find a bit misleading the skip_top_lines name, since that
> > > IMO could be misunderstood that the called function will DO skip lines in
> > > the sensor, which is not the intended response...
> > >
> > > How about g_skip_top_lines, or get_skip_top_lines, or something that
> > > clarifies it's a "get information" abstraction interface?
> >
> > Good point. g_skip_top_lines is a better choice.
> >
> > > 2. Why enumeration mechanisms are not longer needed for a video device?
> > > (You're removing them from video_ops)
> >
> > Because these ops are closely related to sensor devices. They do not
> > normally apply to generic video devices. The addition of this new operation
> > is a good moment to move all sensor-specific ops to this new sensor_ops
> > struct.
> >
> > > 3. Wouldn't it be better to report a valid region, instead of just the
> > > top lines? I think that should be already covered by the driver reporting
> > > the valid size regions on enumeration, no?
> >
> > This has nothing to do with a valid region. No matter what region you
> > capture, the first X lines will always be corrupt for some sensors.
> > Something that clearly needs to be clarified in the comments.
> 
> Could such sensors corrupt the bottom Y lines too, and maybe some columns on 
> the sides ? In that case a "non-corrupted" region would make sense (but would 
> be more difficult to handle).

BTW, Nate (added to CC) has also confirmed, that he also worked with such 
sensors, and also with those, corrupting a few first frames. We so far, 
however, do not implement his proposal to also handle those cameras, it 
has instead been decided to deal with them when / if they appear in the 
mainline.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
