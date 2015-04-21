Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54985 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbbDUQQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 12:16:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: whittenburg@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
Date: Tue, 21 Apr 2015 19:16:56 +0300
Message-ID: <5316821.FKvqnaiTbd@avalon>
In-Reply-To: <CABcw_O=HtCQkVnHk-ERCRKFbp0X7tSGQcU7L5133RQmD50yqsA@mail.gmail.com>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com> <2148230.ZhqY8UHqWD@avalon> <CABcw_O=HtCQkVnHk-ERCRKFbp0X7tSGQcU7L5133RQmD50yqsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Tuesday 21 April 2015 11:04:14 Chris Whittenburg wrote:
> On Fri, Apr 17, 2015 at 4:39 AM, Laurent Pinchart wrote:
> > On Thursday 16 April 2015 13:05:30 Chris Whittenburg wrote:
> >> On Tue, Apr 7, 2015 at 10:51 AM, Laurent Pinchart wrote:
> >>> Black level compensation is applied by the CCDC before writing raw
> >>> frames to memory. If your raw frames are correct BLC is probably not to
> >>> blame.
> >>> 
> >>> The default contrast is x1.0 and the default brightness is +0.0, so I
> >>> don't think those should be blame either.
> >>> 
> >>> I suspect the RGB2RGB conversion matrix to be wrong. The default
> >>> setting is supposed to handle fluorescent lighting. You could try
> >>> setting the RGB2RGB matrix to the identity matrix and see if this
> >>> helps. See
> >>> http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.
> >>> c#l184 for sample code.
> >>> 
> >>> Another matrix that could be worth being reprogrammed is the RGB2YUV
> >>> matrix, which also defaults to fluorescent lighting. Sample code to
> >>> reprogram it is available in the same location.
> >> 
> >> I tried changing the rgb2rgb matrx to the identity matrix:
> >> 
> >> {0x0100, 0x0000, 0x0000},
> >> {0x0000, 0x0100, 0x0000},
> >> {0x0000, 0x0000, 0x0100}
> >> 
> >> And the csc (rgb2yuv) to this:
> >> {256, 0, 0},
> >> {0, 0, 0},
> >> {0, 0, 0}
> >> 
> >> But I couldn't see much, if any, difference.
> >> 
> >> However, when I forced the gamma correction to be bypassed, it seemed to
> >> fix it.
> >> 
> >> Does that make sense?  I guess I don't understand it enough to understand
> >> if gamma correction would have compressed all my luma values.
> > 
> > Yes, it makes sense. Gamma correction applies a non-linear transformation
> > to the pixel values and can explain the problems you were seeing.
> > 
> > I've checked the default rgb2rgb matrix, and it should work fine for your
> > case as all lines add up to 1.0. The default rgb2yuv matrix, however,
> > limits Y values to 220, so you should modify it.
> 
> I believe the formula used is:
> Y = CSCRY*Rin + CSCGY*Gin + CSCBY*Bin +Yoffset
> 
> If CSCRY=1.0, and Rin is in the range 0 to 255, then the resulting Y
> would be in the range [0, 255] as well, so why would the matrix limit
> Y values to 220?  Is it because Rin, Gin, and Bin have already been
> limited to the YCbCr range of [16, 240]?

I meant that the default matrix programmed by the omap3isp driver will limit 
the range to 220.

    {Y}   {  66, 129,  25} {R}
    {U} = { -38, -75, 112} {G}
    {V}   { 112, -94, -18} {B}

Y = 66*R + 129*G + 25*B

As R = G = B = y in your case, that's

Y = 66*y + 129*y + 25*y = 220*y

Coefficients are expressed in S10Q8 format (signed, 10 bits in total, 8 
decimal bits), so we end up with Y = 220/256 * y, limiting the Y range to 220 
(assuming the input value is limited to 8 bits).

-- 
Regards,

Laurent Pinchart

