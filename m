Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63860 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab1I3LAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:00:38 -0400
Received: by qyk7 with SMTP id 7so1754360qyk.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 04:00:37 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, kyungmin.park@samsung.com,
	mchehab@infradead.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] MFC: Change MFC firmware binary name
Date: Fri, 30 Sep 2011 16:26:02 +0530
Message-Id: <1317380162-16344-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patches renames the MFC firmware binary to avoid SoC name in it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index 5f4da80..f2481a8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -38,7 +38,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	 * into kernel. */
 	mfc_debug_enter();
 	err = request_firmware((const struct firmware **)&fw_blob,
-				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
+				     "s5p-mfc.fw", dev->v4l2_dev.dev);
 	if (err != 0) {
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
@@ -116,7 +116,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
 	 * into kernel. */
 	mfc_debug_enter();
 	err = request_firmware((const struct firmware **)&fw_blob,
-				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
+				     "s5p-mfc.fw", dev->v4l2_dev.dev);
 	if (err != 0) {
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
-- 
1.7.4.1

