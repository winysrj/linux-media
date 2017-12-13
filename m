Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37710 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdLMKyp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 05:54:45 -0500
Received: by mail-pl0-f67.google.com with SMTP id s3so775893plp.4
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 02:54:45 -0800 (PST)
From: Sergiy Redko <sergredko@gmail.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        sergredko@gmail.com
Subject: [PATCH] Staging: media: atomisp: made function static
Date: Wed, 13 Dec 2017 21:54:33 +1100
Message-Id: <20171213105433.24965-1-sergredko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed sparse warning by making 'dtrace_dot' function static.

Signed-off-by: Sergiy Redko <sergredko@gmail.com>
---
 .../media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index dd1127a21494..f22d73b56bc6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -2567,6 +2567,7 @@ ia_css_debug_mode_enable_dma_channel(int dma_id,
 	return rc;
 }
 
+static
 void dtrace_dot(const char *fmt, ...)
 {
 	va_list ap;
-- 
2.15.1
