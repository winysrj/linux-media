Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35891 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbdC2Fgk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 01:36:40 -0400
Received: by mail-wr0-f196.google.com with SMTP id u1so579567wra.3
        for <linux-media@vger.kernel.org>; Tue, 28 Mar 2017 22:36:39 -0700 (PDT)
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Haim Daniel <haimdaniel@gmail.com>
Subject: [PATCH]: staging: media: css2400: fix checkpatch error
Message-ID: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
Date: Wed, 29 Mar 2017 08:36:27 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------26C941BE4588EADC006962C6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------26C941BE4588EADC006962C6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------26C941BE4588EADC006962C6
Content-Type: text/x-patch;
 name="0001-media-staging-css2400-fix-checkpatch-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-media-staging-css2400-fix-checkpatch-error.patch"

>From 41d35b455f8eb139912909639e914469ef5e06fb Mon Sep 17 00:00:00 2001
From: Haim Daniel <haimdaniel@gmail.com>
Date: Tue, 28 Mar 2017 19:27:57 +0300
Subject: [PATCH] [media] staging: css2400: fix checkpatch error

isp_capture_defs.h:

enclose macro with complex values in parentheses.

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


--------------26C941BE4588EADC006962C6--
