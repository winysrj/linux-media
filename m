Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36816 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753716AbdC2HuR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:50:17 -0400
Received: by mail-wr0-f196.google.com with SMTP id u1so936822wra.3
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 00:50:16 -0700 (PDT)
From: Haim Daniel <haimdaniel@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Haim Daniel <haimdaniel@gmail.com>
Subject: [PATCH v3] [media] staging: css2400: fix checkpatch error
Date: Wed, 29 Mar 2017 10:50:08 +0300
Message-Id: <1490773808-7242-1-git-send-email-haimdaniel@gmail.com>
In-Reply-To: <20170329072838.GA8008@kroah.com>
References: <20170329072838.GA8008@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_capture_defs.h: clean up ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Haim Daniel <haimdaniel@gmail.com>
---
 .../pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
index aa413df..117c7a2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
@@ -19,7 +19,7 @@
 #define _ISP_CAPTURE_BITS_PER_ELEM                32  /* only for data, not SOP */						           
 #define _ISP_CAPTURE_BYTES_PER_ELEM               (_ISP_CAPTURE_BITS_PER_ELEM/8	)				           
 #define _ISP_CAPTURE_BYTES_PER_WORD               32		/* 256/8 */	
-#define _ISP_CAPTURE_ELEM_PER_WORD                _ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM		           
+#define _ISP_CAPTURE_ELEM_PER_WORD                (_ISP_CAPTURE_BYTES_PER_WORD / _ISP_CAPTURE_BYTES_PER_ELEM)
 
 //#define CAPT_RCV_ACK                              1
 //#define CAPT_WRT_ACK                              2               
-- 
1.9.1
