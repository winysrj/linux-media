Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43321 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaGRMbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 08:31:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 01/23] v4l: Add ARGB and XRGB pixel formats
Date: Fri, 18 Jul 2014 14:31:42 +0200
Message-ID: <3481435.vQMt1BxCmT@avalon>
In-Reply-To: <53C845F0.2010409@xs4all.nl>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53C845F0.2010409@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 17 July 2014 23:53:52 Hans Verkuil wrote:
> Hi Laurent,
> 
> While implementing support for this in v4l-utils I discovered you missed
> one:
>
> On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > The existing RGB pixel formats are ill-defined in respect to their alpha
> > bits and their meaning is driver dependent. Create new standard ARGB and
> > XRGB variants with clearly defined meanings and make the existing
> > variants deprecated.
> > 
> > The new pixel formats 4CC values have been selected to match the DRM
> > 4CCs for the same in-memory formats.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 +++++++++++++++-
> >  include/uapi/linux/videodev2.h                     |   8 +
> >  2 files changed, 403 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 168ff50..0125f4d 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -294,7 +294,11 @@ struct v4l2_pix_format {
> > 
> >  /* RGB formats */
> >  #define V4L2_PIX_FMT_RGB332  v4l2_fourcc('R', 'G', 'B', '1') /*  8 
> >  RGB-3-3-2     */ #define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4',
> >  '4') /* 16  xxxxrrrr ggggbbbb */> 
> > +#define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16 
> > aaaarrrr ggggbbbb */ +#define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R',
> > '1', '2') /* 16  xxxxrrrr ggggbbbb */> 
> >  #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16 
> >  RGB-5-5-5     */> 
> > +#define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16 
> > ARGB-1-5-5-5  */ +#define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1',
> > '5') /* 16  XRGB-1-5-5-5  */> 
> >  #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16 
> >  RGB-5-6-5     */ #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B',
> >  'Q') /* 16  RGB-5-5-5 BE  */
>
> A+X variants should also be added for this RGB555X pix format.

Agreed. The reason I've left it out is that I don't use it in my driver, and 
we have this policy of only adding FOURCCs for formats actively in use. Would 
you still like me to add it ?

> >  #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16 
> >  RGB-5-6-5 BE  */> 
> > @@ -302,7 +306,11 @@ struct v4l2_pix_format {
> > 
> >  #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24 
> >  BGR-8-8-8     */ #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B',
> >  '3') /* 24  RGB-8-8-8     */ #define V4L2_PIX_FMT_BGR32  
> >  v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */> 
> > +#define V4L2_PIX_FMT_ABGR32  v4l2_fourcc('A', 'R', '2', '4') /* 32 
> > BGRA-8-8-8-8  */ +#define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2',
> > '4') /* 32  BGRX-8-8-8-8  */> 
> >  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32 
> >  RGB-8-8-8-8   */> 
> > +#define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32 
> > ARGB-8-8-8-8  */ +#define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2',
> > '4') /* 32  XRGB-8-8-8-8  */> 
> >  /* Grey formats */
> >  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8 
> >  Greyscale     */

-- 
Regards,

Laurent Pinchart

