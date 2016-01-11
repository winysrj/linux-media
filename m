Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43364 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbcAKDJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 22:09:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Add YUV 4:2:2 and YUV 4:4:4 tri-planar non-contiguous formats
Date: Mon, 11 Jan 2016 05:09:45 +0200
Message-ID: <1657661.CoXsjoUhCV@avalon>
In-Reply-To: <56473C30.2090903@xs4all.nl>
References: <1447507593-15016-1-git-send-email-laurent.pinchart@ideasonboard.com> <56473C30.2090903@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Saturday 14 November 2015 14:50:40 Hans Verkuil wrote:
> On 11/14/2015 02:26 PM, Laurent Pinchart wrote:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > The formats use three planes through the multiplanar API, allowing for
> > non-contiguous planes in memory.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml | 159 ++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml | 171 ++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml | 159 ++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml | 171 ++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt.xml         |   4 +
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +
> >  include/uapi/linux/videodev2.h                     |   4 +
> >  7 files changed, 672 insertions(+)
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml
> > 
> > Hello,
> > 
> > The driver using those formats should follow in the not too distant
> > future, but I'd appreciate getting feedback on the definitions already.
> 
> Looks good, but I would combine yuv422m and yvu422m, and do the same for the
> 444m variants. It's overkill to split this up.

The reason I've split them is that yuv420m and yvu420m are split. I can 
combine them.

> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml new file mode 100644
> > index 000000000000..f4d8d74e7f74
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
> > @@ -0,0 +1,159 @@
> > +    <refentry id="V4L2-PIX-FMT-YUV422M">
> > +      <refmeta>
> > +	<refentrytitle>V4L2_PIX_FMT_YUV422M ('YM16')</refentrytitle>
> > +	&manvol;
> > +      </refmeta>
> > +      <refnamediv>
> > +	<refname> <constant>V4L2_PIX_FMT_YUV422M</constant></refname>
> > +	<refpurpose>Planar formats with &frac12; horizontal resolution, also
> > +	known as YUV 4:2:2</refpurpose>
> > +      </refnamediv>
> > +
> > +      <refsect1>
> > +	<title>Description</title>
> > +
> > +	<para>This is a multi-planar format, as opposed to a packed format.
> > +The three components are separated into three sub- images or planes.
> 
> No space needed after 'sub-'.

Will fix.

-- 
Regards,

Laurent Pinchart

