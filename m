Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25854 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbeIUAhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:37:03 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 06/18] video/hdmi: Handle the MPEG Source infoframe
Date: Thu, 20 Sep 2018 21:51:33 +0300
Message-Id: <20180920185145.1912-7-ville.syrjala@linux.intel.com>
In-Reply-To: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
References: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Add the code to deal with the MPEG source infoframe.

Blindly typed from the spec, and totally untested.

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/video/hdmi.c | 229 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hdmi.h |  27 ++++++
 2 files changed, 256 insertions(+)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 9507f668a569..3d24c7746c51 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -706,6 +706,131 @@ hdmi_vendor_any_infoframe_pack(union hdmi_vendor_any_infoframe *frame,
 	return hdmi_vendor_any_infoframe_pack_only(frame, buffer, size);
 }
 
+/**
+ * hdmi_mpeg_source_infoframe_init() - initialize an HDMI MPEG Source infoframe
+ * @frame: HDMI MPEG Source infoframe
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_mpeg_source_infoframe_init(struct hdmi_mpeg_source_infoframe *frame)
+{
+	memset(frame, 0, sizeof(*frame));
+
+	frame->type = HDMI_INFOFRAME_TYPE_MPEG_SOURCE;
+	frame->version = 1;
+	frame->length = HDMI_MPEG_SOURCE_INFOFRAME_SIZE;
+
+	return 0;
+}
+EXPORT_SYMBOL(hdmi_mpeg_source_infoframe_init);
+
+static int hdmi_mpeg_source_infoframe_check_only(const struct hdmi_mpeg_source_infoframe *frame)
+{
+	if (frame->type != HDMI_INFOFRAME_TYPE_MPEG_SOURCE ||
+	    frame->version != 1 ||
+	    frame->length != HDMI_MPEG_SOURCE_INFOFRAME_SIZE)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * hdmi_mpeg_source_infoframe_check() - Check and check a HDMI MPEG Source infoframe
+ * @frame: HDMI MPEG Source infoframe
+ *
+ * Validates that the infoframe is consistent and updates derived fields
+ * (eg. length) based on other fields.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int hdmi_mpeg_source_infoframe_check(struct hdmi_mpeg_source_infoframe *frame)
+{
+	return hdmi_mpeg_source_infoframe_check_only(frame);
+}
+EXPORT_SYMBOL(hdmi_mpeg_source_infoframe_check);
+
+/**
+ * hdmi_mpeg_source_infoframe_pack_only() - write HDMI MPEG Source infoframe to binary buffer
+ * @frame: HDMI MPEG Source infoframe
+ * @buffer: destination buffer
+ * @size: size of buffer
+ *
+ * Packs the information contained in the @frame structure into a binary
+ * representation that can be written into the corresponding controller
+ * registers. Also computes the checksum as required by section 5.3.5 of
+ * the HDMI 1.4 specification.
+ *
+ * Returns the number of bytes packed into the binary buffer or a negative
+ * error code on failure.
+ */
+ssize_t hdmi_mpeg_source_infoframe_pack_only(const struct hdmi_mpeg_source_infoframe *frame,
+					     void *buffer, size_t size)
+{
+	u8 *ptr = buffer;
+	size_t length;
+	int ret;
+
+	ret = hdmi_mpeg_source_infoframe_check_only(frame);
+	if (ret)
+		return ret;
+
+	length = HDMI_INFOFRAME_HEADER_SIZE + frame->length;
+
+	if (size < length)
+		return -ENOSPC;
+
+	memset(buffer, 0, size);
+
+	ptr[0] = frame->type;
+	ptr[1] = frame->version;
+	ptr[2] = frame->length;
+	ptr[3] = 0; /* checksum */
+
+	/* start infoframe payload */
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	ptr[0] = frame->mpeg_bit_rate >> 0;
+	ptr[1] = frame->mpeg_bit_rate >> 8;
+	ptr[2] = frame->mpeg_bit_rate >> 16;
+	ptr[3] = frame->mpeg_bit_rate >> 24;
+	ptr[4] = (frame->field_repeat << 4) | frame->mpeg_frame;
+
+	hdmi_infoframe_set_checksum(buffer, length);
+
+	return length;
+}
+EXPORT_SYMBOL(hdmi_mpeg_source_infoframe_pack_only);
+
+/**
+ * hdmi_mpeg_source_infoframe_pack() - Check and check a HDMI MPEG Source infoframe,
+ *                                     and write it to binary buffer
+ * @frame: HDMI MPEG Source infoframe
+ * @buffer: destination buffer
+ * @size: size of buffer
+ *
+ * Validates that the infoframe is consistent and updates derived fields
+ * (eg. length) based on other fields, after which packs the information
+ * contained in the @frame structure into a binary representation that
+ * can be written into the corresponding controller registers. Also
+ * computes the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns the number of bytes packed into the binary buffer or a negative
+ * error code on failure.
+ */
+ssize_t hdmi_mpeg_source_infoframe_pack(struct hdmi_mpeg_source_infoframe *frame,
+					void *buffer, size_t size)
+{
+	int ret;
+
+	ret = hdmi_mpeg_source_infoframe_check(frame);
+	if (ret)
+		return ret;
+
+	return hdmi_mpeg_source_infoframe_pack_only(frame, buffer, size);
+}
+EXPORT_SYMBOL(hdmi_mpeg_source_infoframe_pack);
+
 /**
  * hdmi_infoframe_check() - Check check a HDMI infoframe
  * @frame: HDMI infoframe
@@ -727,6 +852,8 @@ hdmi_infoframe_check(union hdmi_infoframe *frame)
 		return hdmi_audio_infoframe_check(&frame->audio);
 	case HDMI_INFOFRAME_TYPE_VENDOR:
 		return hdmi_vendor_any_infoframe_check(&frame->vendor);
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		return hdmi_mpeg_source_infoframe_check(&frame->mpeg_source);
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		return -EINVAL;
@@ -770,6 +897,10 @@ hdmi_infoframe_pack_only(const union hdmi_infoframe *frame, void *buffer, size_t
 		length = hdmi_vendor_any_infoframe_pack_only(&frame->vendor,
 							     buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		length = hdmi_mpeg_source_infoframe_pack_only(&frame->mpeg_source,
+							      buffer, size);
+		break;
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		length = -EINVAL;
@@ -816,6 +947,10 @@ hdmi_infoframe_pack(union hdmi_infoframe *frame,
 		length = hdmi_vendor_any_infoframe_pack(&frame->vendor,
 							buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		length = hdmi_mpeg_source_infoframe_pack(&frame->mpeg_source,
+							 buffer, size);
+		break;
 	default:
 		WARN(1, "Bad infoframe type %d\n", frame->any.type);
 		length = -EINVAL;
@@ -838,6 +973,8 @@ static const char *hdmi_infoframe_type_get_name(enum hdmi_infoframe_type type)
 		return "Source Product Description (SPD)";
 	case HDMI_INFOFRAME_TYPE_AUDIO:
 		return "Audio";
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		return "MPEG Source";
 	}
 	return "Reserved";
 }
@@ -1349,6 +1486,46 @@ hdmi_vendor_any_infoframe_log(const char *level,
 	}
 }
 
+static const char *
+hdmi_mpeg_frame_get_name(enum hdmi_mpeg_frame frame)
+{
+	if (frame < 0 || frame > 3)
+		return "invalid";
+
+	switch (frame) {
+	case HDMI_MPEG_FRAME_UNKNOWN:
+		return "Unknown";
+	case HDMI_MPEG_FRAME_I_PICTURE:
+		return "I Picture";
+	case HDMI_MPEG_FRAME_B_PICTURE:
+		return "B Picture";
+	case HDMI_MPEG_FRAME_P_PICTURE:
+		return "P Picture";
+	}
+	return "Reserved";
+}
+
+/**
+ * hdmi_mpeg_source_infoframe_log() - log info of HDMI MPEG Source infoframe
+ * @level: logging level
+ * @dev: device
+ * @frame: HDMI MPEG Source infoframe
+ */
+static void hdmi_mpeg_source_infoframe_log(const char *level,
+					   struct device *dev,
+					   const struct hdmi_mpeg_source_infoframe *frame)
+{
+	hdmi_infoframe_log_header(level, dev,
+				  (const struct hdmi_any_infoframe *)frame);
+
+	hdmi_log("    MPEG bit rate: %d Hz\n",
+		 frame->mpeg_bit_rate);
+	hdmi_log("    MPEG frame: %s\n",
+		 hdmi_mpeg_frame_get_name(frame->mpeg_frame));
+	hdmi_log("    field repeat: %s\n",
+		 frame->field_repeat ? "Yes" : "No");
+}
+
 /**
  * hdmi_infoframe_log() - log info of HDMI infoframe
  * @level: logging level
@@ -1372,6 +1549,9 @@ void hdmi_infoframe_log(const char *level,
 	case HDMI_INFOFRAME_TYPE_VENDOR:
 		hdmi_vendor_any_infoframe_log(level, dev, &frame->vendor);
 		break;
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		hdmi_mpeg_source_infoframe_log(level, dev, &frame->mpeg_source);
+		break;
 	}
 }
 EXPORT_SYMBOL(hdmi_infoframe_log);
@@ -1614,6 +1794,52 @@ hdmi_vendor_any_infoframe_unpack(union hdmi_vendor_any_infoframe *frame,
 	return 0;
 }
 
+/**
+ * hdmi_mpeg_source_infoframe_unpack() - unpack binary buffer to a HDMI MPEG Source infoframe
+ * @frame: HDMI MPEG Source infoframe
+ * @buffer: source buffer
+ * @size: size of buffer
+ *
+ * Unpacks the information contained in binary @buffer into a structured
+ * @frame of the HDMI MPEG Source information frame.
+ * Also verifies the checksum as required by section 5.3.5 of the HDMI 1.4
+ * specification.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+static int hdmi_mpeg_source_infoframe_unpack(struct hdmi_mpeg_source_infoframe *frame,
+					     const void *buffer, size_t size)
+{
+	const u8 *ptr = buffer;
+	int ret;
+
+	if (size < HDMI_INFOFRAME_SIZE(MPEG_SOURCE))
+		return -EINVAL;
+
+	if (ptr[0] != HDMI_INFOFRAME_TYPE_MPEG_SOURCE ||
+	    ptr[1] != 1 ||
+	    ptr[2] != HDMI_MPEG_SOURCE_INFOFRAME_SIZE) {
+		return -EINVAL;
+	}
+
+	if (hdmi_infoframe_checksum(buffer, HDMI_INFOFRAME_SIZE(MPEG_SOURCE)) != 0)
+		return -EINVAL;
+
+	ret = hdmi_mpeg_source_infoframe_init(frame);
+	if (ret)
+		return ret;
+
+	ptr += HDMI_INFOFRAME_HEADER_SIZE;
+
+	frame->mpeg_bit_rate =
+		(ptr[0] << 0) | (ptr[1] << 8) |
+		(ptr[2] << 16) | (ptr[3] << 24);
+	frame->mpeg_frame = ptr[4] & 0x3;
+	frame->field_repeat = ptr[4] & 0x10;
+
+	return 0;
+}
+
 /**
  * hdmi_infoframe_unpack() - unpack binary buffer to a HDMI infoframe
  * @frame: HDMI infoframe
@@ -1649,6 +1875,9 @@ int hdmi_infoframe_unpack(union hdmi_infoframe *frame,
 	case HDMI_INFOFRAME_TYPE_VENDOR:
 		ret = hdmi_vendor_any_infoframe_unpack(&frame->vendor, buffer, size);
 		break;
+	case HDMI_INFOFRAME_TYPE_MPEG_SOURCE:
+		ret = hdmi_mpeg_source_infoframe_unpack(&frame->mpeg_source, buffer, size);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index 80521d9591a1..2c9322f7538d 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -47,6 +47,7 @@ enum hdmi_infoframe_type {
 	HDMI_INFOFRAME_TYPE_AVI = 0x82,
 	HDMI_INFOFRAME_TYPE_SPD = 0x83,
 	HDMI_INFOFRAME_TYPE_AUDIO = 0x84,
+	HDMI_INFOFRAME_TYPE_MPEG_SOURCE = 0x85,
 };
 
 #define HDMI_IEEE_OUI 0x000c03
@@ -55,6 +56,7 @@ enum hdmi_infoframe_type {
 #define HDMI_AVI_INFOFRAME_SIZE    13
 #define HDMI_SPD_INFOFRAME_SIZE    25
 #define HDMI_AUDIO_INFOFRAME_SIZE  10
+#define HDMI_MPEG_SOURCE_INFOFRAME_SIZE  10
 
 #define HDMI_INFOFRAME_SIZE(type)	\
 	(HDMI_INFOFRAME_HEADER_SIZE + HDMI_ ## type ## _INFOFRAME_SIZE)
@@ -337,6 +339,29 @@ union hdmi_vendor_any_infoframe {
 	struct hdmi_vendor_infoframe hdmi;
 };
 
+enum hdmi_mpeg_frame {
+	HDMI_MPEG_FRAME_UNKNOWN,
+	HDMI_MPEG_FRAME_I_PICTURE,
+	HDMI_MPEG_FRAME_B_PICTURE,
+	HDMI_MPEG_FRAME_P_PICTURE,
+};
+
+struct hdmi_mpeg_source_infoframe {
+	enum hdmi_infoframe_type type;
+	unsigned char version;
+	unsigned char length;
+	unsigned int mpeg_bit_rate;
+	enum hdmi_mpeg_frame mpeg_frame;
+	bool field_repeat;
+};
+
+int hdmi_mpeg_source_infoframe_init(struct hdmi_mpeg_source_infoframe *frame);
+ssize_t hdmi_mpeg_source_infoframe_pack(struct hdmi_mpeg_source_infoframe *frame,
+					void *buffer, size_t size);
+ssize_t hdmi_mpeg_source_infoframe_pack_only(const struct hdmi_mpeg_source_infoframe *frame,
+					     void *buffer, size_t size);
+int hdmi_mpeg_source_infoframe_check(struct hdmi_mpeg_source_infoframe *frame);
+
 /**
  * union hdmi_infoframe - overall union of all abstract infoframe representations
  * @any: generic infoframe
@@ -344,6 +369,7 @@ union hdmi_vendor_any_infoframe {
  * @spd: spd infoframe
  * @vendor: union of all vendor infoframes
  * @audio: audio infoframe
+ * @mpeg_source: mpeg source infoframe
  *
  * This is used by the generic pack function. This works since all infoframes
  * have the same header which also indicates which type of infoframe should be
@@ -355,6 +381,7 @@ union hdmi_infoframe {
 	struct hdmi_spd_infoframe spd;
 	union hdmi_vendor_any_infoframe vendor;
 	struct hdmi_audio_infoframe audio;
+	struct hdmi_mpeg_source_infoframe mpeg_source;
 };
 
 ssize_t hdmi_infoframe_pack(union hdmi_infoframe *frame, void *buffer,
-- 
2.16.4
