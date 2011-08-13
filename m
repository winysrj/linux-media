Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38279 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1HMKWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 06:22:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Is V4L2_PIX_FMT_RGB656 RGB or BGR ?
Date: Sat, 13 Aug 2011 12:22:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201108121826.39804.laurent.pinchart@ideasonboard.com> <4E457C88.5040403@redhat.com>
In-Reply-To: <4E457C88.5040403@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108131222.37132.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 12 August 2011 21:18:32 Mauro Carvalho Chehab wrote:
> Em 12-08-2011 13:26, Laurent Pinchart escreveu:
> > According to http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html,
> > V4L2_PIX_FMT_RGB565 is defined as
> > 
> >  Identifier           Byte 0 in memory         Byte 1
> >  
> >                   Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
> >  
> >  V4L2_PIX_FMT_RGB565  g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> > 
> > As this is stored in little-endian, the color word is thus
> > 
> > b4 b3 b2 b1 b0 g5 g4 g3 g2 g1 g0 r4 r3 r2 r1 r0
> > 
> > This looks awfully like BGR to me, not RGB.
> > 
> > I need to define a FOURCC for the corresponding RGB format
> > 
> >  Identifier           Byte 0 in memory         Byte 1
> >  
> >                   Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
> >  
> >  V4L2_PIX_FMT_RGB565  g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> > 
> > Should I call it V4L2_PIX_FMT_BGR565 ? :-)
> 
> Had you seen both Tables 2.6 and 2.7?
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html#rgb-formats-corre
> cted

Good point, I missed 2.7. Thank you.

> The format you're looking for is "table 2.7" version of
> V4L2_PIX_FMT_BGR565.
> 
> Yeah, this looks crazy. Basically, some drivers were using it on one way,
> while other drivers were using it the other way. I suspect that this
> trouble were there since V4L1 times.
> 
> See at the changelogs
> (http://linuxtv.org/downloads/v4l-dvb-apis/hist-v4l2.html), in particular
> the one on 2003:
> 
> 1998-11-14: V4L2_PIX_FMT_RGB24 changed to V4L2_PIX_FMT_BGR24, and
> V4L2_PIX_FMT_RGB32 changed to V4L2_PIX_FMT_BGR32. Audio controls are now
> accessible with the VIDIOC_G_CTRL and VIDIOC_S_CTRL ioctls under names
> starting with V4L2_CID_AUDIO. The V4L2_MAJOR define was removed from
> videodev.h since it was only used once in the videodev kernel module. The
> YUV422 and YUV411 planar image formats were added.

Thinking some more about this, there might be a reason why RGB24/32 and 
BGR24/32 were mixed.

If you look at the RGB565 format, a pixel is stored as

Bit 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    r4 r3 r2 r1 r0 g5 g4 g3 g2 g1 g0 b4 b3 b2 b1 b0

in a 16-bit word. Storing that to memory on a little endian system, we then 
get

Byte 0                        1
Bit  7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0
    g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3

This is logical, and is what table 2.7 defines. If we apply the same reasoning 
to an  RGB24 format, a pixel should be stored in a 24-bit word as 

Bit 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    r7 r6 r5 r4 r3 r2 r1 r0 g7 g6 g5 g4 g3 g2 g1 g0 b7 b6 b5 b4 b3 b2 b1 b0

Storing that to memory on a little endian system, we would get

Byte 0                         1                         2
Bit  7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0
    b7 b6 b5 b4 b3 b2 b1 b0  g7 g6 g5 g4 g3 g2 g1 g0  r7 r6 r5 r4 r3 r2 r1 r0

We call this BGR24 in table 2.7. This makes sense, as bytes are stored in BGR 
order in memory. However, this is inconsistent with the way we name RGB565. 
The RGB565 name is defined by the pixel layout in a 16-bit word, while the 
RGB24 and (RGB32) names are defined by the pixel layout in memory.

This is obviously something we can live with, but it's worth understanding 
where we come from and how we name formats to avoid confusions.

> 2001-04-13: Big endian 16-bit RGB formats were added.
> 
> V4L2 2003-11-05:
> 
>   In the section called “RGB Formats” the following pixel formats were
> incorrectly transferred from Bill Dirks' V4L2 specification. Descriptions
> below refer to bytes in memory, in ascending address order. In the section
> called “Image Properties” the mapping of the V4L VIDEO_PALETTE_RGB24 and
> VIDEO_PALETTE_RGB32 formats to V4L2 pixel formats was accordingly
> corrected. Unrelated to the fixes above, drivers may still interpret some
> V4L2 RGB pixel formats differently. These issues have yet to be addressed,
> for details see the section called “RGB Formats”.

-- 
Regards,

Laurent Pinchart
