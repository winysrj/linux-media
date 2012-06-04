Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40261 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab2FDMiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 08:38:01 -0400
Received: from eusync2.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M53007CMF4D3E00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Jun 2012 13:38:37 +0100 (BST)
Received: from [106.116.48.198] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M53004J2F3A7A00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Jun 2012 13:37:59 +0100 (BST)
Subject: Re: [PATCH 0/2] s5p-mfc: added encoder support for end of stream
 handling
From: Andrzej Hajda <a.hajda@samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
In-reply-to: <201205231428.05117.hansverk@cisco.com>
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
 <201205230943.19410.hansverk@cisco.com> <1337772003.1594.79.camel@AMDC1061>
 <201205231428.05117.hansverk@cisco.com>
Content-type: text/plain; charset=UTF-8
Date: Mon, 04 Jun 2012 14:37:57 +0200
Message-id: <1338813477.21426.65.camel@AMDC1061>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-05-23 at 14:28 +0200, Hans Verkuil wrote:
> On Wed 23 May 2012 13:20:03 Andrzej Hajda wrote:
> > On Wed, 2012-05-23 at 09:43 +0200, Hans Verkuil wrote:
> > > Hi Andrzej!
> > > 
> > > Thanks for the patch, but I do have two questions:
> > > 
> > > On Tue 22 May 2012 17:33:53 Andrzej Hajda wrote:
> > > > Those patches add end of stream handling for s5p-mfc encoder.
> > > > 
> > > > The first patch was sent already to the list as RFC, but the discussion ended
> > > > without any decision.
> > > > This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. Below short
> > > > description of this change.
> > > > 
> > > > s5p_mfc is a mem-to-mem MPEG/H263/H264 encoder and it requires that the last
> > > > incoming frame must be processed differently, it means the information about
> > > > the end of the stream driver should receive NOT LATER than the last
> > > > V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer. Common practice
> > > > of sending empty buffer to indicate end-of-stream do not work in such case.
> > > > Setting V4L2_BUF_FLAG_EOS flag for the last V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
> > > > buffer seems to be the most straightforward solution here.
> > > > 
> > > > V4L2_BUF_FLAG_EOS flag should be used by application if driver requires it
> > > 
> > > How will the application know that?
> > 
> > Application can always set this flag, it will be ignored by drivers not
> > requiring it.
> 
> That's going to make it very hard to write generic applications: people will
> always forget to set that flag, unless they happen to using your hardware.
> 
> > I see some drawback of this solution - application should know if the
> > frame enqueued to the driver is the last one. If the application
> > receives frames to encode form an external source (for example via pipe)
> > it often does not know if the frame it received is the last one. So to
> > be able to properly queue frame to the driver it should wait with frame
> > queuing until it knows there is next frame or end-of-stream is reached,
> > in such situation it will properly set flag before queuing.
> > 
> > Alternative to "V4L2_BUF_FLAG_EOS" solution is to implement "wait for
> > next frame" logic directly into the driver. In such case application can
> > use empty buffer to signal the end of the stream. Driver waits with
> > frame processing if there are at least two buffers in output queue. Then
> > it checks if the second buffer is empty if not it process the first
> > buffer as a normal frame and repeats procedure, if yes it process the
> > first buffer as the last frame and releases second buffer.
> 
> In the current V4L2 API the last output frame is reached when:
> 
> 1) the filehandle is closed
> 2) VIDIOC_STREAMOFF is called
> 3) VIDIOC_ENCODER_CMD is called with V4L2_ENC_CMD_STOP.
> 
> The latter is currently only used by MPEG encoders, but it might be an idea
> to consider it for your hardware as well. Perhaps a flag like 'stop_after_next_frame'
> is needed.

It seemed to me less straightforward - EOS is sent before the last frame
- but I can implement it this way of course.

> 
> How are cases 1 and 2 handled today?
> 

As I lurked into the driver's code it seems it behaves in standard way -
driver waits for device to finish current operation if there is any,
next it releases all buffers.

> And what happens if the app sets the EOS flag, and then later queues another
> buffer without that flag. Is that frame accepted/rejected/ignored?

I have not take care of this situation.

The simplest solution is to reject frames, application in that case
should reopen device to encode next stream if necessary.

Other solution I see is to allow queue output frames but do not process
them by device until device finish producing encoded frames, it would
require device reinitialization.

> 
> I'm trying to understand how the current implementation behaves in corner cases
> like those.
> 
> > The drawback of this solution is that it wastes resources/space
> > (additional buffer) and time (delayed encoding).
> > 
> > I am still hesitating which solution is better, any advices?
> > 
> > 
> > > > and it should be set only on V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffers.
> > > 
> > > Why only for this type?
> > 
> > I wanted to say only for output buffers not just output multi-plane. And
> > why not capture? Explanation below.
> > Capture buffers are filled by driver, so only drivers could set this
> > flag. Some devices provides information about the end of the stream
> > together with the last frame, but some devices provides this info later
> > (for example s5p-mfc :) ). In the latter case to properly flag the
> > capture buffer driver should wait for next available frame. Simpler
> > solution is to use current solution with sending empty buffer to signal
> > the end of the stream.
> 

> I don't believe this is documented anywhere. Wouldn't it be better to send
> a V4L2_EVENT_EOS event? That's documented and is the way I would expect this
> to work.

OK, I will change the code accordingly.

Regards
Andrzej


