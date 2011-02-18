Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39512 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BRKgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 05:36:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH RFC] uvcvideo: Add a mapping for H.264 payloads
Date: Fri, 18 Feb 2011 11:36:02 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
References: <1296243538.17673.23.camel@svmlwks101> <201102171701.57759.laurent.pinchart@ideasonboard.com> <1297985334.2620.86.camel@svmlwks101>
In-Reply-To: <1297985334.2620.86.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181136.02404.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Friday 18 February 2011 00:28:54 Stephan Lachowsky wrote:
> On Thu, 2011-02-17 at 08:01 -0800, Laurent Pinchart wrote:
> > On Friday 28 January 2011 20:38:58 Stephan Lachowsky wrote:
> > > Associate the H.264 GUID with an H.264 pixel format so that frame
> > > and stream based format descriptors with this GUID are recognized
> > > by the UVC video driver.
> > > ---
> > > 
> > >  drivers/media/video/uvc/uvc_driver.c |    5 +++++
> > >  drivers/media/video/uvc/uvcvideo.h   |    3 +++
> > >  include/linux/videodev2.h            |    1 +
> > >  3 files changed, 9 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/uvc/uvc_driver.c
> > > b/drivers/media/video/uvc/uvc_driver.c index 6bcb9e1..a5a86ce 100644
> > > --- a/drivers/media/video/uvc/uvc_driver.c
> > > +++ b/drivers/media/video/uvc/uvc_driver.c
> > > @@ -108,6 +108,11 @@ static struct uvc_format_desc uvc_fmts[] = {
> > > 
> > >  		.guid		= UVC_GUID_FORMAT_MPEG,
> > >  		.fcc		= V4L2_PIX_FMT_MPEG,
> > >  	
> > >  	},
> > > 
> > > +	{
> > > +		.name		= "H.264",
> > > +		.guid		= UVC_GUID_FORMAT_H264,
> > > +		.fcc		= V4L2_PIX_FMT_H264,
> > > +	},
> > > 
> > >  };
> > >  
> > >  /*
> > > 
> > > -----------------------------------------------------------------------
> > > - diff --git a/drivers/media/video/uvc/uvcvideo.h
> > > b/drivers/media/video/uvc/uvcvideo.h index e522f99..4f65ac6 100644
> > > --- a/drivers/media/video/uvc/uvcvideo.h
> > > +++ b/drivers/media/video/uvc/uvcvideo.h
> > > @@ -155,6 +155,9 @@ struct uvc_xu_control {
> > > 
> > >  #define UVC_GUID_FORMAT_MPEG \
> > >  
> > >  	{ 'M',  'P',  'E',  'G', 0x00, 0x00, 0x10, 0x00, \
> > >  	
> > >  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > > 
> > > +#define UVC_GUID_FORMAT_H264 \
> > > +	{ 'H',  '2',  '6',  '4', 0x00, 0x00, 0x10, 0x00, \
> > > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > > 
> > >  /*
> > > 
> > > -----------------------------------------------------------------------
> > > - * Driver specific constants.
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index 5f6f470..d3b5877 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -341,6 +341,7 @@ struct v4l2_pix_format {
> > > 
> > >  #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF
> > >  JPEG
> > >  
> > >     */ #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /*
> > > 
> > > 1394          */ #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P',
> > > 'E', 'G') /* MPEG-1/2/4    */ +#define V4L2_PIX_FMT_H264    
> > > v4l2_fourcc('H', '2', '6', '4') /* H.264 Annex-B NAL Units */
> > 
> > I've discussed H.264 support with Hans Verkuil (CC'ed) some time ago, and
> > his opinion was that we shouldn't use a new V4L2 format for it. H.264 is
> > essentially an MPEG version, so drivers should use V4L2_PIX_FMT_MPEG and
> > select the details using the MPEG CIDs.
> > 
> > Of course feel free to disagree with Hans and discuss the matter with him
> > :-)
> 
> Well MPEG is a loaded acronym to throw around, it means many, many
> things in different contexts.  Saying H.264 is essentially an MPEG
> version is true, but putting something in a labelled drawer doesn't
> necessarily make it square (unless the drawer is square, structurally
> solid, smaller than the something, and the insertion is done with
> extreme prejudice).
> 
> Let me throw a few points out for critique:
> 
>       * There is a 1-1 mapping between between the contents of this UVC
>         stream, and what would be found inside an AVI container with the
>         same fourcc code... Why fight an existing defacto labelling?
>       * There is currently a straightforward correspondence between UVC
>         payload formats and v4l2 fourcc types... Why would you want to
>         add indirection through an overloaded fourcc type, increasing
>         the complexity for all parties involved?
>       * If you don't use the fourcc code to denote the payload format,
>         you lose the ability to enumerate supported formats generically.
>         You require interface users to understand MPEG CID, and use it
>         to sub-enumerate any formats considered MPEG -- which is an
>         arbitrary label in this context -- you wouldn't try to shim
>         Theora or WebM in this way, so why H.264?
>       * MPEG CID
>         (http://v4l2spec.bytesex.org/spec/x802.htm#MPEG-CONTROLS) does
>         not currently have defined controls beyond MPEG2 (No MPEG4 ASP,
>         no MPEG4 AVC)... configuring the minutiae of these codecs is
>         complex enough that they probably deserve their own extended
>         control classes.
> 
> I'm quite persuadable by reason, and quite partial to wit; so do cc
> anyone else that will respond with insight (and/or humour).

One of the reason why MPEG support is implemented with a single fourcc in V4L2 
is that defining a new fourcc for every MPEG flavour (or rather combination of 
flavours) would lead to a very long list of fourccs.

This being said, I have no strong opinion on whether we should define a new 
H.264 fourcc or use the MPEG one with new MPEG4/H.264-specific MPEG controls. 
Hans did when I talked to him about this topic a couple of months ago, so I'll 
let him argue with you :-)

BTW, H.264 "elementary streams" comes in at least two flavours, one with start 
codes and one without. Would you use two fourccs for that ?

-- 
Regards,

Laurent Pinchart
