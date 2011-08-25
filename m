Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65459 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1HYMFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 08:05:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-2
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQH00AULG8X8X70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 13:05:21 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQH00G4DG8WUB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 13:05:21 +0100 (BST)
Date: Thu, 25 Aug 2011 14:02:33 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2/RFC] media: vb2: change queue initialization order
In-reply-to: <201108251312.23728.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Message-id: <021401cc631e$dfa8eba0$9efac2e0$%szyprowski@samsung.com>
Content-language: pl
References: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
 <201108251312.23728.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, August 25, 2011 1:12 PM Hans Verkuil wrote:

> On Thursday, August 25, 2011 12:52:11 Marek Szyprowski wrote:
> > This patch changes the order of operations during stream on call. Now the
> > buffers are first queued to the driver and then the start_streaming method
> > is called.
> >
> > This resolves the most common case when the driver needs to know buffer
> > addresses to enable dma engine and start streaming. Additional parameters
> > to start_streaming and buffer_queue methods have been added to simplify
> > drivers code. The driver are now obliged to check if the number of queued
> > buffers is enough to enable hardware streaming. If not - it should return
> > an error. In such case all the buffers that have been pre-queued are
> > invalidated.
> >
> > Drivers that are able to start/stop streaming on-fly, can control dma
> > engine directly in buf_queue callback. In this case start_streaming
> > callback can be considered as optional. The driver can also assume that
> > after a few first buf_queue calls with zero 'streaming' parameter, the core
> > will finally call start_streaming callback.
> 
> Looks good!
> 
> > This patch also updates some videobuf2 clients (s5p-fimc, s5p-mfc, s5p-tv,
> > mem2mem_testdev and vivi) to work properly with the changed order of
> > operations.
> 
> I assume the final patch will update all vb2 clients?

Yes, of cource. I just wanted to post the patch ASAP. Updating Samsung and 
virtual drivers was easy because I already know a bit about them. Updating
other drivers requires a bit more work to double check if I didn't break
anything.

> I have a few very minor comments below:

Thanks for your comments :) I will include them in the final version.

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


