Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24067 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab1KDQDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 12:03:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU500G1X8KXCA80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 16:02:57 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LU500DKC8KWB1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 16:02:57 +0000 (GMT)
Date: Fri, 04 Nov 2011 17:02:54 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: Query the meaning of variable in v4l2_pix_format and v4l2_plane
In-reply-to: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com>
To: Jonghun Han <jonghun.han@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com
Message-id: <4EB40CAE.50406@samsung.com>
References: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/2011 02:07 PM, Jonghun Han wrote:
>
> Hi,

Hi Mr. Han,

>
> I'm not sure the meaning of variables in v4l2_pix_format and v4l2_plane.
> Especially bytesperline, sizeimage, length and bytesused.
>
> v4l2_pix_format.width		= width
> v4l2_pix_format.height		= height

The fields width and height are undefined for some formats, like 
compressed JPEG and video streams.

> v4l2_pix_format.bytesperline	= bytesperline [in bytes]

The spec says "Distance in bytes between the leftmost pixels in two 
adjacent lines" for the largest plane. For YUV 4:2:0 the largest plane 
is luminance, where one pixel is one byte.

> v4l2_pix_format.sizeimage	= bytesperline * buf height  ->  Is this
> right ?

It is the upper limit for size of image of desired size. This value is 
needed if images are passed in compressed formats.

>
> v4l2_plane.length	= bytesperline * buf height  ->  Is this right ?
> I don't which is right.

This is the upper limit for a size of a given plane. For simple formats use:
v4l2_plane.length = plane_height * plane.bytesperline
The plane_height may be smaller the buf_height. For example for YUV420, 
the height of the chrominance plane, should be the half of buf_height.

For compressed formats it specify upper limit for plane size.

> v4l2_plane.bytesused	= bytesperline * (top + height)
> v4l2_plane.bytesused	= bytesperline * height
> v4l2_plane.bytesused	= width * height * bytesperpixel
> v4l2_plane.bytesused	= bytesperline * (top + height) - (pixelperline -
> (left + width)) * bytesperpixel

bytesused specify how much valid data is present in the buffer.
For simple formates you should use:
v4l2_plane.bytesused	= v4l2_plane.length
while queuing buffer into OUTPUT queue.

The inner rectangle refers to cropping rectangle for mem2mem devices. 
This rectangle should not be used in any computations of the buffer 
parameters.

Best regards,
Tomasz Stanislawski
>
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
>
>
> Best regards,
>
>

