Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:56424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab0JYKNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 06:13:42 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0LAU00MCCCESEU40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Oct 2010 19:13:40 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LAU00JXFCEP2I@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Oct 2010 19:13:40 +0900 (KST)
Date: Mon, 25 Oct 2010 12:13:36 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
In-reply-to: <AANLkTinaYuwHci++fDRB7c1Lzbcew2Hzzect=GZqOpEL@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Message-id: <019301cb742d$4ba0c990$e2e25cb0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com>
 <1287556873-23179-2-git-send-email-m.szyprowski@samsung.com>
 <AANLkTinaYuwHci++fDRB7c1Lzbcew2Hzzect=GZqOpEL@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, October 25, 2010 2:17 AM Pawel Osciak wrote:

> On Tue, Oct 19, 2010 at 23:41, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > From: Pawel Osciak <p.osciak@samsung.com>
> 
> > +/**
> > + * __vb2_queue_cancel() - cancel and stop (pause) streaming
> > + *
> > + * Removes all queued buffers from driver's queue and all buffers queued by
> > + * userspace from videobuf's queue. Returns to state after reqbufs.
> > + */
> > +static void __vb2_queue_cancel(struct vb2_queue *q)
> > +{
> > +       /*
> > +        * Tell driver to stop all dma transactions and release all queued
> > +        * buffers
> > +        */
> 
> Just being picky, but those doesn't neccesarily are "dma" transactions.

Ok, I will change this comment.

> 
> > +       if (q->streaming && q->ops->stop_streaming)
> > +               q->ops->stop_streaming(q);
> > +       q->streaming = 0;
> > +
> > +       /*
> > +        * Remove all buffers from videobuf's list...
> > +        */
> > +       INIT_LIST_HEAD(&q->queued_list);
> > +       /*
> > +        * ...and done list; userspace will not receive any buffers it
> > +        * has not already dequeued before initiating cancel.
> > +        */
> > +       INIT_LIST_HEAD(&q->done_list);
> > +       wake_up_all(&q->done_wq);
> 
> Any reason for replacing wake_up_interruptible_all with wake_up_all?

IMHO there is no reason to limit it to wake_up_interruptible_all. 

Initially I thought that the driver MIGHT want to implement stop_streaming()
on top of this wait_queue, but later I abandoned this idea...

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center

