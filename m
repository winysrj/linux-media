Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60088 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbdJFVid (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 17:38:33 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: s5p-mfc: check for firmware allocation before requesting firmware
Date: Fri,  6 Oct 2017 15:30:07 -0600
Message-Id: <e7c1ad0167ca363cc783be11871a04957127a3fa.1507325072.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507325072.git.shuahkh@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507325072.git.shuahkh@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check if firmware is allocated before requesting firmware instead of
requesting firmware only to release it if firmware is not allocated.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 69ef9c2..f064a0d1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -55,6 +55,11 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 	 * into kernel. */
 	mfc_debug_enter();
 
+	if (!dev->fw_buf.virt) {
+		mfc_err("MFC firmware is not allocated\n");
+		return -EINVAL;
+	}
+
 	for (i = MFC_FW_MAX_VERSIONS - 1; i >= 0; i--) {
 		if (!dev->variant->fw_name[i])
 			continue;
@@ -75,11 +80,6 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 		release_firmware(fw_blob);
 		return -ENOMEM;
 	}
-	if (!dev->fw_buf.virt) {
-		mfc_err("MFC firmware is not allocated\n");
-		release_firmware(fw_blob);
-		return -EINVAL;
-	}
 	memcpy(dev->fw_buf.virt, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
-- 
2.7.4
