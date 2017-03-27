Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35610 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdC0I5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 04:57:22 -0400
Date: Mon, 27 Mar 2017 17:52:20 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: atomisp: fix an issue timeout value for checking
 error
Message-ID: <20170327085220.GA26407@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The timeout variable could be zero even if the bits has expected result.
The checking expected bits again would be better instead whether
the timeout value is zero or not.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 94bc793..f2e5749 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -220,11 +220,11 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 			timeout--;
 		}
 
-		if (timeout != 0)
+		if (!(isp_sspm1 & ISP_FREQ_VALID_MASK))
 			break;
 	}
 
-	if (timeout == 0) {
+	if (isp_sspm1 & ISP_FREQ_VALID_MASK) {
 		dev_err(isp->dev, "DFS failed due to HW error.\n");
 		return -EINVAL;
 	}
@@ -238,7 +238,7 @@ static int write_target_freq_to_hw(struct atomisp_device *isp,
 		udelay(100);
 		timeout--;
 	}
-	if (timeout == 0) {
+	if ((isp_sspm1 >> ISP_FREQ_STAT_OFFSET) != ratio) {
 		dev_err(isp->dev, "DFS target freq is rejected by HW.\n");
 		return -EINVAL;
 	}
-- 
1.9.1
