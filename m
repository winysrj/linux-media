Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51481 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbbFINza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 09:55:30 -0400
Received: from [10.54.92.107] (unknown [173.38.220.39])
	by tschai.lan (Postfix) with ESMTPSA id 116DE2A008D
	for <linux-media@vger.kernel.org>; Tue,  9 Jun 2015 15:55:23 +0200 (CEST)
Message-ID: <5576F02D.9080403@xs4all.nl>
Date: Tue, 09 Jun 2015 15:54:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] rc/Kconfig: fix indentation problem
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RC_ST and IR_SUNXI entries have weird indentation, and the RC_ST
entry is actually malformed. Fix it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index ddfab25..b6e1311 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -371,21 +371,21 @@ config RC_ST
 	tristate "ST remote control receiver"
 	depends on RC_CORE
 	depends on ARCH_STI || COMPILE_TEST
-	help
-	 Say Y here if you want support for ST remote control driver
-	 which allows both IR and UHF RX.
-	 The driver passes raw pulse and space information to the LIRC decoder.
+	---help---
+	   Say Y here if you want support for ST remote control driver
+	   which allows both IR and UHF RX.
+	   The driver passes raw pulse and space information to the LIRC decoder.

-	 If you're not sure, select N here.
+	   If you're not sure, select N here.

 config IR_SUNXI
-    tristate "SUNXI IR remote control"
-    depends on RC_CORE
-    depends on ARCH_SUNXI || COMPILE_TEST
-    ---help---
-      Say Y if you want to use sunXi internal IR Controller
-
-      To compile this driver as a module, choose M here: the module will
-      be called sunxi-ir.
+	tristate "SUNXI IR remote control"
+	depends on RC_CORE
+	depends on ARCH_SUNXI || COMPILE_TEST
+	---help---
+	   Say Y if you want to use sunXi internal IR Controller
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called sunxi-ir.

 endif #RC_DEVICES
