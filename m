Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35517 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751043AbdJEOCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 10:02:07 -0400
Message-ID: <1507212125.8473.14.camel@pengutronix.de>
Subject: Re: i.MX6 CODA warning: vb2:   counters for queue xxx, buffer y:
 UNBALANCED!
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Linux Media <linux-media@vger.kernel.org>
Date: Thu, 05 Oct 2017 16:02:05 +0200
In-Reply-To: <m3zi95yjgz.fsf@t19.piap.pl>
References: <m3zi95yjgz.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-10-05 at 12:31 +0200, Krzysztof Hałasa wrote:
> Hi,
> 
> I'm using i.MX6 CODA H.264 encoder and found a minor bug somewhere.
> Not sure how it should be fixed, though.
> The problem manifests itself when I configure (open, qbuf etc) the
> encoder device and then close it without any start/stop streaming
> calls.
> I'm using 2 buffers in this example:
> 
> vb2:   counters for queue b699c808, buffer 0: UNBALANCED!
> vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 1 buf_finish: 1
> vb2:     buf_queue: 0 buf_done: 0
> vb2:     alloc: 1 put: 1 prepare: 1 finish: 0 mmap: 1
>                          ^^^^^^^^^^^^^^^^^^^^
> vb2:     get_userptr: 0 put_userptr: 0
> vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf: 0 unmap_dmabuf:
> 0
> vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0
> 
> vb2:   counters for queue b699c808, buffer 1: UNBALANCED!
> vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 1 buf_finish: 1
> vb2:     buf_queue: 0 buf_done: 0
> vb2:     alloc: 1 put: 1 prepare: 1 finish: 0 mmap: 1
>                          ^^^^^^^^^^^^^^^^^^^^
> vb2:     get_userptr: 0 put_userptr: 0
> vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf: 0 unmap_dmabuf:
> 0
> vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0
> 
> These are H.264 (encoder "capture") buffers. Note the alloc
> prepare/finish disparity.
> 
> I have investigated a bit and it seems it's some missing *buf_done()
> call, probably belonging to coda_release(), but I'm not sure. Or maybe
> should my program "finish" the buffers before doing close()?

I have to admit, I'm a bit unsure how this should be handled.

If the buffers are queued via VIDIOC_QBUF, but VIDIOC_STREAMON is never
called, the buffers are (mem_)prepared in __buf_prepare, but they are
never enqueued in the driver via __enqueue_in_driver. This is reflected
by the balanced buf_queue/done line:

vb2:     buf_queue: 0 buf_done: 0

I can't call v4l2_m2m_buf_done on buffers that have not been queued in
the driver yet: these buffers are in state VB2_BUF_STATE_QUEUED, not
VB2_BUF_STATE_ACTIVE. But vb2_buffer_done, which is the only place that
(mem_)finishes the buffers, only operates on active buffers.

The kerneldoc comments for vb2_mem_ops indicate that prepare/finish are
called whenever the buffer is passed from userspace to the driver and
back, but they make no mention of buffers being passed from userspace to
the videobuf2 core, which doesn't pass them on to the driver until
STREAMON.

regards
Philipp
