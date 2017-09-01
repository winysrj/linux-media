Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47009
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752155AbdIANZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 25/27] media: dvb CA docs: place undocumented data together with ioctls
Date: Fri,  1 Sep 2017 10:24:47 -0300
Message-Id: <fcebe5a3582acc707db78b0ad294c8463c5b8998.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, the same undocumented structs are on two places:
at ca_data_types.rst and together with their ioctls.

Move them to just one place and use the standard way to
represent them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-msg.rst    | 38 ++++++--------------------
 Documentation/media/uapi/dvb/ca-set-descr.rst  | 10 +++++++
 Documentation/media/uapi/dvb/ca_data_types.rst | 32 ----------------------
 3 files changed, 19 insertions(+), 61 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index 121588da3ef1..1ee9d667c901 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -28,37 +28,17 @@ Arguments
 ``msg``
   Pointer to struct :c:type:`ca_msg`.
 
+.. c:type:: ca_msg
 
-.. c:type:: struct ca_msg
-
-.. flat-table:: struct ca_msg
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-      - type
-      - name
-      - description
-    -
-       - unsigned int
-       - index
-       -
-
-    -
-       - unsigned int
-       - type
-       -
-
-    -
-       - unsigned int
-       - length
-       -
-
-    -
-       - unsigned char
-       - msg[256]
-       -
+.. code-block:: c
 
+    /* a message to/from a CI-CAM */
+    struct ca_msg {
+	unsigned int index;
+	unsigned int type;
+	unsigned int length;
+	unsigned char msg[256];
+    };
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 70f7b3cf12ad..95de34cf74ba 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -28,6 +28,16 @@ Arguments
 ``msg``
   Pointer to struct :c:type:`ca_descr`.
 
+.. c:type:: ca_descr
+
+.. code-block:: c
+
+    struct ca_descr {
+	unsigned int index;
+	unsigned int parity;
+	unsigned char cw[8];
+    };
+
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index aa57dd176825..ac7cbd76ddd5 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -7,35 +7,3 @@ CA Data Types
 *************
 
 .. kernel-doc:: include/uapi/linux/dvb/ca.h
-
-.. c:type:: ca_msg
-
-Undocumented data types
-=======================
-
-.. note::
-
-   Those data types are undocumented. Documentation is welcome.
-
-.. c:type:: ca_msg
-
-.. code-block:: c
-
-    /* a message to/from a CI-CAM */
-    struct ca_msg {
-	unsigned int index;
-	unsigned int type;
-	unsigned int length;
-	unsigned char msg[256];
-    };
-
-
-.. c:type:: ca_descr
-
-.. code-block:: c
-
-    struct ca_descr {
-	unsigned int index;
-	unsigned int parity;
-	unsigned char cw[8];
-    };
-- 
2.13.5
