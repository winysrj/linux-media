Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42878 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754578AbcEQJ1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 05:27:03 -0400
Date: Tue, 17 May 2016 12:26:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 0/4] Meta-data video device type
Message-ID: <20160517092628.GA26360@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <57359DBE.4090904@xs4all.nl>
 <104553394.R3AD42rbhA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104553394.R3AD42rbhA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, May 16, 2016 at 12:21:17PM +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 13 May 2016 11:26:22 Hans Verkuil wrote:
> > On 05/12/2016 02:17 AM, Laurent Pinchart wrote:
> > > Hello,
> > > 
> > > This RFC patch series is a second attempt at adding support for passing
> > > statistics data to userspace using a standard API.
> > > 
> > > The core requirements haven't changed. Statistics data capture requires
> > > zero-copy and decoupling statistics buffers from images buffers, in order
> > > to make statistics data available to userspace as soon as they're
> > > captured. For those reasons the early consensus we have reached is to use
> > > a video device node with a buffer queue to pass statistics buffers using
> > > the V4L2 API, and this new RFC version doesn't challenge that.
> > > 
> > > The major change compared to the previous version is how the first patch
> > > has been split in two. Patch 1/4 now adds a new metadata buffer type and
> > > format (including their support in videobuf2-v4l2), usable with regular
> > > V4L2 video device nodes, while patch 2/4 adds the new metadata video
> > > device type. Metadata buffer queues are thus usable on both the regular
> > > V4L2 device nodes and the new metadata device nodes.
> > > 
> > > This change was driven by the fact that an important category of use cases
> > > doesn't differentiate between metadata and image data in hardware at the
> > > DMA engine level. With such hardware (CSI-2 receivers in particular, but
> > > other bus types could also fall into this category) a stream containing
> > > both metadata and image data virtual streams is transmitted over a single
> > > physical link. The receiver demultiplexes, filters and routes the virtual
> > > streams to further hardware blocks, and in many cases, directly to DMA
> > > engines that are part of the receiver. Those DMA engines can capture a
> > > single virtual stream to memory, with as many DMA engines physically
> > > present in the device as the number of virtual streams that can be
> > > captured concurrently. All those DMA engines are usually identical and
> > > don't care about the type of data they receive and capture. For that
> > > reason limiting the metadata buffer type to metadata device nodes would
> > > require creating two device nodes for each DMA engine (and possibly more
> > > later if we need to capture other types of data). Not only would this
> > > make the API more complex to use for applications, it wouldn't bring any
> > > added value as the video and metadata device nodes associated with a DMA
> > > engine couldn't be used concurrently anyway, as they both correspond to
> > > the same hardware resource.
> > > 
> > > For this reason the ability to capture metadata on a video device node is
> > > useful and desired, and is implemented patch 1/4 using a dedicated video
> > > buffers queue. In the CSI-2 case a driver will create two buffer queues
> > > internally for the same DMA engine, and can select which one to use based
> > > on the buffer type passed for instance to the REQBUFS ioctl (details
> > > still need to be discussed here).
> > 
> > Not quite. It still has only one vb2_queue, you just change the type
> > depending on what mode it is in (video or meta data). Similar to raw vs
> > sliced VBI.
> > 
> > In the latter case it is the VIDIOC_S_FMT call that changes the vb2_queue
> > type depending on whether raw or sliced VBI is requested. That's probably
> > where I would do this for video vs meta as well.
> 
> That sounds good to me. I didn't know we had support for changing the type of 
> a vb2 queue at runtime, that's good news :-)
> 
> > There is one big thing missing here: how does userspace know in this case
> > whether it will get metadata or video? Who decides which CSI virtual stream
> > is routed to which video node?
> 
> I've replied to Sakari's e-mail about this.
> 
> > > A device that contains DMA engines dedicated to
> > > metadata would create a single buffer queue and implement metadata capture
> > > only.
> > > 
> > > Patch 2/4 then adds a dedicated metadata device node type that is limited
> > > to metadata capture. Support for metadata on video device nodes isn't
> > > removed though, both device node types support metadata capture. I have
> > > included this patch as the code existed in the previous version of the
> > > series (and was explicitly requested during review of an earlier
> > > version), but I don't really see what value this would bring compared to
> > > just using video device nodes.
> > 
> > I'm inclined to agree with you.
> 
> Great :-) Should I just drop patch 2/4 then ? Sakari, Mauro, would that be 
> fine with you ?

I do encourage dropping that patch, yes!

> 
> > > As before patch 3/4 defines a first metadata format for the R-Car VSP1 1-D
> > > statistics format as an example, and the new patch 4/4 adds support for
> > > the histogram engine to the VSP1 driver. The implementation uses a
> > > metadata device node, and switching to a video device node wouldn't
> > > require more than applying the following one-liner patch.
> > > 
> > > -       histo->queue.type = V4L2_BUF_TYPE_META_CAPTURE;
> > > +       histo->queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > 
> > You probably mean replacing this:
> > 
> > 	histo->video.vfl_type = VFL_TYPE_META;
> > 
> > by this:
> > 
> > 	histo->video.vfl_type = VFL_TYPE_GRABBER;
> 
> Yes, of course, my bad.
> 
> > > Beside whether patch 2/4 should be included or not (I would prefer
> > > dropping it) and how to select the active queue on a multi-type video
> > > device node (through the REQBUFS ioctl or through a diffent mean), one
> > > point that remains to be discussed is what information to include in the
> > > metadata format. Patch 1/1 defines the new metadata format as
> > > 
> > > struct v4l2_meta_format {
> > > 	__u32				dataformat;
> > > 	__u32				buffersize;
> > > 	__u8				reserved[24];
> > > } __attribute__ ((packed));
> > > 
> > > but at least in the CSI-2 case metadata is, as image data, transmitted in
> > > lines and the receiver needs to be programmed with the line length and the
> > > number of lines for proper operation. We started discussing this on IRC
> > > but haven't reached a conclusion yet.

In two-dimensional DMA there may be padding added at the end of the line. We
also need bytesperline.

Metadata may be also packed the same way as the pixel data for the frame,
albeit it only contains 8 bits per "sample", leaving empty bytes in between.

> 
> This is the last problem that needs to be solved. We can possibly postpone it 
> as I don't need width/height for now.

The three fields consume already half of the reserved space. How about
__u32[16] or such?

> 
> > > Laurent Pinchart (4):
> > >   v4l: Add metadata buffer type and format
> > >   v4l: Add metadata video device type
> > >   v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
> > >   v4l: vsp1: Add HGO support
> > >  
> > >  Documentation/DocBook/media/v4l/dev-meta.xml       |  97 ++++
> > >  .../DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml     | 307 +++++++++++++
> > >  Documentation/DocBook/media/v4l/pixfmt.xml         |   9 +
> > >  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
> > >  drivers/media/platform/Kconfig                     |   1 +
> > >  drivers/media/platform/vsp1/Makefile               |   2 +
> > >  drivers/media/platform/vsp1/vsp1.h                 |   3 +
> > >  drivers/media/platform/vsp1/vsp1_drm.c             |   2 +-
> > >  drivers/media/platform/vsp1/vsp1_drv.c             |  37 +-
> > >  drivers/media/platform/vsp1/vsp1_entity.c          | 131 +++++-
> > >  drivers/media/platform/vsp1/vsp1_entity.h          |   7 +-
> > >  drivers/media/platform/vsp1/vsp1_hgo.c             | 496 ++++++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_hgo.h             |  50 +++
> > >  drivers/media/platform/vsp1/vsp1_histo.c           | 307 +++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_histo.h           |  68 +++
> > >  drivers/media/platform/vsp1/vsp1_pipe.c            |  30 +-
> > >  drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +
> > >  drivers/media/platform/vsp1/vsp1_regs.h            |  24 +-
> > >  drivers/media/platform/vsp1/vsp1_video.c           |  22 +-
> > >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +
> > >  drivers/media/v4l2-core/v4l2-dev.c                 |  37 +-
> > >  drivers/media/v4l2-core/v4l2-ioctl.c               |  40 ++
> > >  drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
> > >  include/media/v4l2-dev.h                           |   3 +-
> > >  include/media/v4l2-ioctl.h                         |   8 +
> > >  include/uapi/linux/media.h                         |   2 +
> > >  include/uapi/linux/videodev2.h                     |  17 +
> > >  27 files changed, 1678 insertions(+), 47 deletions(-)
> > >  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> > >  create mode 100644
> > >  Documentation/DocBook/media/v4l/pixfmt-meta-vsp1-hgo.xml
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
> > >  create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
