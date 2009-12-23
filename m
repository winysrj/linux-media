Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36343 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZLWNRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 08:17:47 -0500
Date: Wed, 23 Dec 2009 14:17:32 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC v2.1 0/2] Mem-to-mem device framework
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1261574255-23386-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is the second version of the proposed implementation for mem-to-mem memory
device framework. Your comments are very welcome.

In v2.1:
I am very sorry for the resend, but somehow an orphaned endif found its way to
Kconfig during the rebase.

Changes since v1:
- v4l2_m2m_buf_queue() now requires m2m_ctx as its argument
- video_queue private data stores driver private data
- a new submenu in kconfig for mem-to-mem devices
- minor rebase leftovers cleanup

A second patch series followed v2 with a new driver for a real device -
Samsung S3C/S5P image rotator, utilizing this framework.


This series contains:

[PATCH v2.1 1/2] V4L: Add memory-to-memory device helper framework for V4L2.
[PATCH v2.1 2/2] V4L: Add a mem-to-mem V4L2 framework test device.
[EXAMPLE v2] Mem-to-mem userspace test application.


Previous discussion and RFC on this topic:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10668


A mem-to-mem device is a device that uses memory buffers passed by
userspace applications for both source and destination. This is
different from existing drivers that use memory buffers for only one
of those at once.
In terms of V4L2 such a device would be both of OUTPUT and CAPTURE type.
Although no such devices are present in the V4L2 framework, a demand for such
a model exists, e.g. for 'resizer devices'.


-------------------------------------------------------------------------------
Mem-to-mem devices
-------------------------------------------------------------------------------
In the previous discussion we concluded that we should use one video node with
two queues, an output (V4L2_BUF_TYPE_VIDEO_OUTPUT) queue for source buffers and
a capture queue (V4L2_BUF_TYPE_VIDEO_CAPTURE) for destination buffers.


Each instance has its own set of queues: 2 videobuf_queues, each with a ready
buffer queue, managed by the framework. Everything is encapsulated in the
queue context struct:

struct v4l2_m2m_queue_ctx {
        struct videobuf_queue   q;
     /* ... */
        /* Queue for buffers ready to be processed as soon as this
         * instance receives access to the device */
        struct list_head        rdy_queue;
     /* ... */
};

struct v4l2_m2m_ctx {
     /* ... */
        /* Capture (output to memory) queue context */
        struct v4l2_m2m_queue_ctx       cap_q_ctx;

        /* Output (input from memory) queue context */
        struct v4l2_m2m_queue_ctx       out_q_ctx;
     /* ... */
};

Streamon can be called for all instances and will not sleep if another instance
is streaming.

vidioc_querycap() should report V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT.

-------------------------------------------------------------------------------
Queuing and dequeuing buffers
-------------------------------------------------------------------------------
Applications can queue as many buffers as they want and it is not required to
queue an equal number of source and destination buffers. If there is not enough
buffers of any type, a new transaction will simply not be scheduled.

-------------------------------------------------------------------------------
Source and destination formats
-------------------------------------------------------------------------------
Should be set per queue. A helper function to access queues depending on the
passed type - v4l2_m2m_get_vq() - is supplied. Most of the format-handling code
is normally located in drivers anyway. The only exception is the "field" member
of the videobuf_queue struct, which has to be set directly. It breaks
encapsulation a little bit, but nothing can be done with it.

-------------------------------------------------------------------------------
Scheduling
-------------------------------------------------------------------------------
Requirements/assumptions:
1. More than one instance can be open at the same time.
2. Each instance periodically receives exclusive access to the device, performs
an operation (operations) and yields back the device in a state that allows
other instances to use it.
3. When an instance gets access to the device, it performs a
"transaction"/"job". A transaction/job is defined as the shortest operation
that cannot/should not be further divided without having to restart it from
scratch, or without having to perform expensive reconfiguration of a device,
etc.
4. Transactions can use multiple source/destination buffers.
5. Only a driver can tell when it is ready to perform a transaction, so
a optional callback is provided for that purpose (job_ready()).


There are three common requirements for a transaction to be ready to run:
- at least one source buffer ready
- at least one destination buffer ready
- streaming on
- (optional) driver-specific requirements (driver-specific callback function)

So when buffers are queued by qbuf() or streaming is turned on with
streamon(), the framework calls v4l2_m2m_try_schedule().

v4l2_m2m_try_schedule()
1. Checks for the above conditions.
2. Checks for driver-specific conditions by calling job_ready() callback, if
supplied.
3. If all the checks succeed, it calls v4l2_m2m_schedule() to schedule the
transaction.

v4l2_m2m_schedule()
1. Checks whether the transaction is already on job queue and schedules it
if not (by adding it to the job queue).
2. Calls v4l2_m2m_try_run().

v4l2_m2m_try_run()
1. Runs a job if and is pending and none is currently running by calling
device_run() callback.

When the device_run() callback is called, the driver has to begin the
transaction. When it is finished, the driver has to call v4l2_m2m_job_finish().

v4l2_m2m_job_finish()
1. Removes the currently running transaction from the job queue and calls
v4l2_m2m_try_run to (possibly) run the next pending transaction.

There is also support for forced transaction aborting (when an application
gets killed). The framework calls job_abort() callback and the driver has
to abort the transaction as soon as possible and call v4l2_m2m_job_finish()
to indicate that the transaction has been aborted.


Additionally, some kind of timeout for transactions could be added to prevent
instances from claiming the device for too long.

-------------------------------------------------------------------------------
Acquiring ready buffers to process
-------------------------------------------------------------------------------
Ready buffers can be acquired using v4l2_m2m_next_src_buf()/
v4l2_m2m_next_dst_buf(). After the transaction they are removed from the queues
with v4l2_m2m_dst_buf_remove()/v4l2_m2m_src_buf_remove(). This is not
multi-buffer-transaction-safe. It will have to be modified, but ideally after
we decide how to handle multi-buffer transactions in videobuf core.

-------------------------------------------------------------------------------
poll()
-------------------------------------------------------------------------------
We cannot have poll() for multiple queues on one node, so we use poll() for the
destination queue only.

-------------------------------------------------------------------------------
mmap()
-------------------------------------------------------------------------------
Requirements:
- allow mapping buffers from different queues
- retain "magic" offset values so videobuf can still match buffers by offsets

The proposed solution involves a querybuf() and mmap() multiplexers:

a) When a driver calls querybuf(), we have access to the type and we can
detect which queue to call videobuf_querybuf() on:

        vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
        ret = videobuf_querybuf(vq, buf);

The offsets returned from videobuf_querybuf() for one of the queues are further
offset by a predefined constant (DST_QUEUE_OFF_BASE). This way the driver
(and applications) receive different offsets for the same buffer indexes of
each queue:

        if (buf->memory == V4L2_MEMORY_MMAP
            && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
                buf->m.offset += DST_QUEUE_OFF_BASE;
        }


b) When the application (driver) calls mmap(), the offsets which were modified
in querybuf() are detected and the proper queue for them chosen based on that.
Finally, the modified offsets are passed to videobuf_mmap_mapper() for proper
queues with their offsets changed back to values recognizable by videobuf:

        unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
        struct videobuf_queue *vq;

        if (offset < DST_QUEUE_OFF_BASE) {
                vq = v4l2_m2m_get_src_vq(m2m_ctx);
        } else {
                vq = v4l2_m2m_get_dst_vq(m2m_ctx);
                vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
        }

        return videobuf_mmap_mapper(vq, vma);


-------------------------------------------------------------------------------
Test device and a userspace application
-------------------------------------------------------------------------------
mem2mem_testdev.c is a test driver for the framework. It uses timers for fake
interrupts and allows testing transaction with different number of buffers
and transaction durations simultaneously.

process-vmalloc.c is a capture+output test application for the test device.

-------------------------------------------------------------------------------
Future work
-------------------------------------------------------------------------------
- read/write support
- transaction/abort timeouts
- extracting more common code to the framework? (e.g. per-queue format details,
transaction length, etc.)


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

