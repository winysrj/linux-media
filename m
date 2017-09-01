Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46951
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752081AbdIANY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 18/27] media: ca.h: get rid of CA_SET_PID
Date: Fri,  1 Sep 2017 10:24:40 -0300
Message-Id: <3ff9265e5a991b3c68a4eacc42ffd6c31574b0c4.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ioctl seems to be some attempt to support a feature
at the bt8xx dst_ca driver. Yet, as said there, it
"needs more work". Right now, the code there is just
a boilerplate.

At the end of the day, no driver uses this ioctl, nor it is
documented anywhere (except for "needs more work").

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/ca.h.rst.exceptions            |  1 -
 Documentation/media/dvb-drivers/ci.rst             |  1 -
 Documentation/media/uapi/dvb/ca-set-pid.rst        | 60 ----------------------
 Documentation/media/uapi/dvb/ca_data_types.rst     | 14 -----
 Documentation/media/uapi/dvb/ca_function_calls.rst |  1 -
 drivers/media/pci/bt8xx/dst_ca.c                   | 16 ------
 include/uapi/linux/dvb/ca.h                        |  7 ---
 7 files changed, 100 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/ca-set-pid.rst

diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/media/ca.h.rst.exceptions
index d7c9fed8c004..553559cc6ad7 100644
--- a/Documentation/media/ca.h.rst.exceptions
+++ b/Documentation/media/ca.h.rst.exceptions
@@ -16,7 +16,6 @@ replace define CA_NDS :c:type:`ca_descr_info`
 replace define CA_DSS :c:type:`ca_descr_info`
 
 # some typedefs should point to struct/enums
-replace typedef ca_pid_t :c:type:`ca_pid`
 replace typedef ca_slot_info_t :c:type:`ca_slot_info`
 replace typedef ca_descr_info_t :c:type:`ca_descr_info`
 replace typedef ca_caps_t :c:type:`ca_caps`
diff --git a/Documentation/media/dvb-drivers/ci.rst b/Documentation/media/dvb-drivers/ci.rst
index 69b07e9d1816..87f3748c49b9 100644
--- a/Documentation/media/dvb-drivers/ci.rst
+++ b/Documentation/media/dvb-drivers/ci.rst
@@ -143,7 +143,6 @@ All these ioctls are also valid for the High level CI interface
 #define CA_GET_MSG        _IOR('o', 132, ca_msg_t)
 #define CA_SEND_MSG       _IOW('o', 133, ca_msg_t)
 #define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
-#define CA_SET_PID        _IOW('o', 135, ca_pid_t)
 
 
 On querying the device, the device yields information thus:
diff --git a/Documentation/media/uapi/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
deleted file mode 100644
index 891c1c72ef24..000000000000
--- a/Documentation/media/uapi/dvb/ca-set-pid.rst
+++ /dev/null
@@ -1,60 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _CA_SET_PID:
-
-==========
-CA_SET_PID
-==========
-
-Name
-----
-
-CA_SET_PID
-
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, CA_SET_PID, struct ca_pid *pid)
-    :name: CA_SET_PID
-
-
-Arguments
----------
-
-``fd``
-  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
-
-``pid``
-  Pointer to struct :c:type:`ca_pid`.
-
-.. c:type:: ca_pid
-
-.. flat-table:: struct ca_pid
-    :header-rows:  1
-    :stub-columns: 0
-
-    -
-       - unsigned int
-       - pid
-       - Program ID
-
-    -
-       - int
-       - index
-       - PID index. Use -1 to disable.
-
-
-
-Description
------------
-
-.. note:: This ioctl is undocumented. Documentation is welcome.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index d9e27c77426c..555b5137936b 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -94,17 +94,3 @@ ca_descr_t
 	unsigned int parity;
 	unsigned char cw[8];
     } ca_descr_t;
-
-
-.. c:type:: ca_pid
-
-ca-pid
-======
-
-
-.. code-block:: c
-
-    typedef struct ca_pid {
-	unsigned int pid;
-	int index;      /* -1 == disable*/
-    } ca_pid_t;
diff --git a/Documentation/media/uapi/dvb/ca_function_calls.rst b/Documentation/media/uapi/dvb/ca_function_calls.rst
index c085a0ebbc05..87d697851e82 100644
--- a/Documentation/media/uapi/dvb/ca_function_calls.rst
+++ b/Documentation/media/uapi/dvb/ca_function_calls.rst
@@ -18,4 +18,3 @@ CA Function Calls
     ca-get-msg
     ca-send-msg
     ca-set-descr
-    ca-set-pid
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 90f4263452d3..7db47d8bbe15 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -64,13 +64,6 @@ static int ca_set_slot_descr(void)
 	return -EOPNOTSUPP;
 }
 
-/*	Need some more work	*/
-static int ca_set_pid(void)
-{
-	/*	We could make this more graceful ?	*/
-	return -EOPNOTSUPP;
-}
-
 static void put_command_and_length(u8 *data, int command, int length)
 {
 	data[0] = (command >> 16) & 0xff;
@@ -629,15 +622,6 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_DESCR Success !");
 		break;
-	case CA_SET_PID:
-		dprintk(verbose, DST_CA_INFO, 1, " Setting PID");
-		if ((ca_set_pid()) < 0) {
-			dprintk(verbose, DST_CA_ERROR, 1, " -->CA_SET_PID Failed !");
-			result = -1;
-			goto free_mem_and_exit;
-		}
-		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_PID Success !");
-		break;
 	default:
 		result = -EOPNOTSUPP;
 	}
diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index 00cf24587bea..859f6c0c4751 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -73,11 +73,6 @@ struct ca_descr {
 	unsigned char cw[8];
 };
 
-struct ca_pid {
-	unsigned int pid;
-	int index;		/* -1 == disable*/
-};
-
 #define CA_RESET          _IO('o', 128)
 #define CA_GET_CAP        _IOR('o', 129, struct ca_caps)
 #define CA_GET_SLOT_INFO  _IOR('o', 130, struct ca_slot_info)
@@ -85,7 +80,6 @@ struct ca_pid {
 #define CA_GET_MSG        _IOR('o', 132, struct ca_msg)
 #define CA_SEND_MSG       _IOW('o', 133, struct ca_msg)
 #define CA_SET_DESCR      _IOW('o', 134, struct ca_descr)
-#define CA_SET_PID        _IOW('o', 135, struct ca_pid)
 
 #if !defined (__KERNEL__)
 
@@ -95,7 +89,6 @@ typedef struct ca_descr_info  ca_descr_info_t;
 typedef struct ca_caps  ca_caps_t;
 typedef struct ca_msg ca_msg_t;
 typedef struct ca_descr ca_descr_t;
-typedef struct ca_pid ca_pid_t;
 
 #endif
 
-- 
2.13.5
