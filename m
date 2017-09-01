Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48381
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752227AbdIATiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 04/14] media: dvb uAPI docs: adjust return value ioctl descriptions
Date: Fri,  1 Sep 2017 16:37:40 -0300
Message-Id: <acbd744212ad281a4055bdb021e6abc126f7bb85.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several issues on the return value for ioctls:

- Text is confusing;
- Some error codes don't exist;
- The non-generic error codes should come before the text
  that points to the generic error codes;
- Tables don't contain column size hints;
- Some references are not marked as such.

Correct them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-fclose.rst         | 13 ++---
 Documentation/media/uapi/dvb/ca-fopen.rst          | 32 ++-----------
 Documentation/media/uapi/dvb/ca-get-cap.rst        |  4 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |  9 +++-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  | 10 +++-
 Documentation/media/uapi/dvb/ca-reset.rst          |  8 +++-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |  8 +++-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |  8 +++-
 Documentation/media/uapi/dvb/dmx-add-pid.rst       |  8 +++-
 Documentation/media/uapi/dvb/dmx-fclose.rst        | 13 ++---
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 33 +++++--------
 Documentation/media/uapi/dvb/dmx-fread.rst         | 55 +++++++---------------
 Documentation/media/uapi/dvb/dmx-fwrite.rst        | 29 +++++-------
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |  8 +++-
 Documentation/media/uapi/dvb/dmx-get-stc.rst       | 15 ++++--
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    |  8 +++-
 .../media/uapi/dvb/dmx-set-buffer-size.rst         |  9 +++-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    |  9 +++-
 .../media/uapi/dvb/dmx-set-pes-filter.rst          | 12 +++--
 Documentation/media/uapi/dvb/dmx-start.rst         | 15 ++++--
 Documentation/media/uapi/dvb/dmx-stop.rst          |  8 +++-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  8 +++-
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |  8 +++-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  8 +++-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  8 +++-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |  8 +++-
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |  8 +++-
 Documentation/media/uapi/dvb/fe-get-event.rst      |  9 ++--
 Documentation/media/uapi/dvb/fe-get-frontend.rst   | 10 ++--
 Documentation/media/uapi/dvb/fe-get-info.rst       |  8 +++-
 Documentation/media/uapi/dvb/fe-get-property.rst   |  8 +++-
 Documentation/media/uapi/dvb/fe-read-ber.rst       |  8 +++-
 .../media/uapi/dvb/fe-read-signal-strength.rst     |  8 +++-
 Documentation/media/uapi/dvb/fe-read-snr.rst       |  8 +++-
 Documentation/media/uapi/dvb/fe-read-status.rst    |  8 +++-
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |  8 +++-
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |  8 +++-
 Documentation/media/uapi/dvb/fe-set-frontend.rst   | 15 ++++--
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  8 +++-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  8 +++-
 Documentation/media/uapi/dvb/frontend_f_close.rst  | 10 ++--
 Documentation/media/uapi/dvb/frontend_f_open.rst   | 38 +++++++++------
 Documentation/media/uapi/dvb/net-add-if.rst        |  8 +++-
 Documentation/media/uapi/dvb/net-get-if.rst        |  8 +++-
 Documentation/media/uapi/dvb/net-remove-if.rst     |  8 +++-
 45 files changed, 327 insertions(+), 221 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
index 5ecefa4abc3d..d97c1957aad5 100644
--- a/Documentation/media/uapi/dvb/ca-fclose.rst
+++ b/Documentation/media/uapi/dvb/ca-fclose.rst
@@ -34,13 +34,10 @@ This system call closes a previously opened CA device.
 Return Value
 ------------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+On success 0 is returned.
 
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
-    -  .. row 1
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index 3d2819751446..c974a212b618 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -66,33 +66,11 @@ the device in this mode will fail, and an error code will be returned.
 Return Value
 ------------
 
-.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+On success 0 is returned.
 
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
-    -  .. row 1
-
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EINTERNAL``
-
-       -  Internal error.
-
-    -  .. row 3
-
-       -  ``EBUSY``
-
-       -  Device or resource busy.
-
-    -  .. row 4
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index 02d64acfb087..d2d5c1355396 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -40,5 +40,7 @@ Return Value
 On success 0 is returned and :c:type:`ca_caps` is filled.
 
 On error, -1 is returned and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index 1ee9d667c901..bdb116552068 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -49,6 +49,11 @@ Description
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index d7e41e038ca7..1a1d6f0c71b9 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -43,7 +43,15 @@ On success 0 is returned, and :c:type:`ca_slot_info` is filled.
 On error -1 is returned, and the ``errno`` variable is set
 appropriately.
 
-If the slot is not available, ``errno`` will contain ``-EINVAL``.
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths: 1 16
+
+    -  -  ``ENODEV``
+       -  the slot is not available.
 
 The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
index a5dd2797a92f..29788325f90e 100644
--- a/Documentation/media/uapi/dvb/ca-reset.rst
+++ b/Documentation/media/uapi/dvb/ca-reset.rst
@@ -35,6 +35,10 @@ be called before start using the CA hardware.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 532ef5f9d6ac..644b6bda1aea 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -38,6 +38,10 @@ Description
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 95de34cf74ba..9c484317d55c 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -48,6 +48,10 @@ Description
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
index 689cd1fc9142..0aab2fcaacab 100644
--- a/Documentation/media/uapi/dvb/dmx-add-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-add-pid.rst
@@ -40,6 +40,10 @@ DMX_OUT_TSDEMUX_TAP.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index ca93c23cde6d..b4401379e294 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -35,13 +35,10 @@ previously allocated via the open() call.
 Return Value
 ------------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+On success 0 is returned.
 
+On error, -1 is returned and the ``errno`` variable is set
+appropriately.
 
-    -  .. row 1
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index a697e33c32ea..7ed2fda9a7c7 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -69,31 +69,20 @@ using the F_SETFL command of the fcntl system call.
 Return Value
 ------------
 
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
-
-    -  .. row 1
-
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
-
-    -  .. row 3
-
-       -  ``EMFILE``
-
+    -  -  ``EMFILE``
        -  “Too many open files”, i.e. no more filters available.
 
-    -  .. row 4
-
-       -  ``ENOMEM``
-
-       -  The driver failed to allocate enough memory.
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index e8c7f4db353f..8d2fe9839dd3 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -41,54 +41,33 @@ implied by count.
 Return Value
 ------------
 
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
 .. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
+    -  -  ``EWOULDBLOCK``
+       -  No data to return and ``O_NONBLOCK`` was specified.
 
-    -  .. row 1
-
-       -  ``EWOULDBLOCK``
-
-       -  No data to return and O_NONBLOCK was specified.
-
-    -  .. row 2
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-    -  .. row 3
-
-       -  ``ECRC``
-
-       -  Last section had a CRC error - no data returned. The buffer is
-	  flushed.
-
-    -  .. row 4
-
-       -  ``EOVERFLOW``
-
-       -
-
-    -  .. row 5
-
-       -
+    -  -  ``EOVERFLOW``
        -  The filtered data was not read from the buffer in due time,
 	  resulting in non-read data being lost. The buffer is flushed.
 
-    -  .. row 6
+    -  -  ``ETIMEDOUT``
+       -  The section was not loaded within the stated timeout period.
+          See ioctl :ref:`DMX_SET_FILTER` for how to set a timeout.
 
-       -  ``ETIMEDOUT``
+    -  -  ``EFAULT``
+       -  The driver failed to write to the callers buffer due to an
+          invalid \*buf pointer.
 
-       -  The section was not loaded within the stated timeout period. See
-	  ioctl DMX_SET_FILTER for how to set a timeout.
 
-    -  .. row 7
-
-       -  ``EFAULT``
-
-       -  The driver failed to write to the callers buffer due to an invalid
-	  \*buf pointer.
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 8a90dfe28307..5e82a9ee418f 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -44,32 +44,29 @@ The amount of data to be transferred is implied by count.
 Return Value
 ------------
 
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
 .. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
-    -  .. row 1
-
-       -  ``EWOULDBLOCK``
-
-       -  No data was written. This might happen if O_NONBLOCK was
+    -  -  ``EWOULDBLOCK``
+       -  No data was written. This might happen if ``O_NONBLOCK`` was
 	  specified and there is no more buffer space available (if
-	  O_NONBLOCK is not specified the function will block until buffer
+	  ``O_NONBLOCK`` is not specified the function will block until buffer
 	  space is available).
 
-    -  .. row 2
-
-       -  ``EBUSY``
-
+    -  -  ``EBUSY``
        -  This error code indicates that there are conflicting requests. The
 	  corresponding demux device is setup to receive data from the
 	  front- end. Make sure that these filters are stopped and that the
-	  filters with input set to DMX_IN_DVR are started.
+	  filters with input set to ``DMX_IN_DVR`` are started.
 
-    -  .. row 3
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index b31634a1cca4..20288c11d279 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -37,6 +37,10 @@ Description
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
index 9fc501e8128a..6d5d069d4e6c 100644
--- a/Documentation/media/uapi/dvb/dmx-get-stc.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-stc.rst
@@ -42,17 +42,24 @@ the real 90kHz STC value is stc->stc / stc->base .
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-
+    :widths: 1 16
 
     -  .. row 1
 
        -  ``EINVAL``
 
        -  Invalid stc number.
+
+
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
index e411495c619c..1faa40ab11bd 100644
--- a/Documentation/media/uapi/dvb/dmx-remove-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
@@ -41,6 +41,10 @@ DMX_SET_PES_FILTER or DMX_ADD_PID.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
index f2f7379f29ed..a659dd7ca7e6 100644
--- a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
@@ -40,6 +40,11 @@ used.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
index 1d50c803d69a..d6ee52321717 100644
--- a/Documentation/media/uapi/dvb/dmx-set-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-filter.rst
@@ -47,6 +47,11 @@ will be canceled, and the receive buffer will be flushed.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
index 145451d04f7d..d70e7bf96a41 100644
--- a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
@@ -42,15 +42,17 @@ capability is supported.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
 .. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
 
     -  .. row 1
@@ -61,3 +63,7 @@ appropriately. The generic error codes are described at the
 	  There are active filters filtering data from another input source.
 	  Make sure that these filters are stopped before starting this
 	  filter.
+
+
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
index 641f3e017fb1..36700e775296 100644
--- a/Documentation/media/uapi/dvb/dmx-start.rst
+++ b/Documentation/media/uapi/dvb/dmx-start.rst
@@ -29,15 +29,16 @@ Description
 -----------
 
 This ioctl call is used to start the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
+via the ioctl calls :ref:`DMX_SET_FILTER` or :ref:`DMX_SET_PES_FILTER`.
 
 
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
 .. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
@@ -51,7 +52,7 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Invalid argument, i.e. no filtering parameters provided via the
-	  DMX_SET_FILTER or DMX_SET_PES_FILTER functions.
+	  :ref:`DMX_SET_FILTER` or :ref:`DMX_SET_PES_FILTER` ioctls.
 
     -  .. row 2
 
@@ -61,3 +62,7 @@ appropriately. The generic error codes are described at the
 	  There are active filters filtering data from another input source.
 	  Make sure that these filters are stopped before starting this
 	  filter.
+
+
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
index 569a3df44923..5f4bf63868c1 100644
--- a/Documentation/media/uapi/dvb/dmx-stop.rst
+++ b/Documentation/media/uapi/dvb/dmx-stop.rst
@@ -36,6 +36,10 @@ started via the DMX_START command.
 Return Value
 ------------
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 473855584d7f..f220ee351e15 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -39,6 +39,10 @@ The received message is stored at the buffer pointed by ``argp``.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
index 75116f283faf..e1243097c09e 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
@@ -37,6 +37,10 @@ is manually powered off. Not all DVB adapters support this ioctl.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index 54d35517e784..a7e05914efae 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -43,6 +43,10 @@ It provides support for what's specified at
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 7392d6747ad6..d274be7316ff 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -38,7 +38,11 @@ Sends the DiSEqC command pointed by ``argp`` to the antenna subsystem.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
index f41371f12456..dcf2d20d460f 100644
--- a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -46,6 +46,10 @@ dishes were already legacy in 2004.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
index bacafbc462d2..b20cb360fe37 100644
--- a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
@@ -45,6 +45,10 @@ voltages.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-get-event.rst b/Documentation/media/uapi/dvb/fe-get-event.rst
index 8a719c33073d..505db94bf183 100644
--- a/Documentation/media/uapi/dvb/fe-get-event.rst
+++ b/Documentation/media/uapi/dvb/fe-get-event.rst
@@ -44,10 +44,10 @@ an event becomes available.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+On success 0 is returned.
 
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
 
 .. flat-table::
@@ -66,3 +66,6 @@ appropriately. The generic error codes are described at the
        -  ``EOVERFLOW``
 
        -  Overflow in event queue - one or more events were lost.
+
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-get-frontend.rst b/Documentation/media/uapi/dvb/fe-get-frontend.rst
index d53a3f8237c3..5db552cedd70 100644
--- a/Documentation/media/uapi/dvb/fe-get-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-get-frontend.rst
@@ -42,11 +42,10 @@ this command, read-only access to the device is sufficient.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
+On success 0 is returned.
 
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
 .. flat-table::
     :header-rows:  0
@@ -58,3 +57,6 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
+
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 30dde8a791f3..17e9d9aa5b22 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -53,6 +53,10 @@ The frontend capabilities are described at :c:type:`fe_caps`.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index b22e37c4a787..fffa78d17f61 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -64,6 +64,10 @@ depends on the delivery system and on the device:
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-read-ber.rst b/Documentation/media/uapi/dvb/fe-read-ber.rst
index e54972ad5250..1e6a79567a4c 100644
--- a/Documentation/media/uapi/dvb/fe-read-ber.rst
+++ b/Documentation/media/uapi/dvb/fe-read-ber.rst
@@ -41,6 +41,10 @@ access to the device is sufficient.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
index 4b13c4757744..198f6dfb53a1 100644
--- a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
+++ b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
@@ -41,6 +41,10 @@ to the device is sufficient.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-read-snr.rst b/Documentation/media/uapi/dvb/fe-read-snr.rst
index 2aed487f5c99..6db22c043512 100644
--- a/Documentation/media/uapi/dvb/fe-read-snr.rst
+++ b/Documentation/media/uapi/dvb/fe-read-snr.rst
@@ -41,6 +41,10 @@ to the device is sufficient.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 21b2db3591fd..a84b045e8148 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -56,6 +56,10 @@ state changes of the frontend hardware. It is produced using the enum
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
index 46687c123402..f2c688bcacb3 100644
--- a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
@@ -43,6 +43,10 @@ sufficient.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
index 1d5878da2f41..37a9cef1b6bd 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
@@ -48,6 +48,10 @@ FE_TUNE_MODE_ONESHOT mode
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend.rst b/Documentation/media/uapi/dvb/fe-set-frontend.rst
index 7f97dce9aee6..4f3dcf338254 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend.rst
@@ -48,17 +48,24 @@ requires read/write access to the device.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-
+    :widths: 1 16
 
     -  .. row 1
 
        -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
+
+
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index d0950acbbe64..758efa11014c 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -49,6 +49,10 @@ this is done using the DiSEqC ioctls.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index 052f316bb4a3..38d4485290a0 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -53,6 +53,10 @@ power up the LNBf.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
index f3b04b60246c..791434bd9548 100644
--- a/Documentation/media/uapi/dvb/frontend_f_close.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_close.rst
@@ -41,8 +41,10 @@ down automatically.
 Return Value
 ============
 
-The function returns 0 on success, -1 on failure and the ``errno`` is
-set appropriately. Possible error codes:
+On success 0 is returned.
 
-EBADF
-    ``fd`` is not a valid open file descriptor.
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+Generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
index 690eb375bdc1..4c25ece73da1 100644
--- a/Documentation/media/uapi/dvb/frontend_f_open.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_open.rst
@@ -79,24 +79,32 @@ On error, -1 is returned, and the ``errno`` variable is set appropriately.
 
 Possible error codes are:
 
-EACCES
-    The caller has no permission to access the device.
 
-EBUSY
-    The the device driver is already in use.
+On success 0 is returned, and :c:type:`ca_slot_info` is filled.
 
-ENXIO
-    No device corresponding to this device special file exists.
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
 
-ENOMEM
-    Not enough kernel memory was available to complete the request.
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
 
-EMFILE
-    The process already has the maximum number of files open.
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths: 1 16
 
-ENFILE
-    The limit on the total number of files open on the system has been
-    reached.
+    -  - ``EPERM``
+       -  The caller has no permission to access the device.
 
-ENODEV
-    The device got removed.
+    -  - ``EBUSY``
+       -  The the device driver is already in use.
+
+    -  - ``EMFILE``
+       -  The process already has the maximum number of files open.
+
+    -  - ``ENFILE``
+       -  The limit on the total number of files open on the system has been
+	  reached.
+
+
+The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index 82ce2438213f..5896bf1b339b 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -78,6 +78,10 @@ filled with the number of the created interface.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned, and :c:type:`ca_slot_info` is filled.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
index 1bb8ee0cbced..3733b34da9db 100644
--- a/Documentation/media/uapi/dvb/net-get-if.rst
+++ b/Documentation/media/uapi/dvb/net-get-if.rst
@@ -43,6 +43,10 @@ the ``errno`` with ``EINVAL`` error code.
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned, and :c:type:`ca_slot_info` is filled.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/net-remove-if.rst b/Documentation/media/uapi/dvb/net-remove-if.rst
index 646af23a925a..4ebe07a6b79a 100644
--- a/Documentation/media/uapi/dvb/net-remove-if.rst
+++ b/Documentation/media/uapi/dvb/net-remove-if.rst
@@ -39,6 +39,10 @@ The NET_REMOVE_IF ioctl deletes an interface previously created via
 Return Value
 ============
 
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
+On success 0 is returned, and :c:type:`ca_slot_info` is filled.
+
+On error -1 is returned, and the ``errno`` variable is set
+appropriately.
+
+The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.13.5
