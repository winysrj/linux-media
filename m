Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34827 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751617AbeEBXUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 19:20:04 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/2] cec: Kconfig coding style issue
Date: Wed,  2 May 2018 18:19:30 -0500
Message-Id: <1525303170-6303-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525303170-6303-1-git-send-email-brad@nextdimension.cc>
References: <1525303170-6303-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tabs instead of spaces and help is two-spaced after single tab.

The incorrect spacing breaks menuconfig on older kernels.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 37124c3..8add62a 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -78,13 +78,13 @@ config MEDIA_SDR_SUPPORT
 	  Say Y when you have a software defined radio device.
 
 config MEDIA_CEC_SUPPORT
-       bool "HDMI CEC support"
-       ---help---
-	 Enable support for HDMI CEC (Consumer Electronics Control),
-	 which is an optional HDMI feature.
+	bool "HDMI CEC support"
+	---help---
+	  Enable support for HDMI CEC (Consumer Electronics Control),
+	  which is an optional HDMI feature.
 
-	 Say Y when you have an HDMI receiver, transmitter or a USB CEC
-	 adapter that supports HDMI CEC.
+	  Say Y when you have an HDMI receiver, transmitter or a USB CEC
+	  adapter that supports HDMI CEC.
 
 source "drivers/media/cec/Kconfig"
 
-- 
2.7.4
