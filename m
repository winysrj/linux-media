Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40905 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZIAK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 06:59:22 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH take 2] V4L: videobuf-core.c VIDIOC_QBUF should return video buffer flags
Date: Tue, 1 Sep 2009 13:58:51 +0300
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sailus@maxwell.research.nokia.com"
	<sailus@maxwell.research.nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200908311458.54406.tuukka.o.toivonen@nokia.com> <200909011056.19731.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200909011056.19731.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909011358.51199.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 01 September 2009 11:56:19 ext Laurent Pinchart wrote:
> On Monday 31 August 2009 13:58:54 Tuukka.O Toivonen wrote:
> > When user space queues a buffer using VIDIOC_QBUF, the kernel
> > should set flags in struct v4l2_buffer as specified in the V4L2
> > documentation.
> 
> You forgot your SoB line.

My bad.

> > +	__u32 buffer_flags = b->flags;
> 
> Is that safe ? What if userspace sets bogus flags ? 

What else userspace should expect than garbage in, garbage out?
Now this sets and clears exactly what V4L2 spec says it should, should
we clear all other flags also?

What about other fields that are not mentioned in the VIDIOC_QBUF
documentation for input buffers, like bytesused, timestamp, etc.?
Should VIDIOC_QBUF clear those also?

- Tuukka
