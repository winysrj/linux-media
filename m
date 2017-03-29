Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32881 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbdC2HMk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:12:40 -0400
Received: by mail-wm0-f65.google.com with SMTP id o81so3335103wmb.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 00:12:39 -0700 (PDT)
From: Haim Daniel <haimdaniel@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Haim Daniel <haimdaniel@gmail.com>
Subject: [PATCH v2] [media] staging: css2400: fix checkpatch error
Date: Wed, 29 Mar 2017 10:12:28 +0300
Message-Id: <1490771548-6134-1-git-send-email-haimdaniel@gmail.com>
In-Reply-To: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
References: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

isp_capture_defs.h:

fix checkpatch ERROR: 
Macros with complex values should be enclosed in parentheses

Signed-off-by: Haim Daniel <haimdaniel@gmail.com>
---
 .../pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h
index aa413df..78cbbf6 100644
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
