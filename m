Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19167 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1HQNXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 09:23:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQ20024CQIR3C70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Aug 2011 14:23:15 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ20019EQIQGS@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Aug 2011 14:23:15 +0100 (BST)
Date: Wed, 17 Aug 2011 15:22:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
In-reply-to: <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans Verkuil' <hansverk@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Sakari Ailus' <sakari.ailus@maxwell.research.nokia.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
Message-id: <009201cc5ce0$bd34de10$379e9a30$%szyprowski@samsung.com>
Content-language: pl
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081116.41126.hansverk@cisco.com>
 <Pine.LNX.4.64.1108151324220.7851@axis700.grange>
 <201108151336.07258.hansverk@cisco.com>
 <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, August 15, 2011 3:46 PM Guennadi Liakhovetski wrote:
> On Mon, 15 Aug 2011, Hans Verkuil wrote:
> > On Monday, August 15, 2011 13:28:23 Guennadi Liakhovetski wrote:
> > > On Mon, 8 Aug 2011, Hans Verkuil wrote:
> > > > On Friday, August 05, 2011 09:47:13 Guennadi Liakhovetski wrote:
> > > > > A possibility to preallocate and initialise buffers of different sizes
> > > > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > > > >
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > >
> > > > > v4:
> > > > >
> > > > > 1. CREATE_BUFS now takes an array of plane sizes and a fourcc code in
its
> > > > >    argument, instead of a frame format specification, including
> > > > >    documentation update
> > > > > 2. documentation improvements, as suggested by Hans
> > > > > 3. increased reserved fields to 18, as suggested by Sakari
> > > > >
> > > > >  Documentation/DocBook/media/v4l/io.xml             |   17 ++
> > > > >  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
> > > > >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  161
> > > > ++++++++++++++++++++
> > > > >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96
++++++++++++
> > > > >  drivers/media/video/v4l2-compat-ioctl32.c          |    6 +
> > > > >  drivers/media/video/v4l2-ioctl.c                   |   26 +++
> > > > >  include/linux/videodev2.h                          |   18 +++
> > > > >  include/media/v4l2-ioctl.h                         |    2 +
> > > > >  8 files changed, 328 insertions(+), 0 deletions(-)
> > > > >  create mode 100644
Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > > >  create mode 100644
Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > > > >
> > > >
> > > > <snip>
> > > >
> > > > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > > > index fca24cc..3cd0cb3 100644
> > > > > --- a/include/linux/videodev2.h
> > > > > +++ b/include/linux/videodev2.h
> > > > > @@ -653,6 +653,9 @@ struct v4l2_buffer {
> > > > >  #define V4L2_BUF_FLAG_ERROR	0x0040
> > > > >  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is
valid */
> > > > >  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> > > > > +/* Cache handling flags */
> > > > > +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> > > > > +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
> > > > >
> > > > >  /*
> > > > >   *	O V E R L A Y   P R E V I E W
> > > > > @@ -2092,6 +2095,18 @@ struct v4l2_dbg_chip_ident {
> > > > >  	__u32 revision;    /* chip revision, chip specific */
> > > > >  } __attribute__ ((packed));
> > > > >
> > > > > +/* VIDIOC_CREATE_BUFS */
> > > > > +struct v4l2_create_buffers {
> > > > > +	__u32	index;	/* output: buffers index...index + count - 1
have been
> > > > created */
> > > > > +	__u32	count;
> > > > > +	__u32	type;
> > > > > +	__u32	memory;
> > > > > +	__u32	fourcc;
> > > > > +	__u32	num_planes;
> > > > > +	__u32	sizes[VIDEO_MAX_PLANES];
> > > > > +	__u32	reserved[18];
> > > > > +};
> > > >
> > > > I know you are going to hate me for this,
> > >
> > > hm, I'll consider this possibility;-)
> > >
> > > > but I've changed my mind: I think
> > > > this should use a struct v4l2_format after all.
> 
> While switching back, I have to change the struct vb2_ops::queue_setup()
> operation to take a struct v4l2_create_buffers pointer. An earlier version
> of this patch just added one more parameter to .queue_setup(), which is
> easier - changes to videobuf2-core.c are smaller, but it is then
> redundant. We could use the create pointer for both input and output. The
> video plane configuration in frame format is the same as what is
> calculated in .queue_setup(), IIUC. So, we could just let the driver fill
> that one in. This would require then the videobuf2-core.c to parse struct
> v4l2_format to decide which union member we need, depending on the buffer
> type. Do we want this or shall drivers duplicate plane sizes in separate
> .queue_setup() parameters?

IMHO if possible we should have only one callback for the driver. Please 
notice that the driver should be also allowed to increase (or decrease) the
number of buffers for particular format/fourcc.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

