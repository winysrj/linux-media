Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58734 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1HRFtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 01:49:51 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQ4009IP071CI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Aug 2011 06:49:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ400KIX070IW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Aug 2011 06:49:48 +0100 (BST)
Date: Thu, 18 Aug 2011 07:49:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
In-reply-to: <CAMm-=zBhUVnY3gd32PTs+TyP0pdJOY_gfiJkb0K6PF3=yskFGQ@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>
Cc: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans Verkuil' <hansverk@cisco.com>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Sakari Ailus' <sakari.ailus@maxwell.research.nokia.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>
Message-id: <002301cc5d6a$8f41ea40$adc5bec0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081116.41126.hansverk@cisco.com>
 <Pine.LNX.4.64.1108151324220.7851@axis700.grange>
 <201108151336.07258.hansverk@cisco.com>
 <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
 <009201cc5ce0$bd34de10$379e9a30$%szyprowski@samsung.com>
 <CAMm-=zBhUVnY3gd32PTs+TyP0pdJOY_gfiJkb0K6PF3=yskFGQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, August 17, 2011 4:58 PM Pawel Osciak wrote:

> On Wed, Aug 17, 2011 at 06:22, Marek Szyprowski <m.szyprowski@samsung.com>
> wrote:
> > On Monday, August 15, 2011 3:46 PM Guennadi Liakhovetski wrote:
> >> While switching back, I have to change the struct vb2_ops::queue_setup()
> >> operation to take a struct v4l2_create_buffers pointer. An earlier version
> >> of this patch just added one more parameter to .queue_setup(), which is
> >> easier - changes to videobuf2-core.c are smaller, but it is then
> >> redundant. We could use the create pointer for both input and output. The
> >> video plane configuration in frame format is the same as what is
> >> calculated in .queue_setup(), IIUC. So, we could just let the driver fill
> >> that one in. This would require then the videobuf2-core.c to parse struct
> >> v4l2_format to decide which union member we need, depending on the buffer
> >> type. Do we want this or shall drivers duplicate plane sizes in separate
> >> .queue_setup() parameters?
> >
> > IMHO if possible we should have only one callback for the driver. Please
> > notice that the driver should be also allowed to increase (or decrease) the
> > number of buffers for particular format/fourcc.
> >
> 
> Or remove queue_setup altogether (please see my example above). What
> do you think Marek?

I'm perfectly fine with replacing queue_setup callback with something else.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

