Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34023 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdAOAyM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jan 2017 19:54:12 -0500
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org, robsonde@gmail.com,
        thaissa.falbo@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: davinci_vpfe: style fix, using octal file permissions
Date: Sun, 15 Jan 2017 13:53:58 +1300
Message-Id: <20170115005358.19531-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change file permissions to octal style.
Found using checkpatch.

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

