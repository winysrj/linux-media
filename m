Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933204AbdCJLft (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:35:49 -0500
Subject: [PATCH 8/8] atomisp: remove FPGA defines
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:35:17 +0000
Message-ID: <148914571319.25309.6693184637114214680.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are not relevant to an upstream kernel driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../host/hive_isp_css_hrt_modified.h               |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h
index 603ef1d..342553d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h
@@ -30,21 +30,6 @@
 #include <gpio_block.h>
 #include <gp_regs.h>
 #include <gp_timer_hrt.h>
-#ifdef _HIVE_ISP_CSS_FPGA_SYSTEM
-  #include <i2c_api.h>
-  #include <dis_sensor.h>
-  #include <display_driver.h>
-  #include <display.h>
-  #include <display_driver.h>
-  #include <shi_sensor_api.h>
-#define hrt_gdc_slave_port(gdc_id)    HRTCAT(gdc_id,_sl_in)
-  #include <isp2400_mamoiada_demo_params.h>
-  #include <isp2400_support.h>
-  #include "isp_css_dev_flash_hrt.h"
-  #include "isp_css_dev_display_hrt.h"
-  #include "isp_css_dev_i2c_hrt.h"
-  #include "isp_css_dev_tb.h"
-#else /* CSS ASIC system */
   #include <css_receiver_2400_hrt.h>
 //  #include <isp2400_mamoiada_params.h>
 //  #include <isp2400_support.h>
@@ -63,7 +48,6 @@
 #error "hive_isp_css_hrt_modified.h: SYSTEM must be one of {2400_MAMOIADA_SYSTEM, 2401_MAMOIADA_SYSTEM}"
 #endif
   #endif
-#endif /* _HIVE_ISP_CSS_FPGA_SYSTEM */
 #include <sp_hrt.h>
 #include <input_system_hrt.h>
 #include <input_selector_hrt.h>
