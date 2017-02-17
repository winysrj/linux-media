Return-path: <linux-media-owner@vger.kernel.org>
Received: from rio.cs.utah.edu ([155.98.64.241]:41903 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdBQSm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 13:42:28 -0500
From: "Shaobo" <shaobo@cs.utah.edu>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
Cc: <linux-media@vger.kernel.org>, <mchehab@kernel.org>,
        <hverkuil@xs4all.nl>, <sakari.ailus@linux.intel.com>,
        <ricardo.ribalda@gmail.com>
References: <002201d288a9$93dd7360$bb985a20$@cs.utah.edu> <5573207.UYLCxH4UDO@avalon>
In-Reply-To: <5573207.UYLCxH4UDO@avalon>
Subject: RE: Dead code in v4l2-mem2mem.c?
Date: Fri, 17 Feb 2017 11:42:25 -0700
Message-ID: <00a901d2894d$95c553b0$c14ffb10$@cs.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 8BIT
Content-Language: zh-cn
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks a lot for your reply.

I would like to also point out the inconsistency of using `v4l2_m2m_get_vq`
inside drivers/media/v4l2-core/v4l2-mem2mem.c and inside other files. It
appears to me almost all call sites of `v4l2_m2m_get_vq` in
drivers/media/v4l2-core/v4l2-mem2mem.c does not have NULL check afterwards
while in other files (e.g., drivers/media/platform/mx2_emmaprp.c) they do. I
was wondering if there is special assumption on this function in mem2mem.c.

Best,
Shaobo
-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: 2017Äê2ÔÂ17ÈÕ 3:26
To: Shaobo <shaobo@cs.utah.edu>
Cc: linux-media@vger.kernel.org; mchehab@kernel.org; hverkuil@xs4all.nl;
sakari.ailus@linux.intel.com; ricardo.ribalda@gmail.com
Subject: Re: Dead code in v4l2-mem2mem.c?

Hi Shaobo,

First of all, could you please make sure you send future mails to the linux-
media mailing list in plain text only (no HTML) ? The mailing list server
rejects HTML e-mails.

On Thursday 16 Feb 2017 16:08:25 Shaobo wrote:
> Hi there,
> 
> My name is Shaobo He and I am a graduate student at University of 
> Utah. I am applying a static analysis tool to the Linux device 
> drivers, looking for NULL pointer dereference and accidentally found a 
> plausible dead code location in v4l2-mem2mem.c due to undefined behavior.
> 
> The following is the problematic code segment,
> 
> static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx 
> *m2m_ctx,
> 						  enum v4l2_buf_type type)
> {
> 	if (V4L2_TYPE_IS_OUTPUT(type))
> 		return &m2m_ctx->out_q_ctx;
> 	else
> 		return &m2m_ctx->cap_q_ctx;
> }
> 
> struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> 				    enum v4l2_buf_type type)
> {
> 	struct v4l2_m2m_queue_ctx *q_ctx;
> 
> 	q_ctx = get_queue_ctx(m2m_ctx, type);
> 	if (!q_ctx)
> 		return NULL;
> 
> 	return &q_ctx->q;
> }
> 
> `get_queue_ctx` returns a pointer value that is an addition of the 
> base pointer address (`m2m_ctx`) to a non-zero offset. The following 
> is the definition of struct v4l2_m2m_ctx,
> 
> struct v4l2_m2m_ctx {
> 	/* optional cap/out vb2 queues lock */
> 	struct mutex			*q_lock;
> 
> 	/* internal use only */
> 	struct v4l2_m2m_dev		*m2m_dev;
> 
> 	struct v4l2_m2m_queue_ctx	cap_q_ctx;
> 
> 	struct v4l2_m2m_queue_ctx	out_q_ctx;
> 
> 	/* For device job queue */
> 	struct list_head		queue;
> 	unsigned long			job_flags;
> 	wait_queue_head_t		finished;
> 
> 	void				*priv;
> };
> 
> There is a NULL test in a caller of `get_queue_ctx` (line 85), which 
> appears problematic to me. I'm not sure if it is defined or feasible 
> under the context of Linux kernel. This blog
> (https://wdtz.org/undefined-behavior-in-binutils-causes-segfault.html)
> suggests that the NULL check can be optimized away because the only 
> case that the return value can be NULL triggers pointer overflow, 
> which is undefined.
> 
> Please let me know if it makes sense or not. Thanks for your time and 
> I am looking forward to your reply.

The NULL check is indeed wrong. I believe that the m2m_ctx argument passed
to the v4l2_m2m_get_vq() function should never be NULL. We will however need
to audit drivers to make sure that's the case. The NULL check could then be
removed. Alternatively we could check m2m_ctx above the get_queue_ctx()
call, which wouldn't require auditing drivers. It's a safe option, but would
likely result in an unneeded NULL check.

--
Regards,

Laurent Pinchart
