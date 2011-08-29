Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15718 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1H2M0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:26:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-2
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQO005MMVVX4P70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 13:26:21 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQO0074QVVWLP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Aug 2011 13:26:21 +0100 (BST)
Date: Mon, 29 Aug 2011 14:26:04 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v3] media: vb2: change queue initialization order
In-reply-to: <Pine.LNX.4.64.1108291402270.31184@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>,
	'Josh Wu' <josh.wu@atmel.com>,
	'Hans de Goede' <hdegoede@redhat.com>,
	'Paul Mundt' <lethal@linux-sh.org>
Message-id: <009901cc6646$d2a7d4e0$77f77ea0$%szyprowski@samsung.com>
Content-language: pl
References: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1108291402270.31184@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, August 29, 2011 2:05 PM Guennadi Liakhovetski wrote:

> Hi Marek
> 
> On Mon, 29 Aug 2011, Marek Szyprowski wrote:
> 
> > This patch changes the order of operations during stream on call. Now the
> > buffers are first queued to the driver and then the start_streaming method
> > is called.
> >
> > This resolves the most common case when the driver needs to know buffer
> > addresses to enable dma engine and start streaming. Additional parameter
> > to start_streaming method have been added to simplify drivers code. The
> > driver are now obliged to check if the number of queued buffers is high
> > enough to enable hardware streaming. If not - it can return an error. In
> > such case all the buffers that have been pre-queued are invalidated.
> >
> > This patch also updates all videobuf2 clients to work properly with the
> > changed order of operations.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > CC: Hans Verkuil <hverkuil@xs4all.nl>
> > CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > CC: Kamil Debski <k.debski@samsung.com>
> > CC: Jonathan Corbet <corbet@lwn.net>
> > CC: Josh Wu <josh.wu@atmel.com>
> > CC: Hans de Goede <hdegoede@redhat.com>
> > CC: Paul Mundt <lethal@linux-sh.org>
> > ---
> >
> > Hello,
> >
> > This is yet another version of the patch that introduces significant
> > changes in the vb2 streamon operation. I've decided to remove the
> > additional parameter to buf_queue callback and added a few cleanups here
> > and there. This patch also includes an update for all vb2 clients.
> 
> Just for the record: These are not all vb2 clients. A simple grep for
> something like vb2_ops gives you also
> 
> drivers/media/video/mx3_camera.c
> drivers/media/video/sh_mobile_ceu_camera.c

Yes, they are also vb2 clients, but since they don't use start_streaming() 
callback no changes were needed there. Same applies to mem2mem_testdev driver.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


