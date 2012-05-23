Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61965 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780Ab2EWL1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 07:27:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eusync2.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00ELV3SXKN50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 12:26:57 +0100 (BST)
Received: from [106.116.48.198] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M4H00L103UBKB60@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 12:27:48 +0100 (BST)
Subject: Re: [PATCH 0/2] s5p-mfc: added encoder support for end of stream
 handling
From: Andrzej Hajda <a.hajda@samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
In-reply-to: <201205230943.19410.hansverk@cisco.com>
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
 <201205230943.19410.hansverk@cisco.com>
Date: Wed, 23 May 2012 13:20:03 +0200
Message-id: <1337772003.1594.79.camel@AMDC1061>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-05-23 at 09:43 +0200, Hans Verkuil wrote:
> Hi Andrzej!
> 
> Thanks for the patch, but I do have two questions:
> 
> On Tue 22 May 2012 17:33:53 Andrzej Hajda wrote:
> > Those patches add end of stream handling for s5p-mfc encoder.
> > 
> > The first patch was sent already to the list as RFC, but the discussion ended
> > without any decision.
> > This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. Below short
> > description of this change.
> > 
> > s5p_mfc is a mem-to-mem MPEG/H263/H264 encoder and it requires that the last
> > incoming frame must be processed differently, it means the information about
> > the end of the stream driver should receive NOT LATER than the last
> > V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer. Common practice
> > of sending empty buffer to indicate end-of-stream do not work in such case.
> > Setting V4L2_BUF_FLAG_EOS flag for the last V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
> > buffer seems to be the most straightforward solution here.
> > 
> > V4L2_BUF_FLAG_EOS flag should be used by application if driver requires it
> 
> How will the application know that?

Application can always set this flag, it will be ignored by drivers not
requiring it.

I see some drawback of this solution - application should know if the
frame enqueued to the driver is the last one. If the application
receives frames to encode form an external source (for example via pipe)
it often does not know if the frame it received is the last one. So to
be able to properly queue frame to the driver it should wait with frame
queuing until it knows there is next frame or end-of-stream is reached,
in such situation it will properly set flag before queuing.

Alternative to "V4L2_BUF_FLAG_EOS" solution is to implement "wait for
next frame" logic directly into the driver. In such case application can
use empty buffer to signal the end of the stream. Driver waits with
frame processing if there are at least two buffers in output queue. Then
it checks if the second buffer is empty if not it process the first
buffer as a normal frame and repeats procedure, if yes it process the
first buffer as the last frame and releases second buffer.

The drawback of this solution is that it wastes resources/space
(additional buffer) and time (delayed encoding).

I am still hesitating which solution is better, any advices?


> > and it should be set only on V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffers.
> 
> Why only for this type?

I wanted to say only for output buffers not just output multi-plane. And
why not capture? Explanation below.
Capture buffers are filled by driver, so only drivers could set this
flag. Some devices provides information about the end of the stream
together with the last frame, but some devices provides this info later
(for example s5p-mfc :) ). In the latter case to properly flag the
capture buffer driver should wait for next available frame. Simpler
solution is to use current solution with sending empty buffer to signal
the end of the stream.

Regards
Andrzej Hajda


