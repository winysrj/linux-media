Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36496 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLSQDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 11:03:16 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NGU00BL87G8HD80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Dec 2014 16:07:20 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Jean-Michel Hautbois' <jhautbois@gmail.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>
References: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
 <CAL8zT=jDYoiYgYm8THFmYQ1-XKndaQE99a2541UywYXLK1KzVg@mail.gmail.com>
In-reply-to: <CAL8zT=jDYoiYgYm8THFmYQ1-XKndaQE99a2541UywYXLK1KzVg@mail.gmail.com>
Subject: RE: [PATCH 1/2] vb2: Add VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag to
 vb2_fileio_flags
Date: Fri, 19 Dec 2014 17:03:12 +0100
Message-id: <046901d01ba5$4af6dab0$e0e49010$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

> From: Jean-Michel Hautbois [mailto:jhautbois@gmail.com]
> Sent: Friday, December 19, 2014 3:36 PM
> To: Kamil Debski
> Cc: Linux Media Mailing List; m.szyprowski@samsung.com; Hans Verkuil;
> Nicolas Dufresne
> Subject: Re: [PATCH 1/2] vb2: Add VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag
> to vb2_fileio_flags
> 
> Hi Kamil,
> 
> 2014-12-16 12:36 GMT+01:00 Kamil Debski <k.debski@samsung.com>:
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
> Nice, this is something we were planning to do :).
> But I would split this patch and the second which is specific to s5p-
> mfc as this is core specific and should be independant.

This patch contains only changes in the videobuf2-core.c file. The next
patch in the series contains changes in the s5p-mfc driver. There is 
another patch sent today that adds this flag to coda. 

These are all separate patches, two of them are in a single patchset.
Actually, I would send all of them in one patchset, but initially I missed
that the coda driver should also have this change applied. (Nicolas, thank
you for reminding me to do this on IRC).

> 
> 
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
> >                          * userspace clearly never bothered to set it
> and
> >                          * it's a safe assumption that they really
> meant to
> >                          * use the full plane sizes.
> > +                        *
> > +                        * Some drivers, e.g. old codec drivers, use
> bytesused
> > +                        * == 0 as a way to indicate that streaming
> is finished.
> > +                        * In that case, the driver should use the
> following
> > +                        * io_flag VB2_FILEIO_ALLOW_ZERO_BYTESUSED to
> keep old
> > +                        * userspace applications working.
> 
> Not sure if this comment is necessary, as this is already in the
> commit ?

The comment were present in the file already, I expanded them to cover the
exception when the VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag is set.
It is also explained in the commit, I agree, but in the end one usually
looks in the source code. 

> 
> >                          */
> >                         for (plane = 0; plane < vb->num_planes;
> ++plane) {
> >                                 struct v4l2_plane *pdst =
> &v4l2_planes[plane];
> >                                 struct v4l2_plane *psrc =
> > &b->m.planes[plane];
> >
> > -                               pdst->bytesused = psrc->bytesused ?
> > -                                       psrc->bytesused : pdst-
> >length;
> > +                               if (vb->vb2_queue->io_flags &
> > +
> VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> > +                                       pdst->bytesused = psrc-
> >bytesused;
> > +                               else
> > +                                       pdst->bytesused = psrc-
> >bytesused ?
> > +                                               psrc->bytesused :
> > + pdst->length;
> >                                 pdst->data_offset = psrc->data_offset;
> >                         }
> >                 }
> > @@ -1295,6 +1305,12 @@ static void __fill_vb2_buffer(struct
> vb2_buffer *vb, const struct v4l2_buffer *b
> >                  *
> >                  * If bytesused == 0 for the output buffer, then fall
> back
> >                  * to the full buffer size as that's a sensible
> default.
> > +                *
> > +                * Some drivers, e.g. old codec drivers, use
> bytesused == 0
> > +                * as a way to indicate that streaming is finished.
> In that
> > +                * case, the driver should use the following io_flag
> > +                * VB2_FILEIO_ALLOW_ZERO_BYTESUSED to keep old
> userspace
> > +                * applications working.
> 
> Again, not sure this is useful.

Same applies here, I expanded the comment to cover a new case. 

> 
> >                  */
> >                 if (b->memory == V4L2_MEMORY_USERPTR) {
> >                         v4l2_planes[0].m.userptr = b->m.userptr; @@
> > -1306,11 +1322,16 @@ static void __fill_vb2_buffer(struct vb2_buffer
> *vb, const struct v4l2_buffer *b
> >                         v4l2_planes[0].length = b->length;
> >                 }
> >
> > -               if (V4L2_TYPE_IS_OUTPUT(b->type))
> > -                       v4l2_planes[0].bytesused = b->bytesused ?
> > -                               b->bytesused : v4l2_planes[0].length;
> > -               else
> > +               if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> > +                       if (vb->vb2_queue->io_flags &
> > +                               VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> > +                               v4l2_planes[0].bytesused = b-
> >bytesused;
> > +                       else
> > +                               v4l2_planes[0].bytesused = b-
> >bytesused ?
> > +                                       b->bytesused :
> v4l2_planes[0].length;
> > +               } else {
> >                         v4l2_planes[0].bytesused = 0;
> > +               }
> >
> >         }
> >
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h index bd2cec2..0540bc3 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -138,10 +138,13 @@ enum vb2_io_modes {
> >   * by default the 'streaming' style is used by the file io emulator
> >   * @VB2_FILEIO_READ_ONCE:      report EOF after reading the first
> buffer
> >   * @VB2_FILEIO_WRITE_IMMEDIATELY:      queue buffer after each
> write() call
> > + * @VB2_FILEIO_ALLOW_ZERO_BYTESUSED:   the driver setting this flag
> will handle
> > + *                                     bytesused == 0 as a special
> case
> >   */
> >  enum vb2_fileio_flags {
> >         VB2_FILEIO_READ_ONCE            = (1 << 0),
> >         VB2_FILEIO_WRITE_IMMEDIATELY    = (1 << 1),
> > +       VB2_FILEIO_ALLOW_ZERO_BYTESUSED = (1 << 2),
> >  };
> >
> >  /**
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> I tested it with your coda patch too on i.MX6, thank you, this was
> annoying :).
> JM

You're welcome. Thanks for testing :) 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

