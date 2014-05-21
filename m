Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57340 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaEUJ3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 05:29:45 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, sachin.kamat@linaro.org,
	t.figa@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v2 1/3] [media] s5p-mfc: Remove duplicate function s5p_mfc_reload_firmware
Date: Wed, 21 May 2014 14:59:29 +0530
Message-Id: <1400664571-13746-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400664571-13746-1-git-send-email-arun.kk@samsung.com>
References: <1400664571-13746-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function s5p_mfc_reload_firmware is exactly same as
s5p_mfc_load_firmware. So removing the duplicate function.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   33 -------------------------
 2 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 9ed0985..8da4c23 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -162,7 +162,7 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 	/* Double check if there is at least one instance running.
 	 * If no instance is in memory than no firmware should be present */
 	if (dev->num_inst > 0) {
-		ret = s5p_mfc_reload_firmware(dev);
+		ret = s5p_mfc_load_firmware(dev);
 		if (ret) {
 			mfc_err("Failed to reload FW\n");
 			goto unlock;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 6c3f8f7..c97c7c8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -107,39 +107,6 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 	return 0;
 }
 
-/* Reload firmware to MFC */
-int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
-{
-	struct firmware *fw_blob;
-	int err;
-
-	/* Firmare has to be present as a separate file or compiled
-	 * into kernel. */
-	mfc_debug_enter();
-
-	err = request_firmware((const struct firmware **)&fw_blob,
-				     dev->variant->fw_name, dev->v4l2_dev.dev);
-	if (err != 0) {
-		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
-		return -EINVAL;
-	}
-	if (fw_blob->size > dev->fw_size) {
-		mfc_err("MFC firmware is too big to be loaded\n");
-		release_firmware(fw_blob);
-		return -ENOMEM;
-	}
-	if (!dev->fw_virt_addr) {
-		mfc_err("MFC firmware is not allocated\n");
-		release_firmware(fw_blob);
-		return -EINVAL;
-	}
-	memcpy(dev->fw_virt_addr, fw_blob->data, fw_blob->size);
-	wmb();
-	release_firmware(fw_blob);
-	mfc_debug_leave();
-	return 0;
-}
-
 /* Release firmware memory */
 int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 {
-- 
1.7.9.5

