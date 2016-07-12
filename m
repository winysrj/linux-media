Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbcGLMmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 16/20] [media] doc-rst: document LIRC_SET_REC_TIMEOUT_REPORTS
Date: Tue, 12 Jul 2016 09:42:10 -0300
Message-Id: <1dca6f0e024e75c0151c771566baf0403f393b85.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a separate page for this ioctl and improve its documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst | 49 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  8 ----
 3 files changed, 50 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
new file mode 100644
index 000000000000..0c7f85d0ce3b
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_rec_timeout_reports:
+
+**********************************
+ioctl LIRC_SET_REC_TIMEOUT_REPORTS
+**********************************
+
+Name
+====
+
+LIRC_SET_REC_TIMEOUT_REPORTS - enable or disable timeout reports for IR receive
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *enable )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_REC_TIMEOUT_REPORTS
+
+``enable``
+    enable = 1 means enable timeout report, enable = 0 means disable timeout
+    reports.
+
+
+Description
+===========
+
+Enable or disable timeout reports for IR receive. By default, timeout reports
+should be turned off.
+
+.. note::
+
+   This ioctl is only valid for :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index df576d90c73a..9e57779ca2a6 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -24,4 +24,5 @@ LIRC Device Interface
     lirc-set-rec-carrier-range
     lirc-set-send-carrier
     lirc-set-transmitter-mask
+    lirc-set-rec-timeout-reports
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 26544a5fc946..d99fa0eeef4c 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,14 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_REC_TIMEOUT_REPORTS:
-
-``LIRC_SET_REC_TIMEOUT_REPORTS``
-
-    Enable (1) or disable (0) timeout reports in ``LIRC_MODE_MODE2.`` By
-    default, timeout reports should be turned off.
-
-
 .. _LIRC_SET_MEASURE_CARRIER_MODE:
 .. _lirc-mode2-frequency:
 
-- 
2.7.4


