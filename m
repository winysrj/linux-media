Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47145 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3AXPZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 10:25:35 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH4007T0YU2KU70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 15:25:33 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MH4004WSYUBPF00@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 15:25:33 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
 <1359030907-9883-2-git-send-email-k.debski@samsung.com>
 <201301241351.14213.hverkuil@xs4all.nl>
In-reply-to: <201301241351.14213.hverkuil@xs4all.nl>
Subject: RE: [PATCH 1/3 v2] v4l: Define video buffer flag for the COPY
 timestamp type
Date: Thu, 24 Jan 2013 16:25:22 +0100
Message-id: <04b701cdfa47$07de3ec0$179abc40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Thursday, January 24, 2013 1:51 PM
> 
> On Thu 24 January 2013 13:35:05 Kamil Debski wrote:
> > Define video buffer flag for the COPY timestamp. In this case the
> > timestamp value is copied from the OUTPUT to the corresponding
> CAPTURE buffer.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml |    6 ++++++
> >  include/uapi/linux/videodev2.h         |    1 +
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml
> > index 73f202f..fdd1822 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -1145,6 +1145,12 @@ in which case caches have not been
> used.</entry>
> >  	    same clock outside V4L2, use
> >  	    <function>clock_gettime(2)</function> .</entry>
> >  	  </row>
> > +	  <row>
> > +
> <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
> > +	    <entry>0x4000</entry>
> > +	    <entry>The CAPTURE buffer timestamp has been taken from the
> > +	    corresponding OUTPUT buffer.</entry>
> > +	  </row>
> 
> I think I mentioned it before somewhere, but it is helpful if it is
> mentioned here that this only applies to mem2mem devices.

Ok, will do.

Best wishes,
Kamil
 
> Regards,
> 
> 	Hans
> 
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 72e9921..d5a59af 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -697,6 +697,7 @@ struct v4l2_buffer {
> >  #define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
> >  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
> >  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
> > +#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
> >
> >  /**
> >   * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> > descriptor
> >


