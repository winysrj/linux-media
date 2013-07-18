Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:13470 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab3GRITY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 04:19:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 4/5] v4l2: add a motion detection event.
Date: Thu, 18 Jul 2013 10:19:18 +0200
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl> <1372422454-13752-5-git-send-email-hverkuil@xs4all.nl> <2083405.s15EBXhjSd@avalon>
In-Reply-To: <2083405.s15EBXhjSd@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307181019.18959.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 18 July 2013 02:14:28 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 28 June 2013 14:27:33 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  include/uapi/linux/videodev2.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 5cbe815..f926209 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1721,6 +1721,7 @@ struct v4l2_streamparm {
> >  #define V4L2_EVENT_EOS				2
> >  #define V4L2_EVENT_CTRL				3
> >  #define V4L2_EVENT_FRAME_SYNC			4
> > +#define V4L2_EVENT_MOTION_DET			5
> >  #define V4L2_EVENT_PRIVATE_START		0x08000000
> > 
> >  /* Payload for V4L2_EVENT_VSYNC */
> > @@ -1752,12 +1753,28 @@ struct v4l2_event_frame_sync {
> >  	__u32 frame_sequence;
> >  };
> > 
> > +#define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ	(1 << 0)
> > +
> > +/**
> > + * struct v4l2_event_motion_det - motion detection event
> > + * @flags:             if V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ is set, then the
> > + *                     frame_sequence field is valid.
> > + * @frame_sequence:    the frame sequence number associated with this
> > event.
> > + * @region_mask:       which regions detected motion.
> > + */
> > +struct v4l2_event_motion_det {
> > +	__u32 flags;
> > +	__u32 frame_sequence;
> > +	__u32 region_mask;
> 
> Will a 32-bit region mask be extensible enough ? What about hardware that 
> could report motion detection as a (possibly low resolution) binary image ?

I'm not sure whether we should be bothered about this. The struct can easily
be extended later.

Also, in your particular example I would actually expect that that would either
need support for 'large payload events', or you would call G_MATRIX to get that
image.

> > +};
> > +
> >  struct v4l2_event {
> >  	__u32				type;
> >  	union {
> >  		struct v4l2_event_vsync		vsync;
> >  		struct v4l2_event_ctrl		ctrl;
> >  		struct v4l2_event_frame_sync	frame_sync;
> > +		struct v4l2_event_motion_det	motion_det;
> >  		__u8				data[64];
> >  	} u;
> >  	__u32				pending;
> 

Regards,

	Hans
