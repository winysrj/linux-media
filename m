Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56027 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab0KSNzJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 08:55:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] v4l: Add subdev sensor g_skip_frames operation
Date: Fri, 19 Nov 2010 14:55:12 +0100
Cc: linux-media@vger.kernel.org
References: <1290173202-28769-1-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1011191439030.20751@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1011191439030.20751@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191455.12632.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Guennadi,

On Friday 19 November 2010 14:49:44 Guennadi Liakhovetski wrote:
> On Fri, 19 Nov 2010, Laurent Pinchart wrote:
> > Some buggy sensors generate corrupt frames when the stream is started.
> > This new operation returns the number of corrupt frames to skip when
> > starting the stream.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  include/media/v4l2-subdev.h |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 04878e1..b196966 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -291,9 +291,13 @@ struct v4l2_subdev_pad_ops {
> > 
> >   *		      This is needed for some sensors, which always corrupt
> >   *		      several top lines of the output image, or which send their
> >   *		      metadata in them.
> > 
> > + * @g_skip_frames: number of frames to skip at stream start. This is
> > needed for + * 		   buggy sensors that generate faulty frames when they
> > are + * 		   turned on.
> > 
> >   */
> >  
> >  struct v4l2_subdev_sensor_ops {
> >  
> >  	int (*g_skip_top_lines)(struct v4l2_subdev *sd, u32 *lines);
> > 
> > +	int (*g_skip_frames)(struct v4l2_subdev *sd, u32 *frames);
> 
> Well, yes, this would be useful, but, I think, it is a part of a larger
> problem - general video quality from sensors. Like, I think, there are
> other situations, when the sensor driver knows, that the next few frames
> will be of poor quality. E.g., when changing some parameters, which will
> make the sensor re-adjust auto-exposure, auto-gain or something similar.
> So, we can either just handle this one specific case, or try to design a
> more generic approach, or leave frame quality analysis completely to the
> user-space. Like - for a normal generic mplayer, just streaming video to
> an output device - you don't really care in most cases. If recording video
> - you edit it afterwords, if building an industrial quality
> purpose-designed application - it will, probably, take care of these
> things itself. And yes, there is also out-of-band data, that can carry
> such quality-related information. So, this is just one bit of a bigger
> problem, no idea though, wheather it's worth trying to tackle all those
> issues at once or better just fix this one small specific problem.

Lots of different issues there. Quality handling should be implemented in 
userspace, but drivers need to provide enough information to 
applications/libraries. Metadata could be bundled with frame using the recent 
multiplane formats support infrastructure.

The purpose of this operation is to skip frames that are know to be real bad. 
Think of a buggy sensor that outputs a frame of complete garbage when you 
start the stream. Not just bad quality data, but real garbage (either random 
or a flat color).

-- 
Regards,

Laurent Pinchart
