Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbcGIOXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 10:23:44 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: make CEC look more like other parts of the book
Date: Sat,  9 Jul 2016 11:23:32 -0300
Message-Id: <da98a79ba71fe62ae9f7581901df35ce0dc1be68.1468074160.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better organize the contents of the CEC part, moving the
introduction to chapter 1, placing all ioctls at chapter 2
and numerating all chapters and items.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-api.rst   | 60 +++---------------------------
 Documentation/media/uapi/cec/cec-funcs.rst | 21 +++++++++++
 Documentation/media/uapi/cec/cec-intro.rst | 31 +++++++++++++++
 3 files changed, 57 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/media/uapi/cec/cec-funcs.rst
 create mode 100644 Documentation/media/uapi/cec/cec-intro.rst

diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index f40103fefddc..e7dc8253f1e2 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -10,65 +10,15 @@ CEC API
 
 .. _cec-api:
 
-*********************************
-CEC: Consumer Electronics Control
-*********************************
-
-
-.. _cec-intro:
-
-Introduction
-============
-
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
-
-HDMI connectors provide a single pin for use by the Consumer Electronics
-Control protocol. This protocol allows different devices connected by an
-HDMI cable to communicate. The protocol for CEC version 1.4 is defined
-in supplements 1 (CEC) and 2 (HEAC or HDMI Ethernet and Audio Return
-Channel) of the HDMI 1.4a (:ref:`hdmi`) specification and the
-extensions added to CEC version 2.0 are defined in chapter 11 of the
-HDMI 2.0 (:ref:`hdmi2`) specification.
-
-The bitrate is very slow (effectively no more than 36 bytes per second)
-and is based on the ancient AV.link protocol used in old SCART
-connectors. The protocol closely resembles a crazy Rube Goldberg
-contraption and is an unholy mix of low and high level messages. Some
-messages, especially those part of the HEAC protocol layered on top of
-CEC, need to be handled by the kernel, others can be handled either by
-the kernel or by userspace.
-
-In addition, CEC can be implemented in HDMI receivers, transmitters and
-in USB devices that have an HDMI input and an HDMI output and that
-control just the CEC pin.
-
-Drivers that support CEC will create a CEC device node (/dev/cecX) to
-give userspace access to the CEC adapter. The
-:ref:`CEC_ADAP_G_CAPS` ioctl will tell
-userspace what it is allowed to do.
-
-
-.. _cec-user-func:
-
-******************
-Function Reference
-******************
-
+This part describes the CEC: Consumer Electronics Control
 
 .. toctree::
     :maxdepth: 1
+    :numbered:
+    :caption: Table of Contents
 
-    cec-func-open
-    cec-func-close
-    cec-func-ioctl
-    cec-func-poll
-    cec-ioc-adap-g-caps
-    cec-ioc-adap-g-log-addrs
-    cec-ioc-adap-g-phys-addr
-    cec-ioc-dqevent
-    cec-ioc-g-mode
-    cec-ioc-receive
+    cec-intro
+    cec-funcs
     cec-header
 
 
diff --git a/Documentation/media/uapi/cec/cec-funcs.rst b/Documentation/media/uapi/cec/cec-funcs.rst
new file mode 100644
index 000000000000..5b7630f2e076
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-funcs.rst
@@ -0,0 +1,21 @@
+.. _cec-user-func:
+
+******************
+Function Reference
+******************
+
+
+.. toctree::
+    :maxdepth: 1
+    :numbered:
+
+    cec-func-open
+    cec-func-close
+    cec-func-ioctl
+    cec-func-poll
+    cec-ioc-adap-g-caps
+    cec-ioc-adap-g-log-addrs
+    cec-ioc-adap-g-phys-addr
+    cec-ioc-dqevent
+    cec-ioc-g-mode
+    cec-ioc-receive
diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/media/uapi/cec/cec-intro.rst
new file mode 100644
index 000000000000..d6a878866b3f
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-intro.rst
@@ -0,0 +1,31 @@
+.. _cec-intro:
+
+Introduction
+============
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+HDMI connectors provide a single pin for use by the Consumer Electronics
+Control protocol. This protocol allows different devices connected by an
+HDMI cable to communicate. The protocol for CEC version 1.4 is defined
+in supplements 1 (CEC) and 2 (HEAC or HDMI Ethernet and Audio Return
+Channel) of the HDMI 1.4a (:ref:`hdmi`) specification and the
+extensions added to CEC version 2.0 are defined in chapter 11 of the
+HDMI 2.0 (:ref:`hdmi2`) specification.
+
+The bitrate is very slow (effectively no more than 36 bytes per second)
+and is based on the ancient AV.link protocol used in old SCART
+connectors. The protocol closely resembles a crazy Rube Goldberg
+contraption and is an unholy mix of low and high level messages. Some
+messages, especially those part of the HEAC protocol layered on top of
+CEC, need to be handled by the kernel, others can be handled either by
+the kernel or by userspace.
+
+In addition, CEC can be implemented in HDMI receivers, transmitters and
+in USB devices that have an HDMI input and an HDMI output and that
+control just the CEC pin.
+
+Drivers that support CEC will create a CEC device node (/dev/cecX) to
+give userspace access to the CEC adapter. The
+:ref:`CEC_ADAP_G_CAPS` ioctl will tell userspace what it is allowed to do.
-- 
2.7.4

