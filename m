Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44423 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932521AbeCMK1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 06:27:23 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] media: s5p-mfc: Use real device for request_firmware() call
Date: Tue, 13 Mar 2018 11:27:10 +0100
Message-id: <20180313102710.23699-1-m.szyprowski@samsung.com>
References: <CGME20180313102719eucas1p1723f61b6e082a282baf04ed3065cc0ec@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide proper (real) struct device to request_firmware() call. This fixes
following error messages:

(NULL device *): Direct firmware load for s5p-mfc-v6-v2.fw failed with error -2
(NULL device *): Direct firmware load for s5p-mfc-v6.fw failed with error -2

into a bit more meaningful ones:

s5p-mfc 11000000.codec: Direct firmware load for s5p-mfc-v6-v2.fw failed with error -2
s5p-mfc 11000000.codec: Direct firmware load for s5p-mfc-v6.fw failed with error -2

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index f95cd76af537..ef9ae969d307 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -62,7 +62,7 @@ int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev)
 		if (!dev->variant->fw_name[i])
 			continue;
 		err = request_firmware((const struct firmware **)&fw_blob,
-				dev->variant->fw_name[i], dev->v4l2_dev.dev);
+				dev->variant->fw_name[i], &dev->plat_dev->dev);
 		if (!err) {
 			dev->fw_ver = (enum s5p_mfc_fw_ver) i;
 			break;
-- 
2.15.0
