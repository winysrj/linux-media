Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:53593 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754684AbdBQDrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 22:47:09 -0500
Received: from mail-svr1.cs.utah.edu (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id E84FC650075
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 20:47:05 -0700 (MST)
Received: from webmail.cs.utah.edu (zurich.cs.utah.edu [155.98.65.62])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 20:47:05 -0700 (MST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 16 Feb 2017 20:47:05 -0700
From: Shaobo <shaobo@cs.utah.edu>
To: linux-media@vger.kernel.org
Subject: Dead code in v4l2-mem2mem.c?
Message-ID: <6da009217bbd2e6137ba764ac5c640bf@cs.utah.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

My name is Shaobo He and I am a graduate student at University of Utah. 
I am applying a static analysis tool to the Linux device drivers, 
looking for NULL pointer dereference and accidentally found a plausible 
dead code location in v4l2-mem2mem.c due to undefined behavior.

The following is the problematic code segment 
(drivers/media/v4l2-core/v4l2-mem2mem.c),

> 70 static struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx 
> *m2m_ctx,
> 71                                                 enum v4l2_buf_type 
> type)
> 72 {
> 73         if (V4L2_TYPE_IS_OUTPUT(type))
> 74                 return &m2m_ctx->out_q_ctx;
> 75         else
> 76                 return &m2m_ctx->cap_q_ctx;
> 77 }
> 78
> 79 struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
> 80                                        enum v4l2_buf_type type)
> 81 {
> 82         struct v4l2_m2m_queue_ctx *q_ctx;
> 83
> 84         q_ctx = get_queue_ctx(m2m_ctx, type);
> 85         if (!q_ctx)
> 86                 return NULL;
> 87
> 88         return &q_ctx->q;
> 89 }

`get_queue_ctx` returns a pointer value that is an addition of the base 
pointer address (`m2m_ctx`) to a non-zero offset. The following is the 
definition of struct v4l2_m2m_ctx (include/media/v4l2-mem2mem.h),

> 94 struct v4l2_m2m_ctx {
> 95         /* optional cap/out vb2 queues lock */
> 96         struct mutex                    *q_lock;
> 97
> 98         /* internal use only */
> 99         struct v4l2_m2m_dev             *m2m_dev;
> 100
> 101         struct v4l2_m2m_queue_ctx       cap_q_ctx;
> 102
> 103         struct v4l2_m2m_queue_ctx       out_q_ctx;
> 104
> 105         /* For device job queue */
> 106         struct list_head                queue;
> 107         unsigned long                   job_flags;
> 108         wait_queue_head_t               finished;
> 109
> 110         void                            *priv;
> 111 };

There is a NULL test in a caller of `get_queue_ctx` (line 85), which 
appears problematic to me. I’m not sure if it is defined or feasible 
under the context of Linux kernel. This blog 
(https://wdtz.org/undefined-behavior-in-binutils-causes-segfault.html) 
suggests that the NULL check can be optimized away because the only case 
that the return value can be NULL triggers pointer overflow, which is 
undefined.

Please let me know if it makes sense or not. Thanks for your time and I 
am looking forward to your reply.

Best,
Shaobo
