Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38838 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbdHIUbn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:43 -0400
Received: by mail-wm0-f66.google.com with SMTP id y206so737425wmd.5
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:43 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 11/12] [media] ddbridge: Kconfig option to control the MSI modparam default
Date: Wed,  9 Aug 2017 22:31:27 +0200
Message-Id: <20170809203128.31476-12-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

It is known that MSI interrupts - while working quite well so far - can
still cause issues on some hardware platforms (causing I2C timeouts due
to unhandled interrupts). The msi variable/option is set to 1 by default.
So, add a Kconfig option prefixed with "EXPERIMENTAL" that will control
the default value of that modparam, defaulting to off for a better
user experience and (guaranteed) stable operation "per default".

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/Kconfig         | 15 +++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 11 +++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index c79a58fa5fc3..1330b2ecc72a 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -26,3 +26,18 @@ config DVB_DDBRIDGE
 	  - CineS2 V7/V7A and DuoFlex S2 V4 (ST STV0910-based)
 
 	  Say Y if you own such a card and want to use it.
+
+config DVB_DDBRIDGE_MSIENABLE
+	bool "Enable Message Signaled Interrupts (MSI) per default (EXPERIMENTAL)"
+	depends on DVB_DDBRIDGE
+	depends on PCI_MSI
+	default n
+	---help---
+	  Use PCI MSI (Message Signaled Interrupts) per default. Enabling this
+	  might lead to I2C errors originating from the bridge in conjunction
+	  with certain SATA controllers, requiring a reload of the ddbridge
+	  module. MSI can still be disabled by passing msi=0 as option, as
+	  this will just change the msi option default value.
+
+	  If you're unsure, concerned about stability and don't want to pass
+	  module options in case of troubles, say N.
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 5094d2ef79d6..5a930a6e9fb2 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -47,10 +47,17 @@ MODULE_PARM_DESC(adapter_alloc,
 		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
 
 #ifdef CONFIG_PCI_MSI
+#ifdef CONFIG_DVB_DDBRIDGE_MSIENABLE
 int msi = 1;
+#else
+int msi;
+#endif
 module_param(msi, int, 0444);
-MODULE_PARM_DESC(msi,
-		 " Control MSI interrupts: 0-disable, 1-enable (default)");
+#ifdef CONFIG_DVB_DDBRIDGE_MSIENABLE
+MODULE_PARM_DESC(msi, "Control MSI interrupts: 0-disable, 1-enable (default)");
+#else
+MODULE_PARM_DESC(msi, "Control MSI interrupts: 0-disable (default), 1-enable");
+#endif
 #endif
 
 int ci_bitrate = 70000;
-- 
2.13.0
