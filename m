Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46925
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751778AbdIANY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:24:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devendra sharma <devendra.sharma9091@gmail.com>
Subject: [PATCH v2 02/27] media: dmx.h: split typedefs from structs
Date: Fri,  1 Sep 2017 10:24:24 -0300
Message-Id: <3755a59f0e2fa5a2e32f3b7ad1216bdf244c37d9.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using typedefs inside the Kernel is against CodingStyle, and
there's no good usage here.

Just like we did at frontend.h, at changeset 0df289a209e0
("[media] dvb: Get rid of typedev usage for enums"), let's keep
those typedefs only to provide userspace backward compatibility.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c |  4 +--
 include/uapi/linux/dvb/dmx.h    | 56 ++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 45e91add73ba..16b0b74c3114 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -562,7 +562,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 {
 	ktime_t timeout = 0;
 	struct dmx_pes_filter_params *para = &filter->params.pes;
-	dmx_output_t otype;
+	enum dmx_output otype;
 	int ret;
 	int ts_type;
 	enum dmx_ts_pes ts_pes;
@@ -787,7 +787,7 @@ static int dvb_dmxdev_filter_free(struct dmxdev *dmxdev,
 	return 0;
 }
 
-static inline void invert_mode(dmx_filter_t *filter)
+static inline void invert_mode(struct dmx_filter *filter)
 {
 	int i;
 
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 427e4899ed69..1bc4d6fb0f01 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -43,16 +43,14 @@ enum dmx_output
 	DMX_OUT_TSDEMUX_TAP /* Like TS_TAP but retrieved from the DMX device */
 };
 
-typedef enum dmx_output dmx_output_t;
-
-typedef enum dmx_input
+enum dmx_input
 {
 	DMX_IN_FRONTEND, /* Input from a front-end device.  */
 	DMX_IN_DVR       /* Input from the logical DVR device.  */
-} dmx_input_t;
+};
 
 
-typedef enum dmx_ts_pes
+enum dmx_ts_pes
 {
 	DMX_PES_AUDIO0,
 	DMX_PES_VIDEO0,
@@ -79,7 +77,7 @@ typedef enum dmx_ts_pes
 	DMX_PES_PCR3,
 
 	DMX_PES_OTHER
-} dmx_pes_type_t;
+};
 
 #define DMX_PES_AUDIO    DMX_PES_AUDIO0
 #define DMX_PES_VIDEO    DMX_PES_VIDEO0
@@ -88,20 +86,20 @@ typedef enum dmx_ts_pes
 #define DMX_PES_PCR      DMX_PES_PCR0
 
 
-typedef struct dmx_filter
+struct dmx_filter
 {
 	__u8  filter[DMX_FILTER_SIZE];
 	__u8  mask[DMX_FILTER_SIZE];
 	__u8  mode[DMX_FILTER_SIZE];
-} dmx_filter_t;
+};
 
 
 struct dmx_sct_filter_params
 {
-	__u16          pid;
-	dmx_filter_t   filter;
-	__u32          timeout;
-	__u32          flags;
+	__u16             pid;
+	struct dmx_filter filter;
+	__u32             timeout;
+	__u32             flags;
 #define DMX_CHECK_CRC       1
 #define DMX_ONESHOT         2
 #define DMX_IMMEDIATE_START 4
@@ -111,19 +109,19 @@ struct dmx_sct_filter_params
 
 struct dmx_pes_filter_params
 {
-	__u16          pid;
-	dmx_input_t    input;
-	dmx_output_t   output;
-	dmx_pes_type_t pes_type;
-	__u32          flags;
+	__u16           pid;
+	enum dmx_input  input;
+	enum dmx_output output;
+	enum dmx_ts_pes pes_type;
+	__u32           flags;
 };
 
-typedef struct dmx_caps {
+struct dmx_caps {
 	__u32 caps;
 	int num_decoders;
-} dmx_caps_t;
+};
 
-typedef enum dmx_source {
+enum dmx_source {
 	DMX_SOURCE_FRONT0 = 0,
 	DMX_SOURCE_FRONT1,
 	DMX_SOURCE_FRONT2,
@@ -132,7 +130,7 @@ typedef enum dmx_source {
 	DMX_SOURCE_DVR1,
 	DMX_SOURCE_DVR2,
 	DMX_SOURCE_DVR3
-} dmx_source_t;
+};
 
 struct dmx_stc {
 	unsigned int num;	/* input : which STC? 0..N */
@@ -146,10 +144,22 @@ struct dmx_stc {
 #define DMX_SET_PES_FILTER       _IOW('o', 44, struct dmx_pes_filter_params)
 #define DMX_SET_BUFFER_SIZE      _IO('o', 45)
 #define DMX_GET_PES_PIDS         _IOR('o', 47, __u16[5])
-#define DMX_GET_CAPS             _IOR('o', 48, dmx_caps_t)
-#define DMX_SET_SOURCE           _IOW('o', 49, dmx_source_t)
+#define DMX_GET_CAPS             _IOR('o', 48, struct dmx_caps)
+#define DMX_SET_SOURCE           _IOW('o', 49, enum dmx_source)
 #define DMX_GET_STC              _IOWR('o', 50, struct dmx_stc)
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
 #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
 
+#if !defined (__KERNEL__)
+
+/* This is needed for legacy userspace support */
+typedef enum dmx_output dmx_output_t;
+typedef enum dmx_input dmx_input_t;
+typedef enum dmx_ts_pes dmx_pes_type_t;
+typedef struct dmx_filter dmx_filter_t;
+typedef struct dmx_caps dmx_caps_t;
+typedef enum dmx_source  dmx_source_t;
+
+#endif
+
 #endif /* _UAPI_DVBDMX_H_ */
-- 
2.13.5
