Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34874 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdAGCsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:48:52 -0500
Received: by mail-pg0-f66.google.com with SMTP id i5so45660557pgh.2
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2017 18:48:52 -0800 (PST)
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: thaissa.falbo@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>
Subject: [PATCH] Staging: media: style fix, octal file permissions
Date: Sat,  7 Jan 2017 15:48:41 +1300
Message-Id: <20170107024841.18838-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changed file permissions to octal.
Found with checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index bf077f8342f6..32109cdd73a6 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -74,7 +74,7 @@
 static bool debug;
 static bool interface;
 
-module_param(interface, bool, S_IRUGO);
+module_param(interface, bool, 0444);
 module_param(debug, bool, 0644);
 
 /**
-- 
2.11.0

