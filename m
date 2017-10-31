Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44997 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753562AbdJaQE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Aishwarya Pant <aishpant@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 7/7] media: atomisp: make function calls cleaner
Date: Tue, 31 Oct 2017 12:04:20 -0400
Message-Id: <efb110c90542359e1cca9cfb6f8ae05387a4bc48.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The #ifs inside the code makes confusing for reviewers and also
cause problems with smatch:
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2937:1: error: directive in argument list
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2939:1: error: directive in argument list
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2941:1: error: directive in argument list

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 8698f8f758ca..339b5d31e1f1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -2933,13 +2933,15 @@ static long atomisp_vidioc_default(struct file *file, void *fh,
 #else
 		if (isp->motor)
 #endif
-			err = v4l2_subdev_call(
 #ifndef ISP2401
+			err = v4l2_subdev_call(
 					isp->inputs[asd->input_curr].motor,
+					core, ioctl, cmd, arg);
 #else
+			err = v4l2_subdev_call(
 					isp->motor,
-#endif
 					core, ioctl, cmd, arg);
+#endif
 		else
 			err = v4l2_subdev_call(
 					isp->inputs[asd->input_curr].camera,
-- 
2.13.6
