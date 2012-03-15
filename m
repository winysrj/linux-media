Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:27586 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761898Ab2CONTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 09:19:42 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0X00MGDH07FK20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 22:19:40 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0X00C6TH0SAP00@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Thu, 15 Mar 2012 22:19:44 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'javier Martin' <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
References: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
 <20120315110336.GH4220@valkosipuli.localdomain>
In-reply-to: <20120315110336.GH4220@valkosipuli.localdomain>
Subject: RE: [Q] media: V4L2 compressed frames and s_fmt.
Date: Thu, 15 Mar 2012 14:19:33 +0100
Message-id: <006d01cd02ae$457fc960$d07f5c20$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier, Sakari,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: 15 March 2012 12:04
> 
> Hi Javier,
> 
> (Cc Kamil.)
> 
> On Wed, Mar 14, 2012 at 12:22:43PM +0100, javier Martin wrote:
> > Hi,
> > I'm developing a V4L2 mem2mem driver for the codadx6 IP video codec
> > which is included in the i.MX27 chip.
> >
> > The capture interface of this driver can therefore return h.264 or
> > mpeg4 video frames.
> >
> > Provided that the size of each frame varies and is unknown to the
> > user, how is the driver supposed to react to a S_FMT when it comes to
> > parameters such as the following?
> >
> > pix->width
> > pix->height
> > pix->bytesperline
> > pix->sizeimage
> >
> > According to the documentation [1] I understand that the driver can
> > just ignore 'bytesperline' and should return in 'sizeimage' the
> > maximum buffer size to store a compressed frame. However, it does not
> > mention anything special about width and height. Does it make sense
> > setting width and height for h.264/mpeg4 formats?
> 

Yes, in case of the compressed side (capture) the width, height and
bytesperline
is ignored. The MFC driver sets bytesperline to 0 and leaves width and height
intact
during S_FMT. I suggest you do the same or set all of them (width, height,
bytesperline)
to 0.

> It does. This has been recently discussed, and there were a few ideas how
> to
> do this. But no final conclusion AFAIR.
> 
> <URL:http://www.spinics.net/lists/linux-media/msg40905.html>

In this RFC we have discussed the decoding and resolution change while
decoding. Here the question is about encoding.

> 
> Kamil: do you have plans to update the RFC?
> 

As Javier is now working on a codec driver then it might the right time to 
bring the discussion back to life.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

