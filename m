Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10100 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1KDN2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 09:28:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU500M7X1G12E60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 13:28:49 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU5002TD1G0PW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 13:28:49 +0000 (GMT)
Date: Fri, 04 Nov 2011 14:28:48 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Query the meaning of variable in v4l2_pix_format and v4l2_plane
In-reply-to: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com>
To: 'Jonghun Han' <jonghun.han@samsung.com>,
	linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hans.verkuil@cisco.com>
Message-id: <007701cc9af5$af267560$0d736020$%szyprowski@samsung.com>
Content-language: pl
References: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, November 04, 2011 2:08 PM Jonghun Han wrote:

> I'm not sure the meaning of variables in v4l2_pix_format and v4l2_plane.
> Especially bytesperline, sizeimage, length and bytesused.
> 
> v4l2_pix_format.width		= width
> v4l2_pix_format.height		= height
> v4l2_pix_format.bytesperline	= bytesperline [in bytes]
> v4l2_pix_format.sizeimage	= bytesperline * buf height  -> Is this
> right ?

Yes, I would expect it to be calculated this way for formats where 
bytesperline can be defined (for macroblock format bytesperline is hard
to define).

> 
> v4l2_plane.length	= bytesperline * buf height  -> Is this right ?
> I don't which is right.
> v4l2_plane.bytesused	= bytesperline * (top + height)
> v4l2_plane.bytesused	= bytesperline * height
> v4l2_plane.bytesused	= width * height * bytesperpixel
> v4l2_plane.bytesused	= bytesperline * (top + height) - (pixelperline -
> (left + width)) * bytesperpixel

bytesused should indicate how many bytes have been modified from the 
beginning of the buffer, so memcpy(dst, buf->mem, byteused) will copy 
all the video data.

So probably the most appropriate value for bytesused is:
v4l2_plane.bytesused	= bytesperline * (top + height)

I hope my assumptions are correct, but I would also like Hans to comment 
on this.

> I assumed the following buffer.
> 
> |                                                          |
> |<--------------------- bytesperline --------------------->|
> |                                                          |
> +----------------------------------------------------------+-----
> |          ^                                               |  ^
> |          |                                               |  |
> |                                                          |  |
> |          t                                               |  |
> |          o                                               |  |
> |          p                                               |  |
> |                                                          |  |
> |          |                                               |  |
> |          V |<--------- width ---------->|                |  |
> |<-- left -->+----------------------------+ -              |  |
> |            |                            | ^              |
> |            |                            | |              |  b
> |            |                            | |              |  u
> |            |                            |                |  f
> |            |                            | h              |
> |            |                            | e              |  h
> |            |                            | i              |  e
> |            |                            | g              |  i
> |            |                            | h              |  g
> |            |                            | t              |  h
> |            |                            |                |  t
> |            |                            | |              |
> |            |                            | |              |  |
> |            |                            | v              |  |
> |            +----------------------------+ -              |  |
> |                                                          |  |
> |                                                          |  |
> |                                                          |  v
> +----------------------------------------------------------+-----
 
Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


