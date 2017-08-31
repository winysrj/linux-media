Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44950
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751980AbdHaXrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 07/15] media: dvb frontend docs: use kernel-doc documentation
Date: Thu, 31 Aug 2017 20:46:54 -0300
Message-Id: <085d257cf0d7a3a183ffa5e22544e316bdb6658c.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that frontend.h contains most documentation for the frontend,
remove the duplicated information from Documentation/ and use the
kernel-doc auto-generated one instead.

That should simplify maintainership of DVB frontend uAPI, as most
of the documentation will stick with the header file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/frontend.h.rst.exceptions      |  185 ++-
 Documentation/media/uapi/dvb/dtv-fe-stats.rst      |   17 -
 Documentation/media/uapi/dvb/dtv-properties.rst    |   15 -
 Documentation/media/uapi/dvb/dtv-property.rst      |   31 -
 Documentation/media/uapi/dvb/dtv-stats.rst         |   18 -
 Documentation/media/uapi/dvb/dvbproperty-006.rst   |   12 -
 Documentation/media/uapi/dvb/dvbproperty.rst       |   28 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |   40 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |   31 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |   29 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  370 +-----
 Documentation/media/uapi/dvb/fe-get-property.rst   |    2 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |   83 --
 Documentation/media/uapi/dvb/fe-set-tone.rst       |   30 -
 .../media/uapi/dvb/fe_property_parameters.rst      | 1277 ++------------------
 Documentation/media/uapi/dvb/frontend-header.rst   |    4 +
 include/uapi/linux/dvb/frontend.h                  |    8 +-
 17 files changed, 317 insertions(+), 1863 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/dtv-fe-stats.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-properties.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-property.rst
 delete mode 100644 Documentation/media/uapi/dvb/dtv-stats.rst
 delete mode 100644 Documentation/media/uapi/dvb/dvbproperty-006.rst
 create mode 100644 Documentation/media/uapi/dvb/frontend-header.rst

diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
index 7656770f1936..f7c4df620a52 100644
--- a/Documentation/media/frontend.h.rst.exceptions
+++ b/Documentation/media/frontend.h.rst.exceptions
@@ -25,19 +25,9 @@ ignore define DTV_MAX_COMMAND
 ignore define MAX_DTV_STATS
 ignore define DTV_IOCTL_MAX_MSGS
 
-# Stats enum is documented altogether
-replace enum fecap_scale_params :ref:`frontend-stat-properties`
-replace symbol FE_SCALE_COUNTER frontend-stat-properties
-replace symbol FE_SCALE_DECIBEL frontend-stat-properties
-replace symbol FE_SCALE_NOT_AVAILABLE frontend-stat-properties
-replace symbol FE_SCALE_RELATIVE frontend-stat-properties
-
 # the same reference is used for both get and set ioctls
 replace ioctl FE_SET_PROPERTY :c:type:`FE_GET_PROPERTY`
 
-# Ignore struct used only internally at Kernel
-ignore struct dtv_cmds_h
-
 # Typedefs that use the enum reference
 replace typedef fe_sec_voltage_t :c:type:`fe_sec_voltage`
 
@@ -45,3 +35,178 @@ replace typedef fe_sec_voltage_t :c:type:`fe_sec_voltage`
 replace define FE_TUNE_MODE_ONESHOT :c:func:`FE_SET_FRONTEND_TUNE_MODE`
 replace define LNA_AUTO dtv-lna
 replace define NO_STREAM_ID_FILTER dtv-stream-id
+
+# Those enums are defined at the frontend.h header, and not externally
+
+ignore symbol FE_IS_STUPID
+ignore symbol FE_CAN_INVERSION_AUTO
+ignore symbol FE_CAN_FEC_1_2
+ignore symbol FE_CAN_FEC_2_3
+ignore symbol FE_CAN_FEC_3_4
+ignore symbol FE_CAN_FEC_4_5
+ignore symbol FE_CAN_FEC_5_6
+ignore symbol FE_CAN_FEC_6_7
+ignore symbol FE_CAN_FEC_7_8
+ignore symbol FE_CAN_FEC_8_9
+ignore symbol FE_CAN_FEC_AUTO
+ignore symbol FE_CAN_QPSK
+ignore symbol FE_CAN_QAM_16
+ignore symbol FE_CAN_QAM_32
+ignore symbol FE_CAN_QAM_64
+ignore symbol FE_CAN_QAM_128
+ignore symbol FE_CAN_QAM_256
+ignore symbol FE_CAN_QAM_AUTO
+ignore symbol FE_CAN_TRANSMISSION_MODE_AUTO
+ignore symbol FE_CAN_BANDWIDTH_AUTO
+ignore symbol FE_CAN_GUARD_INTERVAL_AUTO
+ignore symbol FE_CAN_HIERARCHY_AUTO
+ignore symbol FE_CAN_8VSB
+ignore symbol FE_CAN_16VSB
+ignore symbol FE_HAS_EXTENDED_CAPS
+ignore symbol FE_CAN_MULTISTREAM
+ignore symbol FE_CAN_TURBO_FEC
+ignore symbol FE_CAN_2G_MODULATION
+ignore symbol FE_NEEDS_BENDING
+ignore symbol FE_CAN_RECOVER
+ignore symbol FE_CAN_MUTE_TS
+
+ignore symbol QPSK
+ignore symbol QAM_16
+ignore symbol QAM_32
+ignore symbol QAM_64
+ignore symbol QAM_128
+ignore symbol QAM_256
+ignore symbol QAM_AUTO
+ignore symbol VSB_8
+ignore symbol VSB_16
+ignore symbol PSK_8
+ignore symbol APSK_16
+ignore symbol APSK_32
+ignore symbol DQPSK
+ignore symbol QAM_4_NR
+
+ignore symbol SEC_VOLTAGE_13
+ignore symbol SEC_VOLTAGE_18
+ignore symbol SEC_VOLTAGE_OFF
+
+ignore symbol SEC_TONE_ON
+ignore symbol SEC_TONE_OFF
+
+ignore symbol SEC_MINI_A
+ignore symbol SEC_MINI_B
+
+ignore symbol FE_NONE
+ignore symbol FE_HAS_SIGNAL
+ignore symbol FE_HAS_CARRIER
+ignore symbol FE_HAS_VITERBI
+ignore symbol FE_HAS_SYNC
+ignore symbol FE_HAS_LOCK
+ignore symbol FE_REINIT
+ignore symbol FE_TIMEDOUT
+
+ignore symbol FEC_NONE
+ignore symbol FEC_1_2
+ignore symbol FEC_2_3
+ignore symbol FEC_3_4
+ignore symbol FEC_4_5
+ignore symbol FEC_5_6
+ignore symbol FEC_6_7
+ignore symbol FEC_7_8
+ignore symbol FEC_8_9
+ignore symbol FEC_AUTO
+ignore symbol FEC_3_5
+ignore symbol FEC_9_10
+ignore symbol FEC_2_5
+
+ignore symbol TRANSMISSION_MODE_AUTO
+ignore symbol TRANSMISSION_MODE_1K
+ignore symbol TRANSMISSION_MODE_2K
+ignore symbol TRANSMISSION_MODE_8K
+ignore symbol TRANSMISSION_MODE_4K
+ignore symbol TRANSMISSION_MODE_16K
+ignore symbol TRANSMISSION_MODE_32K
+ignore symbol TRANSMISSION_MODE_C1
+ignore symbol TRANSMISSION_MODE_C3780
+ignore symbol TRANSMISSION_MODE_2K
+ignore symbol TRANSMISSION_MODE_8K
+
+ignore symbol GUARD_INTERVAL_AUTO
+ignore symbol GUARD_INTERVAL_1_128
+ignore symbol GUARD_INTERVAL_1_32
+ignore symbol GUARD_INTERVAL_1_16
+ignore symbol GUARD_INTERVAL_1_8
+ignore symbol GUARD_INTERVAL_1_4
+ignore symbol GUARD_INTERVAL_19_128
+ignore symbol GUARD_INTERVAL_19_256
+ignore symbol GUARD_INTERVAL_PN420
+ignore symbol GUARD_INTERVAL_PN595
+ignore symbol GUARD_INTERVAL_PN945
+
+ignore symbol HIERARCHY_NONE
+ignore symbol HIERARCHY_AUTO
+ignore symbol HIERARCHY_1
+ignore symbol HIERARCHY_2
+ignore symbol HIERARCHY_4
+
+ignore symbol INTERLEAVING_NONE
+ignore symbol INTERLEAVING_AUTO
+ignore symbol INTERLEAVING_240
+ignore symbol INTERLEAVING_720
+
+ignore symbol PILOT_ON
+ignore symbol PILOT_OFF
+ignore symbol PILOT_AUTO
+
+ignore symbol ROLLOFF_35
+ignore symbol ROLLOFF_20
+ignore symbol ROLLOFF_25
+ignore symbol ROLLOFF_AUTO
+
+ignore symbol INVERSION_ON
+ignore symbol INVERSION_OFF
+ignore symbol INVERSION_AUTO
+
+ignore symbol SYS_UNDEFINED
+ignore symbol SYS_DVBC_ANNEX_A
+ignore symbol SYS_DVBC_ANNEX_B
+ignore symbol SYS_DVBC_ANNEX_C
+ignore symbol SYS_ISDBC
+ignore symbol SYS_DVBT
+ignore symbol SYS_DVBT2
+ignore symbol SYS_ISDBT
+ignore symbol SYS_ATSC
+ignore symbol SYS_ATSCMH
+ignore symbol SYS_DTMB
+ignore symbol SYS_DVBS
+ignore symbol SYS_DVBS2
+ignore symbol SYS_TURBO
+ignore symbol SYS_ISDBS
+ignore symbol SYS_DAB
+ignore symbol SYS_DSS
+ignore symbol SYS_CMMB
+ignore symbol SYS_DVBH
+
+ignore symbol ATSCMH_SCCC_BLK_SEP
+ignore symbol ATSCMH_SCCC_BLK_COMB
+ignore symbol ATSCMH_SCCC_BLK_RES
+
+ignore symbol ATSCMH_SCCC_CODE_HLF
+ignore symbol ATSCMH_SCCC_CODE_QTR
+ignore symbol ATSCMH_SCCC_CODE_RES
+
+ignore symbol ATSCMH_RSFRAME_ENS_PRI
+ignore symbol ATSCMH_RSFRAME_ENS_SEC
+
+ignore symbol ATSCMH_RSFRAME_PRI_ONLY
+ignore symbol ATSCMH_RSFRAME_PRI_SEC
+ignore symbol ATSCMH_RSFRAME_RES
+
+ignore symbol ATSCMH_RSCODE_211_187
+ignore symbol ATSCMH_RSCODE_223_187
+ignore symbol ATSCMH_RSCODE_235_187
+ignore symbol ATSCMH_RSCODE_RES
+
+ignore symbol FE_SCALE_NOT_AVAILABLE
+ignore symbol FE_SCALE_DECIBEL
+ignore symbol FE_SCALE_RELATIVE
+ignore symbol FE_SCALE_COUNTER
diff --git a/Documentation/media/uapi/dvb/dtv-fe-stats.rst b/Documentation/media/uapi/dvb/dtv-fe-stats.rst
deleted file mode 100644
index e8a02a1f138d..000000000000
--- a/Documentation/media/uapi/dvb/dtv-fe-stats.rst
+++ /dev/null
@@ -1,17 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. c:type:: dtv_fe_stats
-
-*******************
-struct dtv_fe_stats
-*******************
-
-
-.. code-block:: c
-
-    #define MAX_DTV_STATS   4
-
-    struct dtv_fe_stats {
-	__u8 len;
-	struct dtv_stats stat[MAX_DTV_STATS];
-    } __packed;
diff --git a/Documentation/media/uapi/dvb/dtv-properties.rst b/Documentation/media/uapi/dvb/dtv-properties.rst
deleted file mode 100644
index 48c4e834ad11..000000000000
--- a/Documentation/media/uapi/dvb/dtv-properties.rst
+++ /dev/null
@@ -1,15 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. c:type:: dtv_properties
-
-*********************
-struct dtv_properties
-*********************
-
-
-.. code-block:: c
-
-    struct dtv_properties {
-	__u32 num;
-	struct dtv_property *props;
-    };
diff --git a/Documentation/media/uapi/dvb/dtv-property.rst b/Documentation/media/uapi/dvb/dtv-property.rst
deleted file mode 100644
index 3ddc3474b00e..000000000000
--- a/Documentation/media/uapi/dvb/dtv-property.rst
+++ /dev/null
@@ -1,31 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. c:type:: dtv_property
-
-*******************
-struct dtv_property
-*******************
-
-
-.. code-block:: c
-
-    /* Reserved fields should be set to 0 */
-
-    struct dtv_property {
-	__u32 cmd;
-	__u32 reserved[3];
-	union {
-	    __u32 data;
-	    struct dtv_fe_stats st;
-	    struct {
-		__u8 data[32];
-		__u32 len;
-		__u32 reserved1[3];
-		void *reserved2;
-	    } buffer;
-	} u;
-	int result;
-    } __attribute__ ((packed));
-
-    /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
-    #define DTV_IOCTL_MAX_MSGS 64
diff --git a/Documentation/media/uapi/dvb/dtv-stats.rst b/Documentation/media/uapi/dvb/dtv-stats.rst
deleted file mode 100644
index 35239e72bf74..000000000000
--- a/Documentation/media/uapi/dvb/dtv-stats.rst
+++ /dev/null
@@ -1,18 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. c:type:: dtv_stats
-
-****************
-struct dtv_stats
-****************
-
-
-.. code-block:: c
-
-    struct dtv_stats {
-	__u8 scale; /* enum fecap_scale_params type */
-	union {
-	    __u64 uvalue;   /* for counters and relative scales */
-	    __s64 svalue;   /* for 1/1000 dB measures */
-	};
-    } __packed;
diff --git a/Documentation/media/uapi/dvb/dvbproperty-006.rst b/Documentation/media/uapi/dvb/dvbproperty-006.rst
deleted file mode 100644
index 3343a0f306fe..000000000000
--- a/Documentation/media/uapi/dvb/dvbproperty-006.rst
+++ /dev/null
@@ -1,12 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-**************
-Property types
-**************
-
-On :ref:`FE_GET_PROPERTY and FE_SET_PROPERTY <FE_GET_PROPERTY>`,
-the actual action is determined by the dtv_property cmd/data pairs.
-With one single ioctl, is possible to get/set up to 64 properties. The
-actual meaning of each property is described on the next sections.
-
-The available frontend property types are shown on the next section.
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 843f1d70aff0..c40943be5925 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -2,8 +2,9 @@
 
 .. _frontend-properties:
 
-DVB Frontend properties
-=======================
+**************
+Property types
+**************
 
 Tuning into a Digital TV physical channel and starting decoding it
 requires changing a set of parameters, in order to control the tuner,
@@ -20,10 +21,15 @@ enough to group the structs that would be required for those new
 standards. Also, extending it would break userspace.
 
 So, the legacy union/struct based approach was deprecated, in favor
-of a properties set approach.
+of a properties set approach. On such approach,
+:ref:`FE_GET_PROPERTY and FE_SET_PROPERTY <FE_GET_PROPERTY>` are used
+to setup the frontend and read its status.
+
+The actual action is determined by a set of dtv_property cmd/data pairs.
+With one single ioctl, is possible to get/set up to 64 properties.
 
 This section describes the new and recommended way to set the frontend,
-with suppports all digital TV delivery systems.
+with supports all digital TV delivery systems.
 
 .. note::
 
@@ -63,12 +69,9 @@ Mbauds, those properties should be sent to
 The code that would that would do the above is show in
 :ref:`dtv-prop-example`.
 
-.. _dtv-prop-example:
-
-Example: Setting digital TV frontend properties
-===============================================
-
 .. code-block:: c
+    :caption: Example: Setting digital TV frontend properties
+    :name: dtv-prop-example
 
     #include <stdio.h>
     #include <fcntl.h>
@@ -112,17 +115,12 @@ Example: Setting digital TV frontend properties
    provides methods for usual operations like program scanning and to
    read/write channel descriptor files.
 
-
 .. toctree::
     :maxdepth: 1
 
-    dtv-stats
-    dtv-fe-stats
-    dtv-property
-    dtv-properties
-    dvbproperty-006
     fe_property_parameters
     frontend-stat-properties
     frontend-property-terrestrial-systems
     frontend-property-cable-systems
     frontend-property-satellite-systems
+    frontend-header
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 302db2857f90..473855584d7f 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -26,8 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``argp``
-    pointer to struct
-    :c:type:`dvb_diseqc_slave_reply`
+    pointer to struct :c:type:`dvb_diseqc_slave_reply`.
 
 
 Description
@@ -35,42 +34,7 @@ Description
 
 Receives reply from a DiSEqC 2.0 command.
 
-.. c:type:: dvb_diseqc_slave_reply
-
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
-.. flat-table:: struct dvb_diseqc_slave_reply
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       1 1 2
-
-
-    -  .. row 1
-
-       -  uint8_t
-
-       -  msg[4]
-
-       -  DiSEqC message (framing, data[3])
-
-    -  .. row 2
-
-       -  uint8_t
-
-       -  msg_len
-
-       -  Length of the DiSEqC message. Valid values are 0 to 4, where 0
-	  means no msg
-
-    -  .. row 3
-
-       -  int
-
-       -  timeout
-
-       -  Return from ioctl after timeout ms with errorcode when no message
-	  was received
-
+The received message is stored at the buffer pointed by ``argp``.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index e962f6ec5aaf..54d35517e784 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``tone``
-    an integer enumered value described at :c:type:`fe_sec_mini_cmd`
+    An integer enumered value described at :c:type:`fe_sec_mini_cmd`.
 
 
 Description
@@ -39,35 +39,6 @@ read/write permissions.
 It provides support for what's specified at
 `Digital Satellite Equipment Control (DiSEqC) - Simple "ToneBurst" Detection Circuit specification. <http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf>`__
 
-.. c:type:: fe_sec_mini_cmd
-
-.. flat-table:: enum fe_sec_mini_cmd
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _SEC-MINI-A:
-
-	  ``SEC_MINI_A``
-
-       -  Sends a mini-DiSEqC 22kHz '0' Tone Burst to select satellite-A
-
-    -  .. row 3
-
-       -  .. _SEC-MINI-B:
-
-	  ``SEC_MINI_B``
-
-       -  Sends a mini-DiSEqC 22kHz '1' Data Burst to select satellite-B
-
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index bbcab3df39b5..7392d6747ad6 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -33,34 +33,7 @@ Arguments
 Description
 ===========
 
-Sends a DiSEqC command to the antenna subsystem.
-
-
-.. c:type:: dvb_diseqc_master_cmd
-
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
-.. flat-table:: struct dvb_diseqc_master_cmd
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       1 1 2
-
-
-    -  .. row 1
-
-       -  uint8_t
-
-       -  msg[6]
-
-       -  DiSEqC message (framing, address, command, data[3])
-
-    -  .. row 2
-
-       -  uint8_t
-
-       -  msg_len
-
-       -  Length of the DiSEqC message. Valid values are 3 to 6
+Sends the DiSEqC command pointed by ``argp`` to the antenna subsystem.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index e3d64b251f61..30dde8a791f3 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -40,112 +40,6 @@ takes a pointer to dvb_frontend_info which is filled by the driver.
 When the driver is not compatible with this specification the ioctl
 returns an error.
 
-.. c:type:: dvb_frontend_info
-
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
-
-.. flat-table:: struct dvb_frontend_info
-    :header-rows:  0
-    :stub-columns: 0
-    :widths:       1 1 2
-
-
-    -  .. row 1
-
-       -  char
-
-       -  name[128]
-
-       -  Name of the frontend
-
-    -  .. row 2
-
-       -  fe_type_t
-
-       -  type
-
-       -  **DEPRECATED**. DVBv3 type. Should not be used on modern programs,
-	  as a frontend may have more than one type. So, the DVBv5 API
-	  should be used instead to enumerate and select the frontend type.
-
-    -  .. row 3
-
-       -  uint32_t
-
-       -  frequency_min
-
-       -  Minimal frequency supported by the frontend
-
-    -  .. row 4
-
-       -  uint32_t
-
-       -  frequency_max
-
-       -  Maximal frequency supported by the frontend
-
-    -  .. row 5
-
-       -  uint32_t
-
-       -  frequency_stepsize
-
-       -  Frequency step - all frequencies are multiple of this value
-
-    -  .. row 6
-
-       -  uint32_t
-
-       -  frequency_tolerance
-
-       -  Tolerance of the frequency
-
-    -  .. row 7
-
-       -  uint32_t
-
-       -  symbol_rate_min
-
-       -  Minimal symbol rate (for Cable/Satellite systems), in bauds
-
-    -  .. row 8
-
-       -  uint32_t
-
-       -  symbol_rate_max
-
-       -  Maximal symbol rate (for Cable/Satellite systems), in bauds
-
-    -  .. row 9
-
-       -  uint32_t
-
-       -  symbol_rate_tolerance
-
-       -  Maximal symbol rate tolerance, in ppm
-
-    -  .. row 10
-
-       -  uint32_t
-
-       -  notifier_delay
-
-       -  **DEPRECATED**. Not used by any driver.
-
-    -  .. row 11
-
-       -  enum :c:type:`fe_caps`
-
-       -  caps
-
-       -  Capabilities supported by the frontend
-
-
-.. note::
-
-   The frequencies are specified in Hz for Terrestrial and Cable
-   systems. They're specified in kHz for Satellite systems
-
 
 frontend capabilities
 =====================
@@ -153,269 +47,7 @@ frontend capabilities
 Capabilities describe what a frontend can do. Some capabilities are
 supported only on some specific frontend types.
 
-.. c:type:: fe_caps
-
-.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
-
-.. flat-table:: enum fe_caps
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _FE-IS-STUPID:
-
-	  ``FE_IS_STUPID``
-
-       -  There's something wrong at the frontend, and it can't report its
-	  capabilities
-
-    -  .. row 3
-
-       -  .. _FE-CAN-INVERSION-AUTO:
-
-	  ``FE_CAN_INVERSION_AUTO``
-
-       -  The frontend is capable of auto-detecting inversion
-
-    -  .. row 4
-
-       -  .. _FE-CAN-FEC-1-2:
-
-	  ``FE_CAN_FEC_1_2``
-
-       -  The frontend supports FEC 1/2
-
-    -  .. row 5
-
-       -  .. _FE-CAN-FEC-2-3:
-
-	  ``FE_CAN_FEC_2_3``
-
-       -  The frontend supports FEC 2/3
-
-    -  .. row 6
-
-       -  .. _FE-CAN-FEC-3-4:
-
-	  ``FE_CAN_FEC_3_4``
-
-       -  The frontend supports FEC 3/4
-
-    -  .. row 7
-
-       -  .. _FE-CAN-FEC-4-5:
-
-	  ``FE_CAN_FEC_4_5``
-
-       -  The frontend supports FEC 4/5
-
-    -  .. row 8
-
-       -  .. _FE-CAN-FEC-5-6:
-
-	  ``FE_CAN_FEC_5_6``
-
-       -  The frontend supports FEC 5/6
-
-    -  .. row 9
-
-       -  .. _FE-CAN-FEC-6-7:
-
-	  ``FE_CAN_FEC_6_7``
-
-       -  The frontend supports FEC 6/7
-
-    -  .. row 10
-
-       -  .. _FE-CAN-FEC-7-8:
-
-	  ``FE_CAN_FEC_7_8``
-
-       -  The frontend supports FEC 7/8
-
-    -  .. row 11
-
-       -  .. _FE-CAN-FEC-8-9:
-
-	  ``FE_CAN_FEC_8_9``
-
-       -  The frontend supports FEC 8/9
-
-    -  .. row 12
-
-       -  .. _FE-CAN-FEC-AUTO:
-
-	  ``FE_CAN_FEC_AUTO``
-
-       -  The frontend can autodetect FEC.
-
-    -  .. row 13
-
-       -  .. _FE-CAN-QPSK:
-
-	  ``FE_CAN_QPSK``
-
-       -  The frontend supports QPSK modulation
-
-    -  .. row 14
-
-       -  .. _FE-CAN-QAM-16:
-
-	  ``FE_CAN_QAM_16``
-
-       -  The frontend supports 16-QAM modulation
-
-    -  .. row 15
-
-       -  .. _FE-CAN-QAM-32:
-
-	  ``FE_CAN_QAM_32``
-
-       -  The frontend supports 32-QAM modulation
-
-    -  .. row 16
-
-       -  .. _FE-CAN-QAM-64:
-
-	  ``FE_CAN_QAM_64``
-
-       -  The frontend supports 64-QAM modulation
-
-    -  .. row 17
-
-       -  .. _FE-CAN-QAM-128:
-
-	  ``FE_CAN_QAM_128``
-
-       -  The frontend supports 128-QAM modulation
-
-    -  .. row 18
-
-       -  .. _FE-CAN-QAM-256:
-
-	  ``FE_CAN_QAM_256``
-
-       -  The frontend supports 256-QAM modulation
-
-    -  .. row 19
-
-       -  .. _FE-CAN-QAM-AUTO:
-
-	  ``FE_CAN_QAM_AUTO``
-
-       -  The frontend can autodetect modulation
-
-    -  .. row 20
-
-       -  .. _FE-CAN-TRANSMISSION-MODE-AUTO:
-
-	  ``FE_CAN_TRANSMISSION_MODE_AUTO``
-
-       -  The frontend can autodetect the transmission mode
-
-    -  .. row 21
-
-       -  .. _FE-CAN-BANDWIDTH-AUTO:
-
-	  ``FE_CAN_BANDWIDTH_AUTO``
-
-       -  The frontend can autodetect the bandwidth
-
-    -  .. row 22
-
-       -  .. _FE-CAN-GUARD-INTERVAL-AUTO:
-
-	  ``FE_CAN_GUARD_INTERVAL_AUTO``
-
-       -  The frontend can autodetect the guard interval
-
-    -  .. row 23
-
-       -  .. _FE-CAN-HIERARCHY-AUTO:
-
-	  ``FE_CAN_HIERARCHY_AUTO``
-
-       -  The frontend can autodetect hierarch
-
-    -  .. row 24
-
-       -  .. _FE-CAN-8VSB:
-
-	  ``FE_CAN_8VSB``
-
-       -  The frontend supports 8-VSB modulation
-
-    -  .. row 25
-
-       -  .. _FE-CAN-16VSB:
-
-	  ``FE_CAN_16VSB``
-
-       -  The frontend supports 16-VSB modulation
-
-    -  .. row 26
-
-       -  .. _FE-HAS-EXTENDED-CAPS:
-
-	  ``FE_HAS_EXTENDED_CAPS``
-
-       -  Currently, unused
-
-    -  .. row 27
-
-       -  .. _FE-CAN-MULTISTREAM:
-
-	  ``FE_CAN_MULTISTREAM``
-
-       -  The frontend supports multistream filtering
-
-    -  .. row 28
-
-       -  .. _FE-CAN-TURBO-FEC:
-
-	  ``FE_CAN_TURBO_FEC``
-
-       -  The frontend supports turbo FEC modulation
-
-    -  .. row 29
-
-       -  .. _FE-CAN-2G-MODULATION:
-
-	  ``FE_CAN_2G_MODULATION``
-
-       -  The frontend supports "2nd generation modulation" (DVB-S2/T2)>
-
-    -  .. row 30
-
-       -  .. _FE-NEEDS-BENDING:
-
-	  ``FE_NEEDS_BENDING``
-
-       -  Not supported anymore, don't use it
-
-    -  .. row 31
-
-       -  .. _FE-CAN-RECOVER:
-
-	  ``FE_CAN_RECOVER``
-
-       -  The frontend can recover from a cable unplug automatically
-
-    -  .. row 32
-
-       -  .. _FE-CAN-MUTE-TS:
-
-	  ``FE_CAN_MUTE_TS``
-
-       -  The frontend can stop spurious TS data output
+The frontend capabilities are described at :c:type:`fe_caps`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 015d4db597b5..b22e37c4a787 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -29,7 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``argp``
-    pointer to struct :c:type:`dtv_properties`
+    Pointer to struct :c:type:`dtv_properties`.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 76b93e386552..21b2db3591fd 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -52,89 +52,6 @@ The fe_status parameter is used to indicate the current state and/or
 state changes of the frontend hardware. It is produced using the enum
 :c:type:`fe_status` values on a bitmask
 
-.. c:type:: fe_status
-
-.. tabularcolumns:: |p{3.5cm}|p{14.0cm}|
-
-.. _fe-status:
-
-.. flat-table:: enum fe_status
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _FE-NONE:
-
-	  ``FE_NONE``
-
-       -  The frontend doesn't have any kind of lock. That's the initial frontend status
-
-    -  .. row 3
-
-       -  .. _FE-HAS-SIGNAL:
-
-	  ``FE_HAS_SIGNAL``
-
-       -  The frontend has found something above the noise level
-
-    -  .. row 4
-
-       -  .. _FE-HAS-CARRIER:
-
-	  ``FE_HAS_CARRIER``
-
-       -  The frontend has found a DVB signal
-
-    -  .. row 5
-
-       -  .. _FE-HAS-VITERBI:
-
-	  ``FE_HAS_VITERBI``
-
-       -  The frontend FEC inner coding (Viterbi, LDPC or other inner code)
-	  is stable
-
-    -  .. row 6
-
-       -  .. _FE-HAS-SYNC:
-
-	  ``FE_HAS_SYNC``
-
-       -  Synchronization bytes was found
-
-    -  .. row 7
-
-       -  .. _FE-HAS-LOCK:
-
-	  ``FE_HAS_LOCK``
-
-       -  The DVB were locked and everything is working
-
-    -  .. row 8
-
-       -  .. _FE-TIMEDOUT:
-
-	  ``FE_TIMEDOUT``
-
-       -  no lock within the last about 2 seconds
-
-    -  .. row 9
-
-       -  .. _FE-REINIT:
-
-	  ``FE_REINIT``
-
-       -  The frontend was reinitialized, application is recommended to
-	  reset DiSEqC, tone and parameters
-
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index 84e4da3fd4c9..d0950acbbe64 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -45,36 +45,6 @@ this is done using the DiSEqC ioctls.
    capability of selecting the band. So, it is recommended that applications
    would change to SEC_TONE_OFF when the device is not used.
 
-.. c:type:: fe_sec_tone_mode
-
-.. flat-table:: enum fe_sec_tone_mode
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _SEC-TONE-ON:
-
-	  ``SEC_TONE_ON``
-
-       -  Sends a 22kHz tone burst to the antenna
-
-    -  .. row 3
-
-       -  .. _SEC-TONE-OFF:
-
-	  ``SEC_TONE_OFF``
-
-       -  Don't send a 22kHz tone to the antenna (except if the
-	  FE_DISEQC_* ioctls are called)
-
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 7bb7559c4500..c6eb74f59b00 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -6,6 +6,11 @@
 Digital TV property parameters
 ******************************
 
+There are several different Digital TV parameters that can be used by
+:ref:`FE_SET_PROPERTY and FE_GET_PROPERTY ioctls<FE_GET_PROPERTY>`.
+This section describes each of them. Please notice, however, that only
+a subset of them are needed to setup a frontend.
+
 
 .. _DTV-UNDEFINED:
 
@@ -67,144 +72,36 @@ DTV_MODULATION
 ==============
 
 Specifies the frontend modulation type for delivery systems that
-supports more than one modulation type. The modulation can be one of the
-types defined by enum :c:type:`fe_modulation`.
-
-
-.. c:type:: fe_modulation
-
-Modulation property
--------------------
-
-Most of the digital TV standards currently offers more than one possible
-modulation (sometimes called as "constellation" on some standards). This
-enum contains the values used by the Kernel. Please note that not all
-modulations are supported by a given standard.
-
-
-.. flat-table:: enum fe_modulation
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _QPSK:
-
-	  ``QPSK``
-
-       -  QPSK modulation
-
-    -  .. row 3
-
-       -  .. _QAM-16:
-
-	  ``QAM_16``
-
-       -  16-QAM modulation
-
-    -  .. row 4
-
-       -  .. _QAM-32:
-
-	  ``QAM_32``
-
-       -  32-QAM modulation
-
-    -  .. row 5
-
-       -  .. _QAM-64:
-
-	  ``QAM_64``
-
-       -  64-QAM modulation
-
-    -  .. row 6
-
-       -  .. _QAM-128:
-
-	  ``QAM_128``
-
-       -  128-QAM modulation
-
-    -  .. row 7
-
-       -  .. _QAM-256:
-
-	  ``QAM_256``
-
-       -  256-QAM modulation
-
-    -  .. row 8
-
-       -  .. _QAM-AUTO:
-
-	  ``QAM_AUTO``
-
-       -  Autodetect QAM modulation
-
-    -  .. row 9
-
-       -  .. _VSB-8:
-
-	  ``VSB_8``
-
-       -  8-VSB modulation
-
-    -  .. row 10
-
-       -  .. _VSB-16:
-
-	  ``VSB_16``
-
-       -  16-VSB modulation
-
-    -  .. row 11
-
-       -  .. _PSK-8:
-
-	  ``PSK_8``
-
-       -  8-PSK modulation
-
-    -  .. row 12
-
-       -  .. _APSK-16:
-
-	  ``APSK_16``
-
-       -  16-APSK modulation
-
-    -  .. row 13
-
-       -  .. _APSK-32:
-
-	  ``APSK_32``
-
-       -  32-APSK modulation
-
-    -  .. row 14
-
-       -  .. _DQPSK:
-
-	  ``DQPSK``
-
-       -  DQPSK modulation
-
-    -  .. row 15
-
-       -  .. _QAM-4-NR:
-
-	  ``QAM_4_NR``
-
-       -  4-QAM-NR modulation
-
+supports more multiple modulations.
+
+The modulation can be one of the types defined by enum :c:type:`fe_modulation`.
+
+Most of the digital TV standards offers more than one possible
+modulation type.
+
+The table below presents a summary of the types of modulation types
+supported by each delivery system, as currently defined by specs.
+
+======================= =======================================================
+Standard		Modulation types
+======================= =======================================================
+ATSC (version 1)	8-VSB and 16-VSB.
+DMTB			4-QAM, 16-QAM, 32-QAM, 64-QAM and 4-QAM-NR.
+DVB-C Annex A/C		16-QAM, 32-QAM, 64-QAM and 256-QAM.
+DVB-C Annex B		64-QAM.
+DVB-T			QPSK, 16-QAM and 64-QAM.
+DVB-T2			QPSK, 16-QAM, 64-QAM and 256-QAM.
+DVB-S			No need to set. It supports only QPSK.
+DVB-S2			QPSK, 8-PSK, 16-APSK and 32-APSK.
+ISDB-T			QPSK, DQPSK, 16-QAM and 64-QAM.
+ISDB-S			8-PSK, QPSK and BPSK.
+======================= =======================================================
+
+.. note::
+
+   Please notice that some of the above modulation types may not be
+   defined currently at the Kernel. The reason is simple: no driver
+   needed such definition yet.
 
 
 .. _DTV-BANDWIDTH-HZ:
@@ -249,54 +146,7 @@ DTV_INVERSION
 
 Specifies if the frontend should do spectral inversion or not.
 
-.. c:type:: fe_spectral_inversion
-
-enum fe_modulation: Frontend spectral inversion
------------------------------------------------
-
-This parameter indicates if spectral inversion should be presumed or
-not. In the automatic setting (``INVERSION_AUTO``) the hardware will try
-to figure out the correct setting by itself. If the hardware doesn't
-support, the DVB core will try to lock at the carrier first with
-inversion off. If it fails, it will try to enable inversion.
-
-
-.. flat-table:: enum fe_modulation
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _INVERSION-OFF:
-
-	  ``INVERSION_OFF``
-
-       -  Don't do spectral band inversion.
-
-    -  .. row 3
-
-       -  .. _INVERSION-ON:
-
-	  ``INVERSION_ON``
-
-       -  Do spectral band inversion.
-
-    -  .. row 4
-
-       -  .. _INVERSION-AUTO:
-
-	  ``INVERSION_AUTO``
-
-       -  Autodetect spectral band inversion.
-
-
+The acceptable values are defined by :c:type:`fe_spectral_inversion`.
 
 .. _DTV-DISEQC-MASTER:
 
@@ -320,128 +170,9 @@ standards.
 DTV_INNER_FEC
 =============
 
-Used cable/satellite transmissions. The acceptable values are:
-
-.. c:type:: fe_code_rate
-
-enum fe_code_rate: type of the Forward Error Correction.
---------------------------------------------------------
-
-.. flat-table:: enum fe_code_rate
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _FEC-NONE:
-
-	  ``FEC_NONE``
-
-       -  No Forward Error Correction Code
-
-    -  .. row 3
-
-       -  .. _FEC-AUTO:
-
-	  ``FEC_AUTO``
-
-       -  Autodetect Error Correction Code
-
-    -  .. row 4
-
-       -  .. _FEC-1-2:
-
-	  ``FEC_1_2``
-
-       -  Forward Error Correction Code 1/2
-
-    -  .. row 5
-
-       -  .. _FEC-2-3:
-
-	  ``FEC_2_3``
-
-       -  Forward Error Correction Code 2/3
-
-    -  .. row 6
-
-       -  .. _FEC-3-4:
-
-	  ``FEC_3_4``
-
-       -  Forward Error Correction Code 3/4
-
-    -  .. row 7
-
-       -  .. _FEC-4-5:
-
-	  ``FEC_4_5``
-
-       -  Forward Error Correction Code 4/5
-
-    -  .. row 8
-
-       -  .. _FEC-5-6:
-
-	  ``FEC_5_6``
-
-       -  Forward Error Correction Code 5/6
-
-    -  .. row 9
-
-       -  .. _FEC-6-7:
-
-	  ``FEC_6_7``
-
-       -  Forward Error Correction Code 6/7
-
-    -  .. row 10
-
-       -  .. _FEC-7-8:
-
-	  ``FEC_7_8``
-
-       -  Forward Error Correction Code 7/8
-
-    -  .. row 11
-
-       -  .. _FEC-8-9:
-
-	  ``FEC_8_9``
-
-       -  Forward Error Correction Code 8/9
-
-    -  .. row 12
-
-       -  .. _FEC-9-10:
-
-	  ``FEC_9_10``
-
-       -  Forward Error Correction Code 9/10
-
-    -  .. row 13
-
-       -  .. _FEC-2-5:
-
-	  ``FEC_2_5``
-
-       -  Forward Error Correction Code 2/5
-
-    -  .. row 14
-
-       -  .. _FEC-3-5:
-
-	  ``FEC_3_5``
-
-       -  Forward Error Correction Code 3/5
+Used cable/satellite transmissions.
 
+The acceptable values are defined by :c:type:`fe_code_rate`.
 
 
 .. _DTV-VOLTAGE:
@@ -454,44 +185,7 @@ polarzation (horizontal/vertical). When using DiSEqC epuipment this
 voltage has to be switched consistently to the DiSEqC commands as
 described in the DiSEqC spec.
 
-
-.. c:type:: fe_sec_voltage
-
-.. flat-table:: enum fe_sec_voltage
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _SEC-VOLTAGE-13:
-
-	  ``SEC_VOLTAGE_13``
-
-       -  Set DC voltage level to 13V
-
-    -  .. row 3
-
-       -  .. _SEC-VOLTAGE-18:
-
-	  ``SEC_VOLTAGE_18``
-
-       -  Set DC voltage level to 18V
-
-    -  .. row 4
-
-       -  .. _SEC-VOLTAGE-OFF:
-
-	  ``SEC_VOLTAGE_OFF``
-
-       -  Don't send any voltage to the antenna
-
+The acceptable values are defined by :c:type:`fe_sec_voltage`.
 
 
 .. _DTV-TONE:
@@ -507,50 +201,9 @@ Currently not used.
 DTV_PILOT
 =========
 
-Sets DVB-S2 pilot
-
-
-.. c:type:: fe_pilot
-
-fe_pilot type
--------------
-
-
-.. flat-table:: enum fe_pilot
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _PILOT-ON:
-
-	  ``PILOT_ON``
-
-       -  Pilot tones enabled
-
-    -  .. row 3
-
-       -  .. _PILOT-OFF:
-
-	  ``PILOT_OFF``
-
-       -  Pilot tones disabled
-
-    -  .. row 4
-
-       -  .. _PILOT-AUTO:
-
-	  ``PILOT_AUTO``
-
-       -  Autodetect pilot tones
+Sets DVB-S2 pilot.
 
+The acceptable values are defined by :c:type:`fe_pilot`.
 
 
 .. _DTV-ROLLOFF:
@@ -560,56 +213,7 @@ DTV_ROLLOFF
 
 Sets DVB-S2 rolloff
 
-
-.. c:type:: fe_rolloff
-
-fe_rolloff type
----------------
-
-
-.. flat-table:: enum fe_rolloff
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ROLLOFF-35:
-
-	  ``ROLLOFF_35``
-
-       -  Roloff factor: α=35%
-
-    -  .. row 3
-
-       -  .. _ROLLOFF-20:
-
-	  ``ROLLOFF_20``
-
-       -  Roloff factor: α=20%
-
-    -  .. row 4
-
-       -  .. _ROLLOFF-25:
-
-	  ``ROLLOFF_25``
-
-       -  Roloff factor: α=25%
-
-    -  .. row 5
-
-       -  .. _ROLLOFF-AUTO:
-
-	  ``ROLLOFF_AUTO``
-
-       -  Auto-detect the roloff factor.
-
+The acceptable values are defined by :c:type:`fe_rolloff`.
 
 
 .. _DTV-DISEQC-SLAVE-REPLY:
@@ -641,180 +245,9 @@ Currently not implemented.
 DTV_DELIVERY_SYSTEM
 ===================
 
-Specifies the type of Delivery system
-
-
-.. c:type:: fe_delivery_system
-
-fe_delivery_system type
------------------------
-
-Possible values:
-
-
-.. flat-table:: enum fe_delivery_system
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _SYS-UNDEFINED:
-
-	  ``SYS_UNDEFINED``
-
-       -  Undefined standard. Generally, indicates an error
-
-    -  .. row 3
-
-       -  .. _SYS-DVBC-ANNEX-A:
-
-	  ``SYS_DVBC_ANNEX_A``
-
-       -  Cable TV: DVB-C following ITU-T J.83 Annex A spec
-
-    -  .. row 4
-
-       -  .. _SYS-DVBC-ANNEX-B:
-
-	  ``SYS_DVBC_ANNEX_B``
-
-       -  Cable TV: DVB-C following ITU-T J.83 Annex B spec (ClearQAM)
-
-    -  .. row 5
-
-       -  .. _SYS-DVBC-ANNEX-C:
-
-	  ``SYS_DVBC_ANNEX_C``
-
-       -  Cable TV: DVB-C following ITU-T J.83 Annex C spec
-
-    -  .. row 6
-
-       -  .. _SYS-ISDBC:
-
-	  ``SYS_ISDBC``
-
-       -  Cable TV: ISDB-C (no drivers yet)
-
-    -  .. row 7
-
-       -  .. _SYS-DVBT:
-
-	  ``SYS_DVBT``
-
-       -  Terrestral TV: DVB-T
-
-    -  .. row 8
-
-       -  .. _SYS-DVBT2:
-
-	  ``SYS_DVBT2``
-
-       -  Terrestral TV: DVB-T2
-
-    -  .. row 9
-
-       -  .. _SYS-ISDBT:
-
-	  ``SYS_ISDBT``
-
-       -  Terrestral TV: ISDB-T
-
-    -  .. row 10
-
-       -  .. _SYS-ATSC:
-
-	  ``SYS_ATSC``
-
-       -  Terrestral TV: ATSC
-
-    -  .. row 11
-
-       -  .. _SYS-ATSCMH:
-
-	  ``SYS_ATSCMH``
-
-       -  Terrestral TV (mobile): ATSC-M/H
-
-    -  .. row 12
-
-       -  .. _SYS-DTMB:
-
-	  ``SYS_DTMB``
-
-       -  Terrestrial TV: DTMB
-
-    -  .. row 13
-
-       -  .. _SYS-DVBS:
-
-	  ``SYS_DVBS``
-
-       -  Satellite TV: DVB-S
-
-    -  .. row 14
-
-       -  .. _SYS-DVBS2:
-
-	  ``SYS_DVBS2``
-
-       -  Satellite TV: DVB-S2
-
-    -  .. row 15
-
-       -  .. _SYS-TURBO:
-
-	  ``SYS_TURBO``
-
-       -  Satellite TV: DVB-S Turbo
-
-    -  .. row 16
-
-       -  .. _SYS-ISDBS:
-
-	  ``SYS_ISDBS``
-
-       -  Satellite TV: ISDB-S
-
-    -  .. row 17
-
-       -  .. _SYS-DAB:
-
-	  ``SYS_DAB``
-
-       -  Digital audio: DAB (not fully supported)
-
-    -  .. row 18
-
-       -  .. _SYS-DSS:
-
-	  ``SYS_DSS``
-
-       -  Satellite TV:"DSS (not fully supported)
-
-    -  .. row 19
-
-       -  .. _SYS-CMMB:
-
-	  ``SYS_CMMB``
-
-       -  Terrestral TV (mobile):CMMB (not fully supported)
-
-    -  .. row 20
-
-       -  .. _SYS-DVBH:
-
-	  ``SYS_DVBH``
-
-       -  Terrestral TV (mobile): DVB-H (standard deprecated)
+Specifies the type of Delivery system.
 
+The acceptable values are defined by :c:type:`fe_delivery_system`.
 
 
 .. _DTV-ISDBT-PARTIAL-RECEPTION:
@@ -964,7 +397,11 @@ Only the values of the first 3 bits are used. Other bits will be silently ignore
 DTV_ISDBT_LAYER[A-C]_FEC
 ------------------------
 
-Possible values: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
+The Forward Error Correction mechanism used by a given ISDB Layer, as
+defined by :c:type:`fe_code_rate`.
+
+
+Possible values are: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
 ``FEC_5_6``, ``FEC_7_8``
 
 
@@ -973,11 +410,17 @@ Possible values: ``FEC_AUTO``, ``FEC_1_2``, ``FEC_2_3``, ``FEC_3_4``,
 DTV_ISDBT_LAYER[A-C]_MODULATION
 -------------------------------
 
-Possible values: ``QAM_AUTO``, QP\ ``SK, QAM_16``, ``QAM_64``, ``DQPSK``
+The modulation used by a given ISDB Layer, as defined by
+:c:type:`fe_modulation`.
 
-Note: If layer C is ``DQPSK`` layer B has to be ``DQPSK``. If layer B is
-``DQPSK`` and ``DTV_ISDBT_PARTIAL_RECEPTION``\ =0 layer has to be
-``DQPSK``.
+Possible values are: ``QAM_AUTO``, ``QPSK``, ``QAM_16``, ``QAM_64``, ``DQPSK``
+
+.. note::
+
+   #. If layer C is ``DQPSK``, then layer B has to be ``DQPSK``.
+
+   #. If layer B is ``DQPSK`` and ``DTV_ISDBT_PARTIAL_RECEPTION``\ = 0,
+      then layer has to be ``DQPSK``.
 
 
 .. _DTV-ISDBT-LAYER-SEGMENT-COUNT:
@@ -993,15 +436,15 @@ Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
 .. _isdbt-layer_seg-cnt-table:
 
 .. flat-table:: Truth table for ISDB-T Sound Broadcasting
-    :header-rows:  0
+    :header-rows:  1
     :stub-columns: 0
 
 
     -  .. row 1
 
-       -  PR
+       -  Partial Reception
 
-       -  SB
+       -  Sound Broadcasting
 
        -  Layer A width
 
@@ -1086,7 +529,7 @@ TMCC-structure, as shown in the table below.
 .. c:type:: isdbt_layer_interleaving_table
 
 .. flat-table:: ISDB-T time interleaving modes
-    :header-rows:  0
+    :header-rows:  1
     :stub-columns: 0
 
 
@@ -1216,42 +659,7 @@ DTV_ATSCMH_RS_FRAME_MODE
 
 Reed Solomon (RS) frame mode.
 
-Possible values are:
-
-.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
-
-.. c:type:: atscmh_rs_frame_mode
-
-.. flat-table:: enum atscmh_rs_frame_mode
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ATSCMH-RSFRAME-PRI-ONLY:
-
-	  ``ATSCMH_RSFRAME_PRI_ONLY``
-
-       -  Single Frame: There is only a primary RS Frame for all Group
-	  Regions.
-
-    -  .. row 3
-
-       -  .. _ATSCMH-RSFRAME-PRI-SEC:
-
-	  ``ATSCMH_RSFRAME_PRI_SEC``
-
-       -  Dual Frame: There are two separate RS Frames: Primary RS Frame for
-	  Group Region A and B and Secondary RS Frame for Group Region C and
-	  D.
-
+The acceptable values are defined by :c:type:`atscmh_rs_frame_mode`.
 
 
 .. _DTV-ATSCMH-RS-FRAME-ENSEMBLE:
@@ -1261,46 +669,7 @@ DTV_ATSCMH_RS_FRAME_ENSEMBLE
 
 Reed Solomon(RS) frame ensemble.
 
-Possible values are:
-
-
-.. c:type:: atscmh_rs_frame_ensemble
-
-.. flat-table:: enum atscmh_rs_frame_ensemble
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ATSCMH-RSFRAME-ENS-PRI:
-
-	  ``ATSCMH_RSFRAME_ENS_PRI``
-
-       -  Primary Ensemble.
-
-    -  .. row 3
-
-       -  .. _ATSCMH-RSFRAME-ENS-SEC:
-
-	  ``AATSCMH_RSFRAME_PRI_SEC``
-
-       -  Secondary Ensemble.
-
-    -  .. row 4
-
-       -  .. _ATSCMH-RSFRAME-RES:
-
-	  ``AATSCMH_RSFRAME_RES``
-
-       -  Reserved. Shouldn't be used.
-
+The acceptable values are defined by :c:type:`atscmh_rs_frame_ensemble`.
 
 
 .. _DTV-ATSCMH-RS-CODE-MODE-PRI:
@@ -1310,54 +679,7 @@ DTV_ATSCMH_RS_CODE_MODE_PRI
 
 Reed Solomon (RS) code mode (primary).
 
-Possible values are:
-
-
-.. c:type:: atscmh_rs_code_mode
-
-.. flat-table:: enum atscmh_rs_code_mode
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ATSCMH-RSCODE-211-187:
-
-	  ``ATSCMH_RSCODE_211_187``
-
-       -  Reed Solomon code (211,187).
-
-    -  .. row 3
-
-       -  .. _ATSCMH-RSCODE-223-187:
-
-	  ``ATSCMH_RSCODE_223_187``
-
-       -  Reed Solomon code (223,187).
-
-    -  .. row 4
-
-       -  .. _ATSCMH-RSCODE-235-187:
-
-	  ``ATSCMH_RSCODE_235_187``
-
-       -  Reed Solomon code (235,187).
-
-    -  .. row 5
-
-       -  .. _ATSCMH-RSCODE-RES:
-
-	  ``ATSCMH_RSCODE_RES``
-
-       -  Reserved. Shouldn't be used.
-
+The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
 
 
 .. _DTV-ATSCMH-RS-CODE-MODE-SEC:
@@ -1367,8 +689,7 @@ DTV_ATSCMH_RS_CODE_MODE_SEC
 
 Reed Solomon (RS) code mode (secondary).
 
-Possible values are the same as documented on enum
-:c:type:`atscmh_rs_code_mode`:
+The acceptable values are defined by :c:type:`atscmh_rs_code_mode`.
 
 
 .. _DTV-ATSCMH-SCCC-BLOCK-MODE:
@@ -1378,49 +699,7 @@ DTV_ATSCMH_SCCC_BLOCK_MODE
 
 Series Concatenated Convolutional Code Block Mode.
 
-Possible values are:
-
-.. tabularcolumns:: |p{4.5cm}|p{13.0cm}|
-
-.. c:type:: atscmh_sccc_block_mode
-
-.. flat-table:: enum atscmh_scc_block_mode
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ATSCMH-SCCC-BLK-SEP:
-
-	  ``ATSCMH_SCCC_BLK_SEP``
-
-       -  Separate SCCC: the SCCC outer code mode shall be set independently
-	  for each Group Region (A, B, C, D)
-
-    -  .. row 3
-
-       -  .. _ATSCMH-SCCC-BLK-COMB:
-
-	  ``ATSCMH_SCCC_BLK_COMB``
-
-       -  Combined SCCC: all four Regions shall have the same SCCC outer
-	  code mode.
-
-    -  .. row 4
-
-       -  .. _ATSCMH-SCCC-BLK-RES:
-
-	  ``ATSCMH_SCCC_BLK_RES``
-
-       -  Reserved. Shouldn't be used.
-
+The acceptable values are defined by :c:type:`atscmh_sccc_block_mode`.
 
 
 .. _DTV-ATSCMH-SCCC-CODE-MODE-A:
@@ -1430,47 +709,7 @@ DTV_ATSCMH_SCCC_CODE_MODE_A
 
 Series Concatenated Convolutional Code Rate.
 
-Possible values are:
-
-
-.. c:type:: atscmh_sccc_code_mode
-
-.. flat-table:: enum atscmh_sccc_code_mode
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _ATSCMH-SCCC-CODE-HLF:
-
-	  ``ATSCMH_SCCC_CODE_HLF``
-
-       -  The outer code rate of a SCCC Block is 1/2 rate.
-
-    -  .. row 3
-
-       -  .. _ATSCMH-SCCC-CODE-QTR:
-
-	  ``ATSCMH_SCCC_CODE_QTR``
-
-       -  The outer code rate of a SCCC Block is 1/4 rate.
-
-    -  .. row 4
-
-       -  .. _ATSCMH-SCCC-CODE-RES:
-
-	  ``ATSCMH_SCCC_CODE_RES``
-
-       -  to be documented.
-
-
+The acceptable values are defined by :c:type:`atscmh_sccc_code_mode`.
 
 .. _DTV-ATSCMH-SCCC-CODE-MODE-B:
 
@@ -1518,8 +757,9 @@ Returns the major/minor version of the DVB API
 DTV_CODE_RATE_HP
 ================
 
-Used on terrestrial transmissions. The acceptable values are the ones
-described at :c:type:`fe_transmit_mode`.
+Used on terrestrial transmissions.
+
+The acceptable values are defined by :c:type:`fe_transmit_mode`.
 
 
 .. _DTV-CODE-RATE-LP:
@@ -1527,8 +767,9 @@ described at :c:type:`fe_transmit_mode`.
 DTV_CODE_RATE_LP
 ================
 
-Used on terrestrial transmissions. The acceptable values are the ones
-described at :c:type:`fe_transmit_mode`.
+Used on terrestrial transmissions.
+
+The acceptable values are defined by :c:type:`fe_transmit_mode`.
 
 
 .. _DTV-GUARD-INTERVAL:
@@ -1536,242 +777,54 @@ described at :c:type:`fe_transmit_mode`.
 DTV_GUARD_INTERVAL
 ==================
 
-Possible values are:
-
-
-.. c:type:: fe_guard_interval
-
-Modulation guard interval
--------------------------
-
-
-.. flat-table:: enum fe_guard_interval
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _GUARD-INTERVAL-AUTO:
-
-	  ``GUARD_INTERVAL_AUTO``
-
-       -  Autodetect the guard interval
-
-    -  .. row 3
-
-       -  .. _GUARD-INTERVAL-1-128:
-
-	  ``GUARD_INTERVAL_1_128``
-
-       -  Guard interval 1/128
-
-    -  .. row 4
-
-       -  .. _GUARD-INTERVAL-1-32:
-
-	  ``GUARD_INTERVAL_1_32``
-
-       -  Guard interval 1/32
-
-    -  .. row 5
-
-       -  .. _GUARD-INTERVAL-1-16:
-
-	  ``GUARD_INTERVAL_1_16``
-
-       -  Guard interval 1/16
-
-    -  .. row 6
-
-       -  .. _GUARD-INTERVAL-1-8:
-
-	  ``GUARD_INTERVAL_1_8``
-
-       -  Guard interval 1/8
-
-    -  .. row 7
-
-       -  .. _GUARD-INTERVAL-1-4:
-
-	  ``GUARD_INTERVAL_1_4``
-
-       -  Guard interval 1/4
-
-    -  .. row 8
-
-       -  .. _GUARD-INTERVAL-19-128:
-
-	  ``GUARD_INTERVAL_19_128``
-
-       -  Guard interval 19/128
-
-    -  .. row 9
-
-       -  .. _GUARD-INTERVAL-19-256:
-
-	  ``GUARD_INTERVAL_19_256``
-
-       -  Guard interval 19/256
-
-    -  .. row 10
-
-       -  .. _GUARD-INTERVAL-PN420:
-
-	  ``GUARD_INTERVAL_PN420``
-
-       -  PN length 420 (1/4)
-
-    -  .. row 11
-
-       -  .. _GUARD-INTERVAL-PN595:
-
-	  ``GUARD_INTERVAL_PN595``
-
-       -  PN length 595 (1/6)
-
-    -  .. row 12
-
-       -  .. _GUARD-INTERVAL-PN945:
-
-	  ``GUARD_INTERVAL_PN945``
-
-       -  PN length 945 (1/9)
-
-
-Notes:
-
-1) If ``DTV_GUARD_INTERVAL`` is set the ``GUARD_INTERVAL_AUTO`` the
-hardware will try to find the correct guard interval (if capable) and
-will use TMCC to fill in the missing parameters.
-
-2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at
-present
-
-3) DTMB specifies PN420, PN595 and PN945.
-
+The acceptable values are defined by :c:type:`fe_guard_interval`.
+
+.. note::
+
+   #. If ``DTV_GUARD_INTERVAL`` is set the ``GUARD_INTERVAL_AUTO`` the
+      hardware will try to find the correct guard interval (if capable) and
+      will use TMCC to fill in the missing parameters.
+   #. Intervals ``GUARD_INTERVAL_1_128``, ``GUARD_INTERVAL_19_128``
+      and ``GUARD_INTERVAL_19_256`` are used only for DVB-T2 at
+      present.
+   #. Intervals ``GUARD_INTERVAL_PN420``, ``GUARD_INTERVAL_PN595`` and
+      ``GUARD_INTERVAL_PN945`` are used only for DMTB at the present.
+      On such standard, only those intervals and ``GUARD_INTERVAL_AUTO``
+      are valid.
 
 .. _DTV-TRANSMISSION-MODE:
 
 DTV_TRANSMISSION_MODE
 =====================
 
-Specifies the number of carriers used by the standard. This is used only
-on OFTM-based standards, e. g. DVB-T/T2, ISDB-T, DTMB
+Specifies the FFT size (with corresponds to the approximate number of
+carriers) used by the standard. This is used only on OFTM-based standards,
+e. g. DVB-T/T2, ISDB-T, DTMB.
 
+The acceptable values are defined by :c:type:`fe_transmit_mode`.
 
-.. c:type:: fe_transmit_mode
+.. note::
 
-enum fe_transmit_mode: Number of carriers per channel
------------------------------------------------------
+   #. ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
+      **mode** on such standard, and are numbered from 1 to 3:
 
-.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
+      ====	========	========================
+      Mode	FFT size	Transmission mode
+      ====	========	========================
+      1		2K		``TRANSMISSION_MODE_2K``
+      2		4K		``TRANSMISSION_MODE_4K``
+      3		8K		``TRANSMISSION_MODE_8K``
+      ====	========	========================
 
-.. flat-table:: enum fe_transmit_mode
-    :header-rows:  1
-    :stub-columns: 0
+   #. If ``DTV_TRANSMISSION_MODE`` is set the ``TRANSMISSION_MODE_AUTO``
+      the hardware will try to find the correct FFT-size (if capable) and
+      will use TMCC to fill in the missing parameters.
 
+   #. DVB-T specifies 2K and 8K as valid sizes.
 
-    -  .. row 1
+   #. DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.
 
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _TRANSMISSION-MODE-AUTO:
-
-	  ``TRANSMISSION_MODE_AUTO``
-
-       -  Autodetect transmission mode. The hardware will try to find the
-	  correct FFT-size (if capable) to fill in the missing parameters.
-
-    -  .. row 3
-
-       -  .. _TRANSMISSION-MODE-1K:
-
-	  ``TRANSMISSION_MODE_1K``
-
-       -  Transmission mode 1K
-
-    -  .. row 4
-
-       -  .. _TRANSMISSION-MODE-2K:
-
-	  ``TRANSMISSION_MODE_2K``
-
-       -  Transmission mode 2K
-
-    -  .. row 5
-
-       -  .. _TRANSMISSION-MODE-8K:
-
-	  ``TRANSMISSION_MODE_8K``
-
-       -  Transmission mode 8K
-
-    -  .. row 6
-
-       -  .. _TRANSMISSION-MODE-4K:
-
-	  ``TRANSMISSION_MODE_4K``
-
-       -  Transmission mode 4K
-
-    -  .. row 7
-
-       -  .. _TRANSMISSION-MODE-16K:
-
-	  ``TRANSMISSION_MODE_16K``
-
-       -  Transmission mode 16K
-
-    -  .. row 8
-
-       -  .. _TRANSMISSION-MODE-32K:
-
-	  ``TRANSMISSION_MODE_32K``
-
-       -  Transmission mode 32K
-
-    -  .. row 9
-
-       -  .. _TRANSMISSION-MODE-C1:
-
-	  ``TRANSMISSION_MODE_C1``
-
-       -  Single Carrier (C=1) transmission mode (DTMB)
-
-    -  .. row 10
-
-       -  .. _TRANSMISSION-MODE-C3780:
-
-	  ``TRANSMISSION_MODE_C3780``
-
-       -  Multi Carrier (C=3780) transmission mode (DTMB)
-
-
-Notes:
-
-1) ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
-'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K
-
-2) If ``DTV_TRANSMISSION_MODE`` is set the ``TRANSMISSION_MODE_AUTO``
-the hardware will try to find the correct FFT-size (if capable) and will
-use TMCC to fill in the missing parameters.
-
-3) DVB-T specifies 2K and 8K as valid sizes.
-
-4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.
-
-5) DTMB specifies C1 and C3780.
+   #. DTMB specifies C1 and C3780.
 
 
 .. _DTV-HIERARCHY:
@@ -1779,66 +832,9 @@ use TMCC to fill in the missing parameters.
 DTV_HIERARCHY
 =============
 
-Frontend hierarchy
-
-
-.. c:type:: fe_hierarchy
-
-Frontend hierarchy
-------------------
-
-
-.. flat-table:: enum fe_hierarchy
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _HIERARCHY-NONE:
-
-	  ``HIERARCHY_NONE``
-
-       -  No hierarchy
-
-    -  .. row 3
-
-       -  .. _HIERARCHY-AUTO:
-
-	  ``HIERARCHY_AUTO``
-
-       -  Autodetect hierarchy (if supported)
-
-    -  .. row 4
-
-       -  .. _HIERARCHY-1:
-
-	  ``HIERARCHY_1``
-
-       -  Hierarchy 1
-
-    -  .. row 5
-
-       -  .. _HIERARCHY-2:
-
-	  ``HIERARCHY_2``
-
-       -  Hierarchy 2
-
-    -  .. row 6
-
-       -  .. _HIERARCHY-4:
-
-	  ``HIERARCHY_4``
-
-       -  Hierarchy 4
+Frontend hierarchy.
 
+The acceptable values are defined by :c:type:`fe_hierarchy`.
 
 
 .. _DTV-STREAM-ID:
@@ -1884,60 +880,17 @@ with it, rather than trying to use FE_GET_INFO. In the case of a
 legacy frontend, the result is just the same as with FE_GET_INFO, but
 in a more structured format
 
+The acceptable values are defined by :c:type:`fe_delivery_system`.
+
 
 .. _DTV-INTERLEAVING:
 
 DTV_INTERLEAVING
 ================
 
-Time interleaving to be used. Currently, used only on DTMB.
-
-
-.. c:type:: fe_interleaving
-
-.. flat-table:: enum fe_interleaving
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  .. _INTERLEAVING-NONE:
-
-	  ``INTERLEAVING_NONE``
-
-       -  No interleaving.
-
-    -  .. row 3
-
-       -  .. _INTERLEAVING-AUTO:
-
-	  ``INTERLEAVING_AUTO``
-
-       -  Auto-detect interleaving.
-
-    -  .. row 4
-
-       -  .. _INTERLEAVING-240:
-
-	  ``INTERLEAVING_240``
-
-       -  Interleaving of 240 symbols.
-
-    -  .. row 5
-
-       -  .. _INTERLEAVING-720:
-
-	  ``INTERLEAVING_720``
-
-       -  Interleaving of 720 symbols.
+Time interleaving to be used.
 
+The acceptable values are defined by :c:type:`fe_interleaving`.
 
 
 .. _DTV-LNA:
diff --git a/Documentation/media/uapi/dvb/frontend-header.rst b/Documentation/media/uapi/dvb/frontend-header.rst
new file mode 100644
index 000000000000..8d8433cf1e12
--- /dev/null
+++ b/Documentation/media/uapi/dvb/frontend-header.rst
@@ -0,0 +1,4 @@
+Frontend uAPI data types
+========================
+
+.. kernel-doc:: include/uapi/linux/dvb/frontend.h
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c7f2124b7851..f898cc384f43 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -554,10 +554,10 @@ enum fe_pilot {
 };
 
 /**
- * enum fe_rolloff - Rolloff factor (also known as alpha)
- * @ROLLOFF_35:		Roloff factor: 35%
- * @ROLLOFF_20:		Roloff factor: 20%
- * @ROLLOFF_25:		Roloff factor: 25%
+ * enum fe_rolloff - Rolloff factor
+ * @ROLLOFF_35:		Roloff factor: α=35%
+ * @ROLLOFF_20:		Roloff factor: α=20%
+ * @ROLLOFF_25:		Roloff factor: α=25%
  * @ROLLOFF_AUTO:	Auto-detect the roloff factor.
  *
  * .. note:
-- 
2.13.5
