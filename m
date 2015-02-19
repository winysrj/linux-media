Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24635 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbBSPkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 10:40:37 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NK000BWFZQDIHB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2015 15:44:37 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
References: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
 <54E5BDC4.6090904@xs4all.nl>
In-reply-to: <54E5BDC4.6090904@xs4all.nl>
Subject: RE: [PATCH v3 1/4] vb2: split the io_flags member of vb2_queue into a
 bit field
Date: Thu, 19 Feb 2015 16:40:34 +0100
Message-id: <00ed01d04c5a$66edea20$34c9be60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thank you for the review!

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, February 19, 2015 11:41 AM
> 
> On 02/19/15 11:11, Kamil Debski wrote:
> > This patch splits the io_flags member of vb2_queue into a bit field.
> > Instead of an enum with flags separate bit fields were introduced.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c |   15 +++++++++------
> >  include/media/videobuf2-core.h           |   16 ++++------------
> >  2 files changed, 13 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
> > index bc08a82..62531956 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -2760,7 +2760,8 @@ struct vb2_fileio_data {
> >  	unsigned int initial_index;
> >  	unsigned int q_count;
> >  	unsigned int dq_count;
> > -	unsigned int flags;
> > +	unsigned read_once:1;
> > +	unsigned write_immediately:1;
> >  };
> >
> >  /**
> > @@ -2798,14 +2799,16 @@ static int __vb2_init_fileio(struct vb2_queue
> *q, int read)
> >  	 */
> >  	count = 1;
> >
> > -	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
> > -		(read) ? "read" : "write", count, q->io_flags);
> > +	dprintk(3, "setting up file io: mode %s, count %d, read_once %d,
> write_immediately %d\n",
> > +		(read) ? "read" : "write", count, q->fileio_read_once,
> > +		q->fileio_write_immediately);
> >
> >  	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
> >  	if (fileio == NULL)
> >  		return -ENOMEM;
> >
> > -	fileio->flags = q->io_flags;
> > +	fileio->read_once = q->fileio_read_once;
> > +	fileio->write_immediately = q->fileio_write_immediately;
> >
> >  	/*
> >  	 * Request buffers and use MMAP type to force driver @@ -3029,11
> > +3032,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q,
> char __user *data, size_
> >  	 * Queue next buffer if required.
> >  	 */
> >  	if (buf->pos == buf->size ||
> > -	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
> > +	   (!read && (fileio->write_immediately))) {
> 
> No need for the parenthesis around fileio->write_immediately.
> 
> >  		/*
> >  		 * Check if this is the last buffer to read.
> >  		 */
> > -		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
> > +		if (read && (fileio->read_once) &&
> 
> Ditto for fileio->read_once.
> 
> >  		    fileio->dq_count == 1) {
> >  			dprintk(3, "read limit reached\n");
> >  			return __vb2_cleanup_fileio(q);
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h index bd2cec2..1346693 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -134,17 +134,6 @@ enum vb2_io_modes {  };
> >
> >  /**
> > - * enum vb2_fileio_flags - flags for selecting a mode of the file io
> > emulator,
> > - * by default the 'streaming' style is used by the file io emulator
> > - * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
> > - * @VB2_FILEIO_WRITE_IMMEDIATELY:	queue buffer after each
> write() call
> > - */
> > -enum vb2_fileio_flags {
> > -	VB2_FILEIO_READ_ONCE		= (1 << 0),
> > -	VB2_FILEIO_WRITE_IMMEDIATELY	= (1 << 1),
> > -};
> > -
> > -/**
> >   * enum vb2_buffer_state - current video buffer state
> >   * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
> >   * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
> > @@ -347,6 +336,7 @@ struct v4l2_fh;
> >   * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
> >   * @io_modes:	supported io methods (see vb2_io_modes enum)
> >   * @io_flags:	additional io flags (see vb2_fileio_flags enum)
> 
> io_flags no longer exists.
> 
> > + * XXX
> 
> Same question as before: XXX ????
> 
> I assume the intention was to replace XXX with the documentation of the
> new bitfields which is now lost after removing the enum
> vb2_fileio_flags.

The lack of morning coffee is here to blame. Sorry, I'll post an fix in a
moment.

> 
> >   * @lock:	pointer to a mutex that protects the vb2_queue
> struct. The
> >   *		driver can set this to a mutex to let the v4l2 core
> serialize
> >   *		the queuing ioctls. If the driver wants to handle locking
> > @@ -396,7 +386,9 @@ struct v4l2_fh;
> >  struct vb2_queue {
> >  	enum v4l2_buf_type		type;
> >  	unsigned int			io_modes;
> > -	unsigned int			io_flags;
> > +	unsigned			fileio_read_once:1;
> > +	unsigned			fileio_write_immediately:1;
> > +
> >  	struct mutex			*lock;
> >  	struct v4l2_fh			*owner;
> >
> >
> 
> Regards,
> 
> 	Hans

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

