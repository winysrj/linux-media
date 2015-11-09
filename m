Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45360 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbKIWVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 17:21:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Clarify RGB666 pixel format definition
Date: Tue, 10 Nov 2015 00:21:13 +0200
Message-ID: <1467109.0hyysKvb3u@avalon>
In-Reply-To: <4301993.tc7nBMPXQH@avalon>
References: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com> <540F127D.4020300@samsung.com> <4301993.tc7nBMPXQH@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Reviving a "slightly" old discussion.

On Wednesday 29 October 2014 13:45:46 Laurent Pinchart wrote:
> On Tuesday 09 September 2014 16:45:17 Sylwester Nawrocki wrote:
> > On 09/09/14 15:18, Laurent Pinchart wrote:
> >> On Tuesday 22 July 2014 00:44:34 Hans Verkuil wrote:
> >>> On 07/22/2014 12:30 AM, Laurent Pinchart wrote:
> >>>> On Monday 21 July 2014 23:43:16 Hans Verkuil wrote:
> >>>>> On 07/21/2014 10:39 PM, Laurent Pinchart wrote:
> >>>>>> The RGB666 pixel format doesn't include an alpha channel. Document
> >>>>>> it as such.
> >>>>>> 
> >>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>>>> ---
> >>>>>> 
> >>>>>>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml          | 20
> >>>>>>  ++++-------
> >>>>>> 
> >>>>>> 1 file changed, 6 insertions(+), 14 deletions(-)
> >>>>>> 
> >>>>>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>>>>> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
> >>>>>> 32feac9..c47692a 100644
> >>>>>> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>>>>> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> >>>>>> @@ -330,20 +330,12 @@ colorspace
> >>>>>> <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
> >>>>>> 
> >>>>>>  	    <entry></entry>
> >>>>>>  	    <entry>r<subscript>1</subscript></entry>
> >>>>>>  	    <entry>r<subscript>0</subscript></entry>
> >>>>>> 
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> -	    <entry></entry>
> >>>>>> +	    <entry>-</entry>
> >>>>>> +	    <entry>-</entry>
> >>>>>> +	    <entry>-</entry>
> >>>>>> +	    <entry>-</entry>
> >>>>>> +	    <entry>-</entry>
> >>>>>> +	    <entry>-</entry>
> >>>>> 
> >>>>> Just to clarify: BGR666 is a three byte format, not a four byte
> >>>>> format?

[snip]

> > My apologies, I didn't notice this earlier.
> > 
> > In case of S5P/Exynos FIMC the format is:
> > 
> > Byte 0   Byte 1   Byte 2   Byte 3
> > 
> > BBBBBBGG GGGGRRRR RR------ --------
> > 
> > i.e. 4 byte per pixel, with 14-bit padding (don't care bits).
> > 
> > As far as S3C6410 CAMIF is concerned it's hard to say. I primarily
> > developed the s3c-camif driver for S3C2440 SoC, which doesn't support
> > BGR666 format. I merged some patches from others adding s3c6410 support,
> > before sending upstream.
> > 
> > Nevertheless, looking at the S3C CAMIF datasheet the RGB666 format seems
> > identical with the FIMC one. See [1], chapter "20.7.4 MEMORY STORING
> > METHOD". This would make sense, since the S5P/Exynos FIMC is basically
> > a significantly evolved S3C CAMIF AFAICT.
> 
> Looking at the figure, I would understand RGB666 as follows
> 
> Bits 31     24|23         16|15                    8|7                     0
> ---- ----|---- -- R5 R4|R3 R2 R1 R0 G5 G4 G3 G2|G1 G0 B5 B4 B3 B2 B1 B0
> 
> Assuming little endian memory format, that would thus be
> 
> Byte 0   Byte 1   Byte 2   Byte 3
> 
> GGBBBBBB RRRRGGGG ------RR --------
> 
> If the memory format was big endian it would instead be
> 
> -------- ------RR RRRRGGGG GGBBBBBB
> 
> > [1] http://www.arm9board.net/download/OK6410/docs/S3C6410X.pdf

Did I understand something incorrectly ?

-- 
Regards,

Laurent Pinchart

