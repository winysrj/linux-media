Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbcGHVFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 17:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/4] [media] doc-rst: linux_tc CEC enhanced markup
Date: Fri,  8 Jul 2016 18:05:09 -0300
Message-Id: <21c62694499800f74def88edfbd5dcd91c492b79.1468011909.git.mchehab@s-opensource.com>
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

leaved content unchanged, only improved markup and references

* more man-like sections (add Name section)
* defined target for each stuct field description
* replace constant with ":ref:" to (field) description

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-api.rst           | 11 +--
 Documentation/media/uapi/cec/cec-func-close.rst    | 16 +---
 Documentation/media/uapi/cec/cec-func-ioctl.rst    | 17 +---
 Documentation/media/uapi/cec/cec-func-open.rst     | 26 ++----
 Documentation/media/uapi/cec/cec-func-poll.rst     | 20 ++---
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 41 ++++------
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 87 ++++++++++----------
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    | 31 +++----
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 30 +++----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 95 ++++++++++------------
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 74 ++++++++---------
 11 files changed, 181 insertions(+), 267 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index 2aa0c50e60b3..ffee32e0f906 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -43,7 +43,7 @@ control just the CEC pin.
 
 Drivers that support CEC will create a CEC device node (/dev/cecX) to
 give userspace access to the CEC adapter. The
-:ref:`CEC_ADAP_G_CAPS <cec-ioc-adap-g-caps>` ioctl will tell
+:ref:`CEC_ADAP_G_CAPS` ioctl will tell
 userspace what it is allowed to do.
 
 
@@ -83,12 +83,3 @@ Revision and Copyright
 :revision: 1.0.0 / 2016-03-17 (*hv*)
 
 Initial revision
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index 68e47e2aa068..11f083602792 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -6,9 +6,10 @@
 cec close()
 ***********
 
-*man cec-close(2)*
+Name
+====
 
-Close a cec device
+cec-close - Close a cec device
 
 
 Synopsis
@@ -19,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. c:function:: int close( int fd )
+.. cpp:function:: int close( int fd )
 
 Arguments
 =========
@@ -46,12 +47,3 @@ Return Value
 
 EBADF
     ``fd`` is not a valid open file descriptor.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 9d37591e3ef4..69510ac5088a 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -6,10 +6,10 @@
 cec ioctl()
 ***********
 
-*man cec-ioctl(2)*
-
-Control a cec device
+Name
+====
 
+cec-ioctl - Control a cec device
 
 Synopsis
 ========
@@ -19,7 +19,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. c:function:: int ioctl( int fd, int request, void *argp )
+.. cpp:function:: int ioctl( int fd, int request, void *argp )
 
 Arguments
 =========
@@ -66,12 +66,3 @@ descriptions.
 
 When an ioctl that takes an output or read/write parameter fails, the
 parameter remains unmodified.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 4691194ee795..53ffc091e2c0 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -6,10 +6,10 @@
 cec open()
 **********
 
-*man cec-open(2)*
-
-Open a cec device
+Name
+====
 
+cec-open - Open a cec device
 
 Synopsis
 ========
@@ -19,7 +19,8 @@ Synopsis
     #include <fcntl.h>
 
 
-.. c:function:: int open( const char *device_name, int flags )
+.. cpp:function:: int open( const char *device_name, int flags )
+
 
 Arguments
 =========
@@ -31,11 +32,11 @@ Arguments
     Open flags. Access mode must be ``O_RDWR``.
 
     When the ``O_NONBLOCK`` flag is given, the
-    :ref:`CEC_RECEIVE <cec-ioc-receive>` ioctl will return EAGAIN
+    :ref:`CEC_RECEIVE` ioctl will return EAGAIN
     error code when no message is available, and the
-    :ref:`CEC_TRANSMIT <cec-ioc-receive>`,
-    :ref:`CEC_ADAP_S_PHYS_ADDR <cec-ioc-adap-g-phys-addr>` and
-    :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>` ioctls
+    :ref:`CEC_TRANSMIT`,
+    :ref:`CEC_ADAP_S_PHYS_ADDR` and
+    :ref:`CEC_ADAP_S_LOG_ADDRS` ioctls
     all act in non-blocking mode.
 
     Other flags have no effect.
@@ -77,12 +78,3 @@ ENOMEM
 
 ENXIO
     No device corresponding to this device special file exists.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index ee559217c4f1..ff5175fbf62f 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -6,9 +6,10 @@
 cec poll()
 **********
 
-*man cec-poll(2)*
+Name
+====
 
-Wait for some event on a file descriptor
+cec-poll - Wait for some event on a file descriptor
 
 
 Synopsis
@@ -19,7 +20,11 @@ Synopsis
     #include <sys/poll.h>
 
 
-.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+.. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+
+Arguments
+=========
+
 
 Description
 ===========
@@ -63,12 +68,3 @@ EINTR
 
 EINVAL
     The ``nfds`` argument is greater than ``OPEN_MAX``.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index e5441eca6f75..4544b6f86ae0 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -1,20 +1,20 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-adap-g-caps:
+.. _CEC_ADAP_G_CAPS:
 
 *********************
 ioctl CEC_ADAP_G_CAPS
 *********************
 
-*man CEC_ADAP_G_CAPS(2)*
-
-Query device capabilities
+Name
+====
 
+CEC_ADAP_G_CAPS - Query device capabilities
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_caps *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct cec_caps *argp )
 
 Arguments
 =========
@@ -34,7 +34,7 @@ Description
 Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
-All cec devices must support the ``CEC_ADAP_G_CAPS`` ioctl. To query
+All cec devices must support the :ref:`CEC_ADAP_G_CAPS` ioctl. To query
 device information, applications call the ioctl with a pointer to a
 struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
 returns the information to the application. The ioctl never fails.
@@ -93,52 +93,52 @@ returns the information to the application. The ioctl never fails.
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_CAP_PHYS_ADDR`:
 
        -  ``CEC_CAP_PHYS_ADDR``
 
        -  0x00000001
 
        -  Userspace has to configure the physical address by calling
-          :ref:`CEC_ADAP_S_PHYS_ADDR <cec-ioc-adap-g-phys-addr>`. If
+          :ref:`CEC_ADAP_S_PHYS_ADDR`. If
           this capability isn't set, then setting the physical address is
           handled by the kernel whenever the EDID is set (for an HDMI
           receiver) or read (for an HDMI transmitter).
 
-    -  .. row 2
+    -  .. _`CEC_CAP_LOG_ADDRS`:
 
        -  ``CEC_CAP_LOG_ADDRS``
 
        -  0x00000002
 
        -  Userspace has to configure the logical addresses by calling
-          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`. If
+          :ref:`CEC_ADAP_S_LOG_ADDRS`. If
           this capability isn't set, then the kernel will have configured
           this.
 
-    -  .. row 3
+    -  .. _`CEC_CAP_TRANSMIT`:
 
        -  ``CEC_CAP_TRANSMIT``
 
        -  0x00000004
 
        -  Userspace can transmit CEC messages by calling
-          :ref:`CEC_TRANSMIT <cec-ioc-receive>`. This implies that
+          :ref:`CEC_TRANSMIT`. This implies that
           userspace can be a follower as well, since being able to transmit
           messages is a prerequisite of becoming a follower. If this
           capability isn't set, then the kernel will handle all CEC
           transmits and process all CEC messages it receives.
 
-    -  .. row 4
+    -  .. _`CEC_CAP_PASSTHROUGH`:
 
        -  ``CEC_CAP_PASSTHROUGH``
 
        -  0x00000008
 
        -  Userspace can use the passthrough mode by calling
-          :ref:`CEC_S_MODE <cec-ioc-g-mode>`.
+          :ref:`CEC_S_MODE`.
 
-    -  .. row 5
+    -  .. _`CEC_CAP_RC`:
 
        -  ``CEC_CAP_RC``
 
@@ -146,7 +146,7 @@ returns the information to the application. The ioctl never fails.
 
        -  This adapter supports the remote control protocol.
 
-    -  .. row 6
+    -  .. _`CEC_CAP_MONITOR_ALL`:
 
        -  ``CEC_CAP_MONITOR_ALL``
 
@@ -163,12 +163,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 70fd5b96ecc1..f6c294fe119e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -1,21 +1,24 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-adap-g-log-addrs:
+.. _CEC_ADAP_LOG_ADDRS:
+.. _CEC_ADAP_G_LOG_ADDRS:
+.. _CEC_ADAP_S_LOG_ADDRS:
 
 ************************************************
 ioctl CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS
 ************************************************
 
-*man CEC_ADAP_G_LOG_ADDRS(2)*
+Name
+====
 
-CEC_ADAP_S_LOG_ADDRS
-Get or set the logical addresses
+CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS - Get or set the logical addresses
 
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
+
 
 Arguments
 =========
@@ -36,18 +39,18 @@ Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
 To query the current CEC logical addresses, applications call the
-``CEC_ADAP_G_LOG_ADDRS`` ioctl with a pointer to a
+:ref:`CEC_ADAP_G_LOG_ADDRS` ioctl with a pointer to a
 :c:type:`struct cec_log_addrs` structure where the drivers stores
 the logical addresses.
 
 To set new logical addresses, applications fill in struct
-:c:type:`struct cec_log_addrs` and call the ``CEC_ADAP_S_LOG_ADDRS``
-ioctl with a pointer to this struct. The ``CEC_ADAP_S_LOG_ADDRS`` ioctl
+:c:type:`struct cec_log_addrs` and call the :ref:`CEC_ADAP_S_LOG_ADDRS`
+ioctl with a pointer to this struct. The :ref:`CEC_ADAP_S_LOG_ADDRS` ioctl
 is only available if ``CEC_CAP_LOG_ADDRS`` is set (ENOTTY error code is
 returned otherwise). This ioctl will block until all requested logical
-addresses have been claimed. ``CEC_ADAP_S_LOG_ADDRS`` can only be called
+addresses have been claimed. :ref:`CEC_ADAP_S_LOG_ADDRS` can only be called
 by a file handle in initiator mode (see
-:ref:`CEC_S_MODE <cec-ioc-g-mode>`).
+:ref:`CEC_S_MODE`).
 
 
 .. _cec-log-addrs:
@@ -90,7 +93,7 @@ by a file handle in initiator mode (see
        -  The CEC version that this adapter shall use. See
           :ref:`cec-versions`. Used to implement the
           ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
-          Note that ``CEC_OP_CEC_VERSION_1_3A`` is not allowed by the CEC
+          Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC_OP_CEC_VERSION_1_3A>` is not allowed by the CEC
           framework.
 
     -  .. row 4
@@ -101,7 +104,7 @@ by a file handle in initiator mode (see
 
        -  Number of logical addresses to set up. Must be ≤
           ``available_log_addrs`` as returned by
-          :ref:`CEC_ADAP_G_CAPS <cec-ioc-adap-g-caps>`. All arrays in
+          :ref:`CEC_ADAP_G_CAPS`. All arrays in
           this structure are only filled up to index
           ``available_log_addrs``-1. The remaining array elements will be
           ignored. Note that the CEC 2.0 standard allows for a maximum of 2
@@ -158,7 +161,7 @@ by a file handle in initiator mode (see
        -  Logical address types. See :ref:`cec-log-addr-types` for
           possible types. The driver will update this with the actual
           logical address type that it claimed (e.g. it may have to fallback
-          to ``CEC_LOG_ADDR_TYPE_UNREGISTERED``).
+          to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC_LOG_ADDR_TYPE_UNREGISTERED>`).
 
     -  .. row 10
 
@@ -169,7 +172,7 @@ by a file handle in initiator mode (see
        -  CEC 2.0 specific: all device types. See
           :ref:`cec-all-dev-types-flags`. Used to implement the
           ``CEC_MSG_REPORT_FEATURES`` message. This field is ignored if
-          ``cec_version`` < ``CEC_OP_CEC_VERSION_2_0``.
+          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC_OP_CEC_VERSION_2_0>`.
 
     -  .. row 11
 
@@ -180,7 +183,7 @@ by a file handle in initiator mode (see
        -  Features for each logical address. Used to implement the
           ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
           RC Profile and the Device Features. This field is ignored if
-          ``cec_version`` < ``CEC_OP_CEC_VERSION_2_0``.
+          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC_OP_CEC_VERSION_2_0>`.
 
 
 
@@ -192,7 +195,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_OP_CEC_VERSION_1_3A`:
 
        -  ``CEC_OP_CEC_VERSION_1_3A``
 
@@ -200,7 +203,7 @@ by a file handle in initiator mode (see
 
        -  CEC version according to the HDMI 1.3a standard.
 
-    -  .. row 2
+    -  .. _`CEC_OP_CEC_VERSION_1_4B`:
 
        -  ``CEC_OP_CEC_VERSION_1_4B``
 
@@ -208,7 +211,7 @@ by a file handle in initiator mode (see
 
        -  CEC version according to the HDMI 1.4b standard.
 
-    -  .. row 3
+    -  .. _`CEC_OP_CEC_VERSION_2_0`:
 
        -  ``CEC_OP_CEC_VERSION_2_0``
 
@@ -226,7 +229,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_OP_PRIM_DEVTYPE_TV`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_TV``
 
@@ -234,7 +237,7 @@ by a file handle in initiator mode (see
 
        -  Use for a TV.
 
-    -  .. row 2
+    -  .. _`CEC_OP_PRIM_DEVTYPE_RECORD`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_RECORD``
 
@@ -242,7 +245,7 @@ by a file handle in initiator mode (see
 
        -  Use for a recording device.
 
-    -  .. row 3
+    -  .. _`CEC_OP_PRIM_DEVTYPE_TUNER`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_TUNER``
 
@@ -250,7 +253,7 @@ by a file handle in initiator mode (see
 
        -  Use for a device with a tuner.
 
-    -  .. row 4
+    -  .. _`CEC_OP_PRIM_DEVTYPE_PLAYBACK`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
 
@@ -258,7 +261,7 @@ by a file handle in initiator mode (see
 
        -  Use for a playback device.
 
-    -  .. row 5
+    -  .. _`CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
 
@@ -266,7 +269,7 @@ by a file handle in initiator mode (see
 
        -  Use for an audio system (e.g. an audio/video receiver).
 
-    -  .. row 6
+    -  .. _`CEC_OP_PRIM_DEVTYPE_SWITCH`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_SWITCH``
 
@@ -274,7 +277,7 @@ by a file handle in initiator mode (see
 
        -  Use for a CEC switch.
 
-    -  .. row 7
+    -  .. _`CEC_OP_PRIM_DEVTYPE_VIDEOPROC`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
 
@@ -292,7 +295,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_LOG_ADDR_TYPE_TV`:
 
        -  ``CEC_LOG_ADDR_TYPE_TV``
 
@@ -300,7 +303,7 @@ by a file handle in initiator mode (see
 
        -  Use for a TV.
 
-    -  .. row 2
+    -  .. _`CEC_LOG_ADDR_TYPE_RECORD`:
 
        -  ``CEC_LOG_ADDR_TYPE_RECORD``
 
@@ -308,7 +311,7 @@ by a file handle in initiator mode (see
 
        -  Use for a recording device.
 
-    -  .. row 3
+    -  .. _`CEC_LOG_ADDR_TYPE_TUNER`:
 
        -  ``CEC_LOG_ADDR_TYPE_TUNER``
 
@@ -316,7 +319,7 @@ by a file handle in initiator mode (see
 
        -  Use for a tuner device.
 
-    -  .. row 4
+    -  .. _`CEC_LOG_ADDR_TYPE_PLAYBACK`:
 
        -  ``CEC_LOG_ADDR_TYPE_PLAYBACK``
 
@@ -324,7 +327,7 @@ by a file handle in initiator mode (see
 
        -  Use for a playback device.
 
-    -  .. row 5
+    -  .. _`CEC_LOG_ADDR_TYPE_AUDIOSYSTEM`:
 
        -  ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
 
@@ -332,7 +335,7 @@ by a file handle in initiator mode (see
 
        -  Use for an audio system device.
 
-    -  .. row 6
+    -  .. _`CEC_LOG_ADDR_TYPE_SPECIFIC`:
 
        -  ``CEC_LOG_ADDR_TYPE_SPECIFIC``
 
@@ -340,7 +343,7 @@ by a file handle in initiator mode (see
 
        -  Use for a second TV or for a video processor device.
 
-    -  .. row 7
+    -  .. _`CEC_LOG_ADDR_TYPE_UNREGISTERED`:
 
        -  ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
 
@@ -360,7 +363,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_OP_ALL_DEVTYPE_TV`:
 
        -  ``CEC_OP_ALL_DEVTYPE_TV``
 
@@ -368,7 +371,7 @@ by a file handle in initiator mode (see
 
        -  This supports the TV type.
 
-    -  .. row 2
+    -  .. _`CEC_OP_ALL_DEVTYPE_RECORD`:
 
        -  ``CEC_OP_ALL_DEVTYPE_RECORD``
 
@@ -376,7 +379,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Recording type.
 
-    -  .. row 3
+    -  .. _`CEC_OP_ALL_DEVTYPE_TUNER`:
 
        -  ``CEC_OP_ALL_DEVTYPE_TUNER``
 
@@ -384,7 +387,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Tuner type.
 
-    -  .. row 4
+    -  .. _`CEC_OP_ALL_DEVTYPE_PLAYBACK`:
 
        -  ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
 
@@ -392,7 +395,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Playback type.
 
-    -  .. row 5
+    -  .. _`CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM`:
 
        -  ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
 
@@ -400,7 +403,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Audio System type.
 
-    -  .. row 6
+    -  .. _`CEC_OP_ALL_DEVTYPE_SWITCH`:
 
        -  ``CEC_OP_ALL_DEVTYPE_SWITCH``
 
@@ -417,11 +420,3 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index e6a34d9afd13..40e0baaa1630 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -1,21 +1,23 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-adap-g-phys-addr:
+.. _CEC_ADAP_PHYS_ADDR:
+.. _CEC_ADAP_G_PHYS_ADDR:
+.. _CEC_ADAP_S_PHYS_ADDR:
 
 ************************************************
 ioctl CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR
 ************************************************
 
-*man CEC_ADAP_G_PHYS_ADDR(2)*
+Name
+====
 
-CEC_ADAP_S_PHYS_ADDR
-Get or set the physical address
+CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR - Get or set the physical address
 
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u16 *argp )
+.. cpp:function:: int ioctl( int fd, int request, __u16 *argp )
 
 Arguments
 =========
@@ -36,15 +38,15 @@ Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
 To query the current physical address applications call the
-``CEC_ADAP_G_PHYS_ADDR`` ioctl with a pointer to an __u16 where the
+:ref:`CEC_ADAP_G_PHYS_ADDR` ioctl with a pointer to an __u16 where the
 driver stores the physical address.
 
 To set a new physical address applications store the physical address in
-an __u16 and call the ``CEC_ADAP_S_PHYS_ADDR`` ioctl with a pointer to
-this integer. ``CEC_ADAP_S_PHYS_ADDR`` is only available if
+an __u16 and call the :ref:`CEC_ADAP_S_PHYS_ADDR` ioctl with a pointer to
+this integer. :ref:`CEC_ADAP_S_PHYS_ADDR` is only available if
 ``CEC_CAP_PHYS_ADDR`` is set (ENOTTY error code will be returned
-otherwise). ``CEC_ADAP_S_PHYS_ADDR`` can only be called by a file handle
-in initiator mode (see :ref:`CEC_S_MODE <cec-ioc-g-mode>`), if not
+otherwise). :ref:`CEC_ADAP_S_PHYS_ADDR` can only be called by a file handle
+in initiator mode (see :ref:`CEC_S_MODE`), if not
 EBUSY error code will be returned.
 
 The physical address is a 16-bit number where each group of 4 bits
@@ -67,12 +69,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 832627bb0a90..79f779a9bd6c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -1,20 +1,21 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-g-event:
+.. _CEC_DQEVENT:
 
 *****************
 ioctl CEC_DQEVENT
 *****************
 
-*man CEC_DQEVENT(2)*
+Name
+====
 
-Dequeue a CEC event
+CEC_DQEVENT - Dequeue a CEC event
 
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_event *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct cec_event *argp )
 
 Arguments
 =========
@@ -35,7 +36,7 @@ Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
 CEC devices can send asynchronous events. These can be retrieved by
-calling the ``CEC_DQEVENT`` ioctl. If the file descriptor is in
+calling the :ref:`CEC_DQEVENT` ioctl. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
 set errno to the EAGAIN error code.
 
@@ -155,7 +156,7 @@ state did change in between the two events.
 
        -  ``state_change``
 
-       -  The new adapter state as sent by the ``CEC_EVENT_STATE_CHANGE``
+       -  The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC_EVENT_STATE_CHANGE>`
           event.
 
     -  .. row 6
@@ -165,7 +166,7 @@ state did change in between the two events.
 
        -  ``lost_msgs``
 
-       -  The number of lost messages as sent by the ``CEC_EVENT_LOST_MSGS``
+       -  The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC_EVENT_LOST_MSGS>`
           event.
 
 
@@ -178,7 +179,7 @@ state did change in between the two events.
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _CEC_EVENT_STATE_CHANGE:
 
        -  ``CEC_EVENT_STATE_CHANGE``
 
@@ -188,7 +189,7 @@ state did change in between the two events.
           called an initial event will be generated for that filehandle with
           the CEC Adapter's state at that time.
 
-    -  .. row 2
+    -  .. _CEC_EVENT_LOST_MSGS:
 
        -  ``CEC_EVENT_LOST_MSGS``
 
@@ -207,7 +208,7 @@ state did change in between the two events.
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _CEC_EVENT_FL_INITIAL_VALUE:
 
        -  ``CEC_EVENT_FL_INITIAL_VALUE``
 
@@ -226,12 +227,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index f38c28755d8f..c92f0be46907 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -1,21 +1,19 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-g-mode:
+.. _CEC_MODE:
+.. _CEC_G_MODE:
+.. _CEC_S_MODE:
 
 ****************************
 ioctl CEC_G_MODE, CEC_S_MODE
 ****************************
 
-*man CEC_G_MODE(2)*
-
-CEC_S_MODE
-Get or set exclusive use of the CEC adapter
-
+CEC_G_MODE, CEC_S_MODE - Get or set exclusive use of the CEC adapter
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *argp )
+.. cpp:function:: int ioctl( int fd, int request, __u32 *argp )
 
 Arguments
 =========
@@ -36,8 +34,8 @@ Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
 By default any filehandle can use
-:ref:`CEC_TRANSMIT <cec-ioc-receive>` and
-:ref:`CEC_RECEIVE <cec-ioc-receive>`, but in order to prevent
+:ref:`CEC_TRANSMIT` and
+:ref:`CEC_RECEIVE`, but in order to prevent
 applications from stepping on each others toes it must be possible to
 obtain exclusive access to the CEC adapter. This ioctl sets the
 filehandle to initiator and/or follower mode which can be exclusive
@@ -56,7 +54,7 @@ If the message is not a reply, then the CEC framework will process it
 first. If there is no follower, then the message is just discarded and a
 feature abort is sent back to the initiator if the framework couldn't
 process it. If there is a follower, then the message is passed on to the
-follower who will use :ref:`CEC_RECEIVE <cec-ioc-receive>` to dequeue
+follower who will use :ref:`CEC_RECEIVE` to dequeue
 the new message. The framework expects the follower to make the right
 decisions.
 
@@ -68,10 +66,10 @@ There are some messages that the core will always process, regardless of
 the passthrough mode. See :ref:`cec-core-processing` for details.
 
 If there is no initiator, then any CEC filehandle can use
-:ref:`CEC_TRANSMIT <cec-ioc-receive>`. If there is an exclusive
+:ref:`CEC_TRANSMIT`. If there is an exclusive
 initiator then only that initiator can call
-:ref:`CEC_TRANSMIT <cec-ioc-receive>`. The follower can of course
-always call :ref:`CEC_TRANSMIT <cec-ioc-receive>`.
+:ref:`CEC_TRANSMIT`. The follower can of course
+always call :ref:`CEC_TRANSMIT`.
 
 Available initiator modes are:
 
@@ -84,7 +82,7 @@ Available initiator modes are:
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_MODE_NO_INITIATOR`:
 
        -  ``CEC_MODE_NO_INITIATOR``
 
@@ -93,7 +91,7 @@ Available initiator modes are:
        -  This is not an initiator, i.e. it cannot transmit CEC messages or
           make any other changes to the CEC adapter.
 
-    -  .. row 2
+    -  .. _`CEC_MODE_INITIATOR`:
 
        -  ``CEC_MODE_INITIATOR``
 
@@ -103,7 +101,7 @@ Available initiator modes are:
           it can transmit CEC messages and make changes to the CEC adapter,
           unless there is an exclusive initiator.
 
-    -  .. row 3
+    -  .. _`CEC_MODE_EXCL_INITIATOR`:
 
        -  ``CEC_MODE_EXCL_INITIATOR``
 
@@ -127,7 +125,7 @@ Available follower modes are:
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_MODE_NO_FOLLOWER`:
 
        -  ``CEC_MODE_NO_FOLLOWER``
 
@@ -135,7 +133,7 @@ Available follower modes are:
 
        -  This is not a follower (the default when the device is opened).
 
-    -  .. row 2
+    -  .. _`CEC_MODE_FOLLOWER`:
 
        -  ``CEC_MODE_FOLLOWER``
 
@@ -143,10 +141,10 @@ Available follower modes are:
 
        -  This is a follower and it will receive CEC messages unless there
           is an exclusive follower. You cannot become a follower if
-          ``CEC_CAP_TRANSMIT`` is not set or if ``CEC_MODE_NO_INITIATOR``
+          :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`
           was specified, EINVAL error code is returned in that case.
 
-    -  .. row 3
+    -  .. _`CEC_MODE_EXCL_FOLLOWER`:
 
        -  ``CEC_MODE_EXCL_FOLLOWER``
 
@@ -156,10 +154,10 @@ Available follower modes are:
           receive CEC messages for processing. If someone else is already
           the exclusive follower then an attempt to become one will return
           the EBUSY error code error. You cannot become a follower if
-          ``CEC_CAP_TRANSMIT`` is not set or if ``CEC_MODE_NO_INITIATOR``
+          :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`
           was specified, EINVAL error code is returned in that case.
 
-    -  .. row 4
+    -  .. _`CEC_MODE_EXCL_FOLLOWER_PASSTHRU`:
 
        -  ``CEC_MODE_EXCL_FOLLOWER_PASSTHRU``
 
@@ -171,18 +169,18 @@ Available follower modes are:
           to handle most core messages instead of relying on the CEC
           framework for that. If someone else is already the exclusive
           follower then an attempt to become one will return the EBUSY error
-          code error. You cannot become a follower if ``CEC_CAP_TRANSMIT``
-          is not set or if ``CEC_MODE_NO_INITIATOR`` was specified, EINVAL
+          code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>`
+          is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>` was specified, EINVAL
           error code is returned in that case.
 
-    -  .. row 5
+    -  .. _`CEC_MODE_MONITOR`:
 
        -  ``CEC_MODE_MONITOR``
 
        -  0xe0
 
        -  Put the file descriptor into monitor mode. Can only be used in
-          combination with ``CEC_MODE_NO_INITIATOR``, otherwise EINVAL error
+          combination with :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`, otherwise EINVAL error
           code will be returned. In monitor mode all messages this CEC
           device transmits and all messages it receives (both broadcast
           messages and directed messages for one its logical addresses) will
@@ -190,19 +188,19 @@ Available follower modes are:
           allowed if the process has the ``CAP_NET_ADMIN`` capability. If
           that is not set, then EPERM error code is returned.
 
-    -  .. row 6
+    -  .. _`CEC_MODE_MONITOR_ALL`:
 
        -  ``CEC_MODE_MONITOR_ALL``
 
        -  0xf0
 
        -  Put the file descriptor into 'monitor all' mode. Can only be used
-          in combination with ``CEC_MODE_NO_INITIATOR``, otherwise EINVAL
+          in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`, otherwise EINVAL
           error code will be returned. In 'monitor all' mode all messages
           this CEC device transmits and all messages it receives, including
           directed messages for other CEC devices will be reported. This is
           very useful for debugging, but not all devices support this. This
-          mode requires that the ``CEC_CAP_MONITOR_ALL`` capability is set,
+          mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC_CAP_MONITOR_ALL>` capability is set,
           otherwise EINVAL error code is returned. This is only allowed if
           the process has the ``CAP_NET_ADMIN`` capability. If that is not
           set, then EPERM error code is returned.
@@ -218,25 +216,25 @@ Core message processing details:
     :stub-columns: 0
 
 
-    -  .. row 1
+    -  .. _`CEC_MSG_GET_CEC_VERSION`:
 
        -  ``CEC_MSG_GET_CEC_VERSION``
 
        -  When in passthrough mode this message has to be handled by
           userspace, otherwise the core will return the CEC version that was
           set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+          :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. row 2
+    -  .. _`CEC_MSG_GIVE_DEVICE_VENDOR_ID`:
 
        -  ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
 
        -  When in passthrough mode this message has to be handled by
           userspace, otherwise the core will return the vendor ID that was
           set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+          :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. row 3
+    -  .. _`CEC_MSG_ABORT`:
 
        -  ``CEC_MSG_ABORT``
 
@@ -244,7 +242,7 @@ Core message processing details:
           userspace, otherwise the core will return a feature refused
           message as per the specification.
 
-    -  .. row 4
+    -  .. _`CEC_MSG_GIVE_PHYSICAL_ADDR`:
 
        -  ``CEC_MSG_GIVE_PHYSICAL_ADDR``
 
@@ -252,40 +250,40 @@ Core message processing details:
           userspace, otherwise the core will report the current physical
           address.
 
-    -  .. row 5
+    -  .. _`CEC_MSG_GIVE_OSD_NAME`:
 
        -  ``CEC_MSG_GIVE_OSD_NAME``
 
        -  When in passthrough mode this message has to be handled by
           userspace, otherwise the core will report the current OSD name as
           was set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+          :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. row 6
+    -  .. _`CEC_MSG_GIVE_FEATURES`:
 
        -  ``CEC_MSG_GIVE_FEATURES``
 
        -  When in passthrough mode this message has to be handled by
           userspace, otherwise the core will report the current features as
           was set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>` or
+          :ref:`CEC_ADAP_S_LOG_ADDRS` or
           the message is ignore if the CEC version was older than 2.0.
 
-    -  .. row 7
+    -  .. _`CEC_MSG_USER_CONTROL_PRESSED`:
 
        -  ``CEC_MSG_USER_CONTROL_PRESSED``
 
-       -  If ``CEC_CAP_RC`` is set, then generate a remote control key
+       -  If :ref:`CEC_CAP_RC <CEC_CAP_RC>` is set, then generate a remote control key
           press. This message is always passed on to userspace.
 
-    -  .. row 8
+    -  .. _`CEC_MSG_USER_CONTROL_RELEASED`:
 
        -  ``CEC_MSG_USER_CONTROL_RELEASED``
 
-       -  If ``CEC_CAP_RC`` is set, then generate a remote control key
+       -  If :ref:`CEC_CAP_RC <CEC_CAP_RC>` is set, then generate a remote control key
           release. This message is always passed on to userspace.
 
-    -  .. row 9
+    -  .. _`CEC_MSG_REPORT_PHYSICAL_ADDR`:
 
        -  ``CEC_MSG_REPORT_PHYSICAL_ADDR``
 
@@ -300,12 +298,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 5b303a1e6691..5a345ff446a7 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -1,21 +1,22 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _cec-ioc-receive:
+.. _CEC_TRANSMIT:
+.. _CEC_RECEIVE:
 
 *******************************
 ioctl CEC_RECEIVE, CEC_TRANSMIT
 *******************************
 
-*man CEC_RECEIVE(2)*
+Name
+====
 
-CEC_TRANSMIT
-Receive or transmit a CEC message
+CEC_RECEIVE, CEC_TRANSMIT - Receive or transmit a CEC message
 
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct cec_msg *argp )
+.. cpp:function:: int ioctl( int fd, int request, struct cec_msg *argp )
 
 Arguments
 =========
@@ -36,8 +37,8 @@ Note: this documents the proposed CEC API. This API is not yet finalized
 and is currently only available as a staging kernel module.
 
 To receive a CEC message the application has to fill in the
-:c:type:`struct cec_msg` structure and pass it to the ``CEC_RECEIVE``
-ioctl. ``CEC_RECEIVE`` is only available if ``CEC_CAP_RECEIVE`` is set.
+:c:type:`struct cec_msg` structure and pass it to the :ref:`CEC_RECEIVE`
+ioctl. :ref:`CEC_RECEIVE` is only available if ``CEC_CAP_RECEIVE`` is set.
 If the file descriptor is in non-blocking mode and there are no received
 messages pending, then it will return -1 and set errno to the EAGAIN
 error code. If the file descriptor is in blocking mode and ``timeout``
@@ -46,7 +47,7 @@ it will return -1 and set errno to the ETIMEDOUT error code.
 
 To send a CEC message the application has to fill in the
 :c:type:`struct cec_msg` structure and pass it to the
-``CEC_TRANSMIT`` ioctl. ``CEC_TRANSMIT`` is only available if
+:ref:`CEC_TRANSMIT` ioctl. :ref:`CEC_TRANSMIT` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
 queue, then it will return -1 and set errno to the EBUSY error code.
 
@@ -66,7 +67,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``ts``
 
        -  Timestamp of when the message was transmitted in ns in the case of
-          ``CEC_TRANSMIT`` with ``reply`` set to 0, or the timestamp of the
+          :ref:`CEC_TRANSMIT` with ``reply`` set to 0, or the timestamp of the
           received message in all other cases.
 
     -  .. row 2
@@ -75,9 +76,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  ``len``
 
-       -  The length of the message. For ``CEC_TRANSMIT`` this is filled in
+       -  The length of the message. For :ref:`CEC_TRANSMIT` this is filled in
           by the application. The driver will fill this in for
-          ``CEC_RECEIVE`` and for ``CEC_TRANSMIT`` it will be filled in with
+          :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
           the length of the reply message if ``reply`` was set.
 
     -  .. row 3
@@ -89,7 +90,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  The timeout in milliseconds. This is the time the device will wait
           for a message to be received before timing out. If it is set to 0,
           then it will wait indefinitely when it is called by
-          ``CEC_RECEIVE``. If it is 0 and it is called by ``CEC_TRANSMIT``,
+          :ref:`CEC_RECEIVE`. If it is 0 and it is called by :ref:`CEC_TRANSMIT`,
           then it will be replaced by 1000 if the ``reply`` is non-zero or
           ignored if ``reply`` is 0.
 
@@ -140,9 +141,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  ``msg``\ [16]
 
-       -  The message payload. For ``CEC_TRANSMIT`` this is filled in by the
-          application. The driver will fill this in for ``CEC_RECEIVE`` and
-          for ``CEC_TRANSMIT`` it will be filled in with the payload of the
+       -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
+          application. The driver will fill this in for :ref:`CEC_RECEIVE` and
+          for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
           reply message if ``reply`` was set.
 
     -  .. row 9
@@ -155,12 +156,12 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           ``timeout`` is 0, then don't wait for a reply but return after
           transmitting the message. If there was an error as indicated by a
           non-zero ``tx_status`` field, then ``reply`` and ``timeout`` are
-          both set to 0 by the driver. Ignored by ``CEC_RECEIVE``. The case
+          both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
           where ``reply`` is 0 (this is the opcode for the Feature Abort
           message) and ``timeout`` is non-zero is specifically allowed to
           send a message and wait up to ``timeout`` milliseconds for a
           Feature Abort reply. In this case ``rx_status`` will either be set
-          to ``CEC_RX_STATUS_TIMEOUT`` or ``CEC_RX_STATUS_FEATURE_ABORT``.
+          to :ref:`CEC_RX_STATUS_TIMEOUT <CEC_RX_STATUS_TIMEOUT>` or :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC_RX_STATUS_FEATURE_ABORT>`.
 
     -  .. row 10
 
@@ -171,7 +172,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Arbitration Lost error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          ``CEC_TX_STATUS_ARB_LOST`` status bit is set.
+          :ref:`CEC_TX_STATUS_ARB_LOST <CEC_TX_STATUS_ARB_LOST>` status bit is set.
 
     -  .. row 11
 
@@ -182,7 +183,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Not Acknowledged error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          ``CEC_TX_STATUS_NACK`` status bit is set.
+          :ref:`CEC_TX_STATUS_NACK <CEC_TX_STATUS_NACK>` status bit is set.
 
     -  .. row 12
 
@@ -193,7 +194,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Arbitration Lost error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          ``CEC_TX_STATUS_LOW_DRIVE`` status bit is set.
+          :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC_TX_STATUS_LOW_DRIVE>` status bit is set.
 
     -  .. row 13
 
@@ -204,7 +205,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit errors other than Arbitration
           Lost or Not Acknowledged. This is only set if the hardware
           supports this, otherwise it is always 0. This counter is only
-          valid if the ``CEC_TX_STATUS_ERROR`` status bit is set.
+          valid if the :ref:`CEC_TX_STATUS_ERROR <CEC_TX_STATUS_ERROR>` status bit is set.
 
 
 
@@ -216,18 +217,18 @@ queue, then it will return -1 and set errno to the EBUSY error code.
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_TX_STATUS_OK`:
 
        -  ``CEC_TX_STATUS_OK``
 
        -  0x01
 
        -  The message was transmitted successfully. This is mutually
-          exclusive with ``CEC_TX_STATUS_MAX_RETRIES``. Other bits can still
+          exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC_TX_STATUS_MAX_RETRIES>`. Other bits can still
           be set if earlier attempts met with failure before the transmit
           was eventually successful.
 
-    -  .. row 2
+    -  .. _`CEC_TX_STATUS_ARB_LOST`:
 
        -  ``CEC_TX_STATUS_ARB_LOST``
 
@@ -235,7 +236,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  CEC line arbitration was lost.
 
-    -  .. row 3
+    -  .. _`CEC_TX_STATUS_NACK`:
 
        -  ``CEC_TX_STATUS_NACK``
 
@@ -243,7 +244,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  Message was not acknowledged.
 
-    -  .. row 4
+    -  .. _`CEC_TX_STATUS_LOW_DRIVE`:
 
        -  ``CEC_TX_STATUS_LOW_DRIVE``
 
@@ -253,7 +254,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           follower detected an error on the bus and requests a
           retransmission.
 
-    -  .. row 5
+    -  .. _`CEC_TX_STATUS_ERROR`:
 
        -  ``CEC_TX_STATUS_ERROR``
 
@@ -264,14 +265,14 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           error occurred, or because the hardware tested for other
           conditions besides those two.
 
-    -  .. row 6
+    -  .. _`CEC_TX_STATUS_MAX_RETRIES`:
 
        -  ``CEC_TX_STATUS_MAX_RETRIES``
 
        -  0x20
 
        -  The transmit failed after one or more retries. This status bit is
-          mutually exclusive with ``CEC_TX_STATUS_OK``. Other bits can still
+          mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC_TX_STATUS_OK>`. Other bits can still
           be set to explain which failures were seen.
 
 
@@ -284,7 +285,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
     :widths:       3 1 4
 
 
-    -  .. row 1
+    -  .. _`CEC_RX_STATUS_OK`:
 
        -  ``CEC_RX_STATUS_OK``
 
@@ -292,7 +293,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  The message was received successfully.
 
-    -  .. row 2
+    -  .. _CEC_RX_STATUS_TIMEOUT:
 
        -  ``CEC_RX_STATUS_TIMEOUT``
 
@@ -300,7 +301,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  The reply to an earlier transmitted message timed out.
 
-    -  .. row 3
+    -  .. _`CEC_RX_STATUS_FEATURE_ABORT`:
 
        -  ``CEC_RX_STATUS_FEATURE_ABORT``
 
@@ -318,12 +319,3 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
-- 
2.7.4

