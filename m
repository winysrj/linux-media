Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48361 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754437AbdBGQI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:08:59 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/4] media-ctl: add colorimetry support
Date: Tue,  7 Feb 2017 17:08:50 +0100
Message-Id: <20170207160850.10299-5-p.zabel@pengutronix.de>
In-Reply-To: <20170207160850.10299-1-p.zabel@pengutronix.de>
References: <20170207160850.10299-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media-ctl can be used to propagate v4l2 subdevice pad formats from
source pads of one subdevice to another one's sink pads. These formats
include colorimetry information, so media-ctl should be able to print
or change it using the --set/get-v4l2 option.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 utils/media-ctl/libv4l2subdev.c | 263 ++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/media-ctl.c     |  17 +++
 utils/media-ctl/options.c       |  22 +++-
 utils/media-ctl/v4l2subdev.h    |  80 ++++++++++++
 4 files changed, 381 insertions(+), 1 deletion(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 81d6420f..f01ed89c 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -511,6 +511,118 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
 			continue;
 		}
 
+		if (strhazit("colorspace:", &p)) {
+			enum v4l2_colorspace colorspace;
+			char *strfield;
+
+			for (end = (char *)p; isalnum(*end) || *end == '-';
+			     ++end);
+
+			strfield = strndup(p, end - p);
+			if (!strfield) {
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			colorspace = v4l2_subdev_string_to_colorspace(strfield);
+			free(strfield);
+			if (colorspace == (enum v4l2_colorspace)-1) {
+				media_dbg(media, "Invalid colorspace value '%*s'\n",
+					  end - p, p);
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			format->colorspace = colorspace;
+
+			p = end;
+			continue;
+		}
+
+		if (strhazit("xfer:", &p)) {
+			enum v4l2_xfer_func xfer_func;
+			char *strfield;
+
+			for (end = (char *)p; isalnum(*end) || *end == '-';
+			     ++end);
+
+			strfield = strndup(p, end - p);
+			if (!strfield) {
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			xfer_func = v4l2_subdev_string_to_xfer_func(strfield);
+			free(strfield);
+			if (xfer_func == (enum v4l2_xfer_func)-1) {
+				media_dbg(media, "Invalid transfer function value '%*s'\n",
+					  end - p, p);
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			format->xfer_func = xfer_func;
+
+			p = end;
+			continue;
+		}
+
+		if (strhazit("ycbcr:", &p)) {
+			enum v4l2_ycbcr_encoding ycbcr_enc;
+			char *strfield;
+
+			for (end = (char *)p; isalnum(*end) || *end == '-';
+			     ++end);
+
+			strfield = strndup(p, end - p);
+			if (!strfield) {
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			ycbcr_enc = v4l2_subdev_string_to_ycbcr_encoding(strfield);
+			free(strfield);
+			if (ycbcr_enc == (enum v4l2_ycbcr_encoding)-1) {
+				media_dbg(media, "Invalid YCbCr encoding value '%*s'\n",
+					  end - p, p);
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			format->ycbcr_enc = ycbcr_enc;
+
+			p = end;
+			continue;
+		}
+
+		if (strhazit("quantization:", &p)) {
+			enum v4l2_quantization quantization;
+			char *strfield;
+
+			for (end = (char *)p; isalnum(*end) || *end == '-';
+			     ++end);
+
+			strfield = strndup(p, end - p);
+			if (!strfield) {
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			quantization = v4l2_subdev_string_to_quantization(strfield);
+			free(strfield);
+			if (quantization == (enum v4l2_quantization)-1) {
+				media_dbg(media, "Invalid quantization value '%*s'\n",
+					  end - p, p);
+				*endp = (char *)p;
+				return NULL;
+			}
+
+			format->quantization = quantization;
+
+			p = end;
+			continue;
+		}
+
 		/*
 		 * Backward compatibility: crop rectangles can be specified
 		 * implicitly without the 'crop:' property name.
@@ -839,6 +951,157 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string)
 	return (enum v4l2_field)-1;
 }
 
+static struct {
+	const char *name;
+	enum v4l2_colorspace colorspace;
+} colorspaces[] = {
+	{ "default", V4L2_COLORSPACE_DEFAULT },
+	{ "smpte170m", V4L2_COLORSPACE_SMPTE170M },
+	{ "smpte240m", V4L2_COLORSPACE_SMPTE240M },
+	{ "rec709", V4L2_COLORSPACE_REC709 },
+	{ "bt878", V4L2_COLORSPACE_BT878 },
+	{ "470m", V4L2_COLORSPACE_470_SYSTEM_M },
+	{ "470bg", V4L2_COLORSPACE_470_SYSTEM_BG },
+	{ "jpeg", V4L2_COLORSPACE_JPEG },
+	{ "srgb", V4L2_COLORSPACE_SRGB },
+	{ "adobergb", V4L2_COLORSPACE_ADOBERGB },
+	{ "bt2020", V4L2_COLORSPACE_BT2020 },
+	{ "dcip3", V4L2_COLORSPACE_DCI_P3 },
+};
+
+const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorspaces); ++i) {
+		if (colorspaces[i].colorspace == colorspace)
+			return colorspaces[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_colorspace v4l2_subdev_string_to_colorspace(const char *string)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorspaces); ++i) {
+		if (strcasecmp(colorspaces[i].name, string) == 0)
+			return colorspaces[i].colorspace;
+	}
+
+	return (enum v4l2_colorspace)-1;
+}
+
+static struct {
+	const char *name;
+	enum v4l2_xfer_func xfer_func;
+} xfer_funcs[] = {
+	{ "default", V4L2_XFER_FUNC_DEFAULT },
+	{ "709", V4L2_XFER_FUNC_709 },
+	{ "srgb", V4L2_XFER_FUNC_SRGB },
+	{ "adobergb", V4L2_XFER_FUNC_ADOBERGB },
+	{ "smpte240m", V4L2_XFER_FUNC_SMPTE240M },
+	{ "smpte2084", V4L2_XFER_FUNC_SMPTE2084 },
+	{ "dcip3", V4L2_XFER_FUNC_DCI_P3 },
+	{ "none", V4L2_XFER_FUNC_NONE },
+};
+
+const char *v4l2_subdev_xfer_func_to_string(enum v4l2_xfer_func xfer_func)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(xfer_funcs); ++i) {
+		if (xfer_funcs[i].xfer_func == xfer_func)
+			return xfer_funcs[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_xfer_func v4l2_subdev_string_to_xfer_func(const char *string)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(xfer_funcs); ++i) {
+		if (strcasecmp(xfer_funcs[i].name, string) == 0)
+			return xfer_funcs[i].xfer_func;
+	}
+
+	return (enum v4l2_xfer_func)-1;
+}
+
+static struct {
+	const char *name;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+} ycbcr_encs[] = {
+	{ "default", V4L2_YCBCR_ENC_DEFAULT },
+	{ "601", V4L2_YCBCR_ENC_601 },
+	{ "709", V4L2_YCBCR_ENC_709 },
+	{ "xv601", V4L2_YCBCR_ENC_XV601 },
+	{ "xv709", V4L2_YCBCR_ENC_XV709 },
+	{ "bt2020", V4L2_YCBCR_ENC_BT2020 },
+	{ "bt2020c", V4L2_YCBCR_ENC_BT2020_CONST_LUM },
+	{ "smpte240m", V4L2_YCBCR_ENC_SMPTE240M },
+};
+
+const char *v4l2_subdev_ycbcr_encoding_to_string(enum v4l2_ycbcr_encoding ycbcr_enc)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ycbcr_encs); ++i) {
+		if (ycbcr_encs[i].ycbcr_enc == ycbcr_enc)
+			return ycbcr_encs[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_ycbcr_encoding v4l2_subdev_string_to_ycbcr_encoding(const char *string)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ycbcr_encs); ++i) {
+		if (strcasecmp(ycbcr_encs[i].name, string) == 0)
+			return ycbcr_encs[i].ycbcr_enc;
+	}
+
+	return (enum v4l2_ycbcr_encoding)-1;
+}
+
+static struct {
+	const char *name;
+	enum v4l2_quantization quantization;
+} quantizations[] = {
+	{ "default", V4L2_QUANTIZATION_DEFAULT },
+	{ "full-range", V4L2_QUANTIZATION_FULL_RANGE },
+	{ "lim-range", V4L2_QUANTIZATION_LIM_RANGE },
+};
+
+const char *v4l2_subdev_quantization_to_string(enum v4l2_quantization quantization)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(quantizations); ++i) {
+		if (quantizations[i].quantization == quantization)
+			return quantizations[i].name;
+	}
+
+	return "unknown";
+}
+
+enum v4l2_quantization v4l2_subdev_string_to_quantization(const char *string)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(quantizations); ++i) {
+		if (strcasecmp(quantizations[i].name, string) == 0)
+			return quantizations[i].quantization;
+	}
+
+	return (enum v4l2_quantization)-1;
+}
+
 static const enum v4l2_mbus_pixelcode mbus_codes[] = {
 #include "media-bus-format-codes.h"
 };
diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
index 1be880c6..9c8cff6a 100644
--- a/utils/media-ctl/media-ctl.c
+++ b/utils/media-ctl/media-ctl.c
@@ -101,6 +101,23 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
 	if (format.field)
 		printf(" field:%s", v4l2_subdev_field_to_string(format.field));
 
+	if (format.colorspace) {
+		printf(" colorspace:%s",
+		       v4l2_subdev_colorspace_to_string(format.colorspace));
+
+		if (format.xfer_func)
+			printf(" xfer:%s",
+			       v4l2_subdev_xfer_func_to_string(format.xfer_func));
+
+		if (format.ycbcr_enc)
+			printf(" ycbcr:%s",
+			       v4l2_subdev_ycbcr_encoding_to_string(format.ycbcr_enc));
+
+		if (format.quantization)
+			printf(" quantization:%s",
+			       v4l2_subdev_quantization_to_string(format.quantization));
+	}
+
 	ret = v4l2_subdev_get_selection(entity, &rect, pad,
 					V4L2_SEL_TGT_CROP_BOUNDS,
 					which);
diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index 59841bbe..83ca1cac 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -68,7 +68,9 @@ static void usage(const char *argv0)
 	printf("\tv4l2-properties = v4l2-property { ',' v4l2-property } ;\n");
 	printf("\tv4l2-property   = v4l2-mbusfmt | v4l2-crop | v4l2-interval\n");
 	printf("\t                | v4l2-compose | v4l2-interval ;\n");
-	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ; { 'field:' v4l2-field ; }\n");
+	printf("\tv4l2-mbusfmt    = 'fmt:' fcc '/' size ; { 'field:' v4l2-field ; } { 'colorspace:' v4l2-colorspace ; }\n");
+	printf("\t                   { 'xfer:' v4l2-xfer-func ; } { 'ycbcr-enc:' v4l2-ycbcr-enc-func ; }\n");
+	printf("\t                   { 'quantization:' v4l2-quant ; }\n");
 	printf("\tv4l2-crop       = 'crop:' rectangle ;\n");
 	printf("\tv4l2-compose    = 'compose:' rectangle ;\n");
 	printf("\tv4l2-interval   = '@' numerator '/' denominator ;\n");
@@ -91,6 +93,24 @@ static void usage(const char *argv0)
 	for (i = V4L2_FIELD_ANY; i <= V4L2_FIELD_INTERLACED_BT; i++)
 		printf("\t                %s\n",
 		       v4l2_subdev_field_to_string(i));
+
+	printf("\tv4l2-colorspace One of the following:\n");
+
+	for (i = V4L2_COLORSPACE_DEFAULT; i <= V4L2_COLORSPACE_DCI_P3; i++)
+		printf("\t                %s\n",
+		       v4l2_subdev_colorspace_to_string(i));
+
+	printf("\tv4l2-xfer-func  One of the following:\n");
+
+	for (i = V4L2_XFER_FUNC_DEFAULT; i <= V4L2_XFER_FUNC_SMPTE2084; i++)
+		printf("\t                %s\n",
+		       v4l2_subdev_xfer_func_to_string(i));
+
+	printf("\tv4l2-quant      One of the following:\n");
+
+	for (i = V4L2_QUANTIZATION_DEFAULT; i <= V4L2_QUANTIZATION_LIM_RANGE; i++)
+		printf("\t                %s\n",
+		       v4l2_subdev_quantization_to_string(i));
 }
 
 #define OPT_PRINT_DOT			256
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 413094d5..a1813911 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -276,6 +276,86 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field field);
 enum v4l2_field v4l2_subdev_string_to_field(const char *string);
 
 /**
+ * @brief Convert a colorspace to string.
+ * @param colorspace - colorspace
+ *
+ * Convert colorspace @a colorspace to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_colorspace_to_string(enum v4l2_colorspace colorspace);
+
+/**
+ * @brief Parse string to colorspace.
+ * @param string - nul terminated string, textual colorspace
+ *
+ * Parse human readable string @a string to colorspace.
+ *
+ * @return colorspace on success, -1 on failure.
+ */
+enum v4l2_colorspace v4l2_subdev_string_to_colorspace(const char *string);
+
+/**
+ * @brief Convert a transfer function to string.
+ * @param xfer_func - transfer function
+ *
+ * Convert transfer function @a xfer_func to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_xfer_func_to_string(enum v4l2_xfer_func xfer_func);
+
+/**
+ * @brief Parse string to transfer function.
+ * @param string - nul terminated string, textual transfer function
+ *
+ * Parse human readable string @a string to xfer_func.
+ *
+ * @return xfer_func on success, -1 on failure.
+ */
+enum v4l2_xfer_func v4l2_subdev_string_to_xfer_func(const char *string);
+
+/**
+ * @brief Convert a YCbCr encoding to string.
+ * @param ycbcr_enc - YCbCr encoding
+ *
+ * Convert YCbCr encoding @a ycbcr_enc to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_ycbcr_encoding_to_string(enum v4l2_ycbcr_encoding ycbcr_enc);
+
+/**
+ * @brief Parse string to YCbCr encoding.
+ * @param string - nul terminated string, textual YCbCr encoding
+ *
+ * Parse human readable string @a string to YCbCr encoding.
+ *
+ * @return ycbcr_enc on success, -1 on failure.
+ */
+enum v4l2_ycbcr_encoding v4l2_subdev_string_to_ycbcr_encoding(const char *string);
+
+/**
+ * @brief Convert a quantization to string.
+ * @param quantization - quantization
+ *
+ * Convert quantization @a quantization to a human-readable string.
+ *
+ * @return A pointer to a string on success, NULL on failure.
+ */
+const char *v4l2_subdev_quantization_to_string(enum v4l2_quantization quantization);
+
+/**
+ * @brief Parse string to quantization.
+ * @param string - nul terminated string, textual quantization
+ *
+ * Parse human readable string @a string to quantization.
+ *
+ * @return quantization on success, -1 on failure.
+ */
+enum v4l2_quantization v4l2_subdev_string_to_quantization(const char *string);
+
+/**
  * @brief Enumerate library supported media bus pixel codes.
  * @param length - the number of the supported pixel codes
  *
-- 
2.11.0

