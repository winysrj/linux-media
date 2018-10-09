Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:24330 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725750AbeJJHN0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 03:13:26 -0400
From: Rajmohan Mani <rajmohan.mani@intel.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>
Cc: tfiga@chromium.org, Rajmohan Mani <rajmohan.mani@intel.com>
Subject: [PATCH] media: intel-ipu3: cio2: Remove redundant definitions
Date: Tue,  9 Oct 2018 16:42:45 -0700
Message-Id: <20181009234245.25830-1-rajmohan.mani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed redundant CIO2_IMAGE_MAX_* definitions

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 240635be7a31..7caab9b8c2b9 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -10,8 +10,6 @@
 #define CIO2_PCI_ID					0x9d32
 #define CIO2_PCI_BAR					0
 #define CIO2_DMA_MASK					DMA_BIT_MASK(39)
-#define CIO2_IMAGE_MAX_WIDTH				4224
-#define CIO2_IMAGE_MAX_LENGTH				3136
 
 #define CIO2_IMAGE_MAX_WIDTH				4224
 #define CIO2_IMAGE_MAX_LENGTH				3136
-- 
2.19.1
