Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36465
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755074AbdFXUlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:41:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>,
        Fabrizio Perria <fabrizio.perria@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 4/4] media: atomisp: use LINUX_VERSION_CODE for driver version
Date: Sat, 24 Jun 2017 17:40:27 -0300
Message-Id: <6113c6c7bd2a33c2b3d093b2f36cf195d47cebf4.1498336792.git.mchehab@s-opensource.com>
In-Reply-To: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
References: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
In-Reply-To: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
References: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp subdev driver hardcodes its version to
ATOMISP_CSS_VERSION_21. Yet, it has several tests for versions
below 21 internally, with sounds really odd.

On all other media drivers, we're just keeping version set to
LINUX_VERSION_CODE.

So, do the same here, simplifying the code a little bit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/include/linux/atomisp.h  |  6 -----
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |  9 -------
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  3 ---
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |  6 ++---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      | 29 +++++++++++-----------
 5 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp.h b/drivers/staging/media/atomisp/include/linux/atomisp.h
index 35865462ccf9..d67dd658cff9 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp.h
@@ -28,12 +28,6 @@
 #include <linux/types.h>
 #include <linux/version.h>
 
-/* struct media_device_info.driver_version */
-#define ATOMISP_CSS_VERSION_MASK	0x00ffffff
-#define ATOMISP_CSS_VERSION_15		KERNEL_VERSION(1, 5, 0)
-#define ATOMISP_CSS_VERSION_20		KERNEL_VERSION(2, 0, 0)
-#define ATOMISP_CSS_VERSION_21		KERNEL_VERSION(2, 1, 0)
-
 /* struct media_device_info.hw_revision */
 #define ATOMISP_HW_REVISION_MASK	0x0000ff00
 #define ATOMISP_HW_REVISION_SHIFT	8
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index d3667132851b..a9610f0f2ac5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -75,15 +75,6 @@
 #define ATOMISP_PCI_REV_MRFLD_A0_MAX	0
 #define ATOMISP_PCI_REV_BYT_A0_MAX	4
 
-#define ATOMISP_MAJOR		0
-#define ATOMISP_MINOR		5
-#define ATOMISP_PATCHLEVEL	1
-
-#define DRIVER_VERSION_STR	__stringify(ATOMISP_MAJOR) \
-	"." __stringify(ATOMISP_MINOR) "." __stringify(ATOMISP_PATCHLEVEL)
-#define DRIVER_VERSION		KERNEL_VERSION(ATOMISP_MAJOR, \
-	ATOMISP_MINOR, ATOMISP_PATCHLEVEL)
-
 #define ATOM_ISP_STEP_WIDTH	2
 #define ATOM_ISP_STEP_HEIGHT	2
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index aa0526ebaff1..717647951fb6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -51,7 +51,6 @@
 static const char *DRIVER = "atomisp";	/* max size 15 */
 static const char *CARD = "ATOM ISP";	/* max size 31 */
 static const char *BUS_INFO = "PCI-3";	/* max size 31 */
-static const u32 VERSION = DRIVER_VERSION;
 
 /*
  * FIXME: ISP should not know beforehand all CIDs supported by sensor.
@@ -562,8 +561,6 @@ static int atomisp_querycap(struct file *file, void *fh,
 	strncpy(cap->card, CARD, sizeof(cap->card) - 1);
 	strncpy(cap->bus_info, BUS_INFO, sizeof(cap->card) - 1);
 
-	cap->version = VERSION;
-
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 	    V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index 3d6bb166927c..744ab6eb42a0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -1253,8 +1253,7 @@ int atomisp_create_pads_links(struct atomisp_device *isp)
 {
 	struct atomisp_sub_device *asd;
 	int i, j, ret = 0;
-	isp->num_of_streams = isp->media_dev.driver_version >=
-	    ATOMISP_CSS_VERSION_20 ? 2 : 1;
+	isp->num_of_streams = 2;
 	for (i = 0; i < ATOMISP_CAMERA_NR_PORTS; i++) {
 		for (j = 0; j < isp->num_of_streams; j++) {
 			ret =
@@ -1414,8 +1413,7 @@ int atomisp_subdev_init(struct atomisp_device *isp)
 	 * CSS2.0 running ISP2400 support
 	 * multiple streams
 	 */
-	isp->num_of_streams = isp->media_dev.driver_version >=
-	    ATOMISP_CSS_VERSION_20 ? 2 : 1;
+	isp->num_of_streams = 2;
 	isp->asd = devm_kzalloc(isp->dev, sizeof(struct atomisp_sub_device) *
 			       isp->num_of_streams, GFP_KERNEL);
 	if (!isp->asd)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index a543def739fc..2f49562377e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1083,22 +1083,20 @@ atomisp_load_firmware(struct atomisp_device *isp)
 	if (skip_fwload)
 		return NULL;
 
-	if (isp->media_dev.driver_version == ATOMISP_CSS_VERSION_21) {
-		if (isp->media_dev.hw_revision ==
-		    ((ATOMISP_HW_REVISION_ISP2401 << ATOMISP_HW_REVISION_SHIFT)
-		     | ATOMISP_HW_STEPPING_A0))
-			fw_path = "shisp_2401a0_v21.bin";
+	if (isp->media_dev.hw_revision ==
+	    ((ATOMISP_HW_REVISION_ISP2401 << ATOMISP_HW_REVISION_SHIFT)
+	     | ATOMISP_HW_STEPPING_A0))
+		fw_path = "shisp_2401a0_v21.bin";
 
-		if (isp->media_dev.hw_revision ==
-		    ((ATOMISP_HW_REVISION_ISP2401_LEGACY << ATOMISP_HW_REVISION_SHIFT)
-		     | ATOMISP_HW_STEPPING_A0))
-			fw_path = "shisp_2401a0_legacy_v21.bin";
+	if (isp->media_dev.hw_revision ==
+	    ((ATOMISP_HW_REVISION_ISP2401_LEGACY << ATOMISP_HW_REVISION_SHIFT)
+	     | ATOMISP_HW_STEPPING_A0))
+		fw_path = "shisp_2401a0_legacy_v21.bin";
 
-		if (isp->media_dev.hw_revision ==
-		    ((ATOMISP_HW_REVISION_ISP2400 << ATOMISP_HW_REVISION_SHIFT)
-		     | ATOMISP_HW_STEPPING_B0))
-			fw_path = "shisp_2400b0_v21.bin";
-	}
+	if (isp->media_dev.hw_revision ==
+	    ((ATOMISP_HW_REVISION_ISP2400 << ATOMISP_HW_REVISION_SHIFT)
+	     | ATOMISP_HW_STEPPING_B0))
+		fw_path = "shisp_2400b0_v21.bin";
 
 	if (!fw_path) {
 		dev_err(isp->dev,
@@ -1251,7 +1249,8 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	/* This is not a true PCI device on SoC, so the delay is not needed. */
 	isp->pdev->d3_delay = 0;
 
-	isp->media_dev.driver_version = ATOMISP_CSS_VERSION_21;
+	isp->media_dev.driver_version = LINUX_VERSION_CODE;
+
 	switch (id->device & ATOMISP_PCI_DEVICE_SOC_MASK) {
 	case ATOMISP_PCI_DEVICE_SOC_MRFLD:
 		isp->media_dev.hw_revision =
-- 
2.9.4
