Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbcGLMmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 18/20] [media] doc-rst: document LIRC_SET_WIDEBAND_RECEIVER
Date: Tue, 12 Jul 2016 09:42:12 -0300
Message-Id: <57b08a9b121d894d3aac4cafd338c39e53cbb41a.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put documentation for this ioctl on a separate page and
improve it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   | 56 ++++++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  1 +
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 19 --------
 3 files changed, 57 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
new file mode 100644
index 000000000000..cffb01fd1042
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_wideband_receiver:
+
+********************************
+ioctl LIRC_SET_WIDEBAND_RECEIVER
+********************************
+
+Name
+====
+
+LIRC_SET_WIDEBAND_RECEIVER - enable wide band receiver.
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
+    LIRC_SET_WIDEBAND_RECEIVER
+
+``enable``
+    enable = 1 means enable wideband receiver, enable = 0 means disable
+    wideband receiver.
+
+
+Description
+===========
+
+Some receivers are equipped with special wide band receiver which is
+intended to be used to learn output of existing remote. This ioctl
+allows enabling or disabling it.
+
+This might be useful of receivers that have otherwise narrow band receiver
+that prevents them to be used with some remotes. Wide band receiver might
+also be more precise. On the other hand its disadvantage it usually
+reduced range of reception.
+
+.. note:: Wide band receiver might be implictly enabled if you enable
+    carrier reports. In that case it will be disabled as soon as you disable
+    carrier reports. Trying to disable wide band receiver while carrier
+    reports are active will do nothing.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index 2810253ba852..e9cb510349a0 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -26,4 +26,5 @@ LIRC Device Interface
     lirc-set-transmitter-mask
     lirc-set-rec-timeout-reports
     lirc-set-measure-carrier-mode
+    lirc-set-wideband-receiver
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index d220fc233e6d..fe5f2719ea77 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,25 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_WIDEBAND_RECEIVER:
-
-``LIRC_SET_WIDEBAND_RECEIVER``
-
-    Some receivers are equipped with special wide band receiver which is
-    intended to be used to learn output of existing remote. Calling that
-    ioctl with (1) will enable it, and with (0) disable it. This might
-    be useful of receivers that have otherwise narrow band receiver that
-    prevents them to be used with some remotes. Wide band receiver might
-    also be more precise On the other hand its disadvantage it usually
-    reduced range of reception.
-
-    .. note:: Wide band receiver might be
-       implictly enabled if you enable carrier reports. In that case it
-       will be disabled as soon as you disable carrier reports. Trying to
-       disable wide band receiver while carrier reports are active will do
-       nothing.
-
-
 .. _lirc_dev_errors:
 
 Return Value
-- 
2.7.4


