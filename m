Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58254 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751010AbdGPISw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 04:18:52 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pulse8-cec.rst: add documentation for the pulse8-cec driver
Message-ID: <51c64d0a-1725-041f-0f70-5c5ff88a2250@xs4all.nl>
Date: Sun, 16 Jul 2017 10:18:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the persistent_config module option.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/cec-drivers/index.rst      | 32 ++++++++++++++++++++++++++
 Documentation/media/cec-drivers/pulse8-cec.rst | 11 +++++++++
 Documentation/media/index.rst                  |  1 +
 MAINTAINERS                                    |  1 +
 4 files changed, 45 insertions(+)
 create mode 100644 Documentation/media/cec-drivers/index.rst
 create mode 100644 Documentation/media/cec-drivers/pulse8-cec.rst

diff --git a/Documentation/media/cec-drivers/index.rst b/Documentation/media/cec-drivers/index.rst
new file mode 100644
index 000000000000..1c817aa10bb6
--- /dev/null
+++ b/Documentation/media/cec-drivers/index.rst
@@ -0,0 +1,32 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. include:: <isonum.txt>
+
+.. _cec-drivers:
+
+#################################
+CEC driver-specific documentation
+#################################
+
+**Copyright** |copy| 2017 : LinuxTV Developers
+
+This documentation is free software; you can redistribute it and/or modify it
+under the terms of the GNU General Public License as published by the Free
+Software Foundation version 2 of the License.
+
+This program is distributed in the hope that it will be useful, but WITHOUT
+ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+more details.
+
+For more details see the file COPYING in the source distribution of Linux.
+
+.. class:: toc-title
+
+        Table of Contents
+
+.. toctree::
+	:maxdepth: 5
+	:numbered:
+
+	pulse8-cec
diff --git a/Documentation/media/cec-drivers/pulse8-cec.rst b/Documentation/media/cec-drivers/pulse8-cec.rst
new file mode 100644
index 000000000000..99551c6a9bc5
--- /dev/null
+++ b/Documentation/media/cec-drivers/pulse8-cec.rst
@@ -0,0 +1,11 @@
+Pulse-Eight CEC Adapter driver
+==============================
+
+The pulse8-cec driver implements the following module option:
+
+``persistent_config``
+---------------------
+
+By default this is off, but when set to 1 the driver will store the current
+settings to the device's internal eeprom and restore it the next time the
+device is connected to the USB port.
diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
index 7f8f0af620ce..7d2907d4f8d7 100644
--- a/Documentation/media/index.rst
+++ b/Documentation/media/index.rst
@@ -10,6 +10,7 @@ Contents:
    media_kapi
    dvb-drivers/index
    v4l-drivers/index
+   cec-drivers/index

 .. only::  subproject

diff --git a/MAINTAINERS b/MAINTAINERS
index c4be6d4af7d2..dd50b91aa81c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10416,6 +10416,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/pulse8-cec/*
+F:	Documentation/media/cec-drivers/pulse8-cec.rst

 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
-- 
2.11.0
