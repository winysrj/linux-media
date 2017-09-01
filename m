Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46940
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752049AbdIANY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 15/27] media: dmx.h: get rid of GET_DMX_EVENT
Date: Fri,  1 Sep 2017 10:24:37 -0300
Message-Id: <02294126b52fedd272d1ff5da461a01b25f71440.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This seems to be a pure fictional API :-)

It only exists at the DVB book, with no code implemeting it.

So, just get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/dmx-get-event.rst | 60 --------------------------
 Documentation/media/uapi/dvb/dmx_fcalls.rst    |  1 -
 Documentation/media/uapi/dvb/dmx_types.rst     | 19 --------
 3 files changed, 80 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/dmx-get-event.rst

diff --git a/Documentation/media/uapi/dvb/dmx-get-event.rst b/Documentation/media/uapi/dvb/dmx-get-event.rst
deleted file mode 100644
index 8be626c29158..000000000000
--- a/Documentation/media/uapi/dvb/dmx-get-event.rst
+++ /dev/null
@@ -1,60 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _DMX_GET_EVENT:
-
-=============
-DMX_GET_EVENT
-=============
-
-Name
-----
-
-DMX_GET_EVENT
-
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, DMX_GET_EVENT, struct dmx_event *ev)
-    :name: DMX_GET_EVENT
-
-
-Arguments
----------
-
-``fd``
-    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
-
-``ev``
-    Pointer to the location where the event is to be stored.
-
-
-Description
------------
-
-This ioctl call returns an event if available. If an event is not
-available, the behavior depends on whether the device is in blocking or
-non-blocking mode. In the latter case, the call fails immediately with
-errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
-event becomes available.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EWOULDBLOCK``
-
-       -  There is no event pending, and the device is in non-blocking mode.
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
index be98d60877f2..a17289143220 100644
--- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
+++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
@@ -18,7 +18,6 @@ Demux Function Calls
     dmx-set-filter
     dmx-set-pes-filter
     dmx-set-buffer-size
-    dmx-get-event
     dmx-get-stc
     dmx-get-pes-pids
     dmx-add-pid
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index a205c02ccdc1..171205ed86a4 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -166,25 +166,6 @@ struct dmx_pes_filter_params
 	__u32          flags;
     };
 
-
-struct dmx_event
-================
-
-.. c:type:: dmx_event
-
-.. code-block:: c
-
-     struct dmx_event
-     {
-	 dmx_event_t          event;
-	 time_t               timeStamp;
-	 union
-	 {
-	     dmx_scrambling_status_t scrambling;
-	 } u;
-     };
-
-
 struct dmx_stc
 ==============
 
-- 
2.13.5
