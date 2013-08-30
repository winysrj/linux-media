Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:17144 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3H3IND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 04:13:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <posciak@chromium.org>
Subject: Re: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific special frames.
Date: Fri, 30 Aug 2013 10:12:45 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <52203EDB.8080308@xs4all.nl> <CACHYQ-pUhmPhMrbE8QWM+r6OWbBnOx7g6vjQvOxBSoodnPk4+Q@mail.gmail.com>
In-Reply-To: <CACHYQ-pUhmPhMrbE8QWM+r6OWbBnOx7g6vjQvOxBSoodnPk4+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308301012.46032.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 30 August 2013 09:28:36 Pawel Osciak wrote:
> On Fri, Aug 30, 2013 at 3:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > On 08/30/2013 04:17 AM, Pawel Osciak wrote:
> > > Add bits for previous, golden and altref frame types.
> > >
> > > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> >
> > Kamil, is this something that applies as well to your MFC driver?
> >
> > > ---
> > >  include/uapi/linux/videodev2.h | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h
> > > index 437f1b0..c011ee0 100644
> > > --- a/include/uapi/linux/videodev2.h
> > > +++ b/include/uapi/linux/videodev2.h
> > > @@ -687,6 +687,10 @@ struct v4l2_buffer {
> > >  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN              0x0000
> > >  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC    0x2000
> > >  #define V4L2_BUF_FLAG_TIMESTAMP_COPY         0x4000
> > > +/* VP8 special frames */
> > > +#define V4L2_BUF_FLAG_PREV_FRAME             0x10000  /* VP8 prev frame
> > */
> > > +#define V4L2_BUF_FLAG_GOLDEN_FRAME           0x20000  /* VP8 golden
> > frame */
> > > +#define V4L2_BUF_FLAG_ALTREF_FRAME           0x40000  /* VP8 altref
> > frame */
> >
> > Would it be an idea to use the same bit values as for
> > KEYFRAME/PFRAME/BFRAME?
> > After all, these can never be used at the same time. I'm a bit worried
> > that the
> > bits in this field are eventually all used up by different encoder flags.
> >
> 
> VP8 also has a concept of I and P frames and they are orthogonal to the
> concept of Prev, Golden and Alt. There is no relationship at all, i.e. we
> can't infer I P from Prev Golden Alt and vice versa.

Ah, OK. Me no VP8 expert :-)

> For the I, P
> dimension, we need one bit, but same could be said about H264, we need 2
> bits, not 3 there (if it's not I or P, it's B), and we have 3 bits
> nevertheless.
> For Prev Golden Alt dimension, we do need 3 bits.
> Now, technically, in VP8, the first bit of the frame header indicates if
> the frame is I or P, so we could technically use that in userspace and
> overload I P B to mean Prev Golden Alt for VP8. But while I understand the
> problem with running out of bits very well, as I and P exist in VP8 as
> well, it would be pretty confusing, so it's a trade-off that should be
> carefully weighted.

Are prev/golden/altref frames mutually exclusive? If so, then perhaps we
should use a two-bit mask instead of three bits. And those two-bits can
later be expanded to more to support codecs that have more than four
different frame types.

Regards,

	Hans

> 
> Regards,
> Pawel
> 
> 
> > Regards,
> >
> >         Hans
> >
> > >
> > >  /**
> > >   * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> > descriptor
> > >
> >
> >
> 
