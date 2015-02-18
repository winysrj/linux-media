Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21624 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbBRJmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 04:42:23 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NJY0010XOHF9160@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Feb 2015 09:46:27 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	nicolas.dufresne@collabora.com
References: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
 <54E305AC.6050103@xs4all.nl>
In-reply-to: <54E305AC.6050103@xs4all.nl>
Subject: RE: [PATCH 1/2] vb2: Add VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag to
 vb2_fileio_flags
Date: Wed, 18 Feb 2015 10:42:18 +0100
Message-id: <000001d04b5f$30a4afe0$91ee0fa0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, February 17, 2015 10:11 AM
> 
> Hi Kamil,
> 
> On 12/16/14 12:36, Kamil Debski wrote:
> > The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the
> > behavior of __fill_vb2_buffer function, so that if bytesused is 0 it
> > is set to the size of the buffer. However, bytesused set to 0 is used
> > by older codec drivers as as indication used to mark the end of
> stream.
> >
> > To keep backward compatibility, this patch adds a flag passed to the
> > vb2_queue_init function - VB2_FILEIO_ALLOW_ZERO_BYTESUSED. If the
> flag
> > is set upon initialization of the queue, the videobuf2 keeps the
> value
> > of bytesused intact and passes it to the driver.
> 
> What is the status of this patch series?

I have to admit that I had forgotten a bit about this patch, because of
other
important work. Thanks for reminding me :)
 
> Note that io_flags is really the wrong place for this flag, it should
> be io_modes. This flag has nothing to do with file I/O.

What do you think about adding a separate flags field into the vb2_queue
structure? This could be combined with changing io_flags to u8 or a bit
field
to save space.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> Regards,
> 
> 	Hans
> 
> >
> > Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c |   33
> ++++++++++++++++++++++++------
> >  include/media/videobuf2-core.h           |    3 +++
> >  2 files changed, 30 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
> > index d09a891..1068dbb 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1276,13 +1276,23 @@ static void __fill_vb2_buffer(struct
> vb2_buffer *vb, const struct v4l2_buffer *b
> >  			 * userspace clearly never bothered to set it and
> >  			 * it's a safe assumption that they really meant to
> >  			 * use the full plane sizes.
> > +			 *
> > +			 * Some drivers, e.g. old codec drivers, use
> bytesused
> > +			 * == 0 as a way to indicate that streaming is
> finished.
> > +			 * In that case, the driver should use the following
> > +			 * io_flag VB2_FILEIO_ALLOW_ZERO_BYTESUSED to keep
> old
> > +			 * userspace applications working.
> >  			 */
> >  			for (plane = 0; plane < vb->num_planes; ++plane) {
> >  				struct v4l2_plane *pdst =
&v4l2_planes[plane];
> >  				struct v4l2_plane *psrc =
&b->m.planes[plane];
> >
> > -				pdst->bytesused = psrc->bytesused ?
> > -					psrc->bytesused : pdst->length;
> > +				if (vb->vb2_queue->io_flags &
> > +					VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> > +					pdst->bytesused = psrc->bytesused;
> > +				else
> > +					pdst->bytesused = psrc->bytesused ?
> > +						psrc->bytesused :
pdst->length;
> >  				pdst->data_offset = psrc->data_offset;
> >  			}
> >  		}
> > @@ -1295,6 +1305,12 @@ static void __fill_vb2_buffer(struct
> vb2_buffer *vb, const struct v4l2_buffer *b
> >  		 *
> >  		 * If bytesused == 0 for the output buffer, then fall back
> >  		 * to the full buffer size as that's a sensible default.
> > +		 *
> > +		 * Some drivers, e.g. old codec drivers, use bytesused == 0
> > +		 * as a way to indicate that streaming is finished. In that
> > +		 * case, the driver should use the following io_flag
> > +		 * VB2_FILEIO_ALLOW_ZERO_BYTESUSED to keep old userspace
> > +		 * applications working.
> >  		 */
> >  		if (b->memory == V4L2_MEMORY_USERPTR) {
> >  			v4l2_planes[0].m.userptr = b->m.userptr; @@ -1306,11
> +1322,16 @@
> > static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct
> v4l2_buffer *b
> >  			v4l2_planes[0].length = b->length;
> >  		}
> >
> > -		if (V4L2_TYPE_IS_OUTPUT(b->type))
> > -			v4l2_planes[0].bytesused = b->bytesused ?
> > -				b->bytesused : v4l2_planes[0].length;
> > -		else
> > +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> > +			if (vb->vb2_queue->io_flags &
> > +				VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> > +				v4l2_planes[0].bytesused = b->bytesused;
> > +			else
> > +				v4l2_planes[0].bytesused = b->bytesused ?
> > +					b->bytesused :
v4l2_planes[0].length;
> > +		} else {
> >  			v4l2_planes[0].bytesused = 0;
> > +		}
> >
> >  	}
> >
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h index bd2cec2..0540bc3 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -138,10 +138,13 @@ enum vb2_io_modes {
> >   * by default the 'streaming' style is used by the file io emulator
> >   * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
> >   * @VB2_FILEIO_WRITE_IMMEDIATELY:	queue buffer after each
> write() call
> > + * @VB2_FILEIO_ALLOW_ZERO_BYTESUSED:	the driver setting this flag
> will handle
> > + *					bytesused == 0 as a special case
> >   */
> >  enum vb2_fileio_flags {
> >  	VB2_FILEIO_READ_ONCE		= (1 << 0),
> >  	VB2_FILEIO_WRITE_IMMEDIATELY	= (1 << 1),
> > +	VB2_FILEIO_ALLOW_ZERO_BYTESUSED	= (1 << 2),
> >  };
> >
> >  /**
> >

