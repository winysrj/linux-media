Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0055.outbound.protection.outlook.com ([104.47.33.55]:15072
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750790AbeBUXAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:00:45 -0500
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-media@vger.kernel.org>,
        <rohit.athavale@xilinx.com>
Subject: [PATCH v2 2/3] staging: xm2mvscale: Add TODO for the driver
Date: Wed, 21 Feb 2018 14:43:15 -0800
Message-ID: <1519252996-787-3-git-send-email-rohit.athavale@xilinx.com>
In-Reply-To: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit highlights the key functionalities that will be
improved upon in a future patch set.

Signed-off-by: Rohit Athavale <rohit.athavale@xilinx.com>
---
 drivers/staging/xm2mvscale/TODO | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 drivers/staging/xm2mvscale/TODO

diff --git a/drivers/staging/xm2mvscale/TODO b/drivers/staging/xm2mvscale/TODO
new file mode 100644
index 0000000..f0a0733
--- /dev/null
+++ b/drivers/staging/xm2mvscale/TODO
@@ -0,0 +1,18 @@
+* Fix checkpatch.pl complaints
+* Investigate if V4L2/Media framework can be used on top of HW Layer instead
+  of exisiting char driver.
+* Possible remaining coding style fix.
+* Add support for DMABUF.
+* This is an early prototype, hardware register map changes are expected.
+* Update driver for 64-bit DMA address once the new Xilinx M2M Scaler IP
+  has support for 64-bit DMA Addresses. Current IP supports 32-bit DMA addresses.
+* Remove deadcode.
+* Add documents in Documentation beyond the DT binding doc.
+* This needs a home  in the proper drivers area (example : drivers/misc/),
+  once the quality of the driver is improved. Suggestions about where
+  it should be placed are welcome.
+* The IOCTL header could be moved to an uapi/* area once this is out of staging.
+
+Please send any patches to:
+Greg Kroah-Hartman <greg@kroah.com> and Rohit Athavale <rathaval@xilinx.com>
+
-- 
1.9.1
