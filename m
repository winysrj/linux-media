Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbcGLMmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 20/20] [media] doc-rst: reorganize LIRC ReST files
Date: Tue, 12 Jul 2016 09:42:14 -0300
Message-Id: <dc94fa5f016a54c1a0937a2050128aaa5a0a1110.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize the LIRC rst files, using "-" instead of "_" on
their names, and creating a separate chapter for syscalls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../uapi/rc/{lirc_dev_intro.rst => lirc-dev-intro.rst}     |  0
 Documentation/media/uapi/rc/lirc-dev.rst                   | 14 ++++++++++++++
 .../uapi/rc/{lirc_device_interface.rst => lirc-func.rst}   | 11 +++++------
 .../media/uapi/rc/{lirc_read.rst => lirc-read.rst}         |  8 ++++----
 .../media/uapi/rc/{lirc_write.rst => lirc-write.rst}       |  0
 Documentation/media/uapi/rc/remote_controllers.rst         |  3 +--
 6 files changed, 24 insertions(+), 12 deletions(-)
 rename Documentation/media/uapi/rc/{lirc_dev_intro.rst => lirc-dev-intro.rst} (100%)
 create mode 100644 Documentation/media/uapi/rc/lirc-dev.rst
 rename Documentation/media/uapi/rc/{lirc_device_interface.rst => lirc-func.rst} (81%)
 rename Documentation/media/uapi/rc/{lirc_read.rst => lirc-read.rst} (83%)
 rename Documentation/media/uapi/rc/{lirc_write.rst => lirc-write.rst} (100%)

diff --git a/Documentation/media/uapi/rc/lirc_dev_intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc_dev_intro.rst
rename to Documentation/media/uapi/rc/lirc-dev-intro.rst
diff --git a/Documentation/media/uapi/rc/lirc-dev.rst b/Documentation/media/uapi/rc/lirc-dev.rst
new file mode 100644
index 000000000000..03cde25f5859
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-dev.rst
@@ -0,0 +1,14 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_dev:
+
+LIRC Device Interface
+=====================
+
+
+.. toctree::
+    :maxdepth: 1
+
+    lirc-dev-intro
+    lirc-func
+    lirc-header
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc-func.rst
similarity index 81%
rename from Documentation/media/uapi/rc/lirc_device_interface.rst
rename to Documentation/media/uapi/rc/lirc-func.rst
index a2ad957c96ae..9b5a772ec96c 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -1,17 +1,16 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _lirc_dev:
+.. _lirc_func:
 
-LIRC Device Interface
-=====================
+LIRC Function Reference
+=======================
 
 
 .. toctree::
     :maxdepth: 1
 
-    lirc_dev_intro
-    lirc_read
-    lirc_write
+    lirc-read
+    lirc-write
     lirc-get-features
     lirc-get-send-mode
     lirc-get-rec-mode
diff --git a/Documentation/media/uapi/rc/lirc_read.rst b/Documentation/media/uapi/rc/lirc-read.rst
similarity index 83%
rename from Documentation/media/uapi/rc/lirc_read.rst
rename to Documentation/media/uapi/rc/lirc-read.rst
index a8f1b446c294..8d4e9b6e507d 100644
--- a/Documentation/media/uapi/rc/lirc_read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -44,10 +44,10 @@ is greater than ``SSIZE_MAX``, the result is unspecified.
 The lircd userspace daemon reads raw IR data from the LIRC chardev. The
 exact format of the data depends on what modes a driver supports, and
 what mode has been selected. lircd obtains supported modes and sets the
-active mode via the ioctl interface, detailed at :ref:`lirc_ioctl`.
-The generally preferred mode is LIRC_MODE_MODE2, in which packets
-containing an int value describing an IR signal are read from the
-chardev.
+active mode via the ioctl interface, detailed at :ref:`lirc_func`.
+The generally preferred mode for receive is
+:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`, in which packets containing an
+int value describing an IR signal are read from the chardev.
 
 See also
 `http://www.lirc.org/html/technical.html <http://www.lirc.org/html/technical.html>`__
diff --git a/Documentation/media/uapi/rc/lirc_write.rst b/Documentation/media/uapi/rc/lirc-write.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc_write.rst
rename to Documentation/media/uapi/rc/lirc-write.rst
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index 3e9731afedd9..169286501ebb 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -23,8 +23,7 @@ Remote Controllers
     rc-sysfs-nodes
     rc-tables
     rc-table-change
-    lirc_device_interface
-    lirc-header
+    lirc-dev
 
 
 **********************
-- 
2.7.4


