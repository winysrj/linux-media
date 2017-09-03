Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51764
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751611AbdICNev (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 09:34:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2] media: net.h: add kernel-doc and use it at Documentation/
Date: Sun,  3 Sep 2017 10:34:44 -0300
Message-Id: <3e67ef8566fbb045eacb8b139020c2379e0d7ca1.1504445626.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we did with frontend.h, ca.h and dmx.h, move the struct
definition to net.h.

That should help to keep it updated, as more stuff gets
added there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

v2:
  - Version 1 was broken: it was missing net-types.rst file and if_num was
    called "ifnum", causing a warning.

 Documentation/media/uapi/dvb/net-add-if.rst | 34 -----------------------------
 Documentation/media/uapi/dvb/net-types.rst  |  9 ++++++++
 Documentation/media/uapi/dvb/net.rst        |  1 +
 include/uapi/linux/dvb/net.h                | 15 +++++++++++++
 4 files changed, 25 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/media/uapi/dvb/net-types.rst

diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index 1087efb9baa0..6749b70246c5 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -41,40 +41,6 @@ created.
 The struct :c:type:`dvb_net_if`::ifnum field will be
 filled with the number of the created interface.
 
-.. c:type:: dvb_net_if
-
-.. flat-table:: struct dvb_net_if
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  pid
-
-       -  Packet ID (PID) of the MPEG-TS that contains data
-
-    -  .. row 3
-
-       -  ifnum
-
-       -  number of the Digital TV interface.
-
-    -  .. row 4
-
-       -  feedtype
-
-       -  Encapsulation type of the feed. It can be:
-	  ``DVB_NET_FEEDTYPE_MPE`` for MPE encoding or
-	  ``DVB_NET_FEEDTYPE_ULE`` for ULE encoding.
-
-
 Return Value
 ============
 
diff --git a/Documentation/media/uapi/dvb/net-types.rst b/Documentation/media/uapi/dvb/net-types.rst
new file mode 100644
index 000000000000..e1177bdcd623
--- /dev/null
+++ b/Documentation/media/uapi/dvb/net-types.rst
@@ -0,0 +1,9 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _dmx_types:
+
+**************
+Net Data Types
+**************
+
+.. kernel-doc:: include/uapi/linux/dvb/net.h
diff --git a/Documentation/media/uapi/dvb/net.rst b/Documentation/media/uapi/dvb/net.rst
index fdb5301a4b1f..e0cd4e402627 100644
--- a/Documentation/media/uapi/dvb/net.rst
+++ b/Documentation/media/uapi/dvb/net.rst
@@ -35,6 +35,7 @@ Digital TV net Function Calls
 .. toctree::
     :maxdepth: 1
 
+    net-types
     net-add-if
     net-remove-if
     net-get-if
diff --git a/include/uapi/linux/dvb/net.h b/include/uapi/linux/dvb/net.h
index f451e7eb0b0b..89d805f9a5a6 100644
--- a/include/uapi/linux/dvb/net.h
+++ b/include/uapi/linux/dvb/net.h
@@ -26,6 +26,21 @@
 
 #include <linux/types.h>
 
+/**
+ * struct dvb_net_if - describes a DVB network interface
+ *
+ * @pid: Packet ID (PID) of the MPEG-TS that contains data
+ * @if_num: number of the Digital TV interface.
+ * @feedtype: Encapsulation type of the feed.
+ *
+ * A MPEG-TS stream may contain packet IDs with IP packages on it.
+ * This struct describes it, and the type of encoding.
+ *
+ * @feedtype can be:
+ *
+ *	- %DVB_NET_FEEDTYPE_MPE for MPE encoding
+ *	- %DVB_NET_FEEDTYPE_ULE for ULE encoding.
+ */
 struct dvb_net_if {
 	__u16 pid;
 	__u16 if_num;
-- 
2.13.5
