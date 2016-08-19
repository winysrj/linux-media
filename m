Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754611AbcHSU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 5/6] [media] docs-rst: Convert LIRC uAPI to use C function references
Date: Fri, 19 Aug 2016 17:27:52 -0300
Message-Id: <34c3d7e4a018ff305c76b78746445293ec9b91d9.1471636893.git.mchehab@s-opensource.com>
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
 Documentation/media/uapi/rc/lirc-get-features.rst             |  6 ++----
 Documentation/media/uapi/rc/lirc-get-length.rst               |  6 ++----
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst             | 11 ++++++-----
 Documentation/media/uapi/rc/lirc-get-rec-resolution.rst       |  6 ++----
 Documentation/media/uapi/rc/lirc-get-send-mode.rst            |  9 +++++----
 Documentation/media/uapi/rc/lirc-get-timeout.rst              |  9 +++++----
 Documentation/media/uapi/rc/lirc-read.rst                     |  5 ++++-
 Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst |  6 ++----
 Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst    |  6 ++----
 Documentation/media/uapi/rc/lirc-set-rec-carrier.rst          |  6 ++----
 Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst  |  6 ++----
 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst          |  6 ++----
 Documentation/media/uapi/rc/lirc-set-send-carrier.rst         |  6 ++----
 Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst      |  6 ++----
 Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst     |  6 ++----
 Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst    |  6 ++----
 Documentation/media/uapi/rc/lirc-write.rst                    |  6 ++++--
 17 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index d0c8a426aa16..79e07b4d44d6 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -14,7 +14,8 @@ LIRC_GET_FEATURES - Get the underlying hardware device's features
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *features)
+.. c:function:: int ioctl( int fd, LIRC_GET_FEATURES, __u32 *features)
+    :name: LIRC_GET_FEATURES
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_FEATURES
-
 ``features``
     Bitmask with the LIRC features.
 
diff --git a/Documentation/media/uapi/rc/lirc-get-length.rst b/Documentation/media/uapi/rc/lirc-get-length.rst
index 44c6e8923b40..8c2747c8d2c9 100644
--- a/Documentation/media/uapi/rc/lirc-get-length.rst
+++ b/Documentation/media/uapi/rc/lirc-get-length.rst
@@ -14,7 +14,8 @@ LIRC_GET_LENGTH - Retrieves the code length in bits.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *length )
+.. c:function:: int ioctl( int fd, LIRC_GET_LENGTH, __u32 *length )
+    :name: LIRC_GET_LENGTH
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_LENGTH
-
 ``length``
     length, in bits
 
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index 445c618771f4..a5023e0194c1 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -10,12 +10,16 @@ ioctls LIRC_GET_REC_MODE and LIRC_SET_REC_MODE
 Name
 ====
 
-LIRC_GET_REC_MODE/LIRC_GET_REC_MODE - Get/set supported receive modes.
+LIRC_GET_REC_MODE/LIRC_SET_REC_MODE - Get/set supported receive modes.
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 rx_modes)
+.. c:function:: int ioctl( int fd, LIRC_GET_REC_MODE, __u32 rx_modes)
+	:name: LIRC_GET_REC_MODE
+
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_MODE, __u32 rx_modes)
+	:name: LIRC_SET_REC_MODE
 
 Arguments
 =========
@@ -23,9 +27,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_REC_MODE or LIRC_GET_REC_MODE
-
 ``rx_modes``
     Bitmask with the supported transmit modes.
 
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
index 3ac3a8199c29..6e016edc2bc4 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
@@ -14,7 +14,8 @@ LIRC_GET_REC_RESOLUTION - Obtain the value of receive resolution, in microsecond
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *microseconds)
+.. c:function:: int ioctl( int fd, LIRC_GET_REC_RESOLUTION, __u32 *microseconds)
+    :name: LIRC_GET_REC_RESOLUTION
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_REC_RESOLUTION
-
 ``microseconds``
     Resolution, in microseconds.
 
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index 5e40b7bc1c1f..51ac13428969 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -15,7 +15,11 @@ LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - Get/set supported transmit mode.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *tx_modes )
+.. c:function:: int ioctl( int fd, LIRC_GET_SEND_MODE, __u32 *tx_modes )
+    :name: LIRC_GET_SEND_MODE
+
+.. c:function:: int ioctl( int fd, LIRC_SET_SEND_MODE, __u32 *tx_modes )
+    :name: LIRC_SET_SEND_MODE
 
 Arguments
 =========
@@ -23,9 +27,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_SEND_MODE
-
 ``tx_modes``
     Bitmask with the supported transmit modes.
 
diff --git a/Documentation/media/uapi/rc/lirc-get-timeout.rst b/Documentation/media/uapi/rc/lirc-get-timeout.rst
index 0d103f899350..c94bc5dcaa8e 100644
--- a/Documentation/media/uapi/rc/lirc-get-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-get-timeout.rst
@@ -16,7 +16,11 @@ range for IR receive.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *timeout)
+.. c:function:: int ioctl( int fd, LIRC_GET_MIN_TIMEOUT, __u32 *timeout)
+    :name: LIRC_GET_MIN_TIMEOUT
+
+.. c:function:: int ioctl( int fd, LIRC_GET_MAX_TIMEOUT, __u32 *timeout)
+    :name: LIRC_GET_MAX_TIMEOUT
 
 Arguments
 =========
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_GET_MIN_TIMEOUT or LIRC_GET_MAX_TIMEOUT
-
 ``timeout``
     Timeout, in microseconds.
 
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index c5b5e1db7cad..62bd3d8c9c67 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -21,6 +21,7 @@ Synopsis
 
 
 .. c:function:: ssize_t read( int fd, void *buf, size_t count )
+    :name lirc-read
 
 
 Arguments
@@ -30,8 +31,10 @@ Arguments
     File descriptor returned by ``open()``.
 
 ``buf``
+   Buffer to be filled
+
 ``count``
-
+   Max number of bytes to read
 
 Description
 ===========
diff --git a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
index ee0b46b44c24..6307b5715595 100644
--- a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
@@ -14,7 +14,8 @@ LIRC_SET_MEASURE_CARRIER_MODE - enable or disable measure mode
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, LIRC_SET_MEASURE_CARRIER_MODE, __u32 *enable )
+    :name: LIRC_SET_MEASURE_CARRIER_MODE
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_MEASURE_CARRIER_MODE
-
 ``enable``
     enable = 1 means enable measure mode, enable = 0 means disable measure
     mode.
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
index 44814a5163e6..a83fbbfa0d3b 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
@@ -15,7 +15,8 @@ IR receive.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_CARRIER_RANGE, __u32 *frequency )
+    :name: LIRC_SET_REC_CARRIER_RANGE
 
 Arguments
 =========
@@ -23,9 +24,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_REC_CARRIER_RANGE
-
 ``frequency``
     Frequency of the carrier that modulates PWM data, in Hz.
 
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
index c3508b7fd441..a411c0330818 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
@@ -15,7 +15,8 @@ LIRC_SET_REC_CARRIER - Set carrier used to modulate IR receive.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_CARRIER, __u32 *frequency )
+    :name: LIRC_SET_REC_CARRIER
 
 Arguments
 =========
@@ -23,9 +24,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_REC_CARRIER
-
 ``frequency``
     Frequency of the carrier that modulates PWM data, in Hz.
 
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
index 676e7698b882..9c501bbf4c62 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
@@ -14,7 +14,8 @@ LIRC_SET_REC_TIMEOUT_REPORTS - enable or disable timeout reports for IR receive
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_TIMEOUT_REPORTS, __u32 *enable )
+    :name: LIRC_SET_REC_TIMEOUT_REPORTS
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_REC_TIMEOUT_REPORTS
-
 ``enable``
     enable = 1 means enable timeout report, enable = 0 means disable timeout
     reports.
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
index f54026a14c4f..b3e16bbdbc90 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
@@ -14,7 +14,8 @@ LIRC_SET_REC_TIMEOUT - sets the integer value for IR inactivity timeout.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *timeout )
+.. c:function:: int ioctl( int fd, LIRC_SET_REC_TIMEOUT, __u32 *timeout )
+    :name: LIRC_SET_REC_TIMEOUT
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_REC_TIMEOUT
-
 ``timeout``
     Timeout, in microseconds.
 
diff --git a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
index fa4df86d7698..42c8cfb42df5 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
@@ -15,7 +15,8 @@ LIRC_SET_SEND_CARRIER - Set send carrier used to modulate IR TX.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, LIRC_SET_SEND_CARRIER, __u32 *frequency )
+    :name: LIRC_SET_SEND_CARRIER
 
 Arguments
 =========
@@ -23,9 +24,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_SEND_CARRIER
-
 ``frequency``
     Frequency of the carrier to be modulated, in Hz.
 
diff --git a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
index 7a7d2730d727..20d07c2a37a5 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
@@ -15,7 +15,8 @@ IR transmit.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *duty_cycle)
+.. c:function:: int ioctl( int fd, LIRC_SET_SEND_DUTY_CYCLE, __u32 *duty_cycle)
+    :name: LIRC_SET_SEND_DUTY_CYCLE
 
 Arguments
 =========
@@ -23,9 +24,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_SEND_DUTY_CYCLE
-
 ``duty_cycle``
     Duty cicle, describing the pulse width in percent (from 1 to 99) of
     the total cycle. Values 0 and 100 are reserved.
diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
index 179b835e5b53..69b7ad8c2afb 100644
--- a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
+++ b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
@@ -14,7 +14,8 @@ LIRC_SET_TRANSMITTER_MASK - Enables send codes on a given set of transmitters
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *mask )
+.. c:function:: int ioctl( int fd, LIRC_SET_TRANSMITTER_MASK, __u32 *mask )
+    :name: LIRC_SET_TRANSMITTER_MASK
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_TRANSMITTER_MASK
-
 ``mask``
     Mask with channels to enable tx. Channel 0 is the least significant bit.
 
diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
index 4a9101be40aa..0415c6a54f23 100644
--- a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
+++ b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
@@ -14,7 +14,8 @@ LIRC_SET_WIDEBAND_RECEIVER - enable wide band receiver.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, LIRC_SET_WIDEBAND_RECEIVER, __u32 *enable )
+    :name: LIRC_SET_WIDEBAND_RECEIVER
 
 Arguments
 =========
@@ -22,9 +23,6 @@ Arguments
 ``fd``
     File descriptor returned by open().
 
-``request``
-    LIRC_SET_WIDEBAND_RECEIVER
-
 ``enable``
     enable = 1 means enable wideband receiver, enable = 0 means disable
     wideband receiver.
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 631d961813d1..3b035c6613b1 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: ssize_t write( int fd, void *buf, size_t count )
-
+    :name: lirc-write
 
 Arguments
 =========
@@ -30,8 +30,10 @@ Arguments
     File descriptor returned by ``open()``.
 
 ``buf``
+    Buffer with data to be written
+
 ``count``
-
+    Number of bytes at the buffer
 
 Description
 ===========
-- 
2.7.4


