Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2HTSWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMJ5v031556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] [media] Kconfig reorganization
Date: Mon, 20 Aug 2012 15:22:11 -0300
Message-Id: <1345486935-18002-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize the Kconfig order, for it to be a little more intuitive.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index dcaaf8e..d5b4e72 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -146,34 +146,31 @@ comment "Media drivers"
 source "drivers/media/rc/Kconfig"
 
 #
-# Tuner drivers for DVB and V4L
-#
-
-source "drivers/media/tuners/Kconfig"
-
-source "drivers/media/i2c/Kconfig"
-
-#
 # V4L platform/mem2mem drivers
 #
-source "drivers/media/platform/Kconfig"
-
-source "drivers/media/radio/Kconfig"
 
-source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
+source "drivers/media/pci/Kconfig"
+source "drivers/media/platform/Kconfig"
 source "drivers/media/mmc/Kconfig"
 source "drivers/media/parport/Kconfig"
+source "drivers/media/radio/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
 	depends on DVB_CORE && FIREWIRE
 source "drivers/media/firewire/Kconfig"
 
-comment "Supported DVB Frontends"
-	depends on DVB_CORE
-source "drivers/media/dvb-frontends/Kconfig"
-
-# Common drivers
+# Common driver options
 source "drivers/media/common/Kconfig"
 
+#
+# Ancillary drivers (tuners, i2c, frontends)
+#
+
+comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
+
+source "drivers/media/tuners/Kconfig"
+source "drivers/media/i2c/Kconfig"
+source "drivers/media/dvb-frontends/Kconfig"
+
 endif # MEDIA_SUPPORT
-- 
1.7.11.4

