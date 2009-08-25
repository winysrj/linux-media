Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53498 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756005AbZHYTWr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 15:22:47 -0400
Date: Tue, 25 Aug 2009 21:22:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use
 skip_top_lines in soc-camera
In-Reply-To: <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0908252112210.4810@axis700.grange>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange>
 <200908251902.03790.hverkuil@xs4all.nl> <Pine.LNX.4.64.0908252021200.4810@axis700.grange>
 <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Aug 2009, Aguirre Rodriguez, Sergio Alberto wrote:

> Guennadi,
> 
> Some comments I came across embedded below:
> 
> <snip>
> 
> > +
> > +/**
> > + * struct v4l2_subdev_sensor_ops - v4l2-subdev sensor operations
> > + * @enum_framesizes: enumerate supported framesizes
> > + * @enum_frameintervals: enumerate supported frame format intervals
> > + * @skip_top_lines: number of lines at the top of the image to be
> > skipped. This
> > + *		    is needed for some sensors, that corrupt several top
> > lines.
> > + */
> > +struct v4l2_subdev_sensor_ops {
> >  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct
> > v4l2_frmsizeenum *fsize);
> >  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> > v4l2_frmivalenum *fival);
> > +	int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> >  };
> 
> 1. I honestly find a bit misleading the skip_top_lines name, since that 
> IMO could be misunderstood that the called function will DO skip lines 
> in the sensor, which is not the intended response...
> 
> How about g_skip_top_lines, or get_skip_top_lines, or something that 
> clarifies it's a "get information" abstraction interface?

skip_top_lines was a suggestion of Hans, maybe you're right and 
g_skip_top_lines better describes the purpose of this function, but since 
Hans is the primary author and maintainer of this API, let's see what he 
says.

> 2. Why enumeration mechanisms are not longer needed for a video device? 
> (You're removing them from video_ops)

Also this was Hans' suggestion - he said, that they are only needed for 
sensors.

> 3. Wouldn't it be better to report a valid region, instead of just the 
> top lines? I think that should be already covered by the driver 
> reporting the valid size regions on enumeration, no?

No, this is something different. This is not the same as what cropcap 
delivers. Some sensors (e.g., mt9v022) corrupt some (1 with mt9v022) top 
lines, regardless what cropping you configure. So, you have to configure 
your bridge (or an SoC camera host) to skip that many lines at the top of 
an image. I am not sure whether all bridges can do this, fortunately, 
PXA270 and i.MX31 (not yet implemented), to which I can connect mt9v022, 
can do this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
