Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1HLTSh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 15:18:37 -0400
Message-ID: <4E457C88.5040403@redhat.com>
Date: Fri, 12 Aug 2011 16:18:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Is V4L2_PIX_FMT_RGB656 RGB or BGR ?
References: <201108121826.39804.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108121826.39804.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2011 13:26, Laurent Pinchart escreveu:
> According to http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html, 
> V4L2_PIX_FMT_RGB565 is defined as
> 
>  Identifier           Byte 0 in memory         Byte 1 
>                   Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
>  V4L2_PIX_FMT_RGB565  g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> 
> As this is stored in little-endian, the color word is thus
> 
> b4 b3 b2 b1 b0 g5 g4 g3 g2 g1 g0 r4 r3 r2 r1 r0
> 
> This looks awfully like BGR to me, not RGB.
> 
> I need to define a FOURCC for the corresponding RGB format
> 
>  Identifier           Byte 0 in memory         Byte 1 
>                   Bit  7  6  5  4  3  2  1  0    7  6  5  4  3  2  1  0
>  V4L2_PIX_FMT_RGB565  g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> 
> Should I call it V4L2_PIX_FMT_BGR565 ? :-)
> 

Had you seen both Tables 2.6 and 2.7?

http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html#rgb-formats-corrected

The format you're looking for is "table 2.7" version of V4L2_PIX_FMT_BGR565.

Yeah, this looks crazy. Basically, some drivers were using it on one way, while
other drivers were using it the other way. I suspect that this trouble were there
since V4L1 times.

See at the changelogs (http://linuxtv.org/downloads/v4l-dvb-apis/hist-v4l2.html),
in particular the one on 2003:

1998-11-14: V4L2_PIX_FMT_RGB24 changed to V4L2_PIX_FMT_BGR24, and V4L2_PIX_FMT_RGB32 changed to V4L2_PIX_FMT_BGR32. Audio controls are now accessible with the VIDIOC_G_CTRL and VIDIOC_S_CTRL ioctls under names starting with V4L2_CID_AUDIO. The V4L2_MAJOR define was removed from videodev.h since it was only used once in the videodev kernel module. The YUV422 and YUV411 planar image formats were added.

2001-04-13: Big endian 16-bit RGB formats were added.

V4L2 2003-11-05:

  In the section called “RGB Formats” the following pixel formats were incorrectly transferred from Bill Dirks' V4L2 specification. Descriptions below refer to bytes in memory, in ascending address order.
  In the section called “Image Properties” the mapping of the V4L VIDEO_PALETTE_RGB24 and VIDEO_PALETTE_RGB32 formats to V4L2 pixel formats was accordingly corrected.
  Unrelated to the fixes above, drivers may still interpret some V4L2 RGB pixel formats differently. These issues have yet to be addressed, for details see the section called “RGB Formats”.


Mauro.
