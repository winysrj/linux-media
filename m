Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:61362 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1HHMm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 08:42:56 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Mon, 8 Aug 2011 14:40:27 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange> <201108081116.41126.hansverk@cisco.com> <201108081340.23999.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108081340.23999.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108081440.27488.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, August 08, 2011 13:40:23 Laurent Pinchart wrote:
> On Monday 08 August 2011 11:16:41 Hans Verkuil wrote:
> > On Friday, August 05, 2011 09:47:13 Guennadi Liakhovetski wrote:
> > > A possibility to preallocate and initialise buffers of different sizes
> > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > v4:
> > > 
> > > 1. CREATE_BUFS now takes an array of plane sizes and a fourcc code in 
its
> > > 
> > >    argument, instead of a frame format specification, including
> > >    documentation update
> > > 
> > > 2. documentation improvements, as suggested by Hans
> > > 3. increased reserved fields to 18, as suggested by Sakari
> > > 
> > >  Documentation/DocBook/media/v4l/io.xml             |   17 ++
> > >  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
> > >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  161
> > 
> > ++++++++++++++++++++
> > 
> > >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
> > >  drivers/media/video/v4l2-compat-ioctl32.c          |    6 +
> > >  drivers/media/video/v4l2-ioctl.c                   |   26 +++
> > >  include/linux/videodev2.h                          |   18 +++
> > >  include/media/v4l2-ioctl.h                         |    2 +
> > >  8 files changed, 328 insertions(+), 0 deletions(-)
> > >  create mode 100644
> > >  Documentation/DocBook/media/v4l/vidioc-create-bufs.xml create mode
> > >  100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > 
> > <snip>
> > 
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index fca24cc..3cd0cb3 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -653,6 +653,9 @@ struct v4l2_buffer {
> > > 
> > >  #define V4L2_BUF_FLAG_ERROR	0x0040
> > >  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid 
*/
> > >  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> > > 
> > > +/* Cache handling flags */
> > > +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> > > +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
> > > 
> > >  /*
> > >  
> > >   *	O V E R L A Y   P R E V I E W
> > > 
> > > @@ -2092,6 +2095,18 @@ struct v4l2_dbg_chip_ident {
> > > 
> > >  	__u32 revision;    /* chip revision, chip specific */
> > >  
> > >  } __attribute__ ((packed));
> > > 
> > > +/* VIDIOC_CREATE_BUFS */
> > > +struct v4l2_create_buffers {
> > > +	__u32	index;	/* output: buffers index...index + count - 1 have 
been
> > 
> > created */
> > 
> > > +	__u32	count;
> > > +	__u32	type;
> > > +	__u32	memory;
> > > +	__u32	fourcc;
> > > +	__u32	num_planes;
> > > +	__u32	sizes[VIDEO_MAX_PLANES];
> > > +	__u32	reserved[18];
> > > +};
> > 
> > I know you are going to hate me for this, but I've changed my mind: I 
think
> > this should use a struct v4l2_format after all.
> > 
> > This change of heart came out of discussions during the V4L2 brainstorm
> > meeting last week. The only way to be sure the buffers are allocated
> > optimally is if the driver has all the information. The easiest way to do
> > that is by passing struct v4l2_format. This is also consistent with
> > REQBUFS since that uses the information from the currently selected format
> > (i.e. what you get back from VIDIOC_G_FMT).
> > 
> > There can be subtle behaviors such as allocating from different memory 
back
> > based on the fourcc and the size of the image.
> > 
> > One reason why I liked passing sizes directly is that it allows the caller
> > to ask for more memory than is strictly necessary.
> > 
> > However, while brainstorming last week the suggestion was made that there
> > is no reason why the user can't set the sizeimage field in
> > v4l2_pix_format(_mplane) to something higher. The S/TRY_FMT spec 
explicitly
> > mentions that the sizeimage field is set by the driver, but for the new
> > CREATEBUFS ioctl no such limitation has to be placed. The only thing
> > necessary is to ensure that sizeimage is not too small (and you probably
> > want some sanity check against crazy values as well).
> 
> We need to decide on a policy here. What should be the maximum allowable 
size 
> for MMAP buffers ? How do we restrict the requested image size so that 
> application won't be allowed to starve the system by requesting memory for 
1GP 
> images ?

Either just a arbitrary cap like 1 GB (mainly to prevent any weird calculation 
problems around the 2 GB (signedness) and 4 GB (wrap-around) boundaries), or 
something like 3 or 4 times the minimum buffer size.

I'm in favor of enforcing a 1 GB cap in vb2 and letting drivers enforce a 
policy of their own if that makes sense for them.

I don't really see a problem with requesting large amounts of memory. What 
constitutes 'large' is not something the kernel knows, that's dependent on the 
use case.

Regards,

	Hans

> 
> > This way the decision on how to allocate memory is the same between 
REQBUFS
> > and CREATEBUFS (i.e. both use v4l2_format information), but there is no
> > need for a union as we had in the initial proposal since apps can set the
> > sizeimage to something larger than strictly necessary (or just leave it to
> > 0 to get the smallest size).
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
