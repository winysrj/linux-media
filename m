Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4198 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZHYTRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 15:17:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [PATCH v2] v4l: add new v4l2-subdev sensor operations, use skip_top_lines in soc-camera
Date: Tue, 25 Aug 2009 21:17:45 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0908251855160.4810@axis700.grange> <Pine.LNX.4.64.0908252021200.4810@axis700.grange> <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444BC96E38@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908252117.45230.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 25 August 2009 21:00:19 Aguirre Rodriguez, Sergio Alberto wrote:
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
> 1. I honestly find a bit misleading the skip_top_lines name, since that IMO could be misunderstood that the called function will DO skip lines in the sensor, which is not the intended response...
> 
> How about g_skip_top_lines, or get_skip_top_lines, or something that clarifies it's a "get information" abstraction interface?

Good point. g_skip_top_lines is a better choice.

> 
> 2. Why enumeration mechanisms are not longer needed for a video device? (You're removing them from video_ops)

Because these ops are closely related to sensor devices. They do not normally
apply to generic video devices. The addition of this new operation is a good
moment to move all sensor-specific ops to this new sensor_ops struct.

> 
> 3. Wouldn't it be better to report a valid region, instead of just the top lines? I think that should be already covered by the driver reporting the valid size regions on enumeration, no?

This has nothing to do with a valid region. No matter what region you capture,
the first X lines will always be corrupt for some sensors. Something that
clearly needs to be clarified in the comments.

Regards,

	Hans

> 
> Regards,
> Sergio
> 
> > 
> >  struct v4l2_subdev_ops {
> > @@ -234,6 +245,7 @@ struct v4l2_subdev_ops {
> >  	const struct v4l2_subdev_tuner_ops *tuner;
> >  	const struct v4l2_subdev_audio_ops *audio;
> >  	const struct v4l2_subdev_video_ops *video;
> > +	const struct v4l2_subdev_sensor_ops *sensor;
> >  };
> > 
> >  #define V4L2_SUBDEV_NAME_SIZE 32
> > --
> > 1.6.2.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
