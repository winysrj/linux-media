Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754627AbdCaVRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 17:17:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Alexander Dahl <post@lespocky.de>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH] docs-rst: core_api: move driver-specific stuff to drivers_api
Date: Fri, 31 Mar 2017 18:17:00 -0300
Message-Id: <1c2d5b55b259a233594a61d7c6294a0b626a8fa6.1490994994.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several stuff there that are actually driver-specific.

Move those to the driver_api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/core-api/kernel-api.rst              | 72 ----------------------
 Documentation/driver-api/firmware/index.rst        |  1 +
 .../driver-api/firmware/other_interfaces.rst       | 15 +++++
 Documentation/driver-api/index.rst                 |  2 +
 Documentation/driver-api/misc_devices.rst          |  5 ++
 Documentation/driver-api/pci.rst                   | 50 +++++++++++++++
 6 files changed, 73 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/driver-api/firmware/other_interfaces.rst
 create mode 100644 Documentation/driver-api/misc_devices.rst
 create mode 100644 Documentation/driver-api/pci.rst

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index 9a3d3597a6b7..9ec8488319dc 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -228,72 +228,6 @@ MTRR Handling
 .. kernel-doc:: arch/x86/kernel/cpu/mtrr/main.c
    :export:
 
-PCI Support Library
--------------------
-
-.. kernel-doc:: drivers/pci/pci.c
-   :export:
-
-.. kernel-doc:: drivers/pci/pci-driver.c
-   :export:
-
-.. kernel-doc:: drivers/pci/remove.c
-   :export:
-
-.. kernel-doc:: drivers/pci/search.c
-   :export:
-
-.. kernel-doc:: drivers/pci/msi.c
-   :export:
-
-.. kernel-doc:: drivers/pci/bus.c
-   :export:
-
-.. kernel-doc:: drivers/pci/access.c
-   :export:
-
-.. kernel-doc:: drivers/pci/irq.c
-   :export:
-
-.. kernel-doc:: drivers/pci/htirq.c
-   :export:
-
-.. kernel-doc:: drivers/pci/probe.c
-   :export:
-
-.. kernel-doc:: drivers/pci/slot.c
-   :export:
-
-.. kernel-doc:: drivers/pci/rom.c
-   :export:
-
-.. kernel-doc:: drivers/pci/iov.c
-   :export:
-
-.. kernel-doc:: drivers/pci/pci-sysfs.c
-   :internal:
-
-PCI Hotplug Support Library
----------------------------
-
-.. kernel-doc:: drivers/pci/hotplug/pci_hotplug_core.c
-   :export:
-
-Firmware Interfaces
-===================
-
-DMI Interfaces
---------------
-
-.. kernel-doc:: drivers/firmware/dmi_scan.c
-   :export:
-
-EDD Interfaces
---------------
-
-.. kernel-doc:: drivers/firmware/edd.c
-   :internal:
-
 Security Framework
 ==================
 
@@ -372,12 +306,6 @@ Char devices
 .. kernel-doc:: fs/char_dev.c
    :export:
 
-Miscellaneous Devices
-=====================
-
-.. kernel-doc:: drivers/char/misc.c
-   :export:
-
 Clock Framework
 ===============
 
diff --git a/Documentation/driver-api/firmware/index.rst b/Documentation/driver-api/firmware/index.rst
index 1abe01793031..29da39ec4b8a 100644
--- a/Documentation/driver-api/firmware/index.rst
+++ b/Documentation/driver-api/firmware/index.rst
@@ -7,6 +7,7 @@ Linux Firmware API
    introduction
    core
    request_firmware
+   other_interfaces
 
 .. only::  subproject and html
 
diff --git a/Documentation/driver-api/firmware/other_interfaces.rst b/Documentation/driver-api/firmware/other_interfaces.rst
new file mode 100644
index 000000000000..36c47b1e9824
--- /dev/null
+++ b/Documentation/driver-api/firmware/other_interfaces.rst
@@ -0,0 +1,15 @@
+Other Firmware Interfaces
+=========================
+
+DMI Interfaces
+--------------
+
+.. kernel-doc:: drivers/firmware/dmi_scan.c
+   :export:
+
+EDD Interfaces
+--------------
+
+.. kernel-doc:: drivers/firmware/edd.c
+   :internal:
+
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 90e742577dfc..8058a87c1c74 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -27,6 +27,7 @@ available subsections can be seen below.
    iio/index
    input
    usb/index
+   pci
    spi
    i2c
    hsi
@@ -36,6 +37,7 @@ available subsections can be seen below.
    80211/index
    uio-howto
    firmware/index
+   misc_devices
 
 .. only::  subproject and html
 
diff --git a/Documentation/driver-api/misc_devices.rst b/Documentation/driver-api/misc_devices.rst
new file mode 100644
index 000000000000..c7ee7b02ba88
--- /dev/null
+++ b/Documentation/driver-api/misc_devices.rst
@@ -0,0 +1,5 @@
+Miscellaneous Devices
+=====================
+
+.. kernel-doc:: drivers/char/misc.c
+   :export:
diff --git a/Documentation/driver-api/pci.rst b/Documentation/driver-api/pci.rst
new file mode 100644
index 000000000000..01a6c8b7d3a7
--- /dev/null
+++ b/Documentation/driver-api/pci.rst
@@ -0,0 +1,50 @@
+PCI Support Library
+-------------------
+
+.. kernel-doc:: drivers/pci/pci.c
+   :export:
+
+.. kernel-doc:: drivers/pci/pci-driver.c
+   :export:
+
+.. kernel-doc:: drivers/pci/remove.c
+   :export:
+
+.. kernel-doc:: drivers/pci/search.c
+   :export:
+
+.. kernel-doc:: drivers/pci/msi.c
+   :export:
+
+.. kernel-doc:: drivers/pci/bus.c
+   :export:
+
+.. kernel-doc:: drivers/pci/access.c
+   :export:
+
+.. kernel-doc:: drivers/pci/irq.c
+   :export:
+
+.. kernel-doc:: drivers/pci/htirq.c
+   :export:
+
+.. kernel-doc:: drivers/pci/probe.c
+   :export:
+
+.. kernel-doc:: drivers/pci/slot.c
+   :export:
+
+.. kernel-doc:: drivers/pci/rom.c
+   :export:
+
+.. kernel-doc:: drivers/pci/iov.c
+   :export:
+
+.. kernel-doc:: drivers/pci/pci-sysfs.c
+   :internal:
+
+PCI Hotplug Support Library
+---------------------------
+
+.. kernel-doc:: drivers/pci/hotplug/pci_hotplug_core.c
+   :export:
-- 
2.9.3
