Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56090 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3LIND3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 08:03:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net
Subject: Re: vb2: various cleanups and improvements
Date: Mon, 09 Dec 2013 14:03:38 +0100
Message-ID: <3273275.u4ouo9oMWu@avalon>
In-Reply-To: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
References: <1386231709-14262-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

For patches 1, 2, 4, 7 and 10,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Thursday 05 December 2013 09:21:39 Hans Verkuil wrote:
> This patch series does some cleanups in the qbuf/prepare_buf handling
> (the first two patches). The third patch removes the 'fileio = NULL'
> hack. That hack no longer works when dealing with asynchronous calls
> from a kernel thread so it had to be fixed.
> 
> The next three patches implement retrying start_streaming() if there are
> not enough buffers queued for the DMA engine to start. I know that there
> are more drivers that can be simplified with this feature available in
> the core. Those drivers do the retry of start_streaming in the buf_queue
> op which frankly defeats the purpose of having a central start_streaming
> op. But I leave it to the driver developers to decide whether or not to
> cleanup their drivers.
> 
> The big advantage is that apps can just call STREAMON first, then start
> queuing buffers without having to know the minimum number of buffers that
> have to be queued before the DMA engine will kick in. It always annoyed
> me that vb2 didn't take care of that for me as it is easy enough to do.
> 
> The next two patches add vb2 thread support which is necessary
> for both videobuf2-dvb (the vb2 replacement of videobuf-dvb) and for e.g.
> alsa drivers where you use the same trick as with dvb.
> 
> The thread implementation has been tested with both alsa recording and
> playback for an internal driver (sorry, I can't share the source yet).
> 
> The next patch adds a fix based on a patch from Andy that removes the
> file I/O emulation assumption that buffers are dequeued in the same
> order that they were enqueued.
> 
> The final patch fixes another race condition between QBUF/PREPARE_BUF
> and REQBUFS in the USERPTR case, also caused by the fact that __prepare_buf
> temporarily unlocks the queue lock. The race was found by Laurent.
> 
> Regards,
> 
>         Hans
> 
> New in v3:
> 
> - Added a comment to the thread_start function making it explicit that
>   it is for use with videobuf2-dvb only.
> - Added patch 10/10 to address yet another race condition.
> 
> New in v2:
> 
> - Added a PREPARING state in patch 1 to prevent a race condition that
> Laurent mentioned (two QBUF calls with the same index number at the same
> time). - Changed some minor issues in patch 4 that Laurent mentioned in his
> review. - Added the reworked version of Andy's original patch to remove the
> order assumption in the file I/O emulation.

-- 
Regards,

Laurent Pinchart

