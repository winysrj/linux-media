Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39242 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755233AbdGVLbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 4/6] atomisp2: don't set driver_version
Date: Sat, 22 Jul 2017 13:30:55 +0200
Message-Id: <20170722113057.45202-5-hverkuil@xs4all.nl>
In-Reply-To: <20170722113057.45202-1-hverkuil@xs4all.nl>
References: <20170722113057.45202-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field will be removed as it is not needed anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 2f49562377e6..663aa916e3ca 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1099,9 +1099,7 @@ atomisp_load_firmware(struct atomisp_device *isp)
 		fw_path = "shisp_2400b0_v21.bin";
 
 	if (!fw_path) {
-		dev_err(isp->dev,
-			"Unsupported driver_version 0x%x, hw_revision 0x%x\n",
-			isp->media_dev.driver_version,
+		dev_err(isp->dev, "Unsupported hw_revision 0x%x\n",
 			isp->media_dev.hw_revision);
 		return NULL;
 	}
@@ -1249,8 +1247,6 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	/* This is not a true PCI device on SoC, so the delay is not needed. */
 	isp->pdev->d3_delay = 0;
 
-	isp->media_dev.driver_version = LINUX_VERSION_CODE;
-
 	switch (id->device & ATOMISP_PCI_DEVICE_SOC_MASK) {
 	case ATOMISP_PCI_DEVICE_SOC_MRFLD:
 		isp->media_dev.hw_revision =
-- 
2.13.2
