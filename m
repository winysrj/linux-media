Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44959
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751345AbdHaXrN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 19:47:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 14/15] media: dmx.h: add kernel-doc markups and use it at Documentation/
Date: Thu, 31 Aug 2017 20:47:01 -0300
Message-Id: <171b4c98f50626f3b9a843931345634e83678a16.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The demux documentation is pretty poor nowadays: most of the
structs and enums aren't documented at all.

Add proper kernel-doc markups for them and use it.

Now, the demux API is fully documented :-)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dmx.h.rst.exceptions   |   5 +
 Documentation/media/uapi/dvb/dmx_types.rst | 173 +----------------------------
 include/uapi/linux/dvb/dmx.h               | 152 +++++++++++++++++++------
 3 files changed, 127 insertions(+), 203 deletions(-)

diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index d2dac35bb84b..629db384104a 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -49,3 +49,8 @@ replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
 replace typedef dmx_filter_t :c:type:`dmx_filter`
 replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
 replace typedef dmx_input_t :c:type:`dmx_input`
+
+ignore symbol DMX_OUT_DECODER
+ignore symbol DMX_OUT_TAP
+ignore symbol DMX_OUT_TS_TAP
+ignore symbol DMX_OUT_TSDEMUX_TAP
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 171205ed86a4..2a023a4f516c 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -6,175 +6,4 @@
 Demux Data Types
 ****************
 
-Output for the demux
-====================
-
-.. c:type:: dmx_output
-
-.. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
-
-.. flat-table:: enum dmx_output
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
-       -  .. _DMX-OUT-DECODER:
-
-	  DMX_OUT_DECODER
-
-       -  Streaming directly to decoder.
-
-    -  .. row 3
-
-       -  .. _DMX-OUT-TAP:
-
-	  DMX_OUT_TAP
-
-       -  Output going to a memory buffer (to be retrieved via the read
-	  command). Delivers the stream output to the demux device on which
-	  the ioctl is called.
-
-    -  .. row 4
-
-       -  .. _DMX-OUT-TS-TAP:
-
-	  DMX_OUT_TS_TAP
-
-       -  Output multiplexed into a new TS (to be retrieved by reading from
-	  the logical DVR device). Routes output to the logical DVR device
-	  ``/dev/dvb/adapter?/dvr?``, which delivers a TS multiplexed from
-	  all filters for which ``DMX_OUT_TS_TAP`` was specified.
-
-    -  .. row 5
-
-       -  .. _DMX-OUT-TSDEMUX-TAP:
-
-	  DMX_OUT_TSDEMUX_TAP
-
-       -  Like :ref:`DMX_OUT_TS_TAP <DMX-OUT-TS-TAP>` but retrieved
-	  from the DMX device.
-
-
-dmx_input_t
-===========
-
-.. c:type:: dmx_input
-
-.. code-block:: c
-
-    typedef enum
-    {
-	DMX_IN_FRONTEND, /* Input from a front-end device.  */
-	DMX_IN_DVR       /* Input from the logical DVR device.  */
-    } dmx_input_t;
-
-
-dmx_pes_type_t
-==============
-
-.. c:type:: dmx_pes_type
-
-
-.. code-block:: c
-
-    typedef enum
-    {
-	DMX_PES_AUDIO0,
-	DMX_PES_VIDEO0,
-	DMX_PES_TELETEXT0,
-	DMX_PES_SUBTITLE0,
-	DMX_PES_PCR0,
-
-	DMX_PES_AUDIO1,
-	DMX_PES_VIDEO1,
-	DMX_PES_TELETEXT1,
-	DMX_PES_SUBTITLE1,
-	DMX_PES_PCR1,
-
-	DMX_PES_AUDIO2,
-	DMX_PES_VIDEO2,
-	DMX_PES_TELETEXT2,
-	DMX_PES_SUBTITLE2,
-	DMX_PES_PCR2,
-
-	DMX_PES_AUDIO3,
-	DMX_PES_VIDEO3,
-	DMX_PES_TELETEXT3,
-	DMX_PES_SUBTITLE3,
-	DMX_PES_PCR3,
-
-	DMX_PES_OTHER
-    } dmx_pes_type_t;
-
-
-struct dmx_filter
-=================
-
-.. c:type:: dmx_filter
-
-.. code-block:: c
-
-     typedef struct dmx_filter
-    {
-	__u8  filter[DMX_FILTER_SIZE];
-	__u8  mask[DMX_FILTER_SIZE];
-	__u8  mode[DMX_FILTER_SIZE];
-    } dmx_filter_t;
-
-
-.. c:type:: dmx_sct_filter_params
-
-struct dmx_sct_filter_params
-============================
-
-
-.. code-block:: c
-
-    struct dmx_sct_filter_params
-    {
-	__u16          pid;
-	dmx_filter_t   filter;
-	__u32          timeout;
-	__u32          flags;
-    #define DMX_CHECK_CRC       1
-    #define DMX_ONESHOT         2
-    #define DMX_IMMEDIATE_START 4
-    };
-
-
-struct dmx_pes_filter_params
-============================
-
-.. c:type:: dmx_pes_filter_params
-
-.. code-block:: c
-
-    struct dmx_pes_filter_params
-    {
-	__u16          pid;
-	dmx_input_t    input;
-	dmx_output_t   output;
-	dmx_pes_type_t pes_type;
-	__u32          flags;
-    };
-
-struct dmx_stc
-==============
-
-.. c:type:: dmx_stc
-
-.. code-block:: c
-
-    struct dmx_stc {
-	unsigned int num;   /* input : which STC? 0..N */
-	unsigned int base;  /* output: divisor for stc to get 90 kHz clock */
-	__u64 stc;      /* output: stc in 'base'*90 kHz units */
-    };
+.. kernel-doc:: include/uapi/linux/dvb/dmx.h
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index dd2b832c02ce..8357885fc11c 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -32,28 +32,73 @@
 
 #define DMX_FILTER_SIZE 16
 
-enum dmx_output
-{
-	DMX_OUT_DECODER, /* Streaming directly to decoder. */
-	DMX_OUT_TAP,     /* Output going to a memory buffer */
-			 /* (to be retrieved via the read command).*/
-	DMX_OUT_TS_TAP,  /* Output multiplexed into a new TS  */
-			 /* (to be retrieved by reading from the */
-			 /* logical DVR device).                 */
-	DMX_OUT_TSDEMUX_TAP /* Like TS_TAP but retrieved from the DMX device */
+/**
+ * enum dmx_output - Output for the demux.
+ *
+ * @DMX_OUT_DECODER:
+ *	Streaming directly to decoder.
+ * @DMX_OUT_TAP:
+ *	Output going to a memory buffer (to be retrieved via the read command).
+ *	Delivers the stream output to the demux device on which the ioctl
+ *	is called.
+ * @DMX_OUT_TS_TAP:
+ *	Output multiplexed into a new TS (to be retrieved by reading from the
+ *	logical DVR device). Routes output to the logical DVR device
+ *	``/dev/dvb/adapter?/dvr?``, which delivers a TS multiplexed from all
+ *	filters for which @DMX_OUT_TS_TAP was specified.
+ * @DMX_OUT_TSDEMUX_TAP:
+ *	Like @DMX_OUT_TS_TAP but retrieved from the DMX device.
+ */
+enum dmx_output {
+	DMX_OUT_DECODER,
+	DMX_OUT_TAP,
+	DMX_OUT_TS_TAP,
+	DMX_OUT_TSDEMUX_TAP
 };
 
-typedef enum dmx_output dmx_output_t;
-
-typedef enum dmx_input
-{
-	DMX_IN_FRONTEND, /* Input from a front-end device.  */
-	DMX_IN_DVR       /* Input from the logical DVR device.  */
-} dmx_input_t;
+/**
+ * enum dmx_input - Input from the demux.
+ *
+ * @DMX_IN_FRONTEND:	Input from a front-end device.
+ * @DMX_IN_DVR:		Input from the logical DVR device.
+ */
+enum dmx_input {
+	DMX_IN_FRONTEND,
+	DMX_IN_DVR
+};
 
+/**
+ * enum dmx_ts_pes - type of the PES filter.
+ *
+ * @DMX_PES_AUDIO0:	first audio PID. Also referred as @DMX_PES_AUDIO.
+ * @DMX_PES_VIDEO0:	first video PID. Also referred as @DMX_PES_VIDEO.
+ * @DMX_PES_TELETEXT0:	first teletext PID. Also referred as @DMX_PES_TELETEXT.
+ * @DMX_PES_SUBTITLE0:	first subtitle PID. Also referred as @DMX_PES_SUBTITLE.
+ * @DMX_PES_PCR0:	first Program Clock Reference PID.
+ * 			Also refered as @DMX_PES_PCR.
+ *
+ * @DMX_PES_AUDIO1:	second audio PID.
+ * @DMX_PES_VIDEO1:	second video PID.
+ * @DMX_PES_TELETEXT1:	second teletext PID.
+ * @DMX_PES_SUBTITLE1:	second subtitle PID.
+ * @DMX_PES_PCR1:	second Program Clock Reference PID.
+ *
+ * @DMX_PES_AUDIO2:	third audio PID.
+ * @DMX_PES_VIDEO2:	third video PID.
+ * @DMX_PES_TELETEXT2:	third teletext PID.
+ * @DMX_PES_SUBTITLE2:	third subtitle PID.
+ * @DMX_PES_PCR2:	third Program Clock Reference PID.
+ *
+ * @DMX_PES_AUDIO3:	fourth audio PID.
+ * @DMX_PES_VIDEO3:	fourth video PID.
+ * @DMX_PES_TELETEXT3:	fourth teletext PID.
+ * @DMX_PES_SUBTITLE3:	fourth subtitle PID.
+ * @DMX_PES_PCR3:	fourth Program Clock Reference PID.
+ *
+ * @DMX_PES_OTHER:	any other PID.
+ */
 
-typedef enum dmx_ts_pes
-{
+enum dmx_ts_pes {
 	DMX_PES_AUDIO0,
 	DMX_PES_VIDEO0,
 	DMX_PES_TELETEXT0,
@@ -79,7 +124,7 @@ typedef enum dmx_ts_pes
 	DMX_PES_PCR3,
 
 	DMX_PES_OTHER
-} dmx_pes_type_t;
+};
 
 #define DMX_PES_AUDIO    DMX_PES_AUDIO0
 #define DMX_PES_VIDEO    DMX_PES_VIDEO0
@@ -88,16 +133,41 @@ typedef enum dmx_ts_pes
 #define DMX_PES_PCR      DMX_PES_PCR0
 
 
-typedef struct dmx_filter
-{
+/**
+ * struct dmx_filter - Specifies a section header filter.
+ *
+ * @filter: bit array with bits to be matched at the section header.
+ * @mask: bits that are valid at the filter bit array.
+ * @mode: mode of match: if bit is zero, it will match if equal (positive
+ * 	  match); if bit is one, it will match if the bit is negated.
+ *
+ * Note: All arrays in this struct have a size of DMX_FILTER_SIZE (16 bytes).
+ */
+struct dmx_filter {
 	__u8  filter[DMX_FILTER_SIZE];
 	__u8  mask[DMX_FILTER_SIZE];
 	__u8  mode[DMX_FILTER_SIZE];
-} dmx_filter_t;
+};
 
-
-struct dmx_sct_filter_params
-{
+/**
+ * struct dmx_sct_filter_params - Specifies a section filter.
+ *
+ * @pid: PID to be filtered.
+ * @filter: section header filter, as defined by &struct dmx_filter.
+ * @timeout: maximum time to filter, in milliseconds.
+ * @flags: extra flags for the section filter.
+ *
+ * Carries the configuration for a MPEG-TS section filter.
+ *
+ * The @flags can be:
+ *
+ *	- %DMX_CHECK_CRC - only deliver sections where the CRC check succeeded;
+ *	- %DMX_ONESHOT - disable the section filter after one section
+ *	  has been delivered;
+ *	- %DMX_IMMEDIATE_START - Start filter immediately without requiring a
+ *	  :ref:`DMX_START`.
+ */
+struct dmx_sct_filter_params {
 	__u16          pid;
 	dmx_filter_t   filter;
 	__u32          timeout;
@@ -107,9 +177,17 @@ struct dmx_sct_filter_params
 #define DMX_IMMEDIATE_START 4
 };
 
-
-struct dmx_pes_filter_params
-{
+/**
+ * struct dmx_pes_filter_params - Specifies Packetized Elementary Stream (PES)
+ *	filter parameters.
+ *
+ * @pid:	PID to be filtered.
+ * @input:	Demux input, as specified by &enum dmx_input.
+ * @output:	Demux output, as specified by &enum dmx_output.
+ * @pes_type:	Type of the pes filter, as specified by &enum dmx_pes_type.
+ * @flags:	Demux PES flags.
+ */
+struct dmx_pes_filter_params {
 	__u16          pid;
 	dmx_input_t    input;
 	dmx_output_t   output;
@@ -117,12 +195,24 @@ struct dmx_pes_filter_params
 	__u32          flags;
 };
 
+/**
+ * struct dmx_stc - Stores System Time Counter (STC) information.
+ *
+ * @num: input data: number of the STC, from 0 to N.
+ * @base: output: divisor for STC to get 90 kHz clock.
+ * @stc: output: stc in @base *90 kHz units.
+ */
 struct dmx_stc {
-	unsigned int num;	/* input : which STC? 0..N */
-	unsigned int base;	/* output: divisor for stc to get 90 kHz clock */
-	__u64 stc;		/* output: stc in 'base'*90 kHz units */
+	unsigned int num;
+	unsigned int base;
+	__u64 stc;
 };
 
+typedef enum dmx_output dmx_output_t;
+typedef enum dmx_input dmx_input_t;
+typedef enum dmx_ts_pes dmx_pes_type_t;
+typedef struct dmx_filter dmx_filter_t;
+
 #define DMX_START                _IO('o', 41)
 #define DMX_STOP                 _IO('o', 42)
 #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
-- 
2.13.5
