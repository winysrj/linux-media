Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48378
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752437AbdIATiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 15:38:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 10/14] media: dvb uAPI docs: minor editorial changes
Date: Fri,  1 Sep 2017 16:37:46 -0300
Message-Id: <aa5d12b0d628c1a9b9e4201300175a5a0508e5ee.1504293108.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504293108.git.mchehab@s-opensource.com>
References: <cover.1504293108.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do minor editorial changes to improve documentation readability:

- mark literals as such;
- add table markups to hint sizes;
- define what PES means;
- instead of hardcoding devnode numbers to zero (like adapter0/) use a
  question mark, to indicate that multiple devnodes may exist;
- add cross-references where useful.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/ca-fopen.rst          | 25 +++++++++++-----------
 Documentation/media/uapi/dvb/dmx-add-pid.rst       |  4 ++--
 Documentation/media/uapi/dvb/dmx-fclose.rst        |  5 +++--
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 23 +++++++++++---------
 Documentation/media/uapi/dvb/dmx-fread.rst         |  8 +++----
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |  4 ++--
 Documentation/media/uapi/dvb/dmx-get-stc.rst       | 13 +++++------
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    |  4 ++--
 .../media/uapi/dvb/dmx-set-buffer-size.rst         |  2 +-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    |  4 ++--
 Documentation/media/uapi/dvb/dmx-stop.rst          |  4 ++--
 .../media/uapi/dvb/dvb-fe-read-status.rst          |  2 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  3 ++-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  4 ++--
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |  4 ++--
 Documentation/media/uapi/dvb/fe-type-t.rst         |  2 +-
 16 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index a03a01abf3da..056c71b53a70 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -28,20 +28,20 @@ Arguments
 ``flags``
   A bit-wise OR of the following flags:
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
-    -
-       - O_RDONLY
+    -  - ``O_RDONLY``
        - read-only access
 
-    -
-       - O_RDWR
+    -  - ``O_RDWR``
        - read/write access
 
-    -
-       - O_NONBLOCK
+    -  - ``O_NONBLOCK``
        - open in non-blocking mode
          (blocking mode is the default)
 
@@ -52,15 +52,16 @@ Description
 This system call opens a named ca device (e.g. ``/dev/dvb/adapter?/ca?``)
 for subsequent use.
 
-When an open() call has succeeded, the device will be ready for use. The
+When an ``open()`` call has succeeded, the device will be ready for use. The
 significance of blocking or non-blocking mode is described in the
 documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
+affect the semantics of the ``open()`` call itself. A device opened in
 blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call. This is a standard
-system call, documented in the Linux manual page for fcntl. Only one
-user can open the CA Device in O_RDWR mode. All other attempts to open
-the device in this mode will fail, and an error code will be returned.
+using the ``F_SETFL`` command of the ``fcntl`` system call. This is a
+standard system call, documented in the Linux manual page for fcntl.
+Only one user can open the CA Device in ``O_RDWR`` mode. All other
+attempts to open the device in this mode will fail, and an error code
+will be returned.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
index 0aab2fcaacab..4d5632dfb43e 100644
--- a/Documentation/media/uapi/dvb/dmx-add-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-add-pid.rst
@@ -33,8 +33,8 @@ Description
 -----------
 
 This ioctl call allows to add multiple PIDs to a transport stream filter
-previously set up with DMX_SET_PES_FILTER and output equal to
-DMX_OUT_TSDEMUX_TAP.
+previously set up with :ref:`DMX_SET_PES_FILTER` and output equal to
+:c:type:`DMX_OUT_TSDEMUX_TAP <dmx_output>`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index 8693501dbd4d..578e929f4bde 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -23,13 +23,14 @@ Arguments
 ---------
 
 ``fd``
-  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
+  File descriptor returned by a previous call to
+  :c:func:`open() <dvb-dmx-open>`.
 
 Description
 -----------
 
 This system call deactivates and deallocates a filter that was
-previously allocated via the open() call.
+previously allocated via the :c:func:`open() <dvb-dmx-open>` call.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index 3dee019522db..55628a18ba67 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -27,20 +27,23 @@ Arguments
 ``flags``
   A bit-wise OR of the following flags:
 
+.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
     -
-       - O_RDONLY
+       - ``O_RDONLY``
        - read-only access
 
     -
-       - O_RDWR
+       - ``O_RDWR``
        - read/write access
 
     -
-       - O_NONBLOCK
+       - ``O_NONBLOCK``
        - open in non-blocking mode
          (blocking mode is the default)
 
@@ -48,22 +51,22 @@ Arguments
 Description
 -----------
 
-This system call, used with a device name of /dev/dvb/adapter0/demux0,
+This system call, used with a device name of ``/dev/dvb/adapter?/demux?``,
 allocates a new filter and returns a handle which can be used for
 subsequent control of that filter. This call has to be made for each
 filter to be used, i.e. every returned file descriptor is a reference to
-a single filter. /dev/dvb/adapter0/dvr0 is a logical device to be used
+a single filter. ``/dev/dvb/adapter?/dvr?`` is a logical device to be used
 for retrieving Transport Streams for digital video recording. When
 reading from this device a transport stream containing the packets from
 all PES filters set in the corresponding demux device
-(/dev/dvb/adapter0/demux0) having the output set to DMX_OUT_TS_TAP. A
-recorded Transport Stream is replayed by writing to this device.
+(``/dev/dvb/adapter?/demux?``) having the output set to ``DMX_OUT_TS_TAP``.
+A recorded Transport Stream is replayed by writing to this device.
 
 The significance of blocking or non-blocking mode is described in the
 documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
-blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call.
+affect the semantics of the ``open()`` call itself. A device opened
+in blocking mode can later be put into non-blocking mode (and vice versa)
+using the ``F_SETFL`` command of the fcntl system call.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index 36ba851bc0af..488bdc4ba178 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -33,10 +33,10 @@ Arguments
 Description
 -----------
 
-This system call returns filtered data, which might be section or PES
-data. The filtered data is transferred from the driver’s internal
-circular buffer to buf. The maximum amount of data to be transferred is
-implied by count.
+This system call returns filtered data, which might be section or Packetized
+Elementary Stream (PES) data. The filtered data is transferred from
+the driver’s internal circular buffer to ``buf``. The maximum amount of data
+to be transferred is implied by count.
 
 .. note::
 
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 77f138f6234f..519e5733e53b 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -34,10 +34,10 @@ Description
 -----------
 
 This system call is only provided by the logical device
-/dev/dvb/adapter0/dvr0, associated with the physical demux device that
+``/dev/dvb/adapter?/dvr?``, associated with the physical demux device that
 provides the actual DVR functionality. It is used for replay of a
 digitally recorded Transport Stream. Matching filters have to be defined
-in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
+in the corresponding physical demux device, ``/dev/dvb/adapter?/demux?``.
 The amount of data to be transferred is implied by count.
 
 
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
index 6d5d069d4e6c..604031f7904b 100644
--- a/Documentation/media/uapi/dvb/dmx-get-stc.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-stc.rst
@@ -25,18 +25,19 @@ Arguments
     File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
 ``stc``
-    Pointer to the location where the stc is to be stored.
+    Pointer to :c:type:`dmx_stc` where the stc data is to be stored.
 
 
 Description
 -----------
 
 This ioctl call returns the current value of the system time counter
-(which is driven by a PES filter of type DMX_PES_PCR). Some hardware
-supports more than one STC, so you must specify which one by setting the
-num field of stc before the ioctl (range 0...n). The result is returned
-in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
-the real 90kHz STC value is stc->stc / stc->base .
+(which is driven by a PES filter of type :c:type:`DMX_PES_PCR <dmx_ts_pes>`).
+Some hardware supports more than one STC, so you must specify which one by
+setting the :c:type:`num <dmx_stc>` field of stc before the ioctl (range 0...n).
+The result is returned in form of a ratio with a 64 bit numerator
+and a 32 bit denominator, so the real 90kHz STC value is
+``stc->stc / stc->base``.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
index 1faa40ab11bd..456cc2ded2c0 100644
--- a/Documentation/media/uapi/dvb/dmx-remove-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
@@ -34,8 +34,8 @@ Description
 
 This ioctl call allows to remove a PID when multiple PIDs are set on a
 transport stream filter, e. g. a filter previously set up with output
-equal to DMX_OUT_TSDEMUX_TAP, created via either
-DMX_SET_PES_FILTER or DMX_ADD_PID.
+equal to :c:type:`DMX_OUT_TSDEMUX_TAP <dmx_output>`, created via either
+:ref:`DMX_SET_PES_FILTER` or :ref:`DMX_ADD_PID`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
index a659dd7ca7e6..74fd076a9b90 100644
--- a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
@@ -33,7 +33,7 @@ Description
 
 This ioctl call is used to set the size of the circular buffer used for
 filtered data. The default size is two maximum sized sections, i.e. if
-this function is not called a buffer size of 2 \* 4096 bytes will be
+this function is not called a buffer size of ``2 * 4096`` bytes will be
 used.
 
 
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
index d6ee52321717..88594b8d3846 100644
--- a/Documentation/media/uapi/dvb/dmx-set-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-filter.rst
@@ -40,8 +40,8 @@ state whether a section should be CRC-checked, whether the filter should
 be a ”one-shot” filter, i.e. if the filtering operation should be
 stopped after the first section is received, and whether the filtering
 operation should be started immediately (without waiting for a
-DMX_START ioctl call). If a filter was previously set-up, this filter
-will be canceled, and the receive buffer will be flushed.
+:ref:`DMX_START` ioctl call). If a filter was previously set-up, this
+filter will be canceled, and the receive buffer will be flushed.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
index 5f4bf63868c1..6d9c927bcd5f 100644
--- a/Documentation/media/uapi/dvb/dmx-stop.rst
+++ b/Documentation/media/uapi/dvb/dmx-stop.rst
@@ -29,8 +29,8 @@ Description
 -----------
 
 This ioctl call is used to stop the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
-started via the DMX_START command.
+via the ioctl calls :ref:`DMX_SET_FILTER` or :ref:`DMX_SET_PES_FILTER` and
+started via the :ref:`DMX_START` command.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
index 76c20612b274..212f032cad8b 100644
--- a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
@@ -20,6 +20,6 @@ Signal statistics are provided via
 .. note::
 
    Most statistics require the demodulator to be fully locked
-   (e. g. with FE_HAS_LOCK bit set). See
+   (e. g. with :c:type:`FE_HAS_LOCK <fe_status>` bit set). See
    :ref:`Frontend statistics indicators <frontend-stat-properties>` for
    more details.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index d274be7316ff..6bd3994edfc2 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -33,7 +33,8 @@ Arguments
 Description
 ===========
 
-Sends the DiSEqC command pointed by ``argp`` to the antenna subsystem.
+Sends the DiSEqC command pointed by :c:type:`dvb_diseqc_master_cmd`
+to the antenna subsystem.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 9e5a7a27e158..49307c0abfee 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -34,8 +34,8 @@ Arguments
 Description
 ===========
 
-All Digital TV frontend devices support the ``FE_GET_INFO`` ioctl. It is used
-to identify kernel devices compatible with this specification and to
+All Digital TV frontend devices support the :ref:`FE_GET_INFO` ioctl. It is
+used to identify kernel devices compatible with this specification and to
 obtain information about driver and hardware capabilities. The ioctl
 takes a pointer to dvb_frontend_info which is filled by the driver.
 When the driver is not compatible with this specification the ioctl
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
index 37a9cef1b6bd..3c4bc179b313 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
@@ -30,7 +30,7 @@ Arguments
 
     -  0 - normal tune mode
 
-    -  FE_TUNE_MODE_ONESHOT - When set, this flag will disable any
+    -  ``FE_TUNE_MODE_ONESHOT`` - When set, this flag will disable any
        zigzagging or other "normal" tuning behaviour. Additionally,
        there will be no automatic monitoring of the lock status, and
        hence no frontend events will be generated. If a frontend device
@@ -42,7 +42,7 @@ Description
 ===========
 
 Allow setting tuner mode flags to the frontend, between 0 (normal) or
-FE_TUNE_MODE_ONESHOT mode
+``FE_TUNE_MODE_ONESHOT`` mode
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
index 548b965188d0..dee32ae104d7 100644
--- a/Documentation/media/uapi/dvb/fe-type-t.rst
+++ b/Documentation/media/uapi/dvb/fe-type-t.rst
@@ -78,7 +78,7 @@ parameter.
 
 In the old days, struct :c:type:`dvb_frontend_info`
 used to contain ``fe_type_t`` field to indicate the delivery systems,
-filled with either FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC. While this
+filled with either ``FE_QPSK, FE_QAM, FE_OFDM`` or ``FE_ATSC``. While this
 is still filled to keep backward compatibility, the usage of this field
 is deprecated, as it can report just one delivery system, but some
 devices support multiple delivery systems. Please use
-- 
2.13.5
