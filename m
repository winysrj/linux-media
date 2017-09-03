Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:58097 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752853AbdICODm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 10:03:42 -0400
Subject: [PATCH 2/2] [media] meye: Adjust two function calls together with a
 variable assignment
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pan Bian <bianpan2016@163.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <4370c644-e440-1268-089b-8a8686bbcd5c@users.sourceforge.net>
Message-ID: <7f538823-de13-4246-7482-fcc889385328@users.sourceforge.net>
Date: Sun, 3 Sep 2017 16:03:25 +0200
MIME-Version: 1.0
In-Reply-To: <4370c644-e440-1268-089b-8a8686bbcd5c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 15:41:53 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/meye/meye.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index db36040770a6..9b69a07c1d5b 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1642,14 +1642,15 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	meye.vdev = meye_template;
 	meye.vdev.v4l2_dev = &meye.v4l2_dev;
 
-	ret = -EIO;
-	if ((ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1))) {
+	ret = sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 1);
+	if (ret) {
 		v4l2_err(v4l2_dev, "meye: unable to power on the camera\n");
 		v4l2_err(v4l2_dev, "meye: did you enable the camera in sonypi using the module options ?\n");
 		goto outsonypienable;
 	}
 
-	if ((ret = pci_enable_device(meye.mchip_dev))) {
+	ret = pci_enable_device(meye.mchip_dev);
+	if (ret) {
 		v4l2_err(v4l2_dev, "meye: pci_enable_device failed\n");
 		goto outenabledev;
 	}
-- 
2.14.1
