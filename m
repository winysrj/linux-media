Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57284 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab1DHMs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 08:48:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: vb2: stop_streaming() callback redesign
Date: Fri, 8 Apr 2011 14:48:15 +0200
Cc: "'Pawel Osciak'" <pawel@osciak.com>, linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de
References: <1301874670-14833-1-git-send-email-pawel@osciak.com> <201104041227.30262.laurent.pinchart@ideasonboard.com> <009f01cbf39d$a9cd7320$fd685960$%szyprowski@samsung.com>
In-Reply-To: <009f01cbf39d$a9cd7320$fd685960$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081448.25924.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek,

On Tuesday 05 April 2011 16:27:54 Marek Szyprowski wrote:
> On Monday, April 04, 2011 12:27 PM Laurent Pinchart wrote:
> > On Monday 04 April 2011 01:51:05 Pawel Osciak wrote:
> > > 
> > > This series implements a slight redesign of the stop_streaming()
> > > callback in vb2. The callback has been made obligatory. The drivers
> > > are expected to finish all hardware operations and cede ownership of
> > > all buffers before returning, but are not required to call
> > > vb2_buffer_done() for any of them. The return value from this callback
> > > has also been removed.
> > 
> > What's the rationale behind this patch set ? I've always been against vb2
> > controlling the stream state (vb2 should handle buffer management only in
> > my opinion) and I'd like to understand why you want to make it required.
> 
> Let me remind the rationale behind {start,stop}_streaming. Basically there
> are more than one place where you should change the DMA streaming state,
> some of which are quite obvious (like stream_{on,off}), the others are a
> bit more surprising (like the recently discussed first call to poll()).

stream_on and stream_off are not difficult to handle on the driver side, but I 
agree that it becomes more complex when poll() and read() get involved. I 
still believe that stream on/off is out of scope of the video buffer 
management implemementation.

> Also some of the vb2 operations behaves differently if streaming is
> enabled or not (like dqbuf), so vb2 needs to be aware of streaming state
> change.

I have no issue with vb2 being aware of stream state changes, my issues comes 
from vb2 managing the stream state itself.

> The idea is also to simplify the drivers and provide a one-to-one functions
> for all typical v4l2 operations: req_bufs, query_bufs, q_buf, dq_buf,
> stream_on, stream_off, mmap, read/write, poll, so implementation of all
> from this list can be a simple 4 lines of code, like the following:
> 
> static int vidioc_streamon(struct file *file, void *priv, enum
> v4l2_buf_type i) {
>         struct vivi_dev *dev = video_drvdata(file);
>         return vb2_streamon(&dev->vb_vidq, i);
> }

All those functions deal with buffer management, except for streamon and 
streamoff.

> > I plan to use vb2 in the uvcvideo driver (when vb2 will provide a way to
> > handle device disconnection), and uvcvideo will stop the stream before
> > calling vb2_queue_release() and vb2_streamoff(). Would will I need a
> > stop_stream operation ?
> 
> What's prevents you from moving the dma streaming stop call from
> stop_streaming ioctl and release file operation?

Probably not much. What bothers me is that the vb2 stream on/off callbacks to 
drivers are not properly documented, so driver authors might implement them 
without thinking about all possible call paths, and crash in corner cases. I 
don't like implementing a callback in a driver when I don't know exactly when 
and how it can be called.

-- 
Regards,

Laurent Pinchart
