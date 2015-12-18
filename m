Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46740 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbbLRRQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 12:16:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH/RFC 26/48] videodev2.h: Add request field to v4l2_pix_format_mplane
Date: Fri, 18 Dec 2015 19:16:14 +0200
Message-ID: <3030478.j1ZKoooRrc@avalon>
In-Reply-To: <5673EB82.2060903@xs4all.nl>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1450341626-6695-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <5673EB82.2060903@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Friday 18 December 2015 12:18:26 Hans Verkuil wrote:
> On 12/17/2015 09:40 AM, Laurent Pinchart wrote:
> > Let userspace specify a request ID when getting or setting formats. The
> > support is limited to the multi-planar API at the moment, extending it
> > to the single-planar API is possible if needed.
> > 
> > From a userspace point of view the API change is also minimized and
> > doesn't require any new ioctl.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  include/uapi/linux/videodev2.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 5af1d2d87558..5b2a8bc80eb2 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1973,6 +1973,7 @@ struct v4l2_plane_pix_format {
> > 
> >   * @ycbcr_enc:		enum v4l2_ycbcr_encoding, Y'CbCr encoding
> >   * @quantization:	enum v4l2_quantization, colorspace quantization
> >   * @xfer_func:		enum v4l2_xfer_func, colorspace transfer function
> > 
> > + * @request:		request ID
> > 
> >   */
> >  
> >  struct v4l2_pix_format_mplane {
> >  
> >  	__u32				width;
> > 
> > @@ -1987,7 +1988,8 @@ struct v4l2_pix_format_mplane {
> > 
> >  	__u8				ycbcr_enc;
> >  	__u8				quantization;
> >  	__u8				xfer_func;
> > 
> > -	__u8				reserved[7];
> > +	__u8				reserved[3];
> > +	__u32				request;
> 
> I think I mentioned this before: I feel uncomfortable using 4 bytes of the
> reserved fields when the request ID is limited to 16 bits anyway.

I'm still unsure whether request IDs should be 16 or 32 bits long. If we go 
for 16 bits then I'll of course make this field a __u16.

> I would prefer a __u16 here. Also put the request field *before* the
> reserved array, not after.

The reserved array isn't aligned to a 32 bit (or even 16 bit) boundary. I can 
put the request field before it, with a 8 bit hole before the field.

> >  } __attribute__ ((packed));
> >  
> >  /**

-- 
Regards,

Laurent Pinchart

