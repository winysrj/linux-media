Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcHSU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 4/6] [media] docs-rst: Convert CEC uAPI to use C function references
Date: Fri, 19 Aug 2016 17:27:51 -0300
Message-Id: <a8a7a3b017034ce26e6a5b884e130abb0e9c5608.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name all ioctl references and make them match the ioctls that
are documented. That will improve the cross-reference index,
as it will have all ioctls and syscalls there.

While here, improve the documentation to make them to look more
like the rest of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst           |  3 ++-
 Documentation/media/uapi/cec/cec-func-ioctl.rst           |  5 +++--
 Documentation/media/uapi/cec/cec-func-open.rst            |  1 +
 Documentation/media/uapi/cec/cec-func-poll.rst            | 10 ++++++++++
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst      |  6 ++----
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 12 ++++++------
 Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst | 13 +++++++------
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          |  7 ++-----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           | 13 +++++++------
 Documentation/media/uapi/cec/cec-ioc-receive.rst          | 13 +++++++------
 10 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index c763496b243f..8267c31b317d 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -21,12 +21,13 @@ Synopsis
 
 
 .. c:function:: int close( int fd )
+    :name: cec-close
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <func-open>`.
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 
 Description
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 116132b19515..9e8dbb118d6a 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -20,16 +20,17 @@ Synopsis
 
 
 .. c:function:: int ioctl( int fd, int request, void *argp )
+   :name: cec-ioctl
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <func-open>`.
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``request``
     CEC ioctl request code as defined in the cec.h header file, for
-    example :ref:`CEC_ADAP_G_CAPS`.
+    example :c:func:`CEC_ADAP_G_CAPS`.
 
 ``argp``
     Pointer to a request-specific structure.
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 33e5b5379fa3..af3f5b5c24c6 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -20,6 +20,7 @@ Synopsis
 
 
 .. c:function:: int open( const char *device_name, int flags )
+   :name: cec-open
 
 
 Arguments
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index a5225185f98c..5bacb7c6f33b 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -21,10 +21,20 @@ Synopsis
 
 
 .. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+   :name: cec-poll
 
 Arguments
 =========
 
+``ufds``
+   List of FD events to be watched
+
+``nfds``
+   Number of FD efents at the \*ufds array
+
+``timeout``
+   Timeout to wait for events
+
 
 Description
 ===========
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index cc68e0dcea7e..14d7f6a19455 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -14,7 +14,8 @@ CEC_ADAP_G_CAPS - Query device capabilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_caps *argp )
+.. c:function:: int ioctl( int fd, CEC_ADAP_G_CAPS, struct cec_caps *argp )
+    :name: CEC_ADAP_G_CAPS
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <cec-func-open>`.
 
-``request``
-    CEC_ADAP_G_CAPS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 9de2a005f6fb..1a920109072c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -17,20 +17,20 @@ CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS - Get or set the logical addresses
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
+.. c:function:: int ioctl( int fd, CEC_ADAP_G_LOG_ADDRS, struct cec_log_addrs *argp )
+   :name: CEC_ADAP_G_LOG_ADDRS
 
+.. c:function:: int ioctl( int fd, CEC_ADAP_S_LOG_ADDRS, struct cec_log_addrs *argp )
+   :name: CEC_ADAP_S_LOG_ADDRS
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
-
-``request``
-    CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``argp``
-
+    Pointer to struct cec_log_addrs
 
 Description
 ===========
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 9502d6f25798..3357deb43c85 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -17,19 +17,20 @@ CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR - Get or set the physical address
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u16 *argp )
+.. c:function:: int ioctl( int fd, CEC_ADAP_G_PHYS_ADDR, __u16 *argp )
+    :name: CEC_ADAP_G_PHYS_ADDR
+
+.. c:function:: int ioctl( int fd, CEC_ADAP_S_PHYS_ADDR, __u16 *argp )
+    :name: CEC_ADAP_S_PHYS_ADDR
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
-
-``request``
-    CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``argp``
-
+    Pointer to the CEC address.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index ca9ef597527e..b7f104802045 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -15,8 +15,8 @@ CEC_DQEVENT - Dequeue a CEC event
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_event *argp )
-   :name: CEC_DQEVENT
+.. c:function:: int ioctl( int fd, CEC_DQEVENT, struct cec_event *argp )
+    :name: CEC_DQEVENT
 
 Arguments
 =========
@@ -24,9 +24,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <cec-func-open>`.
 
-``request``
-    CEC_DQEVENT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index a33522267d47..70a41902ab58 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -13,19 +13,20 @@ CEC_G_MODE, CEC_S_MODE - Get or set exclusive use of the CEC adapter
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *argp )
+.. c:function:: int ioctl( int fd, CEC_G_MODE, __u32 *argp )
+   :name: CEC_G_MODE
+
+.. c:function:: int ioctl( int fd, CEC_S_MODE, __u32 *argp )
+   :name: CEC_S_MODE
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
-
-``request``
-    CEC_G_MODE, CEC_S_MODE
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``argp``
-
+    Pointer to CEC mode.
 
 Description
 ===========
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index e31f62a19a3c..7214b1ede34b 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -16,19 +16,20 @@ CEC_RECEIVE, CEC_TRANSMIT - Receive or transmit a CEC message
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_msg *argp )
+.. c:function:: int ioctl( int fd, CEC_RECEIVE, struct cec_msg *argp )
+    :name: CEC_RECEIVE
+
+.. c:function:: int ioctl( int fd, CEC_TRANSMIT, struct cec_msg *argp )
+    :name: CEC_TRANSMIT
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <cec-func-open>`.
-
-``request``
-    CEC_RECEIVE, CEC_TRANSMIT
+    File descriptor returned by :c:func:`open() <cec-open>`.
 
 ``argp``
-
+    Pointer to struct cec_msg.
 
 Description
 ===========
-- 
2.7.4


