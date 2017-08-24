Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33331 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdHXTDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 15:03:51 -0400
Received: by mail-wm0-f67.google.com with SMTP id e67so375331wmd.0
        for <linux-media@vger.kernel.org>; Thu, 24 Aug 2017 12:03:50 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at
Subject: [PATCH] [media_build] ddbridge: backport to enable_msi_block, require kernel 3.8
Date: Thu, 24 Aug 2017 21:03:47 +0200
Message-Id: <20170824190347.1705-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Backport to pci_enable_msi_block for kernels <3.14 (picked from upstream
dddvb package). Also, ddbridge requires the PCI_DEVICE_SUB macro, which
was added in 3.8.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Jasmin Jessich <jasmin@anw.at>
---
This should finally silence all current media_build compile issues related
to the ddbridge pcie driver.

 backports/backports.txt               |  3 +++
 backports/v3.13_ddbridge_pcimsi.patch | 29 +++++++++++++++++++++++++++++
 v4l/versions.txt                      |  2 ++
 3 files changed, 34 insertions(+)
 create mode 100644 backports/v3.13_ddbridge_pcimsi.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 873b2f5..87b9ee8 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -84,6 +84,9 @@ add v3.16_netdev.patch
 add v3.16_wait_on_bit.patch
 add v3.16_void_gpiochip_remove.patch
 
+[3.13.255]
+add v3.13_ddbridge_pcimsi.patch
+
 [3.12.255]
 add v3.12_kfifo_in.patch
 
diff --git a/backports/v3.13_ddbridge_pcimsi.patch b/backports/v3.13_ddbridge_pcimsi.patch
new file mode 100644
index 0000000..80b93a0
--- /dev/null
+++ b/backports/v3.13_ddbridge_pcimsi.patch
@@ -0,0 +1,29 @@
+diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
+index 9ab4736..50c3b4f 100644
+--- a/drivers/media/pci/ddbridge/ddbridge-main.c
++++ b/drivers/media/pci/ddbridge/ddbridge-main.c
+@@ -129,13 +129,18 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
+ 	int stat;
+ 
+ 	if (msi && pci_msi_enabled()) {
+-		stat = pci_enable_msi_range(dev->pdev, 1, nr);
+-		if (stat >= 1) {
+-			dev->msi = stat;
+-			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
+-				dev->msi);
+-		} else
++		stat = pci_enable_msi_block(dev->pdev, nr);
++		if (stat == 0) {
++			dev->msi = nr;
++		} else if (stat == 1) {
++			stat = pci_enable_msi(dev->pdev);
++			dev->msi = 1;
++		}
++		if (stat < 0)
+ 			dev_info(dev->dev, "MSI not available.\n");
++		else
++			dev_info(dev->dev, "using %d MSI interrupts\n",
++				 dev->msi);
+ 	}
+ }
+ #endif
diff --git a/v4l/versions.txt b/v4l/versions.txt
index 5f0b301..abf3b27 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -126,6 +126,8 @@ IR_SPI
 [3.8.0]
 # needs regmap lock/unlock ops
 DVB_TS2020
+# needs the PCI_DEVICE_SUB macro
+DVB_DDBRIDGE
 
 [3.7.0]
 # i2c_add_mux_adapter prototype change
-- 
2.13.0
