Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbcGHVFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 17:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] [media] doc-dst: visually improve the CEC pages
Date: Fri,  8 Jul 2016 18:05:10 -0300
Message-Id: <b2a584367e8a632eef3f8ff367514d4730fabcac.1468011909.git.mchehab@s-opensource.com>
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the widths and show error codes as constants.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst           |  2 +-
 Documentation/media/uapi/cec/cec-func-open.rst            | 10 +++++-----
 Documentation/media/uapi/cec/cec-func-poll.rst            |  8 ++++----
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst      |  4 ++--
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst |  4 ++--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          | 10 +++++-----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           |  5 +++--
 Documentation/media/uapi/cec/cec-ioc-receive.rst          |  6 +++---
 8 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index 11f083602792..ae55e55ab84a 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -45,5 +45,5 @@ Return Value
 :c:func:`close()` returns 0 on success. On error, -1 is returned, and
 ``errno`` is set appropriately. Possible error codes are:
 
-EBADF
+``EBADF``
     ``fd`` is not a valid open file descriptor.
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 53ffc091e2c0..95db9d1dc6b5 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -64,17 +64,17 @@ Return Value
 -1 is returned, and ``errno`` is set appropriately. Possible error codes
 include:
 
-EACCES
+``EACCES``
     The requested access to the file is not allowed.
 
-EMFILE
+``EMFILE``
     The process already has the maximum number of files open.
 
-ENFILE
+``ENFILE``
     The system limit on the total number of open files has been reached.
 
-ENOMEM
+``ENOMEM``
     Insufficient kernel memory was available.
 
-ENXIO
+``ENXIO``
     No device corresponding to this device special file exists.
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index ff5175fbf62f..eacc164558a5 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -56,15 +56,15 @@ On success, :c:func:`poll()` returns the number structures which have
 non-zero ``revents`` fields, or zero if the call timed out. On error -1
 is returned, and the ``errno`` variable is set appropriately:
 
-EBADF
+``EBADF``
     One or more of the ``ufds`` members specify an invalid file
     descriptor.
 
-EFAULT
+``EFAULT``
     ``ufds`` references an inaccessible memory area.
 
-EINTR
+``EINTR``
     The call was interrupted by a signal.
 
-EINVAL
+``EINVAL``
     The ``nfds`` argument is greater than ``OPEN_MAX``.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 4544b6f86ae0..eefec7b4f6bb 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -45,7 +45,7 @@ returns the information to the application. The ioctl never fails.
 .. flat-table:: struct cec_caps
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
+    :widths:       1 1 16
 
 
     -  .. row 1
@@ -90,7 +90,7 @@ returns the information to the application. The ioctl never fails.
 .. flat-table:: CEC Capabilities Flags
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 8
 
 
     -  .. _`CEC_CAP_PHYS_ADDR`:
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index f6c294fe119e..28955d20652f 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -58,7 +58,7 @@ by a file handle in initiator mode (see
 .. flat-table:: struct cec_log_addrs
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
+    :widths:       1 1 16
 
 
     -  .. row 1
@@ -292,7 +292,7 @@ by a file handle in initiator mode (see
 .. flat-table:: CEC Logical Address Types
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _`CEC_LOG_ADDR_TYPE_TV`:
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 79f779a9bd6c..07f22cec5762 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -55,7 +55,7 @@ state did change in between the two events.
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
+    :widths:       1 1 8
 
 
     -  .. row 1
@@ -81,7 +81,7 @@ state did change in between the two events.
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
+    :widths:       1 1 16
 
 
     -  .. row 1
@@ -107,7 +107,7 @@ state did change in between the two events.
 .. flat-table:: struct cec_event
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2 1
+    :widths:       1 1 1 8
 
 
     -  .. row 1
@@ -176,7 +176,7 @@ state did change in between the two events.
 .. flat-table:: CEC Events Types
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _CEC_EVENT_STATE_CHANGE:
@@ -205,7 +205,7 @@ state did change in between the two events.
 .. flat-table:: CEC Event Flags
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 8
 
 
     -  .. _CEC_EVENT_FL_INITIAL_VALUE:
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index c92f0be46907..d0605d876423 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -79,7 +79,7 @@ Available initiator modes are:
 .. flat-table:: Initiator Modes
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _`CEC_MODE_NO_INITIATOR`:
@@ -122,7 +122,7 @@ Available follower modes are:
 .. flat-table:: Follower Modes
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _`CEC_MODE_NO_FOLLOWER`:
@@ -214,6 +214,7 @@ Core message processing details:
 .. flat-table:: Core Message Processing
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 8
 
 
     -  .. _`CEC_MSG_GET_CEC_VERSION`:
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 5a345ff446a7..c5533795595c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -57,7 +57,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 .. flat-table:: struct cec_msg
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2
+    :widths:       1 1 16
 
 
     -  .. row 1
@@ -214,7 +214,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 .. flat-table:: CEC Transmit Status
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _`CEC_TX_STATUS_OK`:
@@ -282,7 +282,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 .. flat-table:: CEC Receive Status
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       3 1 16
 
 
     -  .. _`CEC_RX_STATUS_OK`:
-- 
2.7.4

