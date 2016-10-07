Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34159
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754819AbcJGUju (ORCPT
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
Subject: [PATCH 2/3] [media] exynos-gsc: unregister video device node on driver removal
Date: Fri,  7 Oct 2016 17:39:18 -0300
Message-Id: <1475872759-17969-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
References: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver doesn't unregister the video device node when the driver is
removed, this keeps video device nodes that makes the machine to crash
with a NULL pointer dereference when nodes are attempted to be opened:

[   36.530006] Unable to handle kernel paging request at virtual address bf1f8200
[   36.535985] pgd = edbbc000
[   36.538486] [bf1f8200] *pgd=6d99a811, *pte=00000000, *ppte=00000000
[   36.544727] Internal error: Oops: 7 [#1] PREEMPT SMP ARM
[   36.550016] Modules linked in: s5p_jpeg s5p_mfc v4l2_mem2mem videobuf2_dma_contig
[   36.566303] CPU: 6 PID: 533 Comm: v4l2-ctl Not tainted 4.8.0
[   36.574466] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   36.580526] task: ee3cc600 task.stack: ed626000
[   36.585046] PC is at try_module_get+0x1c/0xac
[   36.589364] LR is at try_module_get+0x1c/0xac
[   36.593698] pc : [<c0187a60>]    lr : [<c0187a60>]    psr: 80070013
[   36.593698] sp : ed627de0  ip : a0070013  fp : 00000000
[   36.605156] r10: 00000002  r9 : ed627ed0  r8 : 00000000
[   36.610331] r7 : c01e5f14  r6 : ed57be00  r5 : bf1f8200  r4 : bf1f8200
[   36.616834] r3 : 00000002  r2 : 00000002  r1 : 01930192  r0 : 00000001
..
[   36.785004] [<c0187a60>] (try_module_get) from [<c01e5c10>] (cdev_get+0x1c/0x4c)
[   36.792362] [<c01e5c10>] (cdev_get) from [<c01e5f40>] (chrdev_open+0x2c/0x178)
[   36.799555] [<c01e5f40>] (chrdev_open) from [<c01df5d4>] (do_dentry_open+0x1e0/0x300)
[   36.807360] [<c01df5d4>] (do_dentry_open) from [<c01eecdc>] (path_openat+0x35c/0xf58)
[   36.815154] [<c01eecdc>] (path_openat) from [<c01f0668>] (do_filp_open+0x5c/0xc0)
[   36.822606] [<c01f0668>] (do_filp_open) from [<c01e09ac>] (do_sys_open+0x10c/0x1bc)
[   36.830235] [<c01e09ac>] (do_sys_open) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)
[   36.837942] Code: 0a00001c e1a04000 e3a00001 ebfec92d (e5943000)

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index a1cac52ea230..c8c0bcec35ed 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -781,6 +781,8 @@ err_m2m_release:
 
 void gsc_unregister_m2m_device(struct gsc_dev *gsc)
 {
-	if (gsc)
+	if (gsc) {
 		v4l2_m2m_release(gsc->m2m.m2m_dev);
+		video_unregister_device(&gsc->vdev);
+	}
 }
-- 
2.7.4

