Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab2JBSGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 14:06:11 -0400
Date: Tue, 2 Oct 2012 15:06:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.7] Samsung Exynos MFC driver update
Message-ID: <20121002150603.31b6b72d@redhat.com>
In-Reply-To: <506B1D47.8040602@samsung.com>
References: <506B1D47.8040602@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Oct 2012 18:58:47 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 34a6b7d093d8fe738ada191b36648d00bc18b7eb:
> 
>   [media] v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler
> (2012-10-01 17:07:07 -0300)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_mfc_for_mauro
> 
> for you to fetch changes up to 8312d9d2d254ab289a322fcfdba1d1ecf5e36256:
> 
>   s5p-mfc: Update MFC v4l2 driver to support MFC6.x (2012-10-02 15:28:42 +0200)
> 
> This is an update of the s5p-mfc driver and related V4L2 API additions
> to support the Multi Format Codec device on the Exynos5 SoC series.
> 
> ----------------------------------------------------------------
> Arun Kumar K (4):
>       v4l: Add fourcc definitions for new formats
>       v4l: Add control definitions for new H264 encoder features

OK.

>       s5p-mfc: Update MFCv5 driver for callback based architecture

This one doesn't apply:

--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@@ -496,11 -499,14 +498,20 @@@ static int vidioc_reqbufs(struct file *
                        s5p_mfc_clock_off();
                        return -ENOMEM;
                }
++<<<<<<< HEAD
 +          if (s5p_mfc_ctx_ready(ctx))
 +                  set_work_bit_irqsave(ctx);
 +          s5p_mfc_try_run(dev);
++=======
+           if (s5p_mfc_ctx_ready(ctx)) {
+                   spin_lock_irqsave(&dev->condlock, flags);
+                   set_bit(ctx->num, &dev->ctx_work_bits);
+                   spin_unlock_irqrestore(&dev->condlock, flags);
+           }
+           s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
++>>>>>>> e67ff71... s5p-mfc: Update MFCv5 driver for callback based architecture
...

@@@ -582,18 -589,24 +593,30 @@@ static int vidioc_streamon(struct file 
                        ctx->src_bufs_cnt = 0;
                        ctx->capture_state = QUEUE_FREE;
                        ctx->output_state = QUEUE_FREE;
++<<<<<<< HEAD
 +                  s5p_mfc_alloc_instance_buffer(ctx);
 +                  s5p_mfc_alloc_dec_temp_buffers(ctx);
 +                  set_work_bit_irqsave(ctx);
++=======
+                   s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer,
+                                   ctx);
+                   s5p_mfc_hw_call(dev->mfc_ops, alloc_dec_temp_buffers,
+                                   ctx);
+                   spin_lock_irqsave(&dev->condlock, flags);
+                   set_bit(ctx->num, &dev->ctx_work_bits);
+                   spin_unlock_irqrestore(&dev->condlock, flags);
++>>>>>>> e67ff71... s5p-mfc: Update MFCv5 driver for callback based architecture

and more...

Also, there are too many changes on this patch, making it harder for
review, especially since there are also some code renames and function
rearrangements.

The better is to split it into smaller and more logical changes, instead
of what it sounds like a driver replacement.

-- 
Regards,
Mauro
