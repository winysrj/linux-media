Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54622
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753486AbdIDMPi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 08:15:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] media: ca.h: document ca_msg and the corresponding ioctls
Date: Mon,  4 Sep 2017 09:15:32 -0300
Message-Id: <5d3763e16e3e910c51e7ced4fac7c3ec53bda1b5.1504526763.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504526763.git.mchehab@s-opensource.com>
References: <cover.1504526763.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504526763.git.mchehab@s-opensource.com>
References: <cover.1504526763.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usually, CA messages are sent/received via reading/writing at
the CA device node. However, two drivers (dst_ca and firedtv-ci)
also implement it via ioctls.

Apparently, on both cases, the net result is the same.

Anyway, let's document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-get-msg.rst  | 19 ++++++-------------
 Documentation/media/uapi/dvb/ca-send-msg.rst |  6 +++++-
 include/uapi/linux/dvb/ca.h                  | 11 ++++++++++-
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index bdb116552068..ceeda623ce93 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -28,22 +28,15 @@ Arguments
 ``msg``
   Pointer to struct :c:type:`ca_msg`.
 
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
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
+Receives a message via a CI CA module.
+
+.. note::
+
+   Please notice that, on most drivers, this is done by reading from
+   the /dev/adapter?/ca? device node.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 644b6bda1aea..9e91287b7bbc 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -32,8 +32,12 @@ Arguments
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
+Sends a message via a CI CA module.
 
+.. note::
+
+   Please notice that, on most drivers, this is done by writing
+   to the /dev/adapter?/ca? device node.
 
 Return Value
 ------------
diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index a62ddf0cebcd..9bcd4cad497b 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -101,7 +101,16 @@ struct ca_caps {
 	unsigned int descr_type;
 };
 
-/* a message to/from a CI-CAM */
+/**
+ * struct ca_msg - a message to/from a CI-CAM
+ *
+ * @index:	unused
+ * @type:	unused
+ * @length:	length of the message
+ * @msg:	message
+ *
+ * This struct carries a message to be send/received from a CI CA module.
+ */
 struct ca_msg {
 	unsigned int index;
 	unsigned int type;
-- 
2.13.5
