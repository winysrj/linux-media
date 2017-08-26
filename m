Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34632 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbdHZM5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 08:57:42 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, corbet@lwn.net,
        kyungmin.park@samsung.com, kamil@wypas.org, a.hajda@samsung.com,
        bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH v2] [media] platform: make video_device const
Date: Sat, 26 Aug 2017 18:27:26 +0530
Message-Id: <1503752246-19643-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used during a copy operation.
Done using Coccinelle:

@match disable optional_qualifier@
identifier s;
@@
static struct video_device s = {...};

@ref@
position p;
identifier match.s;
@@
s@p

@good1@
identifier match.s;
expression list[3] es;
position ref.p;
@@
cx88_vdev_init(es,&s@p,...)

@good2@
position ref.p;
identifier match.s,f,c;
expression e;
@@
(
e = s@p
|
e = s@p.f
|
c(...,s@p.f,...)
|
c(...,s@p,...)
)

@bad depends on  !good1 && !good2@
position ref.p;
identifier match.s;
@@
s@p

@depends on forall !bad disable optional_qualifier@
identifier match.s;
@@
static
+ const
struct video_device s;

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
Changes in v2:
* Combine the patch series sent for drivers/media/platform/ into a 
single patch.

 drivers/media/platform/fsl-viu.c                | 2 +-
 drivers/media/platform/m2m-deinterlace.c        | 2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 +-
 drivers/media/platform/mx2_emmaprp.c            | 2 +-
 drivers/media/platform/s5p-g2d/g2d.c            | 2 +-
 drivers/media/platform/ti-vpe/cal.c             | 2 +-
 drivers/media/platform/ti-vpe/vpe.c             | 2 +-
 drivers/media/platform/via-camera.c             | 2 +-
 drivers/media/platform/vim2m.c                  | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index f7b88e5..b3b91cb 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1380,7 +1380,7 @@ static int viu_mmap(struct file *file, struct vm_area_struct *vma)
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device viu_template = {
+static const struct video_device viu_template = {
 	.name		= "FSL viu",
 	.fops		= &viu_fops,
 	.minor		= -1,
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 98f6db2..c8a1249 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -979,7 +979,7 @@ static int deinterlace_mmap(struct file *file, struct vm_area_struct *vma)
 	.mmap		= deinterlace_mmap,
 };
 
-static struct video_device deinterlace_videodev = {
+static const struct video_device deinterlace_videodev = {
 	.name		= MEM2MEM_NAME,
 	.fops		= &deinterlace_fops,
 	.ioctl_ops	= &deinterlace_ioctl_ops,
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 8cac2f2..b07a251 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1639,7 +1639,7 @@ static int mcam_v4l_release(struct file *filp)
  * This template device holds all of those v4l2 methods; we
  * clone it for specific real devices.
  */
-static struct video_device mcam_v4l_template = {
+static const struct video_device mcam_v4l_template = {
 	.name = "mcam",
 	.fops = &mcam_v4l_fops,
 	.ioctl_ops = &mcam_v4l_ioctl_ops,
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 7fd209e..3493d40 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -873,7 +873,7 @@ static int emmaprp_mmap(struct file *file, struct vm_area_struct *vma)
 	.mmap		= emmaprp_mmap,
 };
 
-static struct video_device emmaprp_videodev = {
+static const struct video_device emmaprp_videodev = {
 	.name		= MEM2MEM_NAME,
 	.fops		= &emmaprp_fops,
 	.ioctl_ops	= &emmaprp_ioctl_ops,
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index bd655b5..66aa8cf 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -602,7 +602,7 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	.vidioc_cropcap			= vidioc_cropcap,
 };
 
-static struct video_device g2d_videodev = {
+static const struct video_device g2d_videodev = {
 	.name		= G2D_NAME,
 	.fops		= &g2d_fops,
 	.ioctl_ops	= &g2d_ioctl_ops,
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 0c7ddf8..42e383a 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1420,7 +1420,7 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device cal_videodev = {
+static const struct video_device cal_videodev = {
 	.name		= CAL_MODULE_NAME,
 	.fops		= &cal_fops,
 	.ioctl_ops	= &cal_ioctl_ops,
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 2873c22..45bd105 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2421,7 +2421,7 @@ static int vpe_release(struct file *file)
 	.mmap		= v4l2_m2m_fop_mmap,
 };
 
-static struct video_device vpe_videodev = {
+static const struct video_device vpe_videodev = {
 	.name		= VPE_MODULE_NAME,
 	.fops		= &vpe_fops,
 	.ioctl_ops	= &vpe_ioctl_ops,
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index e16f70a..805d4a8 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1259,7 +1259,7 @@ static int viacam_resume(void *priv)
  * Setup stuff.
  */
 
-static struct video_device viacam_v4l_template = {
+static const struct video_device viacam_v4l_template = {
 	.name		= "via-camera",
 	.minor		= -1,
 	.tvnorms	= V4L2_STD_NTSC_M,
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index afbaa35..b01fba0 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -974,7 +974,7 @@ static int vim2m_release(struct file *file)
 	.mmap		= v4l2_m2m_fop_mmap,
 };
 
-static struct video_device vim2m_videodev = {
+static const struct video_device vim2m_videodev = {
 	.name		= MEM2MEM_NAME,
 	.vfl_dir	= VFL_DIR_M2M,
 	.fops		= &vim2m_fops,
-- 
1.9.1
