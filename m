Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52285 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaCKLBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 07:01:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 26/48] v4l: Add support for DV timings ioctls on subdev nodes
Date: Tue, 11 Mar 2014 12:02:49 +0100
Message-ID: <2012228.WpjpKDm9d9@avalon>
In-Reply-To: <531EE7AF.2050509@xs4all.nl>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <1394493359-14115-27-git-send-email-laurent.pinchart@ideasonboard.com> <531EE7AF.2050509@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 March 2014 11:38:39 Hans Verkuil wrote:
> On 03/11/14 00:15, Laurent Pinchart wrote:
> > Validate the pad field in the core code whenever specified.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    | 27 +++++++++++++----
> >  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   | 30 +++++++++++++----
> >  drivers/media/v4l2-core/v4l2-subdev.c              | 27 +++++++++++++++++
> >  include/uapi/linux/v4l2-subdev.h                   |  5 ++++
> >  4 files changed, 77 insertions(+), 12 deletions(-)

[snip]

> > diff --git a/include/uapi/linux/v4l2-subdev.h
> > b/include/uapi/linux/v4l2-subdev.h index 9fe3493..6f5c5de 100644
> > --- a/include/uapi/linux/v4l2-subdev.h
> > +++ b/include/uapi/linux/v4l2-subdev.h
> > @@ -169,5 +169,10 @@ struct v4l2_subdev_edid {
> > 
> >  #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct
> > v4l2_subdev_selection)
> >  #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct
> > v4l2_subdev_edid)
> >  #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct
> > v4l2_subdev_edid)
> > +#define VIDIOC_SUBDEV_DV_TIMINGS_CAP		_IOWR('V', 42, struct
> > v4l2_dv_timings_cap)
> > +#define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 43, struct
> > v4l2_enum_dv_timings)
> > +#define VIDIOC_SUBDEV_QUERY_DV_TIMINGS		_IOR('V', 44, struct
> > v4l2_dv_timings)
> > +#define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 45, struct
> > v4l2_dv_timings)
> > +#define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 46, struct
> > v4l2_dv_timings)
>
> Is there a reason for not using the same ioctls numbers as in videodev2.h?
> The advantage is that the core compat32 support will automatically work (it
> doesn't have to do anything yet, but that might change in the future).
> 
> Unless there is a really good reason I would keep them the same, just as we
> did with the EDID ioctls.

I'll fix that.

-- 
Regards,

Laurent Pinchart

