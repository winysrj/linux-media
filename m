Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34171
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754820AbcJGUju (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 16:39:50 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 3/3] [media] exynos-gsc: cleanup m2m src and dst vb2 queues on STREAMOFF
Date: Fri,  7 Oct 2016 17:39:19 -0300
Message-Id: <1475872759-17969-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
References: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media drivers that use the videobuf2 framework have to give back to vb2
all the buffers that received from vb2 using its .buf_queue callback.

But the exynos-gsc driver isn't doing a proper cleanup so vb2 complains
that the number of buffers enqueued and received are not balanced:

WARNING: CPU: 2 PID: 660 at drivers/media/v4l2-core/videobuf2-core.c:1654 __vb2_queue_cancel+0xec/0x150 [videobuf2_core]
Modules linked in: mwifiex_sdio mwifiex uvcvideo exynos_gsc videobuf2_vmalloc s5p_mfc s5p_jpeg
CPU: 2 PID: 660 Comm: lt-gst-validate Not tainted 4.8.0
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c010e24c>] (unwind_backtrace) from [<c010af30>] (show_stack+0x10/0x14)
[<c010af30>] (show_stack) from [<c03291a4>] (dump_stack+0x88/0x9c)
[<c03291a4>] (dump_stack) from [<c011a858>] (__warn+0xe8/0x100)
[<c011a858>] (__warn) from [<c011a920>] (warn_slowpath_null+0x20/0x28)
[<c011a920>] (warn_slowpath_null) from [<bf0b6ed0>] (__vb2_queue_cancel+0xec/0x150 [videobuf2_core])
[<bf0b6ed0>] (__vb2_queue_cancel [videobuf2_core]) from [<bf0b7464>] (vb2_core_streamoff+0x34/0x9c [videobuf2_core])
[<bf0b7464>] (vb2_core_streamoff [videobuf2_core]) from [<bf11b9e8>] (v4l2_m2m_streamoff+0x2c/0xe4 [v4l2_mem2mem])
[<bf11b9e8>] (v4l2_m2m_streamoff [v4l2_mem2mem]) from [<bf01b84c>] (__video_do_ioctl+0x298/0x30c [videodev])
[<bf01b84c>] (__video_do_ioctl [videodev]) from [<bf01b234>] (video_usercopy+0x174/0x4e8 [videodev])
[<bf01b234>] (video_usercopy [videodev]) from [<bf0165c8>] (v4l2_ioctl+0xc4/0xd8 [videodev])
[<bf0165c8>] (v4l2_ioctl [videodev]) from [<c01f291c>] (do_vfs_ioctl+0x9c/0x8f4)
[<c01f291c>] (do_vfs_ioctl) from [<c01f31a8>] (SyS_ioctl+0x34/0x5c)
[<c01f31a8>] (SyS_ioctl) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)

Fix this by passing back to vb2 all the received buffers that were not
processed.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index c8c0bcec35ed..f49f24b4462a 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -66,12 +66,29 @@ static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret > 0 ? 0 : ret;
 }
 
+static void __gsc_m2m_cleanup_queue(struct gsc_ctx *ctx)
+{
+	struct vb2_v4l2_buffer *src_vb, *dst_vb;
+
+	while (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) > 0) {
+		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
+	}
+
+	while (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) > 0) {
+		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
+	}
+}
+
 static void gsc_m2m_stop_streaming(struct vb2_queue *q)
 {
 	struct gsc_ctx *ctx = q->drv_priv;
 
 	__gsc_m2m_job_abort(ctx);
 
+	__gsc_m2m_cleanup_queue(ctx);
+
 	pm_runtime_put(&ctx->gsc_dev->pdev->dev);
 }
 
-- 
2.7.4

