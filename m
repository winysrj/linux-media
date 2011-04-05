Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:35288 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1DEO22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 10:28:28 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LJ600BSZO6WACB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Apr 2011 23:28:08 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LJ600959O6K7M@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Apr 2011 23:28:08 +0900 (KST)
Date: Tue, 05 Apr 2011 16:27:54 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: stop_streaming() callback redesign
In-reply-to: <201104041227.30262.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <009f01cbf39d$a9cd7320$fd685960$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
 <201104041227.30262.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, April 04, 2011 12:27 PM Laurent Pinchart wrote:

> Hi Pawel,
> 
> On Monday 04 April 2011 01:51:05 Pawel Osciak wrote:
> > Hi,
> >
> > This series implements a slight redesign of the stop_streaming() callback
> > in vb2. The callback has been made obligatory. The drivers are expected to
> > finish all hardware operations and cede ownership of all buffers before
> > returning, but are not required to call vb2_buffer_done() for any of them.
> > The return value from this callback has also been removed.
> 
> What's the rationale behind this patch set ? I've always been against vb2
> controlling the stream state (vb2 should handle buffer management only in my
> opinion) and I'd like to understand why you want to make it required.

Let me remind the rationale behind {start,stop}_streaming. Basically there are
more than one place where you should change the DMA streaming state, some of
which are quite obvious (like stream_{on,off}), the others are a bit more
surprising (like the recently discussed first call to poll()). Also some of
the vb2 operations behaves differently if streaming is enabled or not
(like dqbuf), so vb2 needs to be aware of streaming state change.

The idea is also to simplify the drivers and provide a one-to-one functions for
all typical v4l2 operations: req_bufs, query_bufs, q_buf, dq_buf, stream_on,
stream_off, mmap, read/write, poll, so implementation of all from this list can
be a simple 4 lines of code, like the following:

static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
{
        struct vivi_dev *dev = video_drvdata(file);
        return vb2_streamon(&dev->vb_vidq, i);
}

> I plan to use vb2 in the uvcvideo driver (when vb2 will provide a way to
> handle device disconnection), and uvcvideo will stop the stream before calling
> vb2_queue_release() and vb2_streamoff(). Would will I need a stop_stream
> operation ?

What's prevents you from moving the dma streaming stop call from stop_streaming
ioctl and release file operation?

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


