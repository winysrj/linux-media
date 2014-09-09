Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32940 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaIINSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 09:18:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] v4l: Clarify RGB666 pixel format definition
Date: Tue, 09 Sep 2014 16:18:15 +0300
Message-ID: <1468017.Vb1L5kusHW@avalon>
In-Reply-To: <53CD97D2.1010408@xs4all.nl>
References: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com> <1479223.veAhoGoXLY@avalon> <53CD97D2.1010408@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 22 July 2014 00:44:34 Hans Verkuil wrote:
> On 07/22/2014 12:30 AM, Laurent Pinchart wrote:
> > On Monday 21 July 2014 23:43:16 Hans Verkuil wrote:
> >> On 07/21/2014 10:39 PM, Laurent Pinchart wrote:
> >>> The RGB666 pixel format doesn't include an alpha channel. Document it as
> >>> such.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> ---
> >>> 
> >>>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml          | 20
> >>>  +++++----------
> >>> 
> >>> 1 file changed, 6 insertions(+), 14 deletions(-)
> >>> 
> >>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
> >>> 32feac9..c47692a 100644
> >>> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>> @@ -330,20 +330,12 @@ colorspace
> >>> <constant>V4L2_COLORSPACE_SRGB</constant>.</para>>
> >>>  	    <entry></entry>
> >>>  	    <entry>r<subscript>1</subscript></entry>
> >>>  	    <entry>r<subscript>0</subscript></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> -	    <entry></entry>
> >>> +	    <entry>-</entry>
> >>> +	    <entry>-</entry>
> >>> +	    <entry>-</entry>
> >>> +	    <entry>-</entry>
> >>> +	    <entry>-</entry>
> >>> +	    <entry>-</entry>
> >> 
> >> Just to clarify: BGR666 is a three byte format, not a four byte format?
> > 
> > Well... :-)
> > 
> > Three drivers seem to support the BGR666 in mainline : sh_veu, s3c-camif
> > and exynos4-is. Further investigation shows that the sh_veu driver lists
> > the BGR666 format internally but doesn't expose it to userspace and
> > doesn't actually support it, so we're down to two drivers.
> > 
> > Looking at the S3C6410 datasheet, it's unclear how the hardware stores
> > RGB666 pixels in memory. It could be either
> > 
> > Byte 0   Byte 1   Byte 2   Byte 3
> > 
> > -------- ------RR RRRRGGGG GGBBBBBB
> > 
> > or
> > 
> > GGBBBBBB RRRRGGGG ------RR --------
> > 
> > None of those correspond to the RGB666 format defined in the spec.
> > 
> > The Exynos4 FIMC isn't documented in the public datasheet, so I can't
> > check how the format is defined.
> > 
> > Furthermore, various Renesas video-related IP cores support many different
> > RGB666 variants, on either 32 or 24 bits per pixel, with and without
> > alpha.
> > 
> > Beside a loud *sigh*, any comment ? :-)
> 
> You'll have to check with Samsung then. Sylwester, can you shed any light on
> what this format *really* is?

Ping ?


-- 
Regards,

Laurent Pinchart

