Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdJBNnx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 09:43:53 -0400
Date: Mon, 2 Oct 2017 14:43:50 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Jonathan.Chai@arm.com
Subject: Re: [PATCH v3 10/15] [media] vb2: add 'ordered' property to queues
Message-ID: <20171002134350.GE22538@e107564-lin.cambridge.arm.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
 <20170907184226.27482-11-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170907184226.27482-11-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Sep 07, 2017 at 03:42:21PM -0300, Gustavo Padovan wrote:
>From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
>For explicit synchronization (and soon for HAL3/Request API) we need
>the v4l2-driver to guarantee the ordering in which the buffers were queued
>by userspace. This is already true for many drivers, but we never needed
>to say it.
>
>Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
>---
> include/media/videobuf2-core.h | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>index 5ed8d3402474..20099dc22f26 100644
>--- a/include/media/videobuf2-core.h
>+++ b/include/media/videobuf2-core.h
>@@ -508,6 +508,9 @@ struct vb2_buf_ops {
>  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
>  *		last decoded buffer was already dequeued. Set for capture queues
>  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
>+ * @ordered: if the driver can guarantee that the queue will be ordered or not.
>+ *		The default is not ordered unless the driver sets this flag. It
>+ *		is mandatory for using explicit fences.

If it's mandatory for fences (why is that?), then I guess this patch
should come before any of the fence implementation?

But it's not entirely clear to me what this flag means - ordered with
respect to what? Ordered such that the order in which the buffers are
queued in the driver are the same order that they will be dequeued by
userspace?

I think the order they are queued from userspace can still be
different from both the order they are queued in the driver (because
the in-fences can signal in any order), and dequeued again in
userspace, so "ordered" seems a bit ambiguous.

I think it should be more clear.

Cheers
-Brian

>  * @fileio:	file io emulator internal data, used only if emulator is active
>  * @threadio:	thread io internal data, used only if thread is active
>  */
>@@ -560,6 +563,7 @@ struct vb2_queue {
> 	unsigned int			is_output:1;
> 	unsigned int			copy_timestamp:1;
> 	unsigned int			last_buffer_dequeued:1;
>+	unsigned int			ordered:1;
>
> 	struct vb2_fileio_data		*fileio;
> 	struct vb2_threadio_data	*threadio;
>-- 
>2.13.5
>
