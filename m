Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47020
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752160AbdIANZK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 19/27] media: ca.h: document most CA data types
Date: Fri,  1 Sep 2017 10:24:41 -0300
Message-Id: <398138451f55737ed8599f658fac3b7af1a5c704.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For most of the stuff there, documenting is easy, as the
header file contains information.

Yet, I was unable to document two data structs:
	ca_msg and ca_descr

As those two structs are used by a few drivers, keep them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca_data_types.rst | 75 ++++---------------------
 include/uapi/linux/dvb/ca.h                    | 78 ++++++++++++++++++++------
 2 files changed, 70 insertions(+), 83 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index 555b5137936b..aa57dd176825 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -6,91 +6,36 @@
 CA Data Types
 *************
 
+.. kernel-doc:: include/uapi/linux/dvb/ca.h
 
-.. c:type:: ca_slot_info
-
-ca_slot_info_t
-==============
-
-
-.. code-block:: c
-
-    typedef struct ca_slot_info {
-	int num;               /* slot number */
-
-	int type;              /* CA interface this slot supports */
-    #define CA_CI            1     /* CI high level interface */
-    #define CA_CI_LINK       2     /* CI link layer level interface */
-    #define CA_CI_PHYS       4     /* CI physical layer level interface */
-    #define CA_DESCR         8     /* built-in descrambler */
-    #define CA_SC          128     /* simple smart card interface */
-
-	unsigned int flags;
-    #define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
-    #define CA_CI_MODULE_READY   2
-    } ca_slot_info_t;
-
-
-.. c:type:: ca_descr_info
-
-ca_descr_info_t
-===============
-
-
-.. code-block:: c
-
-    typedef struct ca_descr_info {
-	unsigned int num;  /* number of available descramblers (keys) */
-	unsigned int type; /* type of supported scrambling system */
-    #define CA_ECD           1
-    #define CA_NDS           2
-    #define CA_DSS           4
-    } ca_descr_info_t;
-
-
-.. c:type:: ca_caps
-
-ca_caps_t
-=========
-
+.. c:type:: ca_msg
 
-.. code-block:: c
+Undocumented data types
+=======================
 
-    typedef struct ca_caps {
-	unsigned int slot_num;  /* total number of CA card and module slots */
-	unsigned int slot_type; /* OR of all supported types */
-	unsigned int descr_num; /* total number of descrambler slots (keys) */
-	unsigned int descr_type;/* OR of all supported types */
-     } ca_cap_t;
+.. note::
 
+   Those data types are undocumented. Documentation is welcome.
 
 .. c:type:: ca_msg
 
-ca_msg_t
-========
-
-
 .. code-block:: c
 
     /* a message to/from a CI-CAM */
-    typedef struct ca_msg {
+    struct ca_msg {
 	unsigned int index;
 	unsigned int type;
 	unsigned int length;
 	unsigned char msg[256];
-    } ca_msg_t;
+    };
 
 
 .. c:type:: ca_descr
 
-ca_descr_t
-==========
-
-
 .. code-block:: c
 
-    typedef struct ca_descr {
+    struct ca_descr {
 	unsigned int index;
 	unsigned int parity;
 	unsigned char cw[8];
-    } ca_descr_t;
+    };
diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index 859f6c0c4751..f66ed53f4dc7 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -24,39 +24,81 @@
 #ifndef _DVBCA_H_
 #define _DVBCA_H_
 
-/* slot interface types and info */
+/**
+ * struct ca_slot_info - CA slot interface types and info.
+ *
+ * @num:	slot number.
+ * @type:	slot type.
+ * @flags:	flags applicable to the slot.
+ *
+ * This struct stores the CA slot information.
+ *
+ * @type can be:
+ *
+ *	- %CA_CI - CI high level interface;
+ *	- %CA_CI_LINK - CI link layer level interface;
+ *	- %CA_CI_PHYS - CI physical layer level interface;
+ *	- %CA_DESCR - built-in descrambler;
+ *	- %CA_SC -simple smart card interface.
+ *
+ * @flags can be:
+ *
+ *	- %CA_CI_MODULE_PRESENT - module (or card) inserted;
+ *	- %CA_CI_MODULE_READY - module is ready for usage.
+ */
 
 struct ca_slot_info {
-	int num;               /* slot number */
-
-	int type;              /* CA interface this slot supports */
-#define CA_CI            1     /* CI high level interface */
-#define CA_CI_LINK       2     /* CI link layer level interface */
-#define CA_CI_PHYS       4     /* CI physical layer level interface */
-#define CA_DESCR         8     /* built-in descrambler */
-#define CA_SC          128     /* simple smart card interface */
+	int num;
+	int type;
+#define CA_CI            1
+#define CA_CI_LINK       2
+#define CA_CI_PHYS       4
+#define CA_DESCR         8
+#define CA_SC          128
 
 	unsigned int flags;
-#define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
+#define CA_CI_MODULE_PRESENT 1
 #define CA_CI_MODULE_READY   2
 };
 
 
-/* descrambler types and info */
-
+/**
+ * struct ca_descr_info - descrambler types and info.
+ *
+ * @num:	number of available descramblers (keys).
+ * @type:	type of supported scrambling system.
+ *
+ * Identifies the number of descramblers and their type.
+ *
+ * @type can be:
+ *
+ *	- %CA_ECD - European Common Descrambler (ECD) hardware;
+ *	- %CA_NDS - Videoguard (NDS) hardware;
+ *	- %CA_DSS - Distributed Sample Scrambling (DSS) hardware.
+ */
 struct ca_descr_info {
-	unsigned int num;          /* number of available descramblers (keys) */
-	unsigned int type;         /* type of supported scrambling system */
+	unsigned int num;
+	unsigned int type;
 #define CA_ECD           1
 #define CA_NDS           2
 #define CA_DSS           4
 };
 
+/**
+ * struct ca_caps - CA slot interface capabilities.
+ *
+ * @slot_num:	total number of CA card and module slots.
+ * @slot_type:	bitmap with all supported types as defined at
+ *		&struct ca_slot_info (e. g. %CA_CI, %CA_CI_LINK, etc).
+ * @descr_num:	total number of descrambler slots (keys)
+ * @descr_type:	bitmap with all supported types as defined at
+ * 		&struct ca_descr_info (e. g. %CA_ECD, %CA_NDS, etc).
+ */
 struct ca_caps {
-	unsigned int slot_num;     /* total number of CA card and module slots */
-	unsigned int slot_type;    /* OR of all supported types */
-	unsigned int descr_num;    /* total number of descrambler slots (keys) */
-	unsigned int descr_type;   /* OR of all supported types */
+	unsigned int slot_num;
+	unsigned int slot_type;
+	unsigned int descr_num;
+	unsigned int descr_type;
 };
 
 /* a message to/from a CI-CAM */
-- 
2.13.5
