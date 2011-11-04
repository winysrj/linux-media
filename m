Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:23580 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1KDOsE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:48:04 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: "'Jonghun Han'" <jonghun.han@samsung.com>
Subject: Re: Query the meaning of variable in v4l2_pix_format and v4l2_plane
Date: Fri, 4 Nov 2011 15:48:01 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	"'Hans Verkuil'" <hans.verkuil@cisco.com>
References: <001c01cc9af2$c607e0f0$5217a2d0$%han@samsung.com> <007701cc9af5$af267560$0d736020$%szyprowski@samsung.com>
In-Reply-To: <007701cc9af5$af267560$0d736020$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041548.01326.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 November 2011 14:28:48 Marek Szyprowski wrote:
> Hello,
> 
> On Friday, November 04, 2011 2:08 PM Jonghun Han wrote:
> > I'm not sure the meaning of variables in v4l2_pix_format and v4l2_plane.
> > Especially bytesperline, sizeimage, length and bytesused.
> > 
> > v4l2_pix_format.width		= width
> > v4l2_pix_format.height		= height

buf_height, actually (based on your picture).

> > v4l2_pix_format.bytesperline	= bytesperline [in bytes]
> > v4l2_pix_format.sizeimage	= bytesperline * buf height  -> Is this
> > right ?
> 
> Yes, I would expect it to be calculated this way for formats where
> bytesperline can be defined (for macroblock format bytesperline is hard
> to define).

Correct. For formats where bytesperline is meaningless I guess most drivers
will leave this at 0. It's not actually specced what it should be in those
cases.

> > v4l2_plane.length	= bytesperline * buf height  -> Is this right ?
> > I don't which is right.
> > v4l2_plane.bytesused	= bytesperline * (top + height)
> > v4l2_plane.bytesused	= bytesperline * height
> > v4l2_plane.bytesused	= width * height * bytesperpixel
> > v4l2_plane.bytesused	= bytesperline * (top + height) - 
(pixelperline -
> > (left + width)) * bytesperpixel
> 
> bytesused should indicate how many bytes have been modified from the
> beginning of the buffer, so memcpy(dst, buf->mem, byteused) will copy
> all the video data.
> 
> So probably the most appropriate value for bytesused is:
> v4l2_plane.bytesused	= bytesperline * (top + height)

The bytesused field is set by the driver when you capture video and will 
typically be equal to bytesperline * buf_height. For compressed formats it can 
be any value <= sizeimage though.

For video output it is the application that fills in bytesused.

However, I want to add something here: it is currently not possible to specify
anything other than horizontal padding. I.e., bytesperline can be more than 
the width, allowing for a right margin, but you can't specify a left margin.
So left == 0 at the moment. Also, in the current API top == 0 as well.

Drivers can set the data_offset field in v4l2_plane to a non-zero value, and
that might be a way to create a top margin, but this is really meant for meta 
data that is carried at the beginning of a buffer.

Recent discussions led to a proposal to add a app_offset field where 
applications can specify an additional offset from the beginning of the 
buffer. But this has not been added.

Regards,

	Hans

> I hope my assumptions are correct, but I would also like Hans to comment
> on this.
> 
> > I assumed the following buffer.
> > 
> > |<--------------------- bytesperline --------------------->|
> > 
> > +----------------------------------------------------------+-----
> > 
> > |          ^                                               |  ^
> > |          
> > |          
> > |          t                                               |  |
> > |          o                                               |  |
> > |          p                                               |  |
> > |          
> > |          
> > |          V |<--------- width ---------->|                |  |
> > |
> > |<-- left -->+----------------------------+ -              |  |
> > |
> > |            |                            | ^              |
> > |            |                            | 
> > |            |                            | |              |  b
> > |            |                            | |              |  u
> > |            |                            | |              |  
> > |            |                            |                |  f
> > |            |                            | 
> > |            |                            | h              |
> > |            |                            | e              |  h
> > |            |                            | i              |  e
> > |            |                            | g              |  i
> > |            |                            | h              |  g
> > |            |                            | t              |  h
> > |            |                            | 
> > |            |                            |                |  t
> > |            |                            | 
> > |            |                            | v              |  |
> > |            
> > |            +----------------------------+ -              |  |
> > |            
> > |                                                          |  v
> > 
> > +----------------------------------------------------------+-----
> 
> Best regards
