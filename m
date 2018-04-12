Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35236 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753051AbeDLPYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 04/17] media: staging: atomisp: fix string comparation logic
Date: Thu, 12 Apr 2018 11:23:56 -0400
Message-Id: <78c5c0b0c408206ee964a99557baec5c56c3dd60.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

it makes no sense to use strncmp() with a size with is
bigger than the string we're comparing with.

Fix those warnings:

    drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c:776 atomisp_open() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c:913 atomisp_release() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2751 atomisp_vidioc_default() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c  | 6 ++----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 709137f25700..693b905547e4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -773,8 +773,7 @@ static int atomisp_open(struct file *file)
 
 	rt_mutex_lock(&isp->mutex);
 
-	acc_node = !strncmp(vdev->name, "ATOMISP ISP ACC",
-			sizeof(vdev->name));
+	acc_node = !strcmp(vdev->name, "ATOMISP ISP ACC");
 	if (acc_node) {
 		acc_pipe = atomisp_to_acc_pipe(vdev);
 		asd = acc_pipe->asd;
@@ -910,8 +909,7 @@ static int atomisp_release(struct file *file)
 	rt_mutex_lock(&isp->mutex);
 
 	dev_dbg(isp->dev, "release device %s\n", vdev->name);
-	acc_node = !strncmp(vdev->name, "ATOMISP ISP ACC",
-			sizeof(vdev->name));
+	acc_node = !strcmp(vdev->name, "ATOMISP ISP ACC");
 	if (acc_node) {
 		acc_pipe = atomisp_to_acc_pipe(vdev);
 		asd = acc_pipe->asd;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 6e7231243891..8c67aea67b6b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -2748,8 +2748,7 @@ static long atomisp_vidioc_default(struct file *file, void *fh,
 	bool acc_node;
 	int err;
 
-	acc_node = !strncmp(vdev->name, "ATOMISP ISP ACC",
-			sizeof(vdev->name));
+	acc_node = !strcmp(vdev->name, "ATOMISP ISP ACC");
 	if (acc_node)
 		asd = atomisp_to_acc_pipe(vdev)->asd;
 	else
-- 
2.14.3
