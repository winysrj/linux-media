Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54628
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753493AbdIDMPi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 08:15:38 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/2] media: ca docs: document CA_SET_DESCR ioctl and structs
Date: Mon,  4 Sep 2017 09:15:31 -0300
Message-Id: <25b64639e9b3c7880a64b20955174196c877fdb8.1504526763.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504526763.git.mchehab@s-opensource.com>
References: <cover.1504526763.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504526763.git.mchehab@s-opensource.com>
References: <cover.1504526763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The av7110 driver uses CA_SET_DESCR to store the descrambler
control words at the CA descrambler slots.

Document it.

Thanks-to: Honza Petrouš <jpetrous@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-set-descr.rst | 15 ++-------------
 include/uapi/linux/dvb/ca.h                   |  9 ++++++++-
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 9c484317d55c..a6c47205ffd8 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -28,22 +28,11 @@ Arguments
 ``msg``
   Pointer to struct :c:type:`ca_descr`.
 
-.. c:type:: ca_descr
-
-.. code-block:: c
-
-    struct ca_descr {
-	unsigned int index;
-	unsigned int parity;
-	unsigned char cw[8];
-    };
-
-
 Description
 -----------
 
-.. note:: This ioctl is undocumented. Documentation is welcome.
-
+CA_SET_DESCR is used for feeding descrambler CA slots with descrambling
+keys (refered as control words).
 
 Return Value
 ------------
diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index f66ed53f4dc7..a62ddf0cebcd 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -109,9 +109,16 @@ struct ca_msg {
 	unsigned char msg[256];
 };
 
+/**
+ * struct ca_descr - CA descrambler control words info
+ *
+ * @index: CA Descrambler slot
+ * @parity: control words parity, where 0 means even and 1 means odd
+ * @cw: CA Descrambler control words
+ */
 struct ca_descr {
 	unsigned int index;
-	unsigned int parity;	/* 0 == even, 1 == odd */
+	unsigned int parity;
 	unsigned char cw[8];
 };
 
-- 
2.13.5
