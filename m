Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37264 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1LUWX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 17:23:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [PATCH 2/2] v4l2: add new pixel formats supported on dm365
Date: Wed, 21 Dec 2011 23:23:26 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com> <201112210102.09117.laurent.pinchart@ideasonboard.com> <E99FAA59F8D8D34D8A118DD37F7C8F75018915@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F75018915@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112212323.26971.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Wednesday 21 December 2011 14:56:36 Hadli, Manjunath wrote:
> On Wed, Dec 21, 2011 at 05:32:08, Laurent Pinchart wrote:
> > On Friday 16 December 2011 14:42:48 Hadli, Manjunath wrote:
> > > On Thu, Dec 15, 2011 at 18:30:47, Laurent Pinchart wrote:
> > > > On Thursday 15 December 2011 13:24:58 Manjunath Hadli wrote:
> > > > > add new macro V4L2_PIX_FMT_SGRBG10ALAW8 to represent Bayer format
> > > > > frames compressed by A-LAW alogorithm.
> > > > > add V4L2_PIX_FMT_UV8 to represent storage of C (UV interleved)
> > > > > only.
> > > > > 
> > > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > ---
> > > > > 
> > > > >  include/linux/videodev2.h |    6 ++++++
> > > > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > > 
> > > > Could you please also document these formats in
> > > > Documentation/DocBook/media/v4l ?
> > > 
> > > I will. Sorry to have missed that out.
> > > 
> > > > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > > > index 4b752d5..969112d 100644
> > > > > --- a/include/linux/videodev2.h
> > > > > +++ b/include/linux/videodev2.h
> > > > > @@ -338,6 +338,9 @@ struct v4l2_pix_format {
> > > > > 
> > > > >  #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8
> > > > >  YUV
> > > > > 
> > > > > 4:2:0 16x16 macroblocks */ #define V4L2_PIX_FMT_M420
> > > > > v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line
> > > > > uv interleaved */
> > > > > 
> > > > > +/* Chrominance formats */
> > > > > +#define V4L2_PIX_FMT_UV8      v4l2_fourcc('U', 'V', '8', ' ') /* 
> > > > > 8 UV 4:4 */ +
> > > > > 
> > > > >  /* two planes -- one Y, one Cr + Cb interleaved  */
> > > > >  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12
> > > > >  Y/CbCr
> > > > > 
> > > > > 4:2:0  */ #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2',
> > > > > '1') /* 12  Y/CrCb 4:2:0  */ @@ -366,6 +369,9 @@ struct
> > > > > v4l2_pix_format { #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R',
> > > > > 'G', '1', '2') /* 12 RGRG.. GBGB.. */ /* 10bit raw bayer DPCM
> > > > > compressed to 8 bits */ #define V4L2_PIX_FMT_SGRBG10DPCM8
> > > > > v4l2_fourcc('B', 'D', '1', '0')
> > > > > +	/* 10bit raw bayer a-law compressed to 8 bits */ #define
> > > > > +V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('A', 'L', 'W', '8')
> > > > > +
> > > > 
> > > > That's not very future-proof, how would you describe SGBRG10ALAW8
> > > > for instance ?
> > > > 
> > > > Maybe it's time to standardize FOURCCs for Bayer new formats. We
> > > > have 4 characters, we could start with 'B' to denote Bayer, followed
> > > > by one character for the order, one for the compression, and one for
> > > > the number of bits.
> > > 
> > > I agree.
> > > May be ('B', 'G', 'A', '8') is fine for the above?
> > 
> > We need to describe at last BGGR, GBRG, GRBG and RGGB. We could use 'B',
> > 'g', 'G' and 'R' respectively for the second character. The third
> > character would be 'A' for A-law and 'D' for DPCM, and the fourth
> > character could describe the bus width in bits from 0 to 15 with '0' -
> > '9', 'A' - 'F'. However, I suspect that we will need 16-bit wide busses
> > for raw Bayer at some point, and a 0 width is definitely not useful. We
> > could thus offset the width by some value.
> > 
> > This is just a preliminary idea, I'm open to suggestions.
> 
> I think it is a very good suggestion that we can go with.
> B : BGGR
> g : GBRG
> G : GRBG
> R : RGGB
> 
> and 0-F can signify 1-16.

Hans, Guennadi, Sakari, any opinion on that as well ?

-- 
Regards,

Laurent Pinchart
