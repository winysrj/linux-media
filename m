Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44640 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754714AbcBBXWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2016 18:22:50 -0500
Date: Wed, 3 Feb 2016 01:22:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, Samu Onkalo <samu.onkalo@intel.com>
Subject: Re: [yavta PATCH 1/1] cache maintenance skip feature
Message-ID: <20160202232216.GU14876@valkosipuli.retiisi.org.uk>
References: <1453585794-18833-1-git-send-email-sakari.ailus@linux.intel.com>
 <1837311.I3681shYi1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1837311.I3681shYi1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Jan 24, 2016 at 10:09:24PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 23 January 2016 23:49:54 Sakari Ailus wrote:
> > From: Samu Onkalo <samu.onkalo@intel.com>
> > 
> > Add options to skip cache maintenance.
> > --dqbuf-skip-cache
> > --qbuf-skip-cache
> 
> I wonder whether we should add support for this feature to yavta when it 
> hasn't really been exercised much on the kernel side. I've been pondering for 
> some time whether cache management shouldn't be handled in an implicit way 
> instead, by letting the kernel skip cache handling when no userspace mapping 
> exists instead of passing flags explicitly. I'd like to discuss and experiment 
> with that approach first.

This would essentially bind two things together: the buffer and what the
user can do with it.

Supposing that most of the time you'd pass a set of buffers between two
hardware devices but would sometimes access it using the CPU, you'd be
always forced to flush the cache. For instance, capture images from one
device and process them using another. If you wanted to save the captured
raw image occasionally, you'd be forced to flush the cache always,
independently of whether you touch the buffer or not.

Avoiding the cache flush is pretty low level functionality we don't have in
a lot of kernel APIs (anywhere else?) but I think there's a reason why the
flags were added and it's still there (albeit never got properly supported;
I have a patchset for that but it requires further work).

Well, one could argue that you can mmap and munmap the DMA-BUF buffers then,
but doing that takes time as well.

This is a test program. If we end up deprecating (or removing) the flags
from the videodev2.h we can always remove the support from yavta as well.
:-)

> 
> > Signed-off-by: Samu Onkalo <samu.onkalo@intel.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > This patch depends on my earlier patch "Fix --data-prefix option
> > documentation".
> > 
> >  yavta.c |   16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/yavta.c b/yavta.c
> > index b21c3b3..ec4acd6 100644
> > --- a/yavta.c
> > +++ b/yavta.c
> > @@ -73,6 +73,8 @@ struct device
> >  	unsigned int width;
> >  	unsigned int height;
> >  	uint32_t buffer_output_flags;
> > +	uint32_t buffer_qbuf_flags;
> > +	uint32_t buffer_dqbuf_flags;
> >  	uint32_t timestamp_type;
> > 
> >  	unsigned char num_planes;
> > @@ -1010,6 +1012,8 @@ static int video_queue_buffer(struct device *dev, int
> > index, enum buffer_fill_mo }
> >  	}
> > 
> > +	buf.flags |= dev->buffer_qbuf_flags;
> > +
> >  	if (video_is_mplane(dev)) {
> >  		buf.m.planes = planes;
> >  		buf.length = dev->num_planes;
> > @@ -1662,6 +1666,7 @@ static int video_do_capture(struct device *dev,
> > unsigned int nframes, buf.memory = dev->memtype;
> >  		buf.length = VIDEO_MAX_PLANES;
> >  		buf.m.planes = planes;
> > +		buf.flags = dev->buffer_dqbuf_flags;
> > 
> >  		ret = ioctl(dev->fd, VIDIOC_DQBUF, &buf);
> >  		if (ret < 0) {
> > @@ -1781,6 +1786,7 @@ static void usage(const char *argv0)
> >  	printf("-u, --userptr			Use the user pointers streaming 
> method\n");
> >  	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 
> 'value'\n");
> >  	printf("    --data-prefix		Write portions of buffer data before
> > data_offset\n"); +	printf("    --[d]qbuf-skip-cache        Skip cache
> > maintenance\n"); printf("    --buffer-size		Buffer size in bytes\n");
> >  	printf("    --enum-formats		Enumerate formats\n");
> >  	printf("    --enum-inputs		Enumerate inputs\n");
> > @@ -1814,6 +1820,8 @@ static void usage(const char *argv0)
> >  #define OPT_PREMULTIPLIED	269
> >  #define OPT_QUEUE_LATE		270
> >  #define OPT_DATA_PREFIX		271
> > +#define OPT_DQBUF_NO_CACHE      272
> > +#define OPT_QBUF_NO_CACHE	273
> > 
> >  static struct option opts[] = {
> >  	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
> > @@ -1822,6 +1830,7 @@ static struct option opts[] = {
> >  	{"check-overrun", 0, 0, 'C'},
> >  	{"data-prefix", 0, 0, OPT_DATA_PREFIX},
> >  	{"delay", 1, 0, 'd'},
> > +	{"dqbuf-skip-cache", 0, 0, OPT_DQBUF_NO_CACHE},
> >  	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
> >  	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
> >  	{"fd", 1, 0, OPT_FD},
> > @@ -1838,6 +1847,7 @@ static struct option opts[] = {
> >  	{"offset", 1, 0, OPT_USERPTR_OFFSET},
> >  	{"pause", 0, 0, 'p'},
> >  	{"premultiplied", 0, 0, OPT_PREMULTIPLIED},
> > +	{"qbuf-skip-cache", 0, 0, OPT_QBUF_NO_CACHE},
> >  	{"quality", 1, 0, 'q'},
> >  	{"queue-late", 0, 0, OPT_QUEUE_LATE},
> >  	{"get-control", 1, 0, 'r'},
> > @@ -2089,6 +2099,12 @@ int main(int argc, char *argv[])
> >  		case OPT_DATA_PREFIX:
> >  			dev.write_data_prefix = true;
> >  			break;
> > +		case OPT_DQBUF_NO_CACHE:
> > +			dev.buffer_dqbuf_flags |= V4L2_BUF_FLAG_NO_CACHE_INVALIDATE;
> > +			break;
> > +		case OPT_QBUF_NO_CACHE:
> > +			dev.buffer_qbuf_flags |= V4L2_BUF_FLAG_NO_CACHE_INVALIDATE;
> > +			break;
> >  		default:
> >  			printf("Invalid option -%c\n", c);
> >  			printf("Run %s -h for help.\n", argv[0]);
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
