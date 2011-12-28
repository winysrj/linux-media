Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50170 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1L1Kdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 05:33:50 -0500
Date: Wed, 28 Dec 2011 12:33:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] v4l: Add DPCM compressed formats
Message-ID: <20111228103345.GS3677@valkosipuli.localdomain>
References: <20111228102028.GR3677@valkosipuli.localdomain>
 <1325067657-32556-1-git-send-email-sakari.ailus@iki.fi>
 <201112281125.15080.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112281125.15080.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 28, 2011 at 11:25:13AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 28 December 2011 11:20:56 Sakari Ailus wrote:
> > Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  include/linux/videodev2.h |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 0f8f904..560e468 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -365,7 +365,10 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR..
> > BGBG.. */ #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /*
> > 12  RGRG.. GBGB.. */ /* 10bit raw bayer DPCM compressed to 8 bits */
> > +#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('B', 'D', 'B', '1')
> > +#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('B', 'D', 'G', '1')
> >  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> > +#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('B', 'D', 'R', '1')
> >  	/*
> >  	 * 10bit raw bayer, expanded to 16 bits
> >  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
> 
> Could you please have a look at the discussion about a similar patch in 
> http://patchwork.linuxtv.org/patch/8844/ ?

Oh, I had missed that, even if I was cc'd... :-P

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
