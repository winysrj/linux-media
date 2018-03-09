Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38763 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932666AbeCIRuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:50:22 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 12/13] [media] v4l: Add V4L2_CAP_FENCES to drivers
Date: Fri,  9 Mar 2018 14:49:19 -0300
Message-Id: <20180309174920.22373-13-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Drivers that use videobuf2 are capable of using fences and
should report that to userspace.

The coding style is following what each drivers was already
doing.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 3 ++-
 drivers/media/pci/cx23885/cx23885-417.c            | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c          | 3 ++-
 drivers/media/pci/cx88/cx88-video.c                | 3 ++-
 drivers/media/pci/dt3155/dt3155.c                  | 2 +-
 drivers/media/pci/saa7134/saa7134-video.c          | 2 ++
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     | 3 ++-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         | 3 ++-
 drivers/media/pci/sta2x11/sta2x11_vip.c            | 2 +-
 drivers/media/pci/tw68/tw68-video.c                | 3 ++-
 drivers/media/pci/tw686x/tw686x-video.c            | 2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        | 2 +-
 drivers/media/platform/blackfin/bfin_capture.c     | 3 ++-
 drivers/media/platform/coda/coda-common.c          | 3 ++-
 drivers/media/platform/davinci/vpbe_display.c      | 3 ++-
 drivers/media/platform/davinci/vpfe_capture.c      | 3 ++-
 drivers/media/platform/davinci/vpif_capture.c      | 3 ++-
 drivers/media/platform/davinci/vpif_display.c      | 3 ++-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        | 3 ++-
 drivers/media/platform/exynos4-is/fimc-capture.c   | 3 ++-
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 3 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c      | 2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       | 3 ++-
 drivers/media/platform/m2m-deinterlace.c           | 3 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c    | 2 +-
 drivers/media/platform/mx2_emmaprp.c               | 3 ++-
 drivers/media/platform/omap3isp/ispvideo.c         | 2 +-
 drivers/media/platform/pxa_camera.c                | 3 ++-
 drivers/media/platform/rcar_jpu.c                  | 3 ++-
 drivers/media/platform/s3c-camif/camif-capture.c   | 3 ++-
 drivers/media/platform/s5p-g2d/g2d.c               | 3 ++-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 3 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 3 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 3 ++-
 drivers/media/platform/sh_veu.c                    | 3 ++-
 drivers/media/platform/sh_vou.c                    | 2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 3 ++-
 drivers/media/platform/ti-vpe/cal.c                | 2 +-
 drivers/media/platform/ti-vpe/vpe.c                | 3 ++-
 drivers/media/platform/vim2m.c                     | 3 ++-
 drivers/media/platform/vivid/vivid-core.c          | 2 +-
 drivers/media/platform/vsp1/vsp1_histo.c           | 2 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         | 2 +-
 drivers/media/usb/airspy/airspy.c                  | 2 +-
 drivers/media/usb/au0828/au0828-video.c            | 3 ++-
 drivers/media/usb/em28xx/em28xx-video.c            | 1 +
 drivers/media/usb/go7007/go7007-v4l2.c             | 2 +-
 drivers/media/usb/hackrf/hackrf.c                  | 3 ++-
 drivers/media/usb/msi2500/msi2500.c                | 2 +-
 drivers/media/usb/pwc/pwc-v4l.c                    | 2 +-
 drivers/media/usb/s2255/s2255drv.c                 | 2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            | 3 ++-
 drivers/media/usb/usbtv/usbtv-video.c              | 3 ++-
 drivers/media/usb/uvc/uvc_driver.c                 | 1 +
 55 files changed, 89 insertions(+), 52 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 6b6611a0e190..ef1014b5d4a7 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -484,7 +484,8 @@ static int cobalt_querycap(struct file *file, void *priv_fh,
 	strlcpy(vcap->card, "cobalt", sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCIe:%s", pci_name(cobalt->pci_dev));
-	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+		V4L2_CAP_FENCES;
 	if (s->is_output)
 		vcap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
 	else
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a71f3c7569ce..56bf7ec4e25f 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1334,7 +1334,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_VBI_CAPTURE |
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index f8a3deadc77a..dd54e7f7074a 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -643,7 +643,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_AUDIO;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+		V4L2_CAP_AUDIO | V4L2_CAP_FENCES;
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	if (vdev->vfl_type == VFL_TYPE_VBI)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 9be682cdb644..acc74f402a43 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -812,7 +812,8 @@ int cx88_querycap(struct file *file, struct cx88_core *core,
 	struct video_device *vdev = video_devdata(file);
 
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 	if (core->board.tuner_type != UNSET)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	switch (vdev->vfl_type) {
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 1775c36891ae..b677096c7a14 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -311,7 +311,7 @@ static int dt3155_querycap(struct file *filp, void *p,
 	strcpy(cap->card, DT3155_NAME " frame grabber");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 1ca6a32ad10e..aa0bc52633c3 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1534,6 +1534,8 @@ int saa7134_querycap(struct file *file, void *priv,
 	default:
 		return -EINVAL;
 	}
+
+	cap->device_caps |= V4L2_CAP_FENCES;
 	cap->capabilities = radio_caps | video_caps | vbi_caps |
 		cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 25f9f2ebff1d..2900cde5d4a0 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -781,7 +781,8 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 99ffd1ed4a73..acb86823313e 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -388,7 +388,8 @@ static int solo_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index dd199bfc1d45..4113d1279d72 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -420,7 +420,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(vip->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8c1f4a049764..6a11838a96ce 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -741,7 +741,8 @@ static int tw68_querycap(struct file *file, void  *priv,
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING;
+		V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa97b2d0..2a527b6a83e3 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -770,7 +770,7 @@ static int tw686x_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(dev->pci_dev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			   V4L2_CAP_READWRITE;
+			   V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 601ae6487617..b376c60ade04 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1413,7 +1413,7 @@ static int vpfe_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", vpfe->v4l2_dev.name);
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_READWRITE;
+			    V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b7660b1000fd..cfbca15db6ac 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -704,7 +704,8 @@ static int bcap_querycap(struct file *file, void  *priv,
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->bus_info, "Blackfin Platform", sizeof(cap->bus_info));
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 6deb29fe6eb7..0b7ec013ff32 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -394,7 +394,8 @@ static int coda_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, coda_product_name(ctx->dev->devtype->product),
 		sizeof(cap->card));
 	strlcpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 6aabd21fe69f..7ec13e50b4bb 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -638,7 +638,8 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 	struct vpbe_layer *layer = video_drvdata(file);
 	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
-	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	snprintf(cap->driver, sizeof(cap->driver), "%s",
 		dev_name(vpbe_dev->pdev));
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6f44abf7fa31..93defad26f63 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -887,7 +887,8 @@ static int vpfe_querycap(struct file *file, void  *priv,
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
 
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 9364cdf62f54..ca13c8894078 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1092,7 +1092,8 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_capture_config *config = vpif_dev->platform_data;
 
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7be636237acf..2c39b72d466f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -584,7 +584,8 @@ static int vpif_querycap(struct file *file, void  *priv,
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 
-	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 10c3e4659d38..a6465a22f5a8 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -299,7 +299,8 @@ static int gsc_m2m_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&gsc->pdev->dev));
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index ed9302caa004..d14e22f3c910 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -726,7 +726,8 @@ static int fimc_cap_querycap(struct file *file, void *priv,
 	struct fimc_dev *fimc = video_drvdata(file);
 
 	__fimc_vidioc_querycap(&fimc->pdev->dev, cap, V4L2_CAP_STREAMING |
-					V4L2_CAP_VIDEO_CAPTURE_MPLANE);
+					V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+					V4L2_CAP_FENCES);
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 55ba696b8cf4..d3c8d8a8428c 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -349,7 +349,8 @@ static int isp_video_querycap(struct file *file, void *priv,
 {
 	struct fimc_isp *isp = video_drvdata(file);
 
-	__fimc_vidioc_querycap(&isp->pdev->dev, cap, V4L2_CAP_STREAMING);
+	__fimc_vidioc_querycap(&isp->pdev->dev, cap, V4L2_CAP_STREAMING |
+			       V4L2_CAP_FENCES);
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 70d5f5586a5d..5519854ef728 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -659,7 +659,7 @@ static int fimc_lite_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 					dev_name(&fimc->pdev->dev));
 
-	cap->device_caps = V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index dfc487a582c0..fb64abdc80a0 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -237,7 +237,8 @@ static int fimc_m2m_querycap(struct file *file, void *fh,
 				     struct v4l2_capability *cap)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	unsigned int caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	unsigned int caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+			    V4L2_CAP_FENCES;
 
 	__fimc_vidioc_querycap(&fimc->pdev->dev, cap, caps);
 	return 0;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 35a0f45d2a51..2d5a096adc8b 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -461,7 +461,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	 * and are scheduled for removal.
 	 */
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
-			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 80670eeee142..4ac0edbfc194 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1307,7 +1307,7 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
 	strcpy(cap->card, "marvell_ccic");
 	strlcpy(cap->bus_info, cam->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index d03becff66cf..b25d492e8d77 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -401,7 +401,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index b4d4ef926749..cefcd1195a9d 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -658,7 +658,7 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	strlcpy(cap->card, video->video.name, sizeof(cap->card));
 	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
 
-	cap->device_caps = V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_DEVICE_CAPS;
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c71a00736541..402649257f2b 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1997,7 +1997,8 @@ static int pxac_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
 	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index b4b2e2cf5d1a..29d8e30edc8f 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -676,7 +676,8 @@ static int jpu_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(ctx->jpu->dev));
-	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
+	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+		V4L2_CAP_FENCES;
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | cap->device_caps;
 	memset(cap->reserved, 0, sizeof(cap->reserved));
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 9ab8e7ee2e1e..1cec90e5e159 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -643,7 +643,8 @@ static int s3c_camif_vidioc_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s.%d",
 		 dev_name(vp->camif->dev), vp->id);
 
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index cb7d916bfc8b..225a765fda7c 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -299,7 +299,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, G2D_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, G2D_NAME, sizeof(cap->card) - 1);
 	cap->bus_info[0] = 0;
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 28485e6b9cc8..bcd43b33eb3e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1288,7 +1288,8 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 	}
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(ctx->jpeg->dev));
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
+			   V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 369db08dbcae..ba2f79c928bc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -274,7 +274,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	 * device capability flags are left only for backward compatibility
 	 * and are scheduled for removal.
 	 */
-	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index fece496c2a8e..b00415ae644b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -952,7 +952,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	 * device capability flags are left only for backward compatibility
 	 * and are scheduled for removal.
 	 */
-	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 0682b50a67fc..fc0695292393 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -352,7 +352,8 @@ static int sh_veu_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, "sh-mobile VEU", sizeof(cap->card));
 	strlcpy(cap->bus_info, "platform:sh-veu", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+			    V4L2_CAP_FENCES;
 
 	return 0;
 }
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 4dccf29e9d78..8affb8703825 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -385,7 +385,7 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	strlcpy(cap->driver, "sh-vou", sizeof(cap->driver));
 	strlcpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 0cfdc5a67855..f3745b74724c 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -694,7 +694,8 @@ static int bdisp_querycap(struct file *file, void *fh,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d",
 		 BDISP_NAME, bdisp->id);
 
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
+		V4L2_CAP_FENCES;
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5baa6d..83f59b6408c0 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -918,7 +918,7 @@ static int cal_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", ctx->v4l2_dev.name);
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_READWRITE;
+			    V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c2d838884e1c..75840b21fff1 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1512,7 +1512,8 @@ static int vpe_querycap(struct file *file, void *priv,
 	strncpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		VPE_MODULE_NAME);
-	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
+	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e1a54a28b082..13711d203fd6 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -432,7 +432,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", MEM2MEM_NAME);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING |
+			V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 82ec216f2ad8..39cd4aedd968 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -205,7 +205,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->capabilities = dev->vid_cap_caps | dev->vid_out_caps |
 		dev->vbi_cap_caps | dev->vbi_out_caps |
 		dev->radio_rx_caps | dev->radio_tx_caps |
-		dev->sdr_cap_caps | V4L2_CAP_DEVICE_CAPS;
+		dev->sdr_cap_caps | V4L2_CAP_DEVICE_CAPS | V4L2_CAP_FENCES;
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index afab77cf4fa5..647b0c4d6f39 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -480,7 +480,7 @@ static int histo_v4l2_querycap(struct file *file, void *fh,
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
 			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE
-			  | V4L2_CAP_META_CAPTURE;
+			  | V4L2_CAP_META_CAPTURE | V4L2_CAP_FENCES;
 	cap->device_caps = V4L2_CAP_META_CAPTURE
 			 | V4L2_CAP_STREAMING;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c2d3b8f0f487..67e44a76a4f8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -964,7 +964,7 @@ vsp1_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
-			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE | V4L2_CAP_FENCES;
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 565e466ba4fa..5652ca23ec7d 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -494,7 +494,7 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	struct v4l2_fh *vfh = file->private_data;
 	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
 
-	cap->device_caps = V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS
 			  | dma->xdev->v4l2_caps;
 
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index e70c9e2f3798..64a3192413e3 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -623,7 +623,7 @@ static int airspy_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
+			V4L2_CAP_READWRITE | V4L2_CAP_TUNER | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index c765d546114d..29db7799ecb6 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1199,7 +1199,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->device_caps = V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
-		V4L2_CAP_TUNER;
+		V4L2_CAP_TUNER |
+		V4L2_CAP_FENCES;
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f31339727d3b..32a58f1da4e7 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1938,6 +1938,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 
+	cap->device_caps |= V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps |
 			    V4L2_CAP_DEVICE_CAPS | V4L2_CAP_READWRITE |
 			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 98cd57eaf36a..0ef0587eb136 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -289,7 +289,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+				V4L2_CAP_STREAMING | V4L2_CAP_FENCES;
 
 	if (go->board_info->num_aud_inputs)
 		cap->device_caps |= V4L2_CAP_AUDIO;
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 6d692fb3e8dd..5912df138394 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -909,7 +909,8 @@ static int hackrf_querycap(struct file *file, void *fh,
 
 	dev_dbg(&intf->dev, "\n");
 
-	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+			   V4L2_CAP_FENCES;
 	if (vdev->vfl_dir == VFL_DIR_RX)
 		cap->device_caps |= V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
 	else
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 65ef755adfdc..737b10761869 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -608,7 +608,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
+			V4L2_CAP_READWRITE | V4L2_CAP_TUNER | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 043b2b97cee6..571a8c4661c5 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -496,7 +496,7 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	strlcpy(cap->card, pdev->vdev.name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-					V4L2_CAP_READWRITE;
+					V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a00a15f55d37..fe4c4f23adaa 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -734,7 +734,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-		V4L2_CAP_READWRITE;
+		V4L2_CAP_READWRITE | V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77b759a0bcd9..00c8ff034880 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -350,7 +350,8 @@ static int vidioc_querycap(struct file *file,
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING |
-		V4L2_CAP_READWRITE;
+		V4L2_CAP_READWRITE |
+		V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3668a04359e8..4b889dbff6a9 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -521,7 +521,8 @@ static int usbtv_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, "usbtv", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
-	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_FENCES;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 2469b49b2b30..745f69cbf8e0 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1968,6 +1968,7 @@ static int uvc_register_video(struct uvc_device *dev,
 		return ret;
 	}
 
+	stream->chain->caps |= V4L2_CAP_FENCES;
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE
 			| V4L2_CAP_META_CAPTURE;
-- 
2.14.3
