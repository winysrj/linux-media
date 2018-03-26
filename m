Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49962 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeCZVLL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jeremy Sowden <jeremy@azazel.net>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Sergiy Redko <sergredko@gmail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        Aishwarya Pant <aishpant@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH 18/18] media: staging: atomisp: stop duplicating input format types
Date: Mon, 26 Mar 2018 17:10:51 -0400
Message-Id: <e0cf7e6e554eb6eb599554e0f6e27757eeb7f506.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same formats are defined twice with different names,
as warned:

    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5092:58: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5092:58:     int enum atomisp_input_format  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5092:58:     int enum ia_css_stream_format
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5112:50: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5112:50:     int enum atomisp_input_format  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5112:50:     int enum ia_css_stream_format
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5288:42: warning: mixing different enum types
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5288:42:     int enum atomisp_input_format  versus
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:5288:42:     int enum ia_css_stream_format
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62: warning: incorrect type in argument 2 (different address spaces)
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62:    expected void const [noderef] <asn:1>*from
    drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:6179:62:    got unsigned short [usertype] *<noident>

Stop this enum abuse.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/include/linux/atomisp_platform.h |   4 +
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |  12 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  16 +--
 .../atomisp/pci/atomisp2/atomisp_compat_css20.h    |   3 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |  14 +--
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |   8 +-
 .../css2400/camera/util/interface/ia_css_util.h    |   6 +-
 .../pci/atomisp2/css2400/camera/util/src/util.c    |  72 +++++------
 .../atomisp/pci/atomisp2/css2400/ia_css_metadata.h |   4 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_mipi.h     |   2 +-
 .../pci/atomisp2/css2400/ia_css_stream_format.h    |  71 +----------
 .../pci/atomisp2/css2400/ia_css_stream_public.h    |   8 +-
 .../isp/kernels/raw/raw_1.0/ia_css_raw.host.c      |  42 +++----
 .../isp/kernels/raw/raw_1.0/ia_css_raw_types.h     |   2 +-
 .../runtime/binary/interface/ia_css_binary.h       |   8 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   6 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       |  91 +++++++-------
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |  92 +++++++-------
 .../runtime/inputfifo/interface/ia_css_inputfifo.h |   6 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      |  22 ++--
 .../css2400/runtime/isys/interface/ia_css_isys.h   |   4 +-
 .../pci/atomisp2/css2400/runtime/isys/src/rx.c     | 110 ++++++++---------
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 132 ++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |  56 ++++-----
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |   4 +-
 .../pci/atomisp2/css2400/sh_css_stream_format.c    |  58 ++++-----
 .../pci/atomisp2/css2400/sh_css_stream_format.h    |   2 +-
 28 files changed, 396 insertions(+), 461 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index e0f0c379e7ce..aa5e294e7b7d 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -104,6 +104,10 @@ enum atomisp_input_format {
 	ATOMISP_INPUT_FORMAT_USER_DEF8,  /* User defined 8-bit data type 8 */
 };
 
+#define N_ATOMISP_INPUT_FORMAT (ATOMISP_INPUT_FORMAT_USER_DEF8 + 1)
+
+
+
 enum intel_v4l2_subdev_type {
 	RAW_CAMERA = 1,
 	SOC_CAMERA = 2,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index 1567572e5b49..6c829d0a1e4c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -253,7 +253,7 @@ void atomisp_css_isys_set_valid(struct atomisp_sub_device *asd,
 
 void atomisp_css_isys_set_format(struct atomisp_sub_device *asd,
 				 enum atomisp_input_stream_id stream_id,
-				 enum atomisp_css_stream_format format,
+				 enum atomisp_input_format format,
 				 int isys_stream);
 
 int atomisp_css_set_default_isys_config(struct atomisp_sub_device *asd,
@@ -262,18 +262,18 @@ int atomisp_css_set_default_isys_config(struct atomisp_sub_device *asd,
 
 int atomisp_css_isys_two_stream_cfg(struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format);
+				    enum atomisp_input_format input_format);
 
 void atomisp_css_isys_two_stream_cfg_update_stream1(
 				    struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format,
+				    enum atomisp_input_format input_format,
 				    unsigned int width, unsigned int height);
 
 void atomisp_css_isys_two_stream_cfg_update_stream2(
 				    struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format,
+				    enum atomisp_input_format input_format,
 				    unsigned int width, unsigned int height);
 
 int atomisp_css_input_set_resolution(struct atomisp_sub_device *asd,
@@ -290,7 +290,7 @@ void atomisp_css_input_set_bayer_order(struct atomisp_sub_device *asd,
 
 void atomisp_css_input_set_format(struct atomisp_sub_device *asd,
 				enum atomisp_input_stream_id stream_id,
-				enum atomisp_css_stream_format format);
+				enum atomisp_input_format format);
 
 int atomisp_css_input_set_effective_resolution(
 					struct atomisp_sub_device *asd,
@@ -336,7 +336,7 @@ int atomisp_css_input_configure_port(struct atomisp_sub_device *asd,
 				unsigned int num_lanes,
 				unsigned int timeout,
 				unsigned int mipi_freq,
-				enum atomisp_css_stream_format metadata_format,
+				enum atomisp_input_format metadata_format,
 				unsigned int metadata_width,
 				unsigned int metadata_height);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index d9c8c202fd81..f668c68dc33a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1784,7 +1784,7 @@ void atomisp_css_isys_set_valid(struct atomisp_sub_device *asd,
 
 void atomisp_css_isys_set_format(struct atomisp_sub_device *asd,
 				 enum atomisp_input_stream_id stream_id,
-				 enum atomisp_css_stream_format format,
+				 enum atomisp_input_format format,
 				 int isys_stream)
 {
 
@@ -1796,7 +1796,7 @@ void atomisp_css_isys_set_format(struct atomisp_sub_device *asd,
 
 void atomisp_css_input_set_format(struct atomisp_sub_device *asd,
 					enum atomisp_input_stream_id stream_id,
-					enum atomisp_css_stream_format format)
+					enum atomisp_input_format format)
 {
 
 	struct ia_css_stream_config *s_config =
@@ -1835,7 +1835,7 @@ int atomisp_css_set_default_isys_config(struct atomisp_sub_device *asd,
 
 int atomisp_css_isys_two_stream_cfg(struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format)
+				    enum atomisp_input_format input_format)
 {
 	struct ia_css_stream_config *s_config =
 		&asd->stream_env[stream_id].stream_config;
@@ -1849,9 +1849,9 @@ int atomisp_css_isys_two_stream_cfg(struct atomisp_sub_device *asd,
 	s_config->isys_config[IA_CSS_STREAM_ISYS_STREAM_1].linked_isys_stream_id
 		= IA_CSS_STREAM_ISYS_STREAM_0;
 	s_config->isys_config[IA_CSS_STREAM_ISYS_STREAM_0].format =
-		IA_CSS_STREAM_FORMAT_USER_DEF1;
+		ATOMISP_INPUT_FORMAT_USER_DEF1;
 	s_config->isys_config[IA_CSS_STREAM_ISYS_STREAM_1].format =
-		IA_CSS_STREAM_FORMAT_USER_DEF2;
+		ATOMISP_INPUT_FORMAT_USER_DEF2;
 	s_config->isys_config[IA_CSS_STREAM_ISYS_STREAM_1].valid = true;
 	return 0;
 }
@@ -1859,7 +1859,7 @@ int atomisp_css_isys_two_stream_cfg(struct atomisp_sub_device *asd,
 void atomisp_css_isys_two_stream_cfg_update_stream1(
 				    struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format,
+				    enum atomisp_input_format input_format,
 				    unsigned int width, unsigned int height)
 {
 	struct ia_css_stream_config *s_config =
@@ -1877,7 +1877,7 @@ void atomisp_css_isys_two_stream_cfg_update_stream1(
 void atomisp_css_isys_two_stream_cfg_update_stream2(
 				    struct atomisp_sub_device *asd,
 				    enum atomisp_input_stream_id stream_id,
-				    enum atomisp_css_stream_format input_format,
+				    enum atomisp_input_format input_format,
 				    unsigned int width, unsigned int height)
 {
 	struct ia_css_stream_config *s_config =
@@ -2122,7 +2122,7 @@ int atomisp_css_input_configure_port(
 		unsigned int num_lanes,
 		unsigned int timeout,
 		unsigned int mipi_freq,
-		enum atomisp_css_stream_format metadata_format,
+		enum atomisp_input_format metadata_format,
 		unsigned int metadata_width,
 		unsigned int metadata_height)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
index b03711668eda..a06c5b6e8027 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
@@ -37,7 +37,6 @@
 #define atomisp_css_irq_info  ia_css_irq_info
 #define atomisp_css_isp_config ia_css_isp_config
 #define atomisp_css_bayer_order ia_css_bayer_order
-#define atomisp_css_stream_format ia_css_stream_format
 #define atomisp_css_capture_mode ia_css_capture_mode
 #define atomisp_css_input_mode ia_css_input_mode
 #define atomisp_css_frame ia_css_frame
@@ -117,7 +116,7 @@
  */
 #define CSS_ID(val)	(IA_ ## val)
 #define CSS_EVENT(val)	(IA_CSS_EVENT_TYPE_ ## val)
-#define CSS_FORMAT(val)	(IA_CSS_STREAM_FORMAT_ ## val)
+#define CSS_FORMAT(val)	(ATOMISP_INPUT_FORMAT_ ## val)
 
 #define CSS_EVENT_PORT_EOF	CSS_EVENT(PORT_EOF)
 #define CSS_EVENT_FRAME_TAGGED	CSS_EVENT(FRAME_TAGGED)
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index b78276ac22da..49a9973b4289 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -42,17 +42,17 @@ const struct atomisp_in_fmt_conv atomisp_in_fmt_conv[] = {
 	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12, 12, ATOMISP_INPUT_FORMAT_RAW_12, CSS_BAYER_ORDER_GBRG, CSS_FORMAT_RAW_12 },
 	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12, 12, ATOMISP_INPUT_FORMAT_RAW_12, CSS_BAYER_ORDER_GRBG, CSS_FORMAT_RAW_12 },
 	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12, 12, ATOMISP_INPUT_FORMAT_RAW_12, CSS_BAYER_ORDER_RGGB, CSS_FORMAT_RAW_12 },
-	{ MEDIA_BUS_FMT_UYVY8_1X16, 8, 8, ATOMISP_INPUT_FORMAT_YUV422_8, 0, IA_CSS_STREAM_FORMAT_YUV422_8 },
-	{ MEDIA_BUS_FMT_YUYV8_1X16, 8, 8, ATOMISP_INPUT_FORMAT_YUV422_8, 0, IA_CSS_STREAM_FORMAT_YUV422_8 },
-	{ MEDIA_BUS_FMT_JPEG_1X8, 8, 8, CSS_FRAME_FORMAT_BINARY_8, 0, IA_CSS_STREAM_FORMAT_BINARY_8 },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, 8, 8, ATOMISP_INPUT_FORMAT_YUV422_8, 0, ATOMISP_INPUT_FORMAT_YUV422_8 },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, 8, 8, ATOMISP_INPUT_FORMAT_YUV422_8, 0, ATOMISP_INPUT_FORMAT_YUV422_8 },
+	{ MEDIA_BUS_FMT_JPEG_1X8, 8, 8, CSS_FRAME_FORMAT_BINARY_8, 0, ATOMISP_INPUT_FORMAT_BINARY_8 },
 	{ V4L2_MBUS_FMT_CUSTOM_NV12, 12, 12, CSS_FRAME_FORMAT_NV12, 0, CSS_FRAME_FORMAT_NV12 },
 	{ V4L2_MBUS_FMT_CUSTOM_NV21, 12, 12, CSS_FRAME_FORMAT_NV21, 0, CSS_FRAME_FORMAT_NV21 },
-	{ V4L2_MBUS_FMT_CUSTOM_YUV420, 12, 12, ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY, 0, IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY },
+	{ V4L2_MBUS_FMT_CUSTOM_YUV420, 12, 12, ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY, 0, ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY },
 #if 0
-	{ V4L2_MBUS_FMT_CUSTOM_M10MO_RAW, 8, 8, CSS_FRAME_FORMAT_BINARY_8, 0, IA_CSS_STREAM_FORMAT_BINARY_8 },
+	{ V4L2_MBUS_FMT_CUSTOM_M10MO_RAW, 8, 8, CSS_FRAME_FORMAT_BINARY_8, 0, ATOMISP_INPUT_FORMAT_BINARY_8 },
 #endif
 	/* no valid V4L2 MBUS code for metadata format, so leave it 0. */
-	{ 0, 0, 0, ATOMISP_INPUT_FORMAT_EMBEDDED, 0, IA_CSS_STREAM_FORMAT_EMBEDDED },
+	{ 0, 0, 0, ATOMISP_INPUT_FORMAT_EMBEDDED, 0, ATOMISP_INPUT_FORMAT_EMBEDDED },
 	{}
 };
 
@@ -101,7 +101,7 @@ const struct atomisp_in_fmt_conv *atomisp_find_in_fmt_conv(u32 code)
 }
 
 const struct atomisp_in_fmt_conv *atomisp_find_in_fmt_conv_by_atomisp_in_fmt(
-	enum atomisp_css_stream_format atomisp_in_fmt)
+	enum atomisp_input_format atomisp_in_fmt)
 {
 	int i;
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
index c3eba675da06..59ff8723c182 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
@@ -58,9 +58,9 @@ struct atomisp_in_fmt_conv {
 	u32     code;
 	uint8_t bpp; /* bits per pixel */
 	uint8_t depth; /* uncompressed */
-	enum atomisp_css_stream_format atomisp_in_fmt;
+	enum atomisp_input_format atomisp_in_fmt;
 	enum atomisp_css_bayer_order bayer_order;
-	enum ia_css_stream_format css_stream_fmt;
+	enum atomisp_input_format css_stream_fmt;
 };
 
 struct atomisp_sub_device;
@@ -424,10 +424,10 @@ bool atomisp_subdev_is_compressed(u32 code);
 const struct atomisp_in_fmt_conv *atomisp_find_in_fmt_conv(u32 code);
 #ifndef ISP2401
 const struct atomisp_in_fmt_conv *atomisp_find_in_fmt_conv_by_atomisp_in_fmt(
-	enum atomisp_css_stream_format atomisp_in_fmt);
+	enum atomisp_input_format atomisp_in_fmt);
 #else
 const struct atomisp_in_fmt_conv
-    *atomisp_find_in_fmt_conv_by_atomisp_in_fmt(enum atomisp_css_stream_format
+    *atomisp_find_in_fmt_conv_by_atomisp_in_fmt(enum atomisp_input_format
 						atomisp_in_fmt);
 #endif
 const struct atomisp_in_fmt_conv *atomisp_find_in_fmt_conv_compressed(u32 code);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/interface/ia_css_util.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/interface/ia_css_util.h
index a8c27676a38b..5ab48f346790 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/interface/ia_css_util.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/interface/ia_css_util.h
@@ -116,7 +116,7 @@ extern bool ia_css_util_resolution_is_even(
  *
  */
 extern unsigned int ia_css_util_input_format_bpp(
-	enum ia_css_stream_format stream_format,
+	enum atomisp_input_format stream_format,
 	bool two_ppc);
 
 /* @brief check if input format it raw
@@ -126,7 +126,7 @@ extern unsigned int ia_css_util_input_format_bpp(
  *
  */
 extern bool ia_css_util_is_input_format_raw(
-	enum ia_css_stream_format stream_format);
+	enum atomisp_input_format stream_format);
 
 /* @brief check if input format it yuv
  *
@@ -135,7 +135,7 @@ extern bool ia_css_util_is_input_format_raw(
  *
  */
 extern bool ia_css_util_is_input_format_yuv(
-	enum ia_css_stream_format stream_format);
+	enum atomisp_input_format stream_format);
 
 #endif /* __IA_CSS_UTIL_H__ */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
index 54193789a809..91e586112332 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/util/src/util.c
@@ -52,55 +52,55 @@ enum ia_css_err ia_css_convert_errno(
 
 /* MW: Table look-up ??? */
 unsigned int ia_css_util_input_format_bpp(
-	enum ia_css_stream_format format,
+	enum atomisp_input_format format,
 	bool two_ppc)
 {
 	unsigned int rval = 0;
 	switch (format) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
-	case IA_CSS_STREAM_FORMAT_EMBEDDED:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_EMBEDDED:
 		rval = 8;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
 		rval = 10;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		rval = 16;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
 		rval = 4;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
 		rval = 5;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
 		rval = 65;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
 		rval = 6;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
 		rval = 7;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
 		rval = 12;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
 		if (two_ppc)
 			rval = 14;
 		else
 			rval = 12;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		if (two_ppc)
 			rval = 16;
 		else
@@ -175,28 +175,28 @@ bool ia_css_util_resolution_is_even(const struct ia_css_resolution resolution)
 }
 
 #endif
-bool ia_css_util_is_input_format_raw(enum ia_css_stream_format format)
+bool ia_css_util_is_input_format_raw(enum atomisp_input_format format)
 {
-	return ((format == IA_CSS_STREAM_FORMAT_RAW_6) ||
-		(format == IA_CSS_STREAM_FORMAT_RAW_7) ||
-		(format == IA_CSS_STREAM_FORMAT_RAW_8) ||
-		(format == IA_CSS_STREAM_FORMAT_RAW_10) ||
-		(format == IA_CSS_STREAM_FORMAT_RAW_12));
+	return ((format == ATOMISP_INPUT_FORMAT_RAW_6) ||
+		(format == ATOMISP_INPUT_FORMAT_RAW_7) ||
+		(format == ATOMISP_INPUT_FORMAT_RAW_8) ||
+		(format == ATOMISP_INPUT_FORMAT_RAW_10) ||
+		(format == ATOMISP_INPUT_FORMAT_RAW_12));
 	/* raw_14 and raw_16 are not supported as input formats to the ISP.
 	 * They can only be copied to a frame in memory using the
 	 * copy binary.
 	 */
 }
 
-bool ia_css_util_is_input_format_yuv(enum ia_css_stream_format format)
+bool ia_css_util_is_input_format_yuv(enum atomisp_input_format format)
 {
-	return format == IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY ||
-	    format == IA_CSS_STREAM_FORMAT_YUV420_8  ||
-	    format == IA_CSS_STREAM_FORMAT_YUV420_10 ||
-	    format == IA_CSS_STREAM_FORMAT_YUV420_16 ||
-	    format == IA_CSS_STREAM_FORMAT_YUV422_8  ||
-	    format == IA_CSS_STREAM_FORMAT_YUV422_10 ||
-	    format == IA_CSS_STREAM_FORMAT_YUV422_16;
+	return format == ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY ||
+	    format == ATOMISP_INPUT_FORMAT_YUV420_8  ||
+	    format == ATOMISP_INPUT_FORMAT_YUV420_10 ||
+	    format == ATOMISP_INPUT_FORMAT_YUV420_16 ||
+	    format == ATOMISP_INPUT_FORMAT_YUV422_8  ||
+	    format == ATOMISP_INPUT_FORMAT_YUV422_10 ||
+	    format == ATOMISP_INPUT_FORMAT_YUV422_16;
 }
 
 enum ia_css_err ia_css_util_check_input(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_metadata.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_metadata.h
index 8b674c98224c..ed0b6ab371da 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_metadata.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_metadata.h
@@ -27,8 +27,8 @@
  *  to process sensor metadata.
  */
 struct ia_css_metadata_config {
-	enum ia_css_stream_format data_type; /** Data type of CSI-2 embedded
-			data. The default value is IA_CSS_STREAM_FORMAT_EMBEDDED. For
+	enum atomisp_input_format data_type; /** Data type of CSI-2 embedded
+			data. The default value is ATOMISP_INPUT_FORMAT_EMBEDDED. For
 			certain sensors, user can choose non-default data type for embedded
 			data. */
 	struct ia_css_resolution  resolution; /** Resolution */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
index 05170c4487eb..367b2aafa5e8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_mipi.h
@@ -74,7 +74,7 @@ ia_css_mipi_frame_enable_check_on_size(const enum mipi_port_id port,
 enum ia_css_err
 ia_css_mipi_frame_calculate_size(const unsigned int width,
 				const unsigned int height,
-				const enum ia_css_stream_format format,
+				const enum atomisp_input_format format,
 				const bool hasSOLandEOL,
 				const unsigned int embedded_data_size_words,
 				unsigned int *size_mem_words);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_format.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_format.h
index f7e9020a86e1..f97b9eb2b19c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_format.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_format.h
@@ -20,75 +20,10 @@
  */
 
 #include <type_support.h> /* bool */
-
-/* The ISP streaming input interface supports the following formats.
- *  These match the corresponding MIPI formats.
- */
-enum ia_css_stream_format {
-	IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY,    /** 8 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV420_8,  /** 8 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV420_10, /** 10 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV420_16, /** 16 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV422_8,  /** UYVY..UYVY, 8 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV422_10, /** UYVY..UYVY, 10 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_YUV422_16, /** UYVY..UYVY, 16 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_RGB_444,  /** BGR..BGR, 4 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_RGB_555,  /** BGR..BGR, 5 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_RGB_565,  /** BGR..BGR, 5 bits B and R, 6 bits G */
-	IA_CSS_STREAM_FORMAT_RGB_666,  /** BGR..BGR, 6 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_RGB_888,  /** BGR..BGR, 8 bits per subpixel */
-	IA_CSS_STREAM_FORMAT_RAW_6,    /** RAW data, 6 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_7,    /** RAW data, 7 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_8,    /** RAW data, 8 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_10,   /** RAW data, 10 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_12,   /** RAW data, 12 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_14,   /** RAW data, 14 bits per pixel */
-	IA_CSS_STREAM_FORMAT_RAW_16,   /** RAW data, 16 bits per pixel, which is
-					    not specified in CSI-MIPI standard*/
-	IA_CSS_STREAM_FORMAT_BINARY_8, /** Binary byte stream, which is target at
-					    JPEG. */
-
-	/* CSI2-MIPI specific format: Generic short packet data. It is used to
-	 *  keep the timing information for the opening/closing of shutters,
-	 *  triggering of flashes and etc.
-	 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT1,  /** Generic Short Packet Code 1 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT2,  /** Generic Short Packet Code 2 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT3,  /** Generic Short Packet Code 3 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT4,  /** Generic Short Packet Code 4 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT5,  /** Generic Short Packet Code 5 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT6,  /** Generic Short Packet Code 6 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT7,  /** Generic Short Packet Code 7 */
-	IA_CSS_STREAM_FORMAT_GENERIC_SHORT8,  /** Generic Short Packet Code 8 */
-
-	/* CSI2-MIPI specific format: YUV data.
-	 */
-	IA_CSS_STREAM_FORMAT_YUV420_8_SHIFT,  /** YUV420 8-bit (Chroma Shifted Pixel Sampling) */
-	IA_CSS_STREAM_FORMAT_YUV420_10_SHIFT, /** YUV420 8-bit (Chroma Shifted Pixel Sampling) */
-
-	/* CSI2-MIPI specific format: Generic long packet data
-	 */
-	IA_CSS_STREAM_FORMAT_EMBEDDED, /** Embedded 8-bit non Image Data */
-
-	/* CSI2-MIPI specific format: User defined byte-based data. For example,
-	 *  the data transmitter (e.g. the SoC sensor) can keep the JPEG data as
-	 *  the User Defined Data Type 4 and the MPEG data as the
-	 *  User Defined Data Type 7.
-	 */
-	IA_CSS_STREAM_FORMAT_USER_DEF1,  /** User defined 8-bit data type 1 */
-	IA_CSS_STREAM_FORMAT_USER_DEF2,  /** User defined 8-bit data type 2 */
-	IA_CSS_STREAM_FORMAT_USER_DEF3,  /** User defined 8-bit data type 3 */
-	IA_CSS_STREAM_FORMAT_USER_DEF4,  /** User defined 8-bit data type 4 */
-	IA_CSS_STREAM_FORMAT_USER_DEF5,  /** User defined 8-bit data type 5 */
-	IA_CSS_STREAM_FORMAT_USER_DEF6,  /** User defined 8-bit data type 6 */
-	IA_CSS_STREAM_FORMAT_USER_DEF7,  /** User defined 8-bit data type 7 */
-	IA_CSS_STREAM_FORMAT_USER_DEF8,  /** User defined 8-bit data type 8 */
-};
-
-#define	IA_CSS_STREAM_FORMAT_NUM	IA_CSS_STREAM_FORMAT_USER_DEF8
+#include "../../../include/linux/atomisp_platform.h"
 
 unsigned int ia_css_util_input_format_bpp(
-	enum ia_css_stream_format format,
+	enum atomisp_input_format format,
 	bool two_ppc);
 
-#endif /* __IA_CSS_STREAM_FORMAT_H */
+#endif /* __ATOMISP_INPUT_FORMAT_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_public.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_public.h
index ca3203357ff5..ddefad330db7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_public.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_css_stream_public.h
@@ -62,7 +62,7 @@ enum {
  */
 struct ia_css_stream_isys_stream_config {
 	struct ia_css_resolution  input_res; /** Resolution of input data */
-	enum ia_css_stream_format format; /** Format of input stream. This data
+	enum atomisp_input_format format; /** Format of input stream. This data
 					       format will be mapped to MIPI data
 					       type internally. */
 	int linked_isys_stream_id; /** default value is -1, other value means
@@ -77,7 +77,7 @@ struct ia_css_stream_input_config {
 							Used for CSS 2400/1 System and deprecated for other
 							systems (replaced by input_effective_res in
 							ia_css_pipe_config) */
-	enum ia_css_stream_format format; /** Format of input stream. This data
+	enum atomisp_input_format format; /** Format of input stream. This data
 					       format will be mapped to MIPI data
 					       type internally. */
 	enum ia_css_bayer_order bayer_order; /** Bayer order for RAW streams */
@@ -257,7 +257,7 @@ ia_css_stream_unload(struct ia_css_stream *stream);
  *
  * This function will return the stream format.
  */
-enum ia_css_stream_format
+enum atomisp_input_format
 ia_css_stream_get_format(const struct ia_css_stream *stream);
 
 /* @brief Check if the stream is configured for 2 pixels per clock
@@ -453,7 +453,7 @@ ia_css_stream_send_input_line(const struct ia_css_stream *stream,
  */
 void
 ia_css_stream_send_input_embedded_line(const struct ia_css_stream *stream,
-			      enum ia_css_stream_format format,
+			      enum atomisp_input_format format,
 			      const unsigned short *data,
 			      unsigned int width);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw.host.c
index 68a27f0cfba0..fa9ce0fedf23 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw.host.c
@@ -37,34 +37,34 @@ sh_css_elems_bytes_from_info (unsigned raw_bit_depth)
 
 /* MW: These areMIPI / ISYS properties, not camera function properties */
 static enum sh_stream_format
-css2isp_stream_format(enum ia_css_stream_format from)
+css2isp_stream_format(enum atomisp_input_format from)
 {
 	switch (from) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 		return sh_stream_format_yuv420_legacy;
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
 		return sh_stream_format_yuv420;
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		return sh_stream_format_yuv422;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
-	case IA_CSS_STREAM_FORMAT_RGB_555:
-	case IA_CSS_STREAM_FORMAT_RGB_565:
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		return sh_stream_format_rgb;
-	case IA_CSS_STREAM_FORMAT_RAW_6:
-	case IA_CSS_STREAM_FORMAT_RAW_7:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
-	case IA_CSS_STREAM_FORMAT_RAW_12:
-	case IA_CSS_STREAM_FORMAT_RAW_14:
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		return sh_stream_format_raw;
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
 	default:
 		return sh_stream_format_raw;
 	}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw_types.h
index 5c0b8febd79a..ae868eb5e10f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw_types.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/raw/raw_1.0/ia_css_raw_types.h
@@ -28,7 +28,7 @@ struct ia_css_raw_configuration {
 	const struct ia_css_frame_info  *in_info;
 	const struct ia_css_frame_info  *internal_info;
 	bool two_ppc;
-	enum ia_css_stream_format stream_format;
+	enum atomisp_input_format stream_format;
 	bool deinterleaved;
 	uint8_t enable_left_padding;
 };
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
index 732e49a241eb..b62c4d321a4e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/interface/ia_css_binary.h
@@ -113,7 +113,7 @@ struct ia_css_binary_descr {
 #endif
 	bool enable_capture_pp_bli;
 	struct ia_css_resolution dvs_env;
-	enum ia_css_stream_format stream_format;
+	enum atomisp_input_format stream_format;
 	struct ia_css_frame_info *in_info;		/* the info of the input-frame with the
 							   ISP required resolution. */
 	struct ia_css_frame_info *bds_out_info;
@@ -126,7 +126,7 @@ struct ia_css_binary_descr {
 
 struct ia_css_binary {
 	const struct ia_css_binary_xinfo *info;
-	enum ia_css_stream_format input_format;
+	enum atomisp_input_format input_format;
 	struct ia_css_frame_info in_frame_info;
 	struct ia_css_frame_info internal_frame_info;
 	struct ia_css_frame_info out_frame_info[IA_CSS_BINARY_MAX_OUTPUT_PORTS];
@@ -162,7 +162,7 @@ struct ia_css_binary {
 
 #define IA_CSS_BINARY_DEFAULT_SETTINGS \
 (struct ia_css_binary) { \
-	.input_format		= IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY, \
+	.input_format		= ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY, \
 	.in_frame_info		= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 	.internal_frame_info	= IA_CSS_BINARY_DEFAULT_FRAME_INFO, \
 	.out_frame_info		= {IA_CSS_BINARY_DEFAULT_FRAME_INFO}, \
@@ -179,7 +179,7 @@ enum ia_css_err
 ia_css_binary_fill_info(const struct ia_css_binary_xinfo *xinfo,
 		 bool online,
 		 bool two_ppc,
-		 enum ia_css_stream_format stream_format,
+		 enum atomisp_input_format stream_format,
 		 const struct ia_css_frame_info *in_info,
 		 const struct ia_css_frame_info *bds_out_info,
 		 const struct ia_css_frame_info *out_info[],
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index a0f0e9062c4c..0cd6e1da43cf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -861,7 +861,7 @@ binary_supports_output_format(const struct ia_css_binary_xinfo *info,
 #ifdef ISP2401
 static bool
 binary_supports_input_format(const struct ia_css_binary_xinfo *info,
-			     enum ia_css_stream_format format)
+			     enum atomisp_input_format format)
 {
 
 	assert(info != NULL);
@@ -1088,7 +1088,7 @@ enum ia_css_err
 ia_css_binary_fill_info(const struct ia_css_binary_xinfo *xinfo,
 		 bool online,
 		 bool two_ppc,
-		 enum ia_css_stream_format stream_format,
+		 enum atomisp_input_format stream_format,
 		 const struct ia_css_frame_info *in_info, /* can be NULL */
 		 const struct ia_css_frame_info *bds_out_info, /* can be NULL */
 		 const struct ia_css_frame_info *out_info[], /* can be NULL */
@@ -1382,7 +1382,7 @@ ia_css_binary_find(struct ia_css_binary_descr *descr,
 	int mode;
 	bool online;
 	bool two_ppc;
-	enum ia_css_stream_format stream_format;
+	enum atomisp_input_format stream_format;
 	const struct ia_css_frame_info *req_in_info,
 				       *req_bds_out_info,
 				       *req_out_info[IA_CSS_BINARY_MAX_OUTPUT_PORTS],
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
index aa9a2d115265..4607a76dc78a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c
@@ -110,9 +110,6 @@
 /* Global variable to store the dtrace verbosity level */
 unsigned int ia_css_debug_trace_level = IA_CSS_DEBUG_WARNING;
 
-/* Assumes that IA_CSS_STREAM_FORMAT_BINARY_8 is last */
-#define N_IA_CSS_STREAM_FORMAT (IA_CSS_STREAM_FORMAT_BINARY_8+1)
-
 #define DPG_START "ia_css_debug_pipe_graph_dump_start "
 #define DPG_END   " ia_css_debug_pipe_graph_dump_end\n"
 
@@ -141,8 +138,8 @@ static struct pipe_graph_class {
 	int width;
 	int eff_height;
 	int eff_width;
-	enum ia_css_stream_format stream_format;
-} pg_inst = {true, 0, 0, 0, 0, N_IA_CSS_STREAM_FORMAT};
+	enum atomisp_input_format stream_format;
+} pg_inst = {true, 0, 0, 0, 0, N_ATOMISP_INPUT_FORMAT};
 
 static const char * const queue_id_to_str[] = {
 	/* [SH_CSS_QUEUE_A_ID]     =*/ "queue_A",
@@ -261,86 +258,86 @@ unsigned int ia_css_debug_get_dtrace_level(void)
 	return ia_css_debug_trace_level;
 }
 
-static const char *debug_stream_format2str(const enum ia_css_stream_format stream_format)
+static const char *debug_stream_format2str(const enum atomisp_input_format stream_format)
 {
 	switch (stream_format) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 		return "yuv420-8-legacy";
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
 		return "yuv420-8";
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
 		return "yuv420-10";
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
 		return "yuv420-16";
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
 		return "yuv422-8";
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
 		return "yuv422-10";
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		return "yuv422-16";
-	case IA_CSS_STREAM_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
 		return "rgb444";
-	case IA_CSS_STREAM_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
 		return "rgb555";
-	case IA_CSS_STREAM_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
 		return "rgb565";
-	case IA_CSS_STREAM_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
 		return "rgb666";
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		return "rgb888";
-	case IA_CSS_STREAM_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
 		return "raw6";
-	case IA_CSS_STREAM_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
 		return "raw7";
-	case IA_CSS_STREAM_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
 		return "raw8";
-	case IA_CSS_STREAM_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
 		return "raw10";
-	case IA_CSS_STREAM_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
 		return "raw12";
-	case IA_CSS_STREAM_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
 		return "raw14";
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		return "raw16";
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
 		return "binary8";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT1:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT1:
 		return "generic-short1";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT2:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT2:
 		return "generic-short2";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT3:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT3:
 		return "generic-short3";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT4:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT4:
 		return "generic-short4";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT5:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT5:
 		return "generic-short5";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT6:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT6:
 		return "generic-short6";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT7:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT7:
 		return "generic-short7";
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT8:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT8:
 		return "generic-short8";
-	case IA_CSS_STREAM_FORMAT_YUV420_8_SHIFT:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_SHIFT:
 		return "yuv420-8-shift";
-	case IA_CSS_STREAM_FORMAT_YUV420_10_SHIFT:
+	case ATOMISP_INPUT_FORMAT_YUV420_10_SHIFT:
 		return "yuv420-10-shift";
-	case IA_CSS_STREAM_FORMAT_EMBEDDED:
+	case ATOMISP_INPUT_FORMAT_EMBEDDED:
 		return "embedded-8";
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
 		return "user-def-8-type-1";
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
 		return "user-def-8-type-2";
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
 		return "user-def-8-type-3";
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
 		return "user-def-8-type-4";
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
 		return "user-def-8-type-5";
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
 		return "user-def-8-type-6";
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
 		return "user-def-8-type-7";
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		return "user-def-8-type-8";
 
 	default:
@@ -2730,7 +2727,7 @@ void ia_css_debug_pipe_graph_dump_epilogue(void)
 	}
 
 
-	if (pg_inst.stream_format != N_IA_CSS_STREAM_FORMAT) {
+	if (pg_inst.stream_format != N_ATOMISP_INPUT_FORMAT) {
 		/* An input stream format has been set so assume we have
 		 * an input system and sensor
 		 */
@@ -2770,7 +2767,7 @@ void ia_css_debug_pipe_graph_dump_epilogue(void)
 	pg_inst.height = 0;
 	pg_inst.eff_width = 0;
 	pg_inst.eff_height = 0;
-	pg_inst.stream_format = N_IA_CSS_STREAM_FORMAT;
+	pg_inst.stream_format = N_ATOMISP_INPUT_FORMAT;
 }
 
 void
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
index c031c70aee9b..1bed027435fd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c
@@ -112,7 +112,7 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 	    width_b_factor = 1, start_column_b,
 	    left_padding = 0;
 	input_formatter_cfg_t if_a_config, if_b_config;
-	enum ia_css_stream_format input_format;
+	enum atomisp_input_format input_format;
 	enum ia_css_err err = IA_CSS_SUCCESS;
 	uint8_t if_config_index;
 
@@ -189,7 +189,7 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 	bits_per_pixel = input_formatter_get_alignment(INPUT_FORMATTER0_ID)
 	    * 8 / ISP_VEC_NELEMS;
 	switch (input_format) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 		if (two_ppc) {
 			vmem_increment = 1;
 			deinterleaving = 1;
@@ -219,9 +219,9 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 			start_column = start_column * deinterleaving / 2;
 		}
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
 		if (two_ppc) {
 			vmem_increment = 1;
 			deinterleaving = 1;
@@ -246,9 +246,9 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 			start_column *= deinterleaving;
 		}
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		if (two_ppc) {
 			vmem_increment = 1;
 			deinterleaving = 1;
@@ -267,11 +267,11 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 			start_column *= deinterleaving;
 		}
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
-	case IA_CSS_STREAM_FORMAT_RGB_555:
-	case IA_CSS_STREAM_FORMAT_RGB_565:
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		num_vectors *= 2;
 		if (two_ppc) {
 			deinterleaving = 2;	/* BR in if_a, G in if_b */
@@ -293,11 +293,11 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 		num_vectors = num_vectors / 2 * deinterleaving;
 		buf_offset_b = buffer_width / 2 / ISP_VEC_NELEMS;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_6:
-	case IA_CSS_STREAM_FORMAT_RAW_7:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
-	case IA_CSS_STREAM_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
 		if (two_ppc) {
 			int crop_col = (start_column % 2) == 1;
 			vmem_increment = 2;
@@ -332,8 +332,8 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 		vectors_per_line = CEIL_DIV(cropped_width, ISP_VEC_NELEMS);
 		vectors_per_line = CEIL_MUL(vectors_per_line, deinterleaving);
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_14:
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		if (two_ppc) {
 			num_vectors *= 2;
 			vmem_increment = 1;
@@ -350,26 +350,26 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 		}
 		buffer_height *= 2;
 		break;
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT1:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT2:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT3:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT4:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT5:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT6:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT7:
-	case IA_CSS_STREAM_FORMAT_GENERIC_SHORT8:
-	case IA_CSS_STREAM_FORMAT_YUV420_8_SHIFT:
-	case IA_CSS_STREAM_FORMAT_YUV420_10_SHIFT:
-	case IA_CSS_STREAM_FORMAT_EMBEDDED:
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT1:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT2:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT3:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT4:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT5:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT6:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT7:
+	case ATOMISP_INPUT_FORMAT_GENERIC_SHORT8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_SHIFT:
+	case ATOMISP_INPUT_FORMAT_YUV420_10_SHIFT:
+	case ATOMISP_INPUT_FORMAT_EMBEDDED:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		break;
 	}
 	if (width_a == 0)
@@ -420,9 +420,9 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 	if_a_config.buf_eol_offset =
 	    buffer_width * bits_per_pixel / 8 - line_width;
 	if_a_config.is_yuv420_format =
-	    (input_format == IA_CSS_STREAM_FORMAT_YUV420_8)
-	    || (input_format == IA_CSS_STREAM_FORMAT_YUV420_10)
-	    || (input_format == IA_CSS_STREAM_FORMAT_YUV420_16);
+	    (input_format == ATOMISP_INPUT_FORMAT_YUV420_8)
+	    || (input_format == ATOMISP_INPUT_FORMAT_YUV420_10)
+	    || (input_format == ATOMISP_INPUT_FORMAT_YUV420_16);
 	if_a_config.block_no_reqs = (config->mode != IA_CSS_INPUT_MODE_SENSOR);
 
 	if (two_ppc) {
@@ -449,9 +449,9 @@ enum ia_css_err ia_css_ifmtr_configure(struct ia_css_stream_config *config,
 		if_b_config.buf_eol_offset =
 		    buffer_width * bits_per_pixel / 8 - line_width;
 		if_b_config.is_yuv420_format =
-		    input_format == IA_CSS_STREAM_FORMAT_YUV420_8
-		    || input_format == IA_CSS_STREAM_FORMAT_YUV420_10
-		    || input_format == IA_CSS_STREAM_FORMAT_YUV420_16;
+		    input_format == ATOMISP_INPUT_FORMAT_YUV420_8
+		    || input_format == ATOMISP_INPUT_FORMAT_YUV420_10
+		    || input_format == ATOMISP_INPUT_FORMAT_YUV420_16;
 		if_b_config.block_no_reqs =
 		    (config->mode != IA_CSS_INPUT_MODE_SENSOR);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/interface/ia_css_inputfifo.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/interface/ia_css_inputfifo.h
index 47d0f7e53f47..545f9e2da59e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/interface/ia_css_inputfifo.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/interface/ia_css_inputfifo.h
@@ -42,12 +42,12 @@ void ia_css_inputfifo_send_input_frame(
 	unsigned int	width,
 	unsigned int	height,
 	unsigned int	ch_id,
-	enum ia_css_stream_format	input_format,
+	enum atomisp_input_format	input_format,
 	bool			two_ppc);
 
 void ia_css_inputfifo_start_frame(
 	unsigned int	ch_id,
-	enum ia_css_stream_format	input_format,
+	enum atomisp_input_format	input_format,
 	bool			two_ppc);
 
 void ia_css_inputfifo_send_line(
@@ -59,7 +59,7 @@ void ia_css_inputfifo_send_line(
 
 void ia_css_inputfifo_send_embedded_line(
 	unsigned int	ch_id,
-	enum ia_css_stream_format	data_type,
+	enum atomisp_input_format	data_type,
 	const unsigned short	*data,
 	unsigned int	width);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
index 8dc74927e9a2..24ca4aaf8df1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/inputfifo/src/inputfifo.c
@@ -86,7 +86,7 @@ static unsigned int inputfifo_curr_ch_id, inputfifo_curr_fmt_type;
 #endif
 struct inputfifo_instance {
 	unsigned int				ch_id;
-	enum ia_css_stream_format	input_format;
+	enum atomisp_input_format	input_format;
 	bool						two_ppc;
 	bool						streaming;
 	unsigned int				hblank_cycles;
@@ -466,21 +466,21 @@ static void inputfifo_send_frame(
 
 
 static enum inputfifo_mipi_data_type inputfifo_determine_type(
-	enum ia_css_stream_format input_format)
+	enum atomisp_input_format input_format)
 {
 	enum inputfifo_mipi_data_type type;
 
 	type = inputfifo_mipi_data_type_regular;
-	if (input_format == IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY) {
+	if (input_format == ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY) {
 		type =
 			inputfifo_mipi_data_type_yuv420_legacy;
-	} else if (input_format == IA_CSS_STREAM_FORMAT_YUV420_8  ||
-		   input_format == IA_CSS_STREAM_FORMAT_YUV420_10 ||
-		   input_format == IA_CSS_STREAM_FORMAT_YUV420_16) {
+	} else if (input_format == ATOMISP_INPUT_FORMAT_YUV420_8  ||
+		   input_format == ATOMISP_INPUT_FORMAT_YUV420_10 ||
+		   input_format == ATOMISP_INPUT_FORMAT_YUV420_16) {
 		type =
 			inputfifo_mipi_data_type_yuv420;
-	} else if (input_format >= IA_CSS_STREAM_FORMAT_RGB_444 &&
-		   input_format <= IA_CSS_STREAM_FORMAT_RGB_888) {
+	} else if (input_format >= ATOMISP_INPUT_FORMAT_RGB_444 &&
+		   input_format <= ATOMISP_INPUT_FORMAT_RGB_888) {
 		type =
 			inputfifo_mipi_data_type_rgb;
 	}
@@ -500,7 +500,7 @@ void ia_css_inputfifo_send_input_frame(
 	unsigned int width,
 	unsigned int height,
 	unsigned int ch_id,
-	enum ia_css_stream_format input_format,
+	enum atomisp_input_format input_format,
 	bool two_ppc)
 {
 	unsigned int fmt_type, hblank_cycles, marker_cycles;
@@ -524,7 +524,7 @@ void ia_css_inputfifo_send_input_frame(
 
 void ia_css_inputfifo_start_frame(
 	unsigned int ch_id,
-	enum ia_css_stream_format input_format,
+	enum atomisp_input_format input_format,
 	bool two_ppc)
 {
 	struct inputfifo_instance *s2mi;
@@ -574,7 +574,7 @@ void ia_css_inputfifo_send_line(
 
 void ia_css_inputfifo_send_embedded_line(
 	unsigned int	ch_id,
-	enum ia_css_stream_format	data_type,
+	enum atomisp_input_format	data_type,
 	const unsigned short	*data,
 	unsigned int	width)
 {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
index 5f5ee28a157f..8c005db9766e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/interface/ia_css_isys.h
@@ -90,7 +90,7 @@ enum ia_css_err ia_css_isys_convert_compressed_format(
 		struct ia_css_csi2_compression *comp,
 		struct input_system_cfg_s *cfg);
 unsigned int ia_css_csi2_calculate_input_system_alignment(
-	enum ia_css_stream_format fmt_type);
+	enum atomisp_input_format fmt_type);
 #endif
 
 #if !defined(USE_INPUT_SYSTEM_VERSION_2401)
@@ -124,7 +124,7 @@ unsigned int ia_css_isys_rx_translate_irq_infos(unsigned int bits);
  * format type must be sumitted correctly by the application.
  */
 enum ia_css_err ia_css_isys_convert_stream_format_to_mipi_format(
-		enum ia_css_stream_format input_format,
+		enum atomisp_input_format input_format,
 		mipi_predictor_t compression,
 		unsigned int *fmt_type);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
index 65ddff137291..425bd3cc3f34 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/isys/src/rx.c
@@ -229,7 +229,7 @@ void ia_css_isys_rx_clear_irq_info(enum mipi_port_id port, unsigned int irq_info
 #endif /* #if !defined(USE_INPUT_SYSTEM_VERSION_2401) */
 
 enum ia_css_err ia_css_isys_convert_stream_format_to_mipi_format(
-		enum ia_css_stream_format input_format,
+		enum atomisp_input_format input_format,
 		mipi_predictor_t compression,
 		unsigned int *fmt_type)
 {
@@ -244,25 +244,25 @@ enum ia_css_err ia_css_isys_convert_stream_format_to_mipi_format(
 	 */
 	if (compression != MIPI_PREDICTOR_NONE) {
 		switch (input_format) {
-		case IA_CSS_STREAM_FORMAT_RAW_6:
+		case ATOMISP_INPUT_FORMAT_RAW_6:
 			*fmt_type = 6;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_7:
+		case ATOMISP_INPUT_FORMAT_RAW_7:
 			*fmt_type = 7;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_8:
+		case ATOMISP_INPUT_FORMAT_RAW_8:
 			*fmt_type = 8;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_10:
+		case ATOMISP_INPUT_FORMAT_RAW_10:
 			*fmt_type = 10;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_12:
+		case ATOMISP_INPUT_FORMAT_RAW_12:
 			*fmt_type = 12;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_14:
+		case ATOMISP_INPUT_FORMAT_RAW_14:
 			*fmt_type = 14;
 			break;
-		case IA_CSS_STREAM_FORMAT_RAW_16:
+		case ATOMISP_INPUT_FORMAT_RAW_16:
 			*fmt_type = 16;
 			break;
 		default:
@@ -277,96 +277,96 @@ enum ia_css_err ia_css_isys_convert_stream_format_to_mipi_format(
 	 * MW: For some reason the mapping is not 1-to-1
 	 */
 	switch (input_format) {
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		*fmt_type = MIPI_FORMAT_RGB888;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
 		*fmt_type = MIPI_FORMAT_RGB555;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
 		*fmt_type = MIPI_FORMAT_RGB444;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
 		*fmt_type = MIPI_FORMAT_RGB565;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
 		*fmt_type = MIPI_FORMAT_RGB666;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
 		*fmt_type = MIPI_FORMAT_RAW8;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
 		*fmt_type = MIPI_FORMAT_RAW10;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
 		*fmt_type = MIPI_FORMAT_RAW6;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
 		*fmt_type = MIPI_FORMAT_RAW7;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
 		*fmt_type = MIPI_FORMAT_RAW12;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
 		*fmt_type = MIPI_FORMAT_RAW14;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
 		*fmt_type = MIPI_FORMAT_YUV420_8;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
 		*fmt_type = MIPI_FORMAT_YUV420_10;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
 		*fmt_type = MIPI_FORMAT_YUV422_8;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
 		*fmt_type = MIPI_FORMAT_YUV422_10;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 		*fmt_type = MIPI_FORMAT_YUV420_8_LEGACY;
 		break;
-	case IA_CSS_STREAM_FORMAT_EMBEDDED:
+	case ATOMISP_INPUT_FORMAT_EMBEDDED:
 		*fmt_type = MIPI_FORMAT_EMBEDDED;
 		break;
 #ifndef USE_INPUT_SYSTEM_VERSION_2401
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		/* This is not specified by Arasan, so we use
 		 * 17 for now.
 		 */
 		*fmt_type = MIPI_FORMAT_RAW16;
 		break;
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
 		*fmt_type = MIPI_FORMAT_BINARY_8;
 		break;
 #else
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
 		*fmt_type = MIPI_FORMAT_CUSTOM0;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
 		*fmt_type = MIPI_FORMAT_CUSTOM1;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
 		*fmt_type = MIPI_FORMAT_CUSTOM2;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
 		*fmt_type = MIPI_FORMAT_CUSTOM3;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
 		*fmt_type = MIPI_FORMAT_CUSTOM4;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
 		*fmt_type = MIPI_FORMAT_CUSTOM5;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
 		*fmt_type = MIPI_FORMAT_CUSTOM6;
 		break;
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		*fmt_type = MIPI_FORMAT_CUSTOM7;
 		break;
 #endif
 
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 	default:
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	}
@@ -448,34 +448,34 @@ enum ia_css_err ia_css_isys_convert_compressed_format(
 }
 
 unsigned int ia_css_csi2_calculate_input_system_alignment(
-	enum ia_css_stream_format fmt_type)
+	enum atomisp_input_format fmt_type)
 {
 	unsigned int memory_alignment_in_bytes = HIVE_ISP_DDR_WORD_BYTES;
 
 	switch (fmt_type) {
-	case IA_CSS_STREAM_FORMAT_RAW_6:
-	case IA_CSS_STREAM_FORMAT_RAW_7:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
-	case IA_CSS_STREAM_FORMAT_RAW_12:
-	case IA_CSS_STREAM_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
 		memory_alignment_in_bytes = 2 * ISP_VEC_NELEMS;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		/* Planar YUV formats need to have all planes aligned, this means
 		 * double the alignment for the Y plane if the horizontal decimation is 2. */
 		memory_alignment_in_bytes = 2 * HIVE_ISP_DDR_WORD_BYTES;
 		break;
-	case IA_CSS_STREAM_FORMAT_EMBEDDED:
+	case ATOMISP_INPUT_FORMAT_EMBEDDED:
 	default:
 		memory_alignment_in_bytes = HIVE_ISP_DDR_WORD_BYTES;
 		break;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 2f0b76a33414..c771e4b910f3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -462,46 +462,46 @@ verify_copy_out_frame_format(struct ia_css_pipe *pipe)
 	assert(pipe->stream != NULL);
 
 	switch (pipe->stream->config.input_config.format) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
 		for (i=0; i<ARRAY_SIZE(yuv420_copy_formats) && !found; i++)
 			found = (out_fmt == yuv420_copy_formats[i]);
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_YUV420_16);
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
 		for (i=0; i<ARRAY_SIZE(yuv422_copy_formats) && !found; i++)
 			found = (out_fmt == yuv422_copy_formats[i]);
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_YUV422_16 ||
 			 out_fmt == IA_CSS_FRAME_FORMAT_YUV420_16);
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
-	case IA_CSS_STREAM_FORMAT_RGB_555:
-	case IA_CSS_STREAM_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_RGBA888 ||
 			 out_fmt == IA_CSS_FRAME_FORMAT_RGB565);
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_RGBA888 ||
 			 out_fmt == IA_CSS_FRAME_FORMAT_YUV420);
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_6:
-	case IA_CSS_STREAM_FORMAT_RAW_7:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
-	case IA_CSS_STREAM_FORMAT_RAW_12:
-	case IA_CSS_STREAM_FORMAT_RAW_14:
-	case IA_CSS_STREAM_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_RAW) ||
 			(out_fmt == IA_CSS_FRAME_FORMAT_RAW_PACKED);
 		break;
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_BINARY_8);
 		break;
 	default:
@@ -586,13 +586,13 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 }
 #elif !defined(HAS_NO_INPUT_SYSTEM) && defined(USE_INPUT_SYSTEM_VERSION_2401)
 static unsigned int csi2_protocol_calculate_max_subpixels_per_line(
-		enum ia_css_stream_format	format,
+		enum atomisp_input_format	format,
 		unsigned int			pixels_per_line)
 {
 	unsigned int rval;
 
 	switch (format) {
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 		/*
 		 * The frame format layout is shown below.
 		 *
@@ -611,9 +611,9 @@ static unsigned int csi2_protocol_calculate_max_subpixels_per_line(
 		 */
 		rval = pixels_per_line * 2;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
 		/*
 		 * The frame format layout is shown below.
 		 *
@@ -630,9 +630,9 @@ static unsigned int csi2_protocol_calculate_max_subpixels_per_line(
 		 */
 		rval = pixels_per_line * 2;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		/*
 		 * The frame format layout is shown below.
 		 *
@@ -649,11 +649,11 @@ static unsigned int csi2_protocol_calculate_max_subpixels_per_line(
 		 */
 		rval = pixels_per_line * 2;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:
-	case IA_CSS_STREAM_FORMAT_RGB_555:
-	case IA_CSS_STREAM_FORMAT_RGB_565:
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
 		/*
 		 * The frame format layout is shown below.
 		 *
@@ -670,22 +670,22 @@ static unsigned int csi2_protocol_calculate_max_subpixels_per_line(
 		 */
 		rval = pixels_per_line * 4;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_6:
-	case IA_CSS_STREAM_FORMAT_RAW_7:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
-	case IA_CSS_STREAM_FORMAT_RAW_12:
-	case IA_CSS_STREAM_FORMAT_RAW_14:
-	case IA_CSS_STREAM_FORMAT_RAW_16:
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		/*
 		 * The frame format layout is shown below.
 		 *
@@ -927,7 +927,7 @@ static bool sh_css_translate_stream_cfg_to_input_system_input_port_resolution(
 	unsigned int max_subpixels_per_line;
 	unsigned int lines_per_frame;
 	unsigned int align_req_in_bytes;
-	enum ia_css_stream_format fmt_type;
+	enum atomisp_input_format fmt_type;
 
 	fmt_type = stream_cfg->isys_config[isys_stream_idx].format;
 	if ((stream_cfg->mode == IA_CSS_INPUT_MODE_SENSOR ||
@@ -936,11 +936,11 @@ static bool sh_css_translate_stream_cfg_to_input_system_input_port_resolution(
 
 		if (stream_cfg->source.port.compression.uncompressed_bits_per_pixel ==
 			UNCOMPRESSED_BITS_PER_PIXEL_10) {
-				fmt_type = IA_CSS_STREAM_FORMAT_RAW_10;
+				fmt_type = ATOMISP_INPUT_FORMAT_RAW_10;
 		}
 		else if (stream_cfg->source.port.compression.uncompressed_bits_per_pixel ==
 			UNCOMPRESSED_BITS_PER_PIXEL_12) {
-				fmt_type = IA_CSS_STREAM_FORMAT_RAW_12;
+				fmt_type = ATOMISP_INPUT_FORMAT_RAW_12;
 		}
 		else
 			return false;
@@ -1391,7 +1391,7 @@ start_copy_on_sp(struct ia_css_pipe *pipe,
 		ia_css_isys_rx_disable();
 #endif
 
-	if (pipe->stream->config.input_config.format != IA_CSS_STREAM_FORMAT_BINARY_8)
+	if (pipe->stream->config.input_config.format != ATOMISP_INPUT_FORMAT_BINARY_8)
 		return IA_CSS_ERR_INTERNAL_ERROR;
 	sh_css_sp_start_binary_copy(ia_css_pipe_get_pipe_num(pipe), out_frame, pipe->stream->config.pixels_per_clock == 2);
 
@@ -6784,7 +6784,7 @@ static bool copy_on_sp(struct ia_css_pipe *pipe)
 
 	rval &= (pipe->config.default_capture_config.mode == IA_CSS_CAPTURE_MODE_RAW);
 
-	rval &= ((pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_BINARY_8) ||
+	rval &= ((pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_BINARY_8) ||
 		(pipe->config.mode == IA_CSS_PIPE_MODE_COPY));
 
 	return rval;
@@ -6817,7 +6817,7 @@ static enum ia_css_err load_capture_binaries(
 		return err;
 	}
 	if (copy_on_sp(pipe) &&
-	    pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_BINARY_8) {
+	    pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_BINARY_8) {
 		ia_css_frame_info_init(
 			&pipe->output_info[0],
 			JPEG_BYTES,
@@ -6915,7 +6915,7 @@ need_yuv_scaler_stage(const struct ia_css_pipe *pipe)
 
 	/* TODO: make generic function */
 	need_format_conversion =
-		((pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY) &&
+		((pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY) &&
 		(pipe->output_info[0].format != IA_CSS_FRAME_FORMAT_CSI_MIPI_LEGACY_YUV420_8));
 
 	in_res = pipe->config.input_effective_res;
@@ -7304,7 +7304,7 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 	/*
 	 * NOTES
 	 * - Why does the "yuvpp" pipe needs "isp_copy_binary" (i.e. ISP Copy) when
-	 *   its input is "IA_CSS_STREAM_FORMAT_YUV422_8"?
+	 *   its input is "ATOMISP_INPUT_FORMAT_YUV422_8"?
 	 *
 	 *   In most use cases, the first stage in the "yuvpp" pipe is the "yuv_scale_
 	 *   binary". However, the "yuv_scale_binary" does NOT support the input-frame
@@ -7319,7 +7319,7 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 	 *   "yuv_scale_binary".
 	 */
 	need_isp_copy_binary =
-		(pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_YUV422_8);
+		(pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_YUV422_8);
 #else  /* !USE_INPUT_SYSTEM_VERSION_2401 */
 	need_isp_copy_binary = true;
 #endif /*  USE_INPUT_SYSTEM_VERSION_2401 */
@@ -7627,11 +7627,11 @@ create_host_yuvpp_pipeline(struct ia_css_pipe *pipe)
 		 * Bayer-Quad RAW.
 		 */
 		int in_frame_format;
-		if (pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY) {
+		if (pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY) {
 			in_frame_format = IA_CSS_FRAME_FORMAT_CSI_MIPI_LEGACY_YUV420_8;
-		} else if (pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_YUV422_8) {
+		} else if (pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_YUV422_8) {
 			/*
-			 * When the sensor output frame format is "IA_CSS_STREAM_FORMAT_YUV422_8",
+			 * When the sensor output frame format is "ATOMISP_INPUT_FORMAT_YUV422_8",
 			 * the "isp_copy_var" binary is selected as the first stage in the yuvpp
 			 * pipe.
 			 *
@@ -7812,7 +7812,7 @@ create_host_copy_pipeline(struct ia_css_pipe *pipe,
 	out_frame->flash_state = IA_CSS_FRAME_FLASH_STATE_NONE;
 
 	if (copy_on_sp(pipe) &&
-	    pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_BINARY_8) {
+	    pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_BINARY_8) {
 		ia_css_frame_info_init(
 			&out_frame->info,
 			JPEG_BYTES,
@@ -8327,7 +8327,7 @@ sh_css_pipe_get_output_frame_info(struct ia_css_pipe *pipe,
 
 	*info = pipe->output_info[idx];
 	if (copy_on_sp(pipe) &&
-	    pipe->stream->config.input_config.format == IA_CSS_STREAM_FORMAT_BINARY_8) {
+	    pipe->stream->config.input_config.format == ATOMISP_INPUT_FORMAT_BINARY_8) {
 		ia_css_frame_info_init(
 			info,
 			JPEG_BYTES,
@@ -8388,7 +8388,7 @@ ia_css_stream_send_input_line(const struct ia_css_stream *stream,
 
 void
 ia_css_stream_send_input_embedded_line(const struct ia_css_stream *stream,
-		enum ia_css_stream_format format,
+		enum atomisp_input_format format,
 		const unsigned short *data,
 		unsigned int width)
 {
@@ -9359,7 +9359,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 
 #if defined(USE_INPUT_SYSTEM_VERSION_2)
 	/* We don't support metadata for JPEG stream, since they both use str2mem */
-	if (stream_config->input_config.format == IA_CSS_STREAM_FORMAT_BINARY_8 &&
+	if (stream_config->input_config.format == ATOMISP_INPUT_FORMAT_BINARY_8 &&
 	    stream_config->metadata_config.resolution.height > 0) {
 		err = IA_CSS_ERR_INVALID_ARGUMENTS;
 		IA_CSS_LEAVE_ERR(err);
@@ -10138,7 +10138,7 @@ ia_css_temp_pipe_to_pipe_id(const struct ia_css_pipe *pipe, enum ia_css_pipe_id
 	return IA_CSS_SUCCESS;
 }
 
-enum ia_css_stream_format
+enum atomisp_input_format
 ia_css_stream_get_format(const struct ia_css_stream *stream)
 {
 	return stream->config.input_config.format;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
index 0c2e5e3a007a..a6a00024bae8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_mipi.c
@@ -104,7 +104,7 @@ static bool ia_css_mipi_is_source_port_valid(struct ia_css_pipe *pipe,
 enum ia_css_err
 ia_css_mipi_frame_calculate_size(const unsigned int width,
 				const unsigned int height,
-				const enum ia_css_stream_format format,
+				const enum atomisp_input_format format,
 				const bool hasSOLandEOL,
 				const unsigned int embedded_data_size_words,
 				unsigned int *size_mem_words)
@@ -136,16 +136,16 @@ ia_css_mipi_frame_calculate_size(const unsigned int width,
 		     width_padded, height, format, hasSOLandEOL, embedded_data_size_words);
 
 	switch (format) {
-	case IA_CSS_STREAM_FORMAT_RAW_6:		/* 4p, 3B, 24bits */
+	case ATOMISP_INPUT_FORMAT_RAW_6:		/* 4p, 3B, 24bits */
 		bits_per_pixel = 6;	break;
-	case IA_CSS_STREAM_FORMAT_RAW_7:		/* 8p, 7B, 56bits */
+	case ATOMISP_INPUT_FORMAT_RAW_7:		/* 8p, 7B, 56bits */
 		bits_per_pixel = 7;		break;
-	case IA_CSS_STREAM_FORMAT_RAW_8:		/* 1p, 1B, 8bits */
-	case IA_CSS_STREAM_FORMAT_BINARY_8:		/*  8bits, TODO: check. */
-	case IA_CSS_STREAM_FORMAT_YUV420_8:		/* odd 2p, 2B, 16bits, even 2p, 4B, 32bits */
+	case ATOMISP_INPUT_FORMAT_RAW_8:		/* 1p, 1B, 8bits */
+	case ATOMISP_INPUT_FORMAT_BINARY_8:		/*  8bits, TODO: check. */
+	case ATOMISP_INPUT_FORMAT_YUV420_8:		/* odd 2p, 2B, 16bits, even 2p, 4B, 32bits */
 		bits_per_pixel = 8;		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_10:		/* odd 4p, 5B, 40bits, even 4p, 10B, 80bits */
-	case IA_CSS_STREAM_FORMAT_RAW_10:		/* 4p, 5B, 40bits */
+	case ATOMISP_INPUT_FORMAT_YUV420_10:		/* odd 4p, 5B, 40bits, even 4p, 10B, 80bits */
+	case ATOMISP_INPUT_FORMAT_RAW_10:		/* 4p, 5B, 40bits */
 #if !defined(HAS_NO_PACKED_RAW_PIXELS)
 		/* The changes will be reverted as soon as RAW
 		 * Buffers are deployed by the 2401 Input System
@@ -156,26 +156,26 @@ ia_css_mipi_frame_calculate_size(const unsigned int width,
 		bits_per_pixel = 16;
 #endif
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:	/* 2p, 3B, 24bits */
-	case IA_CSS_STREAM_FORMAT_RAW_12:		/* 2p, 3B, 24bits */
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:	/* 2p, 3B, 24bits */
+	case ATOMISP_INPUT_FORMAT_RAW_12:		/* 2p, 3B, 24bits */
 		bits_per_pixel = 12;	break;
-	case IA_CSS_STREAM_FORMAT_RAW_14:		/* 4p, 7B, 56bits */
+	case ATOMISP_INPUT_FORMAT_RAW_14:		/* 4p, 7B, 56bits */
 		bits_per_pixel = 14;	break;
-	case IA_CSS_STREAM_FORMAT_RGB_444:		/* 1p, 2B, 16bits */
-	case IA_CSS_STREAM_FORMAT_RGB_555:		/* 1p, 2B, 16bits */
-	case IA_CSS_STREAM_FORMAT_RGB_565:		/* 1p, 2B, 16bits */
-	case IA_CSS_STREAM_FORMAT_YUV422_8:		/* 2p, 4B, 32bits */
+	case ATOMISP_INPUT_FORMAT_RGB_444:		/* 1p, 2B, 16bits */
+	case ATOMISP_INPUT_FORMAT_RGB_555:		/* 1p, 2B, 16bits */
+	case ATOMISP_INPUT_FORMAT_RGB_565:		/* 1p, 2B, 16bits */
+	case ATOMISP_INPUT_FORMAT_YUV422_8:		/* 2p, 4B, 32bits */
 		bits_per_pixel = 16;	break;
-	case IA_CSS_STREAM_FORMAT_RGB_666:		/* 4p, 9B, 72bits */
+	case ATOMISP_INPUT_FORMAT_RGB_666:		/* 4p, 9B, 72bits */
 		bits_per_pixel = 18;	break;
-	case IA_CSS_STREAM_FORMAT_YUV422_10:		/* 2p, 5B, 40bits */
+	case ATOMISP_INPUT_FORMAT_YUV422_10:		/* 2p, 5B, 40bits */
 		bits_per_pixel = 20;	break;
-	case IA_CSS_STREAM_FORMAT_RGB_888:		/* 1p, 3B, 24bits */
+	case ATOMISP_INPUT_FORMAT_RGB_888:		/* 1p, 3B, 24bits */
 		bits_per_pixel = 24;	break;
 
-	case IA_CSS_STREAM_FORMAT_YUV420_16:		/* Not supported */
-	case IA_CSS_STREAM_FORMAT_YUV422_16:		/* Not supported */
-	case IA_CSS_STREAM_FORMAT_RAW_16:		/* TODO: not specified in MIPI SPEC, check */
+	case ATOMISP_INPUT_FORMAT_YUV420_16:		/* Not supported */
+	case ATOMISP_INPUT_FORMAT_YUV422_16:		/* Not supported */
+	case ATOMISP_INPUT_FORMAT_RAW_16:		/* TODO: not specified in MIPI SPEC, check */
 	default:
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
@@ -183,9 +183,9 @@ ia_css_mipi_frame_calculate_size(const unsigned int width,
 	odd_line_bytes = (width_padded * bits_per_pixel + 7) >> 3; /* ceil ( bits per line / 8) */
 
 	/* Even lines for YUV420 formats are double in bits_per_pixel. */
-	if (format == IA_CSS_STREAM_FORMAT_YUV420_8
-			|| format == IA_CSS_STREAM_FORMAT_YUV420_10
-			|| format == IA_CSS_STREAM_FORMAT_YUV420_16) {
+	if (format == ATOMISP_INPUT_FORMAT_YUV420_8
+			|| format == ATOMISP_INPUT_FORMAT_YUV420_10
+			|| format == ATOMISP_INPUT_FORMAT_YUV420_16) {
 		even_line_bytes = (width_padded * 2 * bits_per_pixel + 7) >> 3; /* ceil ( bits per line / 8) */
 	} else {
 		even_line_bytes = odd_line_bytes;
@@ -285,7 +285,7 @@ calculate_mipi_buff_size(
 #else
 	unsigned int width;
 	unsigned int height;
-	enum ia_css_stream_format format;
+	enum atomisp_input_format format;
 	bool pack_raw_pixels;
 
 	unsigned int width_padded;
@@ -348,15 +348,15 @@ calculate_mipi_buff_size(
 
 	bits_per_pixel = sh_css_stream_format_2_bits_per_subpixel(format);
 	bits_per_pixel =
-		(format == IA_CSS_STREAM_FORMAT_RAW_10 && pack_raw_pixels) ? bits_per_pixel : 16;
+		(format == ATOMISP_INPUT_FORMAT_RAW_10 && pack_raw_pixels) ? bits_per_pixel : 16;
 	if (bits_per_pixel == 0)
 		return IA_CSS_ERR_INTERNAL_ERROR;
 
 	odd_line_bytes = (width_padded * bits_per_pixel + 7) >> 3; /* ceil ( bits per line / 8) */
 
 	/* Even lines for YUV420 formats are double in bits_per_pixel. */
-	if (format == IA_CSS_STREAM_FORMAT_YUV420_8
-		|| format == IA_CSS_STREAM_FORMAT_YUV420_10) {
+	if (format == ATOMISP_INPUT_FORMAT_YUV420_8
+		|| format == ATOMISP_INPUT_FORMAT_YUV420_10) {
 		even_line_bytes = (width_padded * 2 * bits_per_pixel + 7) >> 3; /* ceil ( bits per line / 8) */
 	} else {
 		even_line_bytes = odd_line_bytes;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index ba2b96e330d0..43529b1605c3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -1741,7 +1741,7 @@ ia_css_process_zoom_and_motion(
 				out_infos[0] = &args->out_frame[0]->info;
 			info = &stage->firmware->info.isp;
 			ia_css_binary_fill_info(info, false, false,
-				IA_CSS_STREAM_FORMAT_RAW_10,
+				ATOMISP_INPUT_FORMAT_RAW_10,
 				args->in_frame  ? &args->in_frame->info  : NULL,
 				NULL,
 				out_infos,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index 93f7c50511d8..85263725540d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -754,7 +754,7 @@ sh_css_sp_write_frame_pointers(const struct sh_css_binary_args *args)
 
 static void
 sh_css_sp_init_group(bool two_ppc,
-		     enum ia_css_stream_format input_format,
+		     enum atomisp_input_format input_format,
 		     bool no_isp_sync,
 		     uint8_t if_config_index)
 {
@@ -1117,7 +1117,7 @@ sp_init_stage(struct ia_css_pipeline_stage *stage,
 			out_infos[0] = &args->out_frame[0]->info;
 		info = &firmware->info.isp;
 		ia_css_binary_fill_info(info, false, false,
-			    IA_CSS_STREAM_FORMAT_RAW_10,
+			    ATOMISP_INPUT_FORMAT_RAW_10,
 			    args->in_frame  ? &args->in_frame->info  : NULL,
 			    NULL,
 				out_infos,
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.c
index 52d0a6471597..77f135e7dc3c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.c
@@ -16,55 +16,55 @@
 #include <ia_css_stream_format.h>
 
 unsigned int sh_css_stream_format_2_bits_per_subpixel(
-		enum ia_css_stream_format format)
+		enum atomisp_input_format format)
 {
 	unsigned int rval;
 
 	switch (format) {
-	case IA_CSS_STREAM_FORMAT_RGB_444:
+	case ATOMISP_INPUT_FORMAT_RGB_444:
 		rval = 4;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_555:
+	case ATOMISP_INPUT_FORMAT_RGB_555:
 		rval = 5;
 		break;
-	case IA_CSS_STREAM_FORMAT_RGB_565:
-	case IA_CSS_STREAM_FORMAT_RGB_666:
-	case IA_CSS_STREAM_FORMAT_RAW_6:
+	case ATOMISP_INPUT_FORMAT_RGB_565:
+	case ATOMISP_INPUT_FORMAT_RGB_666:
+	case ATOMISP_INPUT_FORMAT_RAW_6:
 		rval = 6;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_7:
+	case ATOMISP_INPUT_FORMAT_RAW_7:
 		rval = 7;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
-	case IA_CSS_STREAM_FORMAT_YUV420_8:
-	case IA_CSS_STREAM_FORMAT_YUV422_8:
-	case IA_CSS_STREAM_FORMAT_RGB_888:
-	case IA_CSS_STREAM_FORMAT_RAW_8:
-	case IA_CSS_STREAM_FORMAT_BINARY_8:
-	case IA_CSS_STREAM_FORMAT_USER_DEF1:
-	case IA_CSS_STREAM_FORMAT_USER_DEF2:
-	case IA_CSS_STREAM_FORMAT_USER_DEF3:
-	case IA_CSS_STREAM_FORMAT_USER_DEF4:
-	case IA_CSS_STREAM_FORMAT_USER_DEF5:
-	case IA_CSS_STREAM_FORMAT_USER_DEF6:
-	case IA_CSS_STREAM_FORMAT_USER_DEF7:
-	case IA_CSS_STREAM_FORMAT_USER_DEF8:
+	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
+	case ATOMISP_INPUT_FORMAT_YUV420_8:
+	case ATOMISP_INPUT_FORMAT_YUV422_8:
+	case ATOMISP_INPUT_FORMAT_RGB_888:
+	case ATOMISP_INPUT_FORMAT_RAW_8:
+	case ATOMISP_INPUT_FORMAT_BINARY_8:
+	case ATOMISP_INPUT_FORMAT_USER_DEF1:
+	case ATOMISP_INPUT_FORMAT_USER_DEF2:
+	case ATOMISP_INPUT_FORMAT_USER_DEF3:
+	case ATOMISP_INPUT_FORMAT_USER_DEF4:
+	case ATOMISP_INPUT_FORMAT_USER_DEF5:
+	case ATOMISP_INPUT_FORMAT_USER_DEF6:
+	case ATOMISP_INPUT_FORMAT_USER_DEF7:
+	case ATOMISP_INPUT_FORMAT_USER_DEF8:
 		rval = 8;
 		break;
-	case IA_CSS_STREAM_FORMAT_YUV420_10:
-	case IA_CSS_STREAM_FORMAT_YUV422_10:
-	case IA_CSS_STREAM_FORMAT_RAW_10:
+	case ATOMISP_INPUT_FORMAT_YUV420_10:
+	case ATOMISP_INPUT_FORMAT_YUV422_10:
+	case ATOMISP_INPUT_FORMAT_RAW_10:
 		rval = 10;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_12:
+	case ATOMISP_INPUT_FORMAT_RAW_12:
 		rval = 12;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_14:
+	case ATOMISP_INPUT_FORMAT_RAW_14:
 		rval = 14;
 		break;
-	case IA_CSS_STREAM_FORMAT_RAW_16:
-	case IA_CSS_STREAM_FORMAT_YUV420_16:
-	case IA_CSS_STREAM_FORMAT_YUV422_16:
+	case ATOMISP_INPUT_FORMAT_RAW_16:
+	case ATOMISP_INPUT_FORMAT_YUV420_16:
+	case ATOMISP_INPUT_FORMAT_YUV422_16:
 		rval = 16;
 		break;
 	default:
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.h
index aab2b6207051..b699f538e0dd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_stream_format.h
@@ -18,6 +18,6 @@
 #include <ia_css_stream_format.h>
 
 unsigned int sh_css_stream_format_2_bits_per_subpixel(
-		enum ia_css_stream_format format);
+		enum atomisp_input_format format);
 
 #endif /* __SH_CSS_STREAM_FORMAT_H */
-- 
2.14.3
