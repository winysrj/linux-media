Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbbCIVWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:22:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/18] marvell-ccic: fill in bus_info
Date: Mon,  9 Mar 2015 22:22:07 +0100
Message-Id: <1425936143-5658-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The bus_info field of struct v4l2_querycap wasn't filled in and
v4l2-compliance complained about that. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c | 1 +
 drivers/media/platform/marvell-ccic/mcam-core.c   | 3 +++
 drivers/media/platform/marvell-ccic/mcam-core.h   | 2 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c  | 1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index 5628453..e857405 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -476,6 +476,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	mcam->plat_power_up = cafe_ctlr_power_up;
 	mcam->plat_power_down = cafe_ctlr_power_down;
 	mcam->dev = &pdev->dev;
+	snprintf(mcam->bus_info, sizeof(mcam->bus_info), "PCI:%s", pci_name(pdev));
 	/*
 	 * Set the clock speed for the XO 1; I don't believe this
 	 * driver has ever run anywhere else.
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index bf160dd..e83ca1f 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1388,8 +1388,11 @@ static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
 static int mcam_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *cap)
 {
+	struct mcam_camera *cam = priv;
+
 	strcpy(cap->driver, "marvell_ccic");
 	strcpy(cap->card, "marvell_ccic");
+	strlcpy(cap->bus_info, cam->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index aa0c6ea..46bc715 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -163,6 +163,8 @@ struct mcam_camera {
 	unsigned int nbufs;		/* How many are alloc'd */
 	int next_buf;			/* Next to consume (dev_lock) */
 
+	char bus_info[32];		/* querycap bus_info */
+
 	/* DMA buffers - vmalloc mode */
 #ifdef MCAM_MODE_VMALLOC
 	unsigned int dma_buf_size;	/* allocated size */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 0ed9b3a..b5f165a 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -371,6 +371,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->lane = pdata->lane;
 	mcam->chip_id = MCAM_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
+	strlcpy(mcam->bus_info, "platform:mmp-camera", sizeof(mcam->bus_info));
 	spin_lock_init(&mcam->dev_lock);
 	/*
 	 * Get our I/O memory.
-- 
2.1.4

