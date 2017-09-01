Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47008
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752123AbdIANZH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 13/27] media: dmx.h: get rid of DMX_GET_CAPS
Date: Fri,  1 Sep 2017 10:24:35 -0300
Message-Id: <9ef26c72c0d77b21b102b3e20da12e4101cab9dd.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no driver currently using it; it is also not
documented about what it would be supposed to do.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions      |  1 -
 Documentation/media/uapi/dvb/dmx-get-caps.rst | 41 ---------------------------
 Documentation/media/uapi/dvb/dmx_fcalls.rst   |  1 -
 Documentation/media/uapi/dvb/dmx_types.rst    | 12 --------
 include/uapi/linux/dvb/dmx.h                  |  7 -----
 5 files changed, 62 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/dmx-get-caps.rst

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 933ca5a61ce1..5572d2dc9d0e 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -58,7 +58,6 @@ replace define DMX_ONESHOT :c:type:`dmx_sct_filter_params`
 replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
 
 # some typedefs should point to struct/enums
-replace typedef dmx_caps_t :c:type:`dmx_caps`
 replace typedef dmx_filter_t :c:type:`dmx_filter`
 replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
 replace typedef dmx_input_t :c:type:`dmx_input`
diff --git a/Documentation/media/uapi/dvb/dmx-get-caps.rst b/Documentation/media/uapi/dvb/dmx-get-caps.rst
deleted file mode 100644
index 145fb520d779..000000000000
--- a/Documentation/media/uapi/dvb/dmx-get-caps.rst
+++ /dev/null
@@ -1,41 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _DMX_GET_CAPS:
-
-============
-DMX_GET_CAPS
-============
-
-Name
-----
-
-DMX_GET_CAPS
-
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, DMX_GET_CAPS, struct dmx_caps *caps)
-    :name: DMX_GET_CAPS
-
-Arguments
----------
-
-``fd``
-    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
-
-``caps``
-    Pointer to struct :c:type:`dmx_caps`
-
-
-Description
------------
-
-.. note:: This ioctl is undocumented. Documentation is welcome.
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index 77a1554d9834..49e013d4540f 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -21,7 +21,6 @@ Demux Function Calls
     dmx-get-event
     dmx-get-stc
     dmx-get-pes-pids
-    dmx-get-caps
     dmx-set-source
     dmx-add-pid
     dmx-remove-pid
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 0f0113205c94..9e907b85cf16 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -199,18 +199,6 @@ struct dmx_stc
     };
 
 
-struct dmx_caps
-===============
-
-.. c:type:: dmx_caps
-
-.. code-block:: c
-
-     typedef struct dmx_caps {
-	__u32 caps;
-	int num_decoders;
-    } dmx_caps_t;
-
 
 enum dmx_source
 ===============
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 1702f923d425..db8bd00c93de 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -115,11 +115,6 @@ struct dmx_pes_filter_params
 	__u32           flags;
 };
 
-struct dmx_caps {
-	__u32 caps;
-	int num_decoders;
-};
-
 enum dmx_source {
 	DMX_SOURCE_FRONT0 = 0,
 	DMX_SOURCE_FRONT1,
@@ -143,7 +138,6 @@ struct dmx_stc {
 #define DMX_SET_PES_FILTER       _IOW('o', 44, struct dmx_pes_filter_params)
 #define DMX_SET_BUFFER_SIZE      _IO('o', 45)
 #define DMX_GET_PES_PIDS         _IOR('o', 47, __u16[5])
-#define DMX_GET_CAPS             _IOR('o', 48, struct dmx_caps)
 #define DMX_SET_SOURCE           _IOW('o', 49, enum dmx_source)
 #define DMX_GET_STC              _IOWR('o', 50, struct dmx_stc)
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
@@ -156,7 +150,6 @@ typedef enum dmx_output dmx_output_t;
 typedef enum dmx_input dmx_input_t;
 typedef enum dmx_ts_pes dmx_pes_type_t;
 typedef struct dmx_filter dmx_filter_t;
-typedef struct dmx_caps dmx_caps_t;
 typedef enum dmx_source  dmx_source_t;
 
 #endif
-- 
2.13.5
