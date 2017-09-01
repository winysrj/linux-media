Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46951
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752107AbdIANZB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 14/27] media: dmx.h: get rid of DMX_SET_SOURCE
Date: Fri,  1 Sep 2017 10:24:36 -0300
Message-Id: <da4f827cf899b9dd4e45c2aa32a77133f70a1ff4.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No driver uses this ioctl, nor it is documented anywhere.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions        | 13 --------
 Documentation/media/uapi/dvb/dmx-set-source.rst | 44 -------------------------
 Documentation/media/uapi/dvb/dmx_fcalls.rst     |  1 -
 Documentation/media/uapi/dvb/dmx_types.rst      | 20 -----------
 include/uapi/linux/dvb/dmx.h                    | 12 -------
 5 files changed, 90 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/dmx-set-source.rst

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 5572d2dc9d0e..d2dac35bb84b 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -40,18 +40,6 @@ replace enum dmx_input :c:type:`dmx_input`
 replace symbol DMX_IN_FRONTEND :c:type:`dmx_input`
 replace symbol DMX_IN_DVR :c:type:`dmx_input`
 
-# dmx_source_t symbols
-replace enum dmx_source :c:type:`dmx_source`
-replace symbol DMX_SOURCE_FRONT0 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_FRONT1 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_FRONT2 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_FRONT3 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_DVR0 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_DVR1 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_DVR2 :c:type:`dmx_source`
-replace symbol DMX_SOURCE_DVR3 :c:type:`dmx_source`
-
-
 # Flags for struct dmx_sct_filter_params
 replace define DMX_CHECK_CRC :c:type:`dmx_sct_filter_params`
 replace define DMX_ONESHOT :c:type:`dmx_sct_filter_params`
@@ -61,4 +49,3 @@ replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
 replace typedef dmx_filter_t :c:type:`dmx_filter`
 replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
 replace typedef dmx_input_t :c:type:`dmx_input`
-replace typedef dmx_source_t :c:type:`dmx_source`
diff --git a/Documentation/media/uapi/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
deleted file mode 100644
index ac7f77b25e06..000000000000
--- a/Documentation/media/uapi/dvb/dmx-set-source.rst
+++ /dev/null
@@ -1,44 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _DMX_SET_SOURCE:
-
-==============
-DMX_SET_SOURCE
-==============
-
-Name
-----
-
-DMX_SET_SOURCE
-
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, DMX_SET_SOURCE, struct dmx_source *src)
-    :name: DMX_SET_SOURCE
-
-
-Arguments
----------
-
-
-``fd``
-    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
-
-``src``
-   Undocumented.
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
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index 49e013d4540f..be98d60877f2 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -21,6 +21,5 @@ Demux Function Calls
     dmx-get-event
     dmx-get-stc
     dmx-get-pes-pids
-    dmx-set-source
     dmx-add-pid
     dmx-remove-pid
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 9e907b85cf16..a205c02ccdc1 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -197,23 +197,3 @@ struct dmx_stc
 	unsigned int base;  /* output: divisor for stc to get 90 kHz clock */
 	__u64 stc;      /* output: stc in 'base'*90 kHz units */
     };
-
-
-
-enum dmx_source
-===============
-
-.. c:type:: dmx_source
-
-.. code-block:: c
-
-    typedef enum dmx_source {
-	DMX_SOURCE_FRONT0 = 0,
-	DMX_SOURCE_FRONT1,
-	DMX_SOURCE_FRONT2,
-	DMX_SOURCE_FRONT3,
-	DMX_SOURCE_DVR0   = 16,
-	DMX_SOURCE_DVR1,
-	DMX_SOURCE_DVR2,
-	DMX_SOURCE_DVR3
-    } dmx_source_t;
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index db8bd00c93de..08dc17060321 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -115,16 +115,6 @@ struct dmx_pes_filter_params
 	__u32           flags;
 };
 
-enum dmx_source {
-	DMX_SOURCE_FRONT0 = 0,
-	DMX_SOURCE_FRONT1,
-	DMX_SOURCE_FRONT2,
-	DMX_SOURCE_FRONT3,
-	DMX_SOURCE_DVR0   = 16,
-	DMX_SOURCE_DVR1,
-	DMX_SOURCE_DVR2,
-	DMX_SOURCE_DVR3
-};
 
 struct dmx_stc {
 	unsigned int num;	/* input : which STC? 0..N */
@@ -138,7 +128,6 @@ struct dmx_stc {
 #define DMX_SET_PES_FILTER       _IOW('o', 44, struct dmx_pes_filter_params)
 #define DMX_SET_BUFFER_SIZE      _IO('o', 45)
 #define DMX_GET_PES_PIDS         _IOR('o', 47, __u16[5])
-#define DMX_SET_SOURCE           _IOW('o', 49, enum dmx_source)
 #define DMX_GET_STC              _IOWR('o', 50, struct dmx_stc)
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
 #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
@@ -150,7 +139,6 @@ typedef enum dmx_output dmx_output_t;
 typedef enum dmx_input dmx_input_t;
 typedef enum dmx_ts_pes dmx_pes_type_t;
 typedef struct dmx_filter dmx_filter_t;
-typedef enum dmx_source  dmx_source_t;
 
 #endif
 
-- 
2.13.5
