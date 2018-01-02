Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59073 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbeABVBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 16:01:31 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: lirc: lirc mode ioctls deal with current mode
Date: Tue,  2 Jan 2018 21:01:29 +0000
Message-Id: <20180102210129.7608-3-sean@mess.org>
In-Reply-To: <20180102210129.7608-1-sean@mess.org>
References: <20180102210129.7608-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ioctl change the current mode or return the current mode; they
do not tell you which modes are possible (use the lirc features
ioctl for that).

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  | 42 ++++++++++++++++------
 Documentation/media/uapi/rc/lirc-get-send-mode.rst | 38 +++++++++++++++-----
 2 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index 34919feaf392..2722118484fa 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -10,15 +10,15 @@ ioctls LIRC_GET_REC_MODE and LIRC_SET_REC_MODE
 Name
 ====
 
-LIRC_GET_REC_MODE/LIRC_SET_REC_MODE - Get/set supported receive modes.
+LIRC_GET_REC_MODE/LIRC_SET_REC_MODE - Get/set current receive mode.
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, LIRC_GET_REC_MODE, __u32 rx_modes)
+.. c:function:: int ioctl( int fd, LIRC_GET_REC_MODE, __u32 *mode)
 	:name: LIRC_GET_REC_MODE
 
-.. c:function:: int ioctl( int fd, LIRC_SET_REC_MODE, __u32 rx_modes)
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_MODE, __u32 *mode)
 	:name: LIRC_SET_REC_MODE
 
 Arguments
@@ -27,19 +27,41 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``rx_modes``
-    Bitmask with the supported transmit modes.
+``mode``
+    Mode used for receive.
 
 Description
 ===========
 
-Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
-and :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported.
+Get and set the current receive mode. Only
+:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported.
 Use :ref:`lirc_get_features` to find out which modes the driver supports.
 
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device not available.
+
+    -  .. row 2
+
+       -  ``ENOTTY``
+
+       -  Device does not support receiving.
+
+    -  .. row 3
+
+       -  ``EINVAL``
+
+       -  Invalid mode or invalid mode for this device.
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index e39383f08e21..c44e61a79ad1 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -10,15 +10,15 @@ ioctls LIRC_GET_SEND_MODE and LIRC_SET_SEND_MODE
 Name
 ====
 
-LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - Get/set supported transmit mode.
+LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - Get/set current transmit mode.
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, LIRC_GET_SEND_MODE, __u32 *tx_modes )
+.. c:function:: int ioctl( int fd, LIRC_GET_SEND_MODE, __u32 *mode )
     :name: LIRC_GET_SEND_MODE
 
-.. c:function:: int ioctl( int fd, LIRC_SET_SEND_MODE, __u32 *tx_modes )
+.. c:function:: int ioctl( int fd, LIRC_SET_SEND_MODE, __u32 *mode )
     :name: LIRC_SET_SEND_MODE
 
 Arguments
@@ -27,8 +27,8 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``tx_modes``
-    Bitmask with the supported transmit modes.
+``mode``
+    The mode used for transmitting.
 
 
 Description
@@ -44,6 +44,28 @@ modes the driver supports.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device not available.
+
+    -  .. row 2
+
+       -  ``ENOTTY``
+
+       -  Device does not support transmitting.
+
+    -  .. row 3
+
+       -  ``EINVAL``
+
+       -  Invalid mode or invalid mode for this device.
-- 
2.14.3
